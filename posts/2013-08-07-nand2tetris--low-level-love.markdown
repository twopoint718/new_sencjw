---
title: nand2tetris: low-level love
---


I've been working through *The Elements of Computing Systems*, or as
it is sometimes called [nand2tetris](http://nand2tetris.org). This
is a fun course where you start out by being given (say: from God)
the humble nand gate (file photo below):

<img src="http://upload.wikimedia.org/wikipedia/commons/e/e6/NAND_ANSI_Labelled.svg"
     width="300"
     alt="Schematic of a nand gate">

And here's a nude photo (showing how one would be implemented):

<img src="http://upload.wikimedia.org/wikipedia/commons/d/d4/TTL_npn_nand.svg"
     width="300"
     alt="Electrical schematic of a nand gate">

But as far as nand2tetris is concerned, you can just assume that
the above is a fact of life. You have a nand tree. So what do you
do? well you start on an adventure where you define *Not* then *And*
then *Nor* and, well you get the idea. Soon you find that you have a
working [ALU](https://en.wikipedia.org/wiki/Arithmetic_logic_unit).

I'm currently on the cusp of making the hardware to software jump.
All along I've been having a blast wiring up these little beasties
in [HDL](https://en.wikipedia.org/wiki/Hardware_description_language)

The course finishes up with implementing cool software in a HLL
language. I haven't peeped this far ahead but it is supposed to be
akin to Java. Oh yeah, by the time you get to this point you'll have
implemented the compiler for this language, the VM that it runs in,
the raw machine code the VM is written in, the CPU that runs that
machine code, and so on. It goes all the way back to that humble
nand gate that you started out with.

I hope to post some updates as I progress through the course,
~~but the quickest way is to check my commits over on my n2t
github project.~~

*Edit: sorry to say this, but I've taken down that repo since it conflicts
with the wishes of the authors of the course.*

As a slight digression, but surely belonging here, this has
been something of a summer-o-hardware for me. I started reading
[CODE](http://www.charlespetzold.com/code/) by Charles Petzold a
while back and the bottom-up description of computing that he laid
out was intoxicating. I had to learn more and get my hands dirty
with bits and bytes. And that's when my hardware voyage began.

In keeping with this theme, here's a short reading list if you want
to blast your brain with computing. In fact, I bet that if you were
to go through all these books it'd be like getting a degree in
computer science -- with a minor in cool-nerd history:

* [The Information](http://www.amazon.com/dp/1400096235) by James Gleick
* [The Elements of Computing Systems](http://www.amazon.com/Elements-Computing-Systems-Building-Principles/dp/0262640686) by Nisan and Schocken
* [CODE](http://www.charlespetzold.com/code/) by Charles Petzold
* [Understanding Computation](http://computationbook.com) by Tom Stuart
* [Gödel, Escher, Bach](http://www.amazon.com/Gödel-Escher-Bach-Eternal-Golden/dp/0465026567) by Douglas R. Hofstadter

There you have it. Go off and hack hardware!
