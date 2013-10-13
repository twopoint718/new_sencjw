---
title: strangeloop 2011 notes
---


I got back from [Strangeloop 2011](https://thestrangeloop.com/) just this week and wanted to cover some of the interesting points from this *really* fascinating conference (it is on my *must go* list from now on)!

It was incredibly difficult to get to all the talks that I wanted to see because the conference was "seven talks wide" at most points.  A common theme emerged where, as I finished up a talk in one room, I would see the stream of tweets start rolling in about some incredible talk that I had just missed; I can't wait for those videos.

Here's my recap of the stuff that I went to:

**Sunday (workshop day)**

 * *Haskell: Functional Programming, Solid Code, Big Data* with
   Bryan O'Sullivan - this was a really nice intro to Haskell for
   someone that hadn't ever seen it before.  I've worked through
   about half of the "Real World Haskell" book so a lot of this
   was not new.  But it was great to see one of the authors
   explain some points himself.  There was also some interesting
   comments from [Gerald
   Sussman](http://en.wikipedia.org/wiki/Gerald_Jay_Sussman) about
   how haskell is the "most advanced of the obsolete languages"
   (more on that later).


**Monday (first day of conference)**

 * *Category Theory, Monads, and Duality in (Big) Data* with Erik
    Meijer - This was a really cool opening keynote where Erik
    Meijer launched the new term *CoSQL* instead of *NoSQL* by
    showing how the two concepts are
    [duals](http://en.wikipedia.org/wiki/Dual_(mathematics)) of
    one another (in the mathematical, category theory sense). This
    proved to be something of an overarching theme of the
    conference, things being different but mirrored versions of
    the same thing. see: [A co-Relational Model of Data for Large
    Shared Data
    Banks](http://queue.acm.org/detail.cfm?id=1961297).

 * *[I skipped this timeslot because I was on the [hallway
    track](http://blog.hallwaytrack.org/articles/2006/04/27/the-hallway-track-blog)
    listening to Erik Meijer talk about static typing with some
    scala folks; very interesting!]*

 * *An Introduction to Doctor Who (and Neo4j)* with Ian Robinson -
    I have to admit, I got sucked in because I'm a huge Doctor Who
    fan, but I *had* heard of graph databases before and Neo4j
    looked to be a really interesting one. In particular, I wanted
    to see if this could be used from Clojure (yes:
    [borneo](http://github.com/wagjo/borneo) and
    [clojure-neo4j](https://github.com/mattrepl/clojure-neo4j)). The
    talk concerend building a very complicated network of the
    relationships between several Doctor Who props (Daleks!) over
    time. It was pretty easy to see how these mapped nicely to
    nodes with arcs between them.

 * *Skynet: A Scalable, Distributed Service Mesh in Go* with Brian
    Ketelsen - this was a cool talk about a lightweight framework
    written in [go](http://golang.org/) for writing distributed
    applications that are highly resilient. It uses
    [Doozer](https://github.com/ha/doozerd) for data storage
    (though it didn't in this talk).

 * *Parser Combinators: How to Parse (nearly) Anything* with Nate
    Young - This talk gave examples of writing parser combinators
    (where a *parser* here means a function that can consume a
    little input, and then returns another function that consumes
    input after it). The idea is to chain these parsers together
    with *combinators* (higher-order functions which take parsers
    and operate on them, like "oneOrMore" etc.).  This talk
    reminded me of Bryan O'Sullivan's funny phrase about how
    haskell's ">>=" operator (read "bind") is written in "moon
    language".

 * *Getting Truth Out of the DOM* with Yehuda Katz - This was a
    talk about the [SproutCore](http://www.sproutcore.com/)
    framework. Katz had a lot of insight about how to keep the
    browser interaction abstract and event-based rather than
    mucking about (and then being mired) in the DOM.

 * *We Don't Really Know How to Compute!* with Gerald Sussman -
    This was a mind-blowing keynote. In fact, I had to develop a
    new unit of measure, the *Eureka*, which denotes having one's
    mind blown once per minute.  I think that in the 50-some
    minute talk that Sussman gave, I may have had more than about
    50 mind-blowing thoughts. At one point Sussman asked how much
    time he had left and someone from the audience yelled out "who
    cares?", which was pretty much the feeling in the room.

    Sussman started out the talk with a picture of a [Kanizsa
    Triangle](http://en.wikipedia.org/wiki/Illusory_contours) and
    mentioned that the brain can infer that there is a hidden
    triangle in just about 100 ms which is a few tens of "cycles"
    for the brain.  With a computer, we don't know how to even
    begin to solve this recognition problem in that few of cycles;
    *we don't really know how to compute*. Sussman's idea (which I
    can't do justice to here), was that computing as we know it
    has to and will change in the near future. Computing will
    become massively distributed ("ambient", but this term is from
    a later talk) and in disparate nodes that must collaborate to
    arrive at answers.

    His
    [example](http://groups.csail.mit.edu/mac/projects/amorphous/Robust/),
    a *Propagator* was a program that can integrate more annd more
    data while keeping track of the provenance of that data. Or
    another way an "independent stateless machine connecting
    stateful cells". Amazing!


**Tuesday (second day of conference)**

 * *Embedding Ruby and RubyGems Over RedBridge* with Yoko Harada -
   This didn't make that much sense to me until coworker (@devn)
   started doing some cool stuff with using ruby gems from clojure.

 * *Event Driven Programming in Clojure* with Zach Tellman - This
   was a really cool talk.  It looked to me to be an
   implementation of go-style concurrency (channels) in clojure.
   There was also a macro that would analyze data dependencies and
   do the correct async calls. The projects are called
   [Lamina](http://github.com/ztellman/lamina) and
   [Aleph](http://github.com/ztellman/aleph) and they're one of
   those things that I want to find a project on which to use
   them.

 * *Teaching Code Literacy* with Sarah Allen - This was a talk
   about how to give kids the opportunity to learn about
   programming at an early age (Allen says that programming is one
   of those things that you don't know if you'll like it until
   you've tried it.)  She also had found that the ages that
   programming should be introduced is 5th-6th grade; earlier than
   I thought!

 * *Post-PC Computing is not a Vision* with Allen Wirfs-Brock -
   This talk started with a breakdown of the eras of computing.
   First was a "coporate" era, then a "personal" era, and now we
   are entering the "ambient" era.  Each era is defined by what
   ends computing resources are put toward.  In the coporate era
   computing was used to solve problems that businesses had, then
   computing became more available generally, and finally it is
   becoming ubiquitous.  This talk also covered the history of the
   browser and how it is, and will be, the platform for the
   forseeable future.

 * *Simple Made Easy* with Rich Hickey - Rich's talk was an
   argument for disentangling computing.  It started with
   separating the notions of "simple", "complex", and "easy".
   Easy is a subjective thing, things that I find easy you may
   not.  Simple is objective, it derives from the notion of "a
   single fold".  Complex is just the opposite, it is "woven or
   braided".  We must avoid adding complexity to our software, or
   as Rich put it, we must not "complect" it ("to interweave or
   entwine").  Humans have a finite (and very limited) ability to
   handle many factors simultaneously, and so to have any hope of
   working with difficult problems, we must be rigorous in working
   toward simplicity.


   Rich had a few words for TDD in his talk, and I think these
   were widely misinterpreted.  His point was simply that tests
   have a cost and a thoughtless devotion to them will risk
   underestimating that cost.  I think a lot of people took that
   to mean "you shouldn't test" or that "tests are worthless", but
   I think he was just pointing out that they're not free.  He
   introduced the term "guardrail programming" for a style that
   just bounces between the guardrails rather than proceeds to a
   destination by steering.


   This talk drew a standing ovation from the crowd, including, I
   hear, Gerald Sussman.  I'll be looking for it on video when it
   comes out.


Strangeloop 2011+N is definitely on my must-attend list.  The people that I met (which could be another couple of blog posts) were worth the admission all by themselves.  The talks were fascinating and gave me a ton to read up on.  The conference felt like it was well-run and organized.  St. Louis was a cool city to hang out in (I wish we had the same open-container law in Madison!).  I can't wait for next year.
