---
title: the dipert problem
---


Recently, [Alan Dipert](http://alan.dipert.org/) dropped a bomb on the
twittersphere with his posing of [this question](https://twitter.com/alandipert/status/241575872937750529) (warning there are spoilers in the replies):

"pop quiz: solve <http://www.4clojure.com/problem/107> point-free.
answer must be a function value! #clojure"

In case your office has banned 4clojure for being a huge distraction,
I'll post the problem here:

```clojure
(= 256 ((__ 2) 16),
       ((__ 8) 2))

(= [1 8 27 64] (map (__ 3) [1 2 3 4]))

(= [1 2 4 8 16] (map #((__ %) 2) [0 1 2 3 4]))
```

In problem 107, your challenge is to write a function that satisfies
all of these (it could be dropped in place of the `__`s above). I will
let you go take a crack at solving it. Because up next is some serious
spoiler action.

Got your solution? I came up with this:

```clojure
(fn [x] (fn [y] (reduce * (repeat x y))))
```

or (what I was really doing) in Haskell:

```haskell
f :: Int -> Int -> Int
f x y = foldl1 (*) (replicate x y)
```

We are doing manual exponentiation: "make a list of *y*s that is *x* in
length (e.g. `replicate 8 2 == [2, 2, 2, 2, 2, 2, 2, 2]`). Then you
just run multiplication through the list:

```haskell
foldl1 (*) [2,2,2,2,2,2,2,2] == 2 * 2 * 2 * ... 2 == 256
```

Now comes the "Dipert Problem." He has told us that we have to rewrite
the solution (or any solution) using so-called *point-free* style.  I'm
sure that there's more to it, but essentially that means that *we are
not allowed to mention any variables!* When I first heard about this
style, it sounded impossible! The cool thing is that it *isn't* and it
leads to some massively simple code. Let's try it out.

I'm going to start with my solution above called `f` and then write
some successive versions of it, each time, I'll remove a variable and
call it the "next" version: `f1`, `f2`, okay? Cool.

```haskell
f, f1, f2 :: Int -> Int -> Int
f x y = foldl1 (*) (replicate x y)
```

For the first transformation, we need to get rid of the `y` that's
hanging off the end of both sides of our equation. We'll need to juggle
the innards a bit because here is what the types look like so far:

```haskell
foldl1 (*) :: [Int] -> Int
replicate x y :: Int -> a -> [a]
```

`replicate` takes two arguments and then produces a list that the
`foldl1 (*)` wants to consume. The trouble is, and what tripped me up a
bunch, is that I can't just do this:

```haskell
foldl1 (*) . replicate
```

Wah, wah (sad trombone). GHCI tells me:

```
Expected type: Int -> [c0]
  Actual type: Int -> a0 -> [a0]
```

Okay, that makes sense, for the fold and replicate to "line up" for
composition, replicate has to take one argument then produce a list.
The crux is that composition (the "dot" or period in the code) only
works for single-argument-functons:

```haskell
(.) :: (b -> c) -> (a -> b) -> a -> c
```

This is a little pipeline, but reversed because that's how mathematics
does it. It says "the right-side function takes an *a* and gives a *b*,
and the left-side function expects a *b* and gives a *c*; now you can
stitch them together and have a function that *skips* the *b* and
takes you right from *a* to *c*." But we have a function that looks like:

```
(a -> b -> c)
```

on the right-hand side; it won't work. how do we convert a `(a -> b ->
c)` to a `(a -> (b -> c))`? This way:

```haskell
{-
f x y =  foldl1 (*) ((replicate x) y)
f x y = (foldl1 (*) . (replicate x)) y
-}
f1 x  =  foldl1 (*) . (replicate x)
```

*Note:* the first two lines are commented in case you are cut-n-pasting
along. The first line just puts parenthesis in where they really are in
haskell. Each time you see a function of two arguments, it *is really*
a function which takes one argument and returns a function that expects
the second argument! This weird but remarkable fact of haskell is
called [currying](http://www.haskell.org/haskellwiki/Currying).

Now, on to the second line, we see that we have the right types! (I am
cheating a bit on types, if you like, you can define `rep` which *just*
uses `Int`s)

```haskell
replicate x :: Int -> [Int]  -- cheating: where 'x' is a specific int
foldl1 (*)  :: [Int] -> Int

foldl1 (*) . replicate x :: Int -> Int
```

And that brings us to `f1`! We used grouping and composition to move
the `y` outside the computation and then we dropped it from both sides.

Next we'll tackle the x:

```haskell
{-
f x =  (foldl1 (*) .) (replicate x)
f x = ((foldl1 (*) .) . replicate) x
-}
f2 =   (foldl1 (*) .) . replicate
```

It may look different, but the same thing is going on. We can group the
composition with the fold without changing anything. This is just like
doing:

```haskell
3 + 4 == (3 +) 4
```

Next we do that same trick again where we can now compose the inner
functions because the types line up (again, I'm simplifying types a
bit):

```haskell
((foldl1 (*) .) .) :: (a -> b -> [c]) -> a -> b -> c
```

it looks a bit hairy, but in our case, it is just what we want! If I
fill in the actual types we'll be using, it becomes clearer:

```haskell
((foldl1 (*) .) .) :: (Int -> Int -> [Int]) -> Int -> Int -> Int
```

Booyah! This contraption takes a *function* of two `Ints` that produces
a list of ints, `[Int]`. Well, that's just what `replicate` is! So if
we then feed in replicate:

```haskell
(foldl1 (*) .) . replicate :: Int -> Int -> Int
```

And that's it, we have a point-free function that takes two `Int`s and
returns an `Int`. And so that's our last, and final function:

```haskell
f2 = (foldl1 (*) .) . replicate
```

In general, and I don't know a term for this, but the operation of
successive function composition lets us compose higher and higher arity
functions together. Here's a dumb example using my little point-free `succ`
function:

```haskell
g :: Int -> Int
g = (+1)
(g .)       :: (a -> Int) -> a -> Int
(g .) .)    :: (a -> b -> Int) -> a -> b -> Int
(g .) .) .) :: (a -> b -> c -> Int) -> a -> b -> c -> Int
```

Clear pattern. I kinda think of this as saying something like "please
give me a function which *eventually* promises to give me what I want."
The *eventually* part is essentially "after you've collected all the
stuff you need." It would be trivially satisfied by some function that
ignores its args and returns a constant:

```haskell
(((g .) .) .) (\x y z -> 1) 4 5 6 == 2
```

Remembering that `g` just increments, the x y z are *totally ignored*.
The function supplied to the multiply-composed `g` is like some kind of
integer "pre-processor"; the *x*, *y* and *z* can be whatever you need
to do to figure out how to give g an integer. Or at least that's how
I'm thinking of it.

I had a lot of fun trying to figure this out!
