---
title: Lists out of lambdas and boxes out of functions
---


There's a cool article by Steve Losh called [List out of
Lambda](http://stevelosh.com/blog/2013/03/list-out-of-lambda/)
that reminded me, in a really good way, of a section in SICP.
If you want to read the boiled-down scheme version that's
in SICP, here it is (my paraphrasing from
[SICP section 2.1.3](http://mitpress.mit.edu/sicp/full-text/book/book-Z-H-14.html#%_sec_2.1.3))

"cons" makes a list by putting an element onto the front of an
existing list.

    (cons 1 '()) ; '(1)

that's empty list '() and a list with just "1" in it above
'(1). There's two other functions that deconstruct a list: 'car'
and 'cdr', or head and tail (name's not really important):

    (car '(1 2 3)) ; 1
    (cdr '(1 2 3)) ; '(2 3)

Car returns the head of the list and cdr returns the rest of the
list (without the head). You'd think that 'car', 'cdr', and 'cons'
would pretty much have to be built in functions, but actually they
don't!

    (define (cons x y)
      (define (dispatch m)
        (cond ((= m 0) x)
              ((= m 1) y)
              (else (error "Argument not 0 or 1 -- CONS" m))))
      dispatch)

This is the trickiest thing to grok, but then you're in the
clear. Calling 'cons' returns a function (called "dispatch") which
"closes" over its two arguments. That means that the function is
implicitly storing x and y off where function arguments are
stored. Dispatch takes a single argument, m, which acts like a kind of
selector. If m == 0, then dispatch returns the first argument to cons,
if m == 1, then dispatch returns the second argument to cons.

    ((cons 1 '(2 3)) 0) ; 1
    ((cons 1 '(2 3)) 1) ; '(2 3)

Now we just define car and cdr to do exactly this:

    (define (car lst)
      (lst 0))

    (define (cdr lst)
      (lst 1))

Remember that the way that this works is that the list is being
stored as a function so the only thing we can do is to call it!

    (car (cons 1 '(2 3))) ; 1
    (cdr (cons 1 '(2 3))) ; '(2 3)

Cool! We just built lists out of "nothing". If you want to be even
more mind-bending. You can make the "dispatch" function anonymous:

    (define (cons x y)
      (lambda (m)
        (cond ((= m 0) x)
              ((= m 1) y)
              (else (error "Argument not 0 or 1 -- CONS" m)))))

It works the same.

If you view functions as little boxes that basically just contain
their return values this makes sense. A function is like a box
that, when given its argument barfs up the result.  In fact, don't
think of a function as *doing* something, think of it as *being*
something. If it is first class then you should be able to treat
it this way in all respects. You can pass around these little
boxes that have some value "in" them and the only way to get it
out is to "call" it (or force, or... whatever). But, and we're
starting to tread into heavy functional land here, what if you
weren't so hung up on the idea of getting the value "out" of the
box?

    (define (box-it-up x) (lambda () x))

This puts a value, x, in a box. You can do whatever you want with
the box. You can store it, you can pass it around etc. And, of
course, you can open it up by doing this:

    ((box-it-up 10)) ; 10

If that's a bit hard to read, just remember that whatever is the
first thing in a lisp list is called. Javascript would be:

    box_it_up(10)(); // 10

But let's say that we don't really care to open the box (we
labeled our boxes really well). We just want to make sure that,
whenever it is opened, that we obey special handling
instructions. Let's write "double this" on the box.

    (define (double-this box)
      (lambda () (* (box) 2)))

Maybe I bent the rules a bit. I used a magic pen that when I wrote
"double-this" on the box, it performed an old mover's optimization
trick. Instead of just having our original box I magically
duplicated the old box with the twist that the new box now
contains double whatever was in the old one ;) Got that? (Hey,
metaphors are hard).

Maybe you can see where I'm going here. I don't want to have to
make a new kind of "double-this" function every time I want to do
something. How about I just give you the magic pen?

    (define (magic-pen box func)
      (lambda () (func (box))))

That means you can write "double-this" like so:

    (define (double-this box)
      (magic-pen box (lambda (x) (* 2 x))))

Here's how this all looks now:

    (define twenty-box (double-this (box-it-up 10)))

    (twenty-box) ; 20

cool! So this is how I've been thinking about Promises in
javascript. We have a kind of box that unlike functions we really
can't open up for the simple reason that the value may not have
happened yet. But it is no biggie because we can do whatever we
like to the values inside inside the box!

If you've got all that, then I'm happy because I've also kinda
sorted tricked you into understanding monads. Did you notice how I
was just able to handwave at the end and say, "yeah, but instead
of functions the 'box' is some as-yet-unreceived network packet"?
Monads are just the idea that you can compute all day long with
these sorts of "unopened boxes". Well not *just*, but the devil is
in the details and that means that I'll probably write another
blog post about it.
