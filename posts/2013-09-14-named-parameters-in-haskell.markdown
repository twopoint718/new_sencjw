---
title: named parameters in haskell
---


I was watching [Rich Hickey's
keynote](https://www.youtube.com/watch?v=rI8tNMsozo0) for Rails
Conf 2012. I've been watching a lot of talks lately because I've
organized a series of conference talk screenings at my work. And
that's probably a different blog post...

Anyhow, one thing that he mentioned that I don't often
think about is the complexity introduced with positional
parameters. Let me explain:

```javascript
function foo(x, y, z,) {...}
```

Requires that x, y, and z all be present in that exact order
even if that's not important:

```javascript
function make_person(first, last, phone) {...}
function make_person(last, first, phone) {...}
function make_person(phone, first, last) {...}
```

If you encountered a wild `make_person`, you'd have to know which
definition was the one that was used. The point is it really doesn't
matter that a person's attributes are listed in that order.  Any
order is fine. But you've, implicitly, introduced a strict
order-dependence here. Passing in a map/object/hash fixes this
issue[^well_actually]:

[^well_actually]: Well, *almost*. The ideal thing would be a typed
record of some sort so that the function's access would be guaranteed
to be safe. If this weren't the case then you'd have lost the safety
that parameters give you. With parameters, it is instantly obvious
if there's one missing, the call is simply *wrong*. Likewise with
typed records, accessing a field that doesn't exist would be a
compile-time error. In Ruby-style hash access, you'd just get a `nil`
for any missing field/value.

```javascript
function make_person(opts) {
  opts['first'] = ...
  opts['last'] = ...
  opts['phone'] = ...
}
```

Haskell is pretty tied to the positional and unnamed argument
thing. I was looking into how to do named and/or non-positional
arguments.

### Datatype

The first thing that occurred to me is to do something like this:


```haskell
import Text.Printf

data Person = Person { firstName :: String
                     , lastName :: String
                     , email :: String
                     }

formatAddress :: Person -> String
formatAddress p = printf "\"%s %s\" <%s>" f l e
  where
    f = firstName p
    l = lastName p
    e = email p
```

And then I call it like so:

```haskell
formatAddress Person { firstName = "Chris"
                     , lastName = "Wilson"
                     , email = "chris@bendyworks.com"
                     }
```

A slightly better tweak is to create a default that provides values
for anything that's missing (assuming that I have a function that
just calls for one parameter):

```haskell
formatEmail p = printf "<%s>" (email p)

defaultPerson = Person {firstName = "", lastName = "", email = ""}
```

But that "infects" the call site with the `defaultPerson` argument:

```haskell
formatEmail defaultPerson {email="chris@bendyworks.com"}
```

All the other, irrelevant arguments are defaulted by the
`defaultPerson` constructor.

### Named Records

This pulls in the big guns of template Haskell to abstract machinery
something like what is spelled out above:


```haskell
{-# LANGUAGE TemplateHaskell #-}

import Data.NamedRecord
import Text.Printf
import Data.Name

name "firstName"
name "lastName"
name "email"

record "Person"
    `has` "firstName" := ''String
    `has` "lastName"  := ''String
    `has` "email"     := ''String

formatEmail :: Person -> String
formatEmail p = printf "<%s>" e
  where
    e = p `get` email
```

But it has a rather pleasant usage:

    formatEmail (newPerson `set` email := "chris@bendyworks.com")

There is also a nice way to do [default
arguments](http://hackage.haskell.org/packages/archive/named-records/0.5/doc/html/Data-NamedRecord.html).
Go check it out, the docs are good.


### Lenses

Okay, I have to admit that I'm less sure about this. Metaphor-weary
haskellers please forgive me, but lenses seem to be the space-based
laser (SBL) of the Haskell world right now. While the idea is
simple, you'd like a way to pinpoint a structure for observation
or (destructive) modification, the actual infrastructure
surrounding it is rather elaborate. On the [Haskell
Cast #1](https://www.youtube.com/watch?v=D6sva6hGJ-s),
Edward Kmett goes into the details of the lens library.
A few "[lenses are the coalgebras for the costate
comonad](http://patternsinfp.wordpress.com/2011/01/31/lenses-are-the
-coalgebras-for-the-costate-comonad/)"s are thrown around and
there's generally a lot sailing over my head.

On iota of wisdom that I pulled down from the stratosphere was that
lenses are a kind of "getter" and "setter", albeit ones with firm
FP grounding. These can be used to effectively create flexible
parameters to functions. "Flexible" just means:

* a pool of parameters to draw from
* that are named rather than positional
* and not all have to pe present

```haskell
{-# LANGUAGE TemplateHaskell #-}
import Control.Lens
import Text.Printf

data Person = Person { _firstName :: String
                     , _lastName :: String
                     , _email :: String
                     }

makeLenses ''Person

-- use the "email" getter
formatEmail p = printf "<%s>" (p^.email)

-- issues a warning, but works.
main = putStrLn $ formatEmail (Person{_email="chris@bendyworks.com"})
```

Whew. It feels like cheating, but I really like how this works.
Lenses let me "focus" on each field in my data structure by name (or
position).

Lenses seem to fulfill the three bullets that I listed and they do
so in the most "natural" way. I say that because, as Edward Kmett,
goes into, lenses are useful for a bunch of other stuff and they
compose really nicely:

```haskell
data Person = Person { -- ...like above...
                     , _phone = Phone { _number = "...", _type = "mobile" }
                     }

data Phone = Phone { _number :: String, _type :: String }

chris^.phone^.type -- equals "mobile"
```

So, in summary, I feel that lenses provide a credible solution to
the named-record/non-positional/keyword arguments problem. Go forth
and hack.
