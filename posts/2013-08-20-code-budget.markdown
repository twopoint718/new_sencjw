---
title: code budget
---


At almost the moment a new project begins, we start the ritual of
estimation. Guess how long this will take. Guess how much this will
cost. How about if we change that feature to this feature? The goal
of all this prognostication is to try to fit a potentially infinite
product within the finite means we have available to us in terms of
money, people, and (sometimes overlooked) political will.

These are all precious and limited resources that we must *spend*;
we trade what we can afford for the software we want. Grouped among
these precious and limited resources, I think we must include *lines
of code*. As
[Dijkstra](http://www.cs.utexas.edu/~EWD/transcriptions/EWD10xx/EWD1036.html)
noted, that lines of code added are being recorded in the *wrong side
of the ledger*. This means that as code is added to a codebase the
difficulty of making changes or future additions keeps going up.
This has a self-limiting effect in the same way that a dollar budget
is self-limiting: when you exceed the budget you should examine the
goals and outcomes of the project.

That's my proposal. At the start of a project estimate the quantity
of code needed to solve the business problem. This is hard in the
same ways that other estimation is hard, but with time and practice,
should be doable. When this budget is exceeded it should trigger
some tough questions about the state that the project is in. Why
have we used more lines of code than we thought? Could this be
refactored? A benefit of the code budget is that it will force the
team to examine the codebase at exactly the time that projects tend
to be in maximum crunch mode. This hard check is a good thing that
keeps everyone grounded in quality when all other external signals
are screaming everything but.
