---
title: secret santa
---


While I was sitting around and eating a ton of Christmas food, I
got to thinking about the [Secret
Santa](http://en.wikipedia.org/wiki/Secret_Santa) problem.  In its
most basic form, this is the same as something called a
[derangement](http://mathworld.wolfram.com/Derangement.html).  I
mention it just because I think the name is cool, the concept is
super simple, a *derangement* is a permutation of the elements of
a list such that no element stays in the same place:

    [1, 2, 3] would have a derangement:
    [2, 3, 1]

notice that each element has moved.  So this pertains to secret
santas because if you are just not allowed to chose yourself then
a derangement (like
[this](http://hackage.haskell.org/package/derangement)) is all
that you'd need, it would be a valid secret santa!

    > zip [1, 2, 3] (derangement [1, 2, 3])
    [(1,2),(2,3),(3,1)]

cool! person 1 gives to person 2, person 2 gives to person 3, and
person 3 gives to person 1.

As my family could tell you, I thought that I could do better (in
keeping with my motto "if it ain't broke, fix it until it is").
Wouldn't it be cool if in additon to just forbidding the case
where you pick your own name (reflexive), you also can provide two
more lists. One is a list of pairings which are *disallowed* and
the second is a list of pairings which are to be *discouraged*
(less likely).

I've implemented almost what I just described.  In the code below,
I don't actually make a selection from some distribution where
discouraged selections are less likely.  Instead, I've added a
`bestSantas` function that allows you to limit yourself to
selections that are under a certain amount of *badness* (a
selection has 1 point of badness for each discouraged pairing that
it includes).  I hadn't decided how I wanted to select from among
differing levels of badness yet.  But anyway, enjoy!

<script src="https://gist.github.com/1525233.js"></script>
