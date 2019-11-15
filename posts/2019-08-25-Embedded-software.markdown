---
title: Embedded Software
---

I've been really fascinated lately (last ~1 yr or so) by _embedded software_.
In short, software that's written to run on devices that are _tiny_ by today's standards.
A typical microcontroller, say an ARM Cortex M4, may spec out as:

- 80MHz 32-bit processor
- 256KB [Flash](https://en.wikipedia.org/wiki/Flash_memory)
- 32KB [SRAM](https://en.wikipedia.org/wiki/Static_random-access_memory)
- 2KB [EEPROM](https://en.wikipedia.org/wiki/EEPROM)

In short, not a whole lot of storage for your programs and _really_ not a lot of RAM to work within.
Plus, you may not have a ton of extra cycles in which to accomplish what you'd want to do.
Everything about developing for these systems demands a style of work that is exceedingly parsimonious.
And to Johnny or Julie web-dev, you'll come across as a grubby ascetic howling from your mountain shack about _individual bytes!_

Okay.
So what does one get in trade for all this digital self-deprivation?
Two big features that I've noticed are:

- Low-latency and predictable timing
- Interacting with the real world

## Low latency and predictable timing

An embedded system can react to input quickly largely because it isn't doing anything else.
The processor is humming along at its 80MHz, completing a cycle each 12.5 nanoseconds, when some event happens (lingo: "trigger an interrupt").
In a smallish number of cycles, code to handle that event can start running.
The exact figure varies, but it's quick: say 150-250ns.
If you can set a flag or otherwise do simple operations then the whole interrupt may last only 500ns.
This brings within reach the ability to run some bit of code at a megahertz rate.
As far as us pokey humans are concerned, the system reacts instantly.

For me, both as a software developer and consumer, this immediate responsiveness is a deeply satisfying aspect of embedded development.
As a user, I love the idea that when I press a button something _happens_ and that it happens _fast_.
And as a creator, being able to accomplish this feat feels like a superpower.

## Interacting with the real world

Speaking of a superpower, what could be more magical than being able to reach out of the digital world and poke bits into meatspace?
Or the reverse, to sample what's going on "out there" and react to it, computationally.
A sensor reading becomes a byte in a register, all ready to work with.

Astute readers now clear their throats:

> What about combining the _sampling_ with the _poking_?
> And doing that over and over automatically to, like, _control_ stuff?

Yup.
That is both emphatically [a thing](https://en.wikipedia.org/wiki/Control_system) and [really cool](https://en.wikipedia.org/wiki/Control_theory).
Cool.

## Ongoing

Anyway this is a thing that I think is pretty cool and I've been digging into it.
As a fun kicker there's lots of cross-pollination with other things that I also think are cool.
While the term _Internet of Things_ is reaching toxic levels of buzzwordiness, there's a kernel of really neat stuff there.
It's extending the internet's feelers and actuators into the real world.
It involves radio protocols like WiFi, [LoRa](https://lora-alliance.org), [BLE](https://en.wikipedia.org/wiki/Bluetooth_Low_Energy), and [many others](https://www.rs-online.com/designspark/eleven-internet-of-things-iot-protocols-you-need-to-know-about).
You can even use [audio frequencies as your data transport](https://chirp.io).

As work on projects, I'll write about them here.
Or over on the tech blog.
