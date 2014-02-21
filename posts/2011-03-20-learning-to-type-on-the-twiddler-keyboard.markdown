---
title: Learning to type on the Twiddler keyboard
---

I recently got a twiddler chorded keyboard (I love it). My two main goals with it are to be able to use it while doing things like giving talks, because it is like having one of those presentation clickers yet at the same time being able to competently type with it. And the second goal is to use it on my smartphone as a better alternative to the on-screen keyboard. I just want to make a little aside on the second goal. It's not totally clear to me how to use an external USB keyboard with Android (though I have some leads) but things look generally promising.

Either use, of course, assumes that I can type on the crazy thing. I'm one of those people that find it fun to try and re-wire my brain to do new things and I figure that if I switched to dvorak (and have been using it for about 10 years) that I can tackle this thing! I decided to do some drills with the Twiddler so that I get to the point where I can use it for day-to-day stuff, from then on it'll bootstrap itself through frequent use. That, by the way, was roughly my technique for learning dvorak back in the day

 1. Print out the layout and tape it up at eye-level, this breaks
    you of the habit of looking at the keys (they won't help you
    if you remap the keyboard in software)
 2. Do simple drills of the home row (this is great on Dvorak
    because you can form TONS of words)
 3. Expand the drills to less frequently used letters and
    characters
 4. Now that you can type all words, even if you are slow, get on
    IM or IRC in a low-traffic channel that you would like to
    participate in, and just converse. This will provide both
    motivation and practice without the feeling of banging your
    head against the wall.
 5. Do this daily or almost-daily for about 4-8 weeks (that's
    about how long it took me to match and then exceed my QWERTY
    speed)

To deal with steps 2 and 3 on the twiddler, I wrote this short python script that pulls words out out /usr/share/dict/words that can be typed without any chord (open), using the first chord key (1st or "L"), and finally the second chord key (2nd or "M"). I don't have the third chord key on here because using just the first and second is sufficient for all letters. Here's the script:

```python
import random

def all_from(target_list, input_list):
    for c in input_list:
        if not c in target_list:
            return False
    return True

def first_set(input_word):
    return all_from("abcdefghABCDEFGH", input_word)

def second_set(input_word):
    return all_from("ijklmnopqIJKLMNOPQ", input_word)

def third_set(input_word):
    return all_from("rstuvwxyzRSTUVWXYZ", input_word)

def fourth_set(input_word):
    return all_from(".,;'\"?!-", input_word)

def search_words(words, key_set=first_set):
    out = []
    for word in words:
        if key_set(word) and len(word) > 1:
            out.append(word)
    return out

if __name__ == "__main__":
    get_words = 10
    fname = "/usr/share/dict/words"
    wordlist = open(fname, "r").read().split("\n")

    first = search_words(wordlist, first_set)
    second = search_words(wordlist, second_set)
    third = search_words(wordlist, third_set)
    #fourth = search_words(wordlist, fourth_set) # need wordlist w/ punct.

    print "open: ", " ".join(random.sample(first, get_words))
    print "1st:  ", " ".join(random.sample(second, get_words))
    print "2nd:  ", " ".join(random.sample(third, get_words))
    #print "3rd:  ", " ".join(random.sample(fourth, get_words))
```
