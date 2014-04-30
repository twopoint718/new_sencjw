---
title: Lenses 101 (for me)
---

*Note:* This is a short commentary on the new [wreq
library](http://www.serpentine.com/wreq/). These comments were directed at my
coworkers, but I thought they'd be interesting here. This post is literate
Haskell, you should be able to cut-n-paste.

---

> {-# LANGUAGE TemplateHaskell #-}
> module Main where
> import Control.Lens

I think a big reason why I'm so stoked about this is that it's a solid library
that's offering a lens-based API (something that I think will show up more and
more as time goes on). I'm still digging into them, but lenses are sort of
like the "." (dot) from Ruby, but implemented as a library and infinitely more
flexible:

Getters:

your basic "getter" is ^. (carrot-dot, aka "view") It lets you "view" things:

> -- basic "Person" data
> data Person = Person {_fn::String, _ln::String, _email::String} deriving Show
> 
> me :: Person
> me = Person {_fn="Chris", _ln="Wilson", _email="chris@bendyworks.com"}
> 
> $(makeLenses ''Person) -- autogen the getters/setters

And using it to view inside the Person datatype:

> ex1 = me^.fn
> -- "Chris"
> ex2 = me^.email
> -- "chris@bendyworks.com"

Next you've got your "setter" (it just updates, non-destructively returning a
new thing), also called "set":

> ex3 = set fn "Christopher" me
> -- Person {_fn = "Christopher", _ln = "Wilson", _email = "chris@bendyworks.com"}

or saying it with operators (the & above is reverse function application, the
function on the right is applied to the data on the left, kinda like a shell
pipeline):

> ex4 = me & fn.~"Christopher"
> -- Person {_fn = "Christopher", _ln = "Wilson", _email = "chris@bendyworks.com"}

"But Chris!" you interject, "that's just lame-o '.' that's in Ruby ALREADY!
Show me some lazer-beam stuff!" Okay, lenses also do traversing! That is you
can get/set a bunch of things at once:

> -- bendyworks
> data Bendyworks = Bendyworks {_employees::[Person]} deriving Show
> $(makeLenses ''Bendyworks)
> -- some setting up
> bendy = Bendyworks {_employees =
>     [ Person "Amy" "Unger" "amy@bendyworks.com"
>     -- ...
>     , Person "Will" "Strinz" "will@bendyworks.com"
>     ]} -- all employees (imagine)

Now we traverse over the employees field of the Bendyworks structure, and we
can compose a getter with that!

> ex5 = bendy ^.. employees.traversed.fn
> -- ["Amy", ..., "Will"]
> 
> ex6 = bendy ^.. employees.traversed.email
> -- ["amy@bendyworks.com", ..., "will@bendyworks.com"]

The thing that's kinda cool is that "employees.traversed.fn" forms a sort-of
lens on the whole Bendyworks datatype, letting us walk over it and pull out
values. The traversal is a first-class thing (those '.'s in the name are just
plain-old function composition!). We can store it and use it as a new
accessor:

> emails :: Traversal' Bendyworks String
> emails = employees.traversed.email
> 
> ex7 = bendy ^.. emails
> -- [...] -- just like above

They're really composable! You can set a traversal with your old friend .~
(set):

> ex8 = bendy & emails .~ "[HIDDEN]"
> -- Bendyworks {_employees = [Person {_fn="Amy",...,_email="[HIDDEN]"}, ...]}

That's simultaneously setting the emails of all Bendyworkers to the string
"[HIDDEN]". Notice how, if you squint, it's like the .~ is a SUPER-DOT that
can set a bunch of stuff at once. I think it is way cool.  I'm just starting
to look at the lens library and it's big. There are tons of functions in there
and a lot ground covered. But I think that as time goes on this will become
pretty common. Functional getters and setters FTW!
