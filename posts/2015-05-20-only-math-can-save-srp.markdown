---
title: Only Math Can Save the SRP
---

If you travel long in the land of OOP, you'll hear the name *SRP* mentioned.
Maybe you'll even hear the full name *Single Responsibility Principle* used.
If you prod, you may also have heard the definition of this term:
["software should only have one reason to change."][bob2014].
Ignoring for a moment if that's a soft tautology, let's dig into what's going on.
Like a lot of OOP design principles, I believe that this is something of an epicycle approximating (but missing) some underlying truth.

[bob2014]: http://blog.8thlight.com/uncle-bob/2014/05/08/SingleReponsibilityPrinciple.html

SRP gets at the idea that software should be well-factored,
that is, it should be decomposable into independent units which interact in well-defined ways.
We should be able to get things done by aggregating together granular pieces of functionality (be those objects, functions, or whatever).

But, and this is where we need to be more precise, where should we draw those boundaries?
What's a *responsibility* in the context of software?
I think the only meaningful answer is *an algebraic structure*.

Mathematicians have spent a long time characterizing things like *rings*, *groups*, *fields*, and *monoids*.
If these names aren't familiar, don't worry!
The concepts are simple and reinforce one another.

## The Algebra Zoo

Let's start at the bottom.
We'll need just a little basic set theory to get off the ground, but then we'll start flying!

First, empty your mind of programming notions.
We're now in the land of math and here you'll have to be a little bit careful, words have changed meanings a bit.
This can take some getting used to, but I think the fastest way to feel comfortable is to shed notions about what "object" or "set" mean until we get more comfortable.

Now, into the void we'll call into being the idea of a collection.
This is the most abstract possible meaning of *collection*.
It consists of a gathering of *elements* where those elements share some property.
The property could be anything, say *even numbers* like 2, 4, 6.
Or it could be "red squares."
Whatever.
The key property is that for each collection and element you can ask "is this element in this collection?” and get a yes/no answer.
In fact, this notion of *collection* is what *defines* a set.
_Standard disclaimers apply, I’m not a mathemetician and this handwavy explantion would likely get you laughed out of any math gang that you might be a part of._

### Putting Things Together

Programming’s heart and soul is repetition.
From the earliest days of electro-mechanical computing, humans created machines that could grind through tedious tasks.
It went without saying that it was the repetition, in steps, or in raw numbers that made these tasks deadly boring.
In steps the machine and we just describe the steps, letting the  mindless machine step through the busywork.

Even today, the kinds of tasks we want computers to work on tend toward vast amalgamations of similar _things_.
If our tasks were just one-off, maybe we wouldn’t even bother writing programs.

So it is often the case that we want to aggregate things

$\xor$

## Back to Programming

What the OOP crowd has been missing the whole time is to look for these algebraic structures.
They have been polished over the years by many minds until their surface APIs are smooth and minimal;
yet their applicability is general and wide.

The core problem with a `User` object, the [inherent vice][wikiVice] that tends to lead to its eventual [*God Objectdom*][wikiGod], is that we have a fuzzy idea of what _responsibilities_ are and which ones a `User` should have.
Everyone will bring their own cultural ideas to this picnic because `User` is so redolent with squishy, fleshy connotations.
If we really want to make the idea of *SRP* rigorous, we have to get real -- by getting abstract.

[wikiVice]: https://en.wikipedia.org/wiki/Inherent_vice_(library_and_archival_science)
[wikiGod]: https://en.wikipedia.org/wiki/God_object

> The purpose of abstraction is not to be vague, but to create a new semantic level in which one can be absolutely precise
> -- Dijkstra

Our task, knowing what we know about mathematics, is to decompose the `User` object according to the algebraic structures it comprises.

We should ask ourselves some orienting questions.
Can users be combined in some way?
Does the order of that combining matter?
Is there a notion of a *default* or *empty* user?
Can you cancel out a user in some way?
Are users [partially][wikiPoset] or [totally][wikiTotal] ordered?
And so on.

[wikiPoset]: https://en.wikipedia.org/wiki/Partially_ordered_set
[wikiTotal]: https://en.wikipedia.org/wiki/Total_order

Factoring an object in this way is the best that we can hope for.
A [monoid][wikiMon] is not going to suddenly grow a new method.
We could identify new algebraic structures that match up with our object.
Or we could find that some structures, oops, don't actually fit.
But we won't see *any reasons to change* the structures themselves.
Programming becomes the act of identifying the operations we need, the invariants which must hold, and then identifying algebraic structures that make sense.

[wikiMon]: https://en.wikipedia.org/wiki/Monoid

## Concept LEGOs

And so that's how mathematics is the only sensible way that we can interpret the SRP.
It's our job to [creatively work within these constraints][acad2010].
Maybe we find a structure which *almost* fits, but in that discrepancy we see a glimpse of something more general. As [How to Solve It][polya1945], counsels: *can we vary the problem, generalize it?*
We need to mine the annals of math looking for pieces that fit.
These are the data structures of software architecture, the basic building blocks which can be infinitely recombined.

[acad2010]: http://www.achievement.org/autodoc/page/geh0int-4
[polya1945]:  https://en.wikipedia.org/wiki/How_to_Solve_It
