---
title: The Quick Hack v. Developing Software
---

I find that I operate in one of two *modes* when I'm writing software. I'm
either approaching a project as *a quick hack* or as *developing software*.
As much as anything else, this affects how I approach the project and what
kinds of results that I get.

When I'm operating under the auspices of the quick hack, everything is
moving toward and subordinate to the goal. The end product of the quick
hack is everything. I approach the actual hacking in a fit of pique, it's
*annoying* that this thing isn't done yet. I always take the way that's
most expedient and I'm always looking for a shortcut or quick fix.

When I set out to *develop software* my mindset is different. Here I'm
nurturing a seed of an idea. I'm taking small pieces and building
connections between them. I have the sense that I'm making something new,
or at least I'm making something that's *mine* -- I feel ownership. I also
assume that the thing that I'm building has to last.

The natural habitat of a quick hack is a framework. When I'm confronted
with something that doesn't fit, I look for that next StackOverflow answer
that'll tell me how to shoehorn it in among the Tetris pieces that I
already have. The framework is not malleable, I must square-off my round
peg.

Libraries are what support developing software. Properly in charge, I
choose a subordinate library and apply its talents appropriately. There is
no hint of having to make my design fit within the strictures of someone
else's plan. I have the skeleton, I merely need the flesh. If I find that a
library no longer suits my needs, it is easily removed. Well-scoped
libraries tend to match one another much more closely than frameworks do.
The problem that the library solves, the abstraction that it grants, tends
to be more universal than a framework. Two HTTP client libraries will tend
to expose those actions that HTTP supports. With a framework, I must first
accept its world-view before I can start using it.

As I've grown as a software developer, I've come to believe that whenever
possible I should use libraries over frameworks. This has been said
[many][1] [times][2] [before][3], but now I'm *getting there* via my own
experience.  I'm beginning to see that the advantages of frameworks can be
matched by a powerful language combined with a little sense about the
high-level architecture that the application demands. Over time, I've
developed my own palette of designs and code to accomplish most tasks. I
can act as a [linker][4], assembling only those functions that are needed
to accomplish the task at hand.

[1]: http://tom.lokhorst.eu/2010/09/why-libraries-are-better-than-frameworks
[2]: http://discuss.joelonsoftware.com/default.asp?joel.3.219431.12&
[3]: http://blog.orderharmony.com/2011/07/libraries-vs-frameworks.html
[4]: http://en.wikipedia.org/wiki/Linker_(computing)#Static_linking

Lastly, I worry that time and brainpower that I pour into frameworks goes
unrewarded. When I don't want to use a framework, the framework changes, or
I want to do something that the framework doesn't support, I'm left out in
the cold. All of these scenarios play out often. Each time a new version of
Rails comes out, it is infused with whatever OOP fashion is reigning at the
time: concerns, presenters, etc. The way that I *used* to do something is
rendered obsolete without warning and without recourse. The knowledge that
I had about how to work with the framework has gone stale -- like money,
"you can't take it with you."

I think that it is time that we, as software developers, become responsible
for our own fate. Make decisions, find out what works, learn! We have no
excuse for being held hostage to decisions that we didn't make just
because we didn't understand the nature of the decision. Software
development is more than just filling in the blanks on some giant MadLibs
of a framework. Software is the most infinitely pliable medium of design
that the world has ever seen. Like a proof, if you can show your reasoning
to be sound you can do it that way. There's no limit, so go out and build!
