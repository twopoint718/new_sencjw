---
title: Don't zip, bundle(1)
---

I've been playing around with Plan 9 from Bell Labs a bunch lately. It takes the Unix idea that everything should have a file-like interface and runs with that to its logical (and surprisingly useful) extreme. It seems like a system that hangs together really well and has the feeling that it was actually designed, rather than grown. But that's enough about that. What I wanted to mention was a script, bundle(1), that I found to be really useful. So, use the source, Luke!, and then I'll say something about it:

    #!/bin/sh
    echo '# To unbundle, run this file'
    for i
    do
        echo "echo $i"
        echo "sed 's/.//' >$i <<'//GO.SYSIN DD $i'"
        sed "s/^/-/" $i
        echo "//GO.SYSIN DD $i"
    done

Cool huh? It's kinda meta but here's what it does: when you run it like bundle file1 file2 > regen.sh it outputs a script that when run will recreate file1 and file2. It does this with a few applications of sed. Using file1 and file2 as examples, say I have file1's contents:

    hello

and file2 is:

    world!

after running bundle with these two files the contents of regen.sh will look like this:

    # To unbundle, run this file
    echo file1
    sed 's/.//' > file1 <<'//GO.SYSIN DD file1'
    -hello
    //GO.SYSIN DD file1
    echo file2
    sed 's/.//' > file2 <<'//GO.SYSIN DD file2'
    -world!
    //GO.SYSIN DD file2

so, if you run this file, it prints "file1" and "file2" to the terminal, but then writes "hello" and "world" to file1 and file2, respectively (after having stripped the "-" off of each line using sed). So this is a neat little way to package up a bunch of text-ish files into a single "self-expanding" package.
