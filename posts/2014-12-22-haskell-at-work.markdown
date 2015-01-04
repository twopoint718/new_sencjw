---
title: Getting to write Haskell at work
---

Jon and I recently worked on a medium-sized Haskell project:
<https://github.com/bendyworks/api-server>. It has been immensely
gratifying to be able to work on this sort of thing at work. It also makes
me realize the current dismal state of things. I tend to not try to wade
into "language wars" or say things like "my way of doing things is
better..." But after having worked on this project, I'm a little bit sad to
work on other things. Some of the things that I noticed:

* Getting something to build and run took more up-front effort
* ...but that was probably a good thing
* Jumping back into the project was easier
* Finding the bugs that did occur was straightforward
* We wrote fewer tests than similar Ruby project
* Tests were *much* more effective (e.g. simply round-tripping something
  through the database flushed out a bunch of errors)

What I think gets lost in these sorts of commentaries or comparisons and
what I don't want to get lost here is that there's a *clear-win* sense to
it that people tend to miss. That is, I think that these sorts of posts
[bury the lede](http://en.wiktionary.org/wiki/bury_the_lede) by not
starting with: *"Of course Haskell is the way to go, but here are some
drawbacks..."*

The above list omits things like the fact that even though it took longer
to get something up and running, what that *means* is that if we ignored
all the help that Haskell was providing us, we'd only succeed in getting
something *incorrect* up and running sooner. Is it better to get the wrong
answer faster? I don't think so. But I admit that that position may be up
to people's personal taste. This experience has left me grappling with a
sinking feeling, that the current development economy that I'm a part of:
startups writing web apps, large companies wanting new features added to
existing code, and other similar uses cases simply *does not or cannot
support quality*. I'm suspect that using languages and techniques that
squash most bugs and enable code to be reasonably bug-free are just too
expensive. Quality isn't a priority. We as an industry have chosen "give me
the wrong answer, as long as it is quick."

Don't get me wrong, that's a reasonable choice to make and it's how
engineering works. We have to build what the market will support. "Fast,
good, and cheap; pick 2." We seem to have pretty much given up on *good*
and are just playing with variations on fast and cheap.

If that sounds bleak, I don't mean it to. I *want* to inject quality as an
option, but I realize that it's going to have to happen by going through
the system not around it. There's no royal road to software nirvana.
Perhaps we can frame the problem in a way that will make companies take
notice. Michael Snoyman put it [this
way](http://www.yesodweb.com/blog/2012/08/webinar-oreilly):

> Minimizing bugs is a feature that you can sell people on. If I'm
> comparing product A and product B, and I have some reason to believe
> product B will have less bugs, I'm very likely to buy it. It can win out
> over other aspects of the product, such as cost (do you really want to
> pay for bugs?), ease-of-use (it sure was easy to generate that invalid
> output), or extra capabilities (hey look, this product can do 50 things
> badly).

Maybe that's the tagline for developing code with Haskell: "do you really
want to pay for bugs?" If desirable features have a positive cost (e.g.
"how much would you pay for software that could do X?") would bugs have a
negative cost? (e.g. "how much would you pay for software that didn't do
X?"). It opens the possibility of getting hard numbers on the "negative
feature cost" of bugs, (e.g. "I would pay an extra 10% if my software never
did X"). And *that* in turn opens some headroom for using something like
Haskell.

Put another way, I think that bugs are often *undervalued*. Bugs hurt
"delivered value" a lot more than seems to be widely acknowledged. Sure it
can be nice to be the first one to market, or have the biggest mindshare,
but all that will fade fast if the fail whale persists.
