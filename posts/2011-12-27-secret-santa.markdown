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

```
[1, 2, 3] would have a derangement:
[2, 3, 1]
```

notice that each element has moved.  So this pertains to secret
santas because if you are just not allowed to chose yourself then
a derangement (like
[this](http://hackage.haskell.org/package/derangement)) is all
that you'd need, it would be a valid secret santa!

```haskell
zip [1, 2, 3] (derangement [1, 2, 3])
-- [(1,2),(2,3),(3,1)]
```

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

```haskell
import Data.List (delete, permutations, intercalate)
import System.Random

type Person = String
type SantaSuggestion = [(Person, Person)]

people :: [Person]
people = ["Chris", "Sarah", "Matt", "Jimmy", "Colin", "Kelsey", "Peter"]

-- main function chooses from the lowest-scoring (least bad)
-- SantaSuggestions and prints it out
main = do
    let choiceSantas = bestSantas 0
    selected <- randomSelect choiceSantas
    putStrLn $ showSanta selected

-- Various lists of SantaSuggestions...
-- ...everything, allowed or not
allSantas :: [SantaSuggestion]
allSantas = map (zip people) (permutations people)

-- All the SantaSuggestions but with explicitly disallowed pairings
-- eliminated
allowedSantas :: [SantaSuggestion]
allowedSantas = filter goodSuggestion allSantas

-- All allowed SantaSuggestions but with a numeric score of "badness"
rankedSantas :: [(Int, SantaSuggestion)]
rankedSantas = map (\sugg -> (score sugg, sugg)) allowedSantas

-- Limit the ranked SantaSuggestions to those with <= given limit
bestSantas :: Int -> [SantaSuggestion]
bestSantas limit = map snd $ filter (\(score, _) -> score <= limit) rankedSantas

-- a good suggestion is when nothing in the pairings is explicitly
-- disallowed
goodSuggestion :: SantaSuggestion -> Bool
goodSuggestion = not . any disallowed

-- A list of pairings that are not allowed
disallowedPairs = [("Chris", "Sarah"),  -- spouses
                   ("Matt", "Jimmy"),   -- siblings
                   ("Colin", "Kelsey"), -- siblings
                   ("Peter", "Sarah")]  -- siblings

-- These pairings are discouraged, a SantaSuggestion containing these
-- gets points of 'badness' for each one found
discouragedPairs = [("Chris", "Matt"),  -- cousin in-law?
                    ("Sarah", "Matt"),  -- close cousins
                    ("Chris", "Peter")] -- brother in-law

-- can't have yourself, or one of the disallowed pairings
disallowed :: (Person, Person) -> Bool
disallowed p@(x, y) = x == y || any (pairMatch p) disallowedPairs

score :: SantaSuggestion -> Int
score = foldl (\total pair -> total + discouragedPoints pair) 0

discouragedPoints :: (Person, Person) -> Int
discouragedPoints p@(x, y) = if any (pairMatch p) discouragedPairs 
                             then 1 else 0

-- utility stuff
showSanta :: SantaSuggestion -> String
showSanta s = intercalate "\n" $ map (\(p1, p2) -> p1 ++ " gives to " ++ p2) s

pairMatch (u, v) (x, y) = (u, v) == (x, y) || (v, u) == (x, y)

-- adapted from http://www.haskell.org/haskellwiki/99_questions/Solutions/23
randomSelect :: [a] -> IO a
randomSelect lst = do
    pos <- getStdRandom $ randomR (0, (length lst) - 1)
    return $ lst !! pos
```
