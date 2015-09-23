—
title: Lenses for Business, Mk. II
—

## The Mark I

Edward Kmett gave [a talk at ICFP 2015][kmett15] entitled “The Unreasonable Effectiveness of Lenses for Business Applications” which was really tantalizing for me. More on that in a sec.

One of my favorite bloggy things is [F♯ for fun and profit][Wlaschin15]. There, the intrepid Wlaschin writes about functional programming’s assailing of the UML-buttressed walls of the _Enterprise_. But the funny thing is that it works so well! Every subject that he covers, he manages to inject a really compelling use case for FP. The mark of a successful campaign of persuasion is that the victim (that’s me here) comes away feeling like it couldn’t be any other way: “Duh, yeah that’s obvious, FP’s a great fit for [BLOBA][BLOBA]s!”

Having said that of course, now I think, how could it be any different? Compact type definitions like in Haskell or F♯ _really do_ lend themselves to quickly jotting down a business domain. I can follow along writing datatypes pretty much at the speed that a domain expert can utter them. And putting them down, “fixed in a tangible medium of expression,” forces all parties: myself and domain experts to be _concrete enough_.

So yay for expressive types, yay for lightweight syntax, and yay for not talking around in circles all day. Wait, what did that Kmett video have to do with this again? Right.

When I hit play on that video, I was really hoping for something similar. I’ve watched (or attended) [lots][kmett12] [of][Henrichs13] [lens][bayhac14] [talks][spj13] and so the idea that there was going to be this same businessy slant on lenses as on other FP concepts, I was sold. But that’s not what the talk is. It is more like another lens talk, which adds admirably to the canon, but wasn’t in this weird subgenre of programming that I’m into: _FuncBiz_.

And so, like Gandhi says: “Be the functional programming tutorial that you wish to see in the world.” Or something like that. Natch, Imma write that.

[kmett15]: https://www.youtube.com/watch?v=T88TDS7L5DY
[Wlaschin15]: http://fsharpforfunandprofit.com/
[BLOBA]: http://www.slideshare.net/ScottWlaschin/ddd-with-fsharptypesystemlondonndc2013/13?src=clipshare
[kmett12]: https://www.youtube.com/watch?v=cefnmjtAolY
[Henrichs13]: https://www.youtube.com/watch?v=6GNDzrgFhGM
[bayhac14]: https://wiki.haskell.org/BayHac2014
[spj13]: https://skillsmatter.com/skillscasts/4251-lenses-compositional-data-access-and-manipulation

## The Mark II