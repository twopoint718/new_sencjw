# The Transparent Web

## What can the web learn from functional programming?

[Get the book!](https://www.manning.com/books/the-transparent-web?a_aid=transparentweb&a_bid=40bf85fd)

<figure>
  <a href="https://www.manning.com/books/the-transparent-web?a_aid=transparentweb&a_bid=40bf85fd">
	<img
		src="/images/Wilson-TWeb-MEAP.png"
		alt="Transparent Web Cover">
  </a>
</figure>

I've been writing a book!
*The Transparent Web* is my attempt to explore the convergence of functional and web programming.
Functional programming has been with us for over 50 years and the web for about half that.
Clearly, these technologies have coexisted long enough for some _cultural diffusion_ to have happened.
Yet it seemed to me that the main thrust of web development grew out of the OO tradition.
This has taken us really far.
Rails, and frameworks like it, have enabled zillions of great web applications.
But as web applications become ever more dizzyingly complex, we have to begin to wonder.
Are there tools, techniques, and ideas from functional programming just waiting to be adopted?
If so, what are they?
And how could they be used?

This book looks for those answers.
In it, I explore several frameworks to see how they approach the problem of web development.
To support these forays, I cover key concepts used throughout functional programs.

These frameworks, and the concepts behind them are becoming more popular and widespread.
Languages like Rust (Mozilla), Swift (Apple), and F# (Microsoft) suggest that big organizations are betting on functional programming.

If you are a web developer and are curious about what all this _functional noise_ is about, then you should check this book out!


### Topics


Among other topics, I'll cover:

 * *Functional programming*, with examples in multiple languages and contexts.
   Many examples are given in [TypeScript](http://www.typescriptlang.org/).
 * [Isomorphic applications](http://isomorphic.net/), which share code between server & client.
   But this is not limited to only JavaScript!
 * [Opa](http://opalang.org/), an isomorphic client/server language and framework.
 * [Haskell](https://www.haskell.org/), demonstrating how to target [WebAssembly](http://webassembly.org/).
 * [Elm](http://elm-lang.org/), showing off client-side coding.


### Presentations


Please see [talks](talks.html) for a list of all the talks I've given.


### The Book

- **Update 1/2018**: All edits are in (and the MEAP has been updated).
  The book should be published by 3/2018 unless otherwise noted.
  Thanks for following along!
- **Update 11/2017**: All manuscript chapters are available as a MEAP.
  I'm wrapping up on editing the last two chapters!
- **Update 6/2016**: [The Transparent Web](https://manning.com/books/the-transparent-web) is now available as a MEAP (early access book) from [Manning Publications](http://manning.com/)!

### Citation

<a class="copy-bibtex" href="">Copy to clipboard</a>

<textarea class="sourceCode bibtex" style="width: 100%; height: 180px">
\@book{wilson2018,&#10;
&nbsp;&nbsp;&nbsp;&nbsp;title = {The Transparent Web},&#10;
&nbsp;&nbsp;&nbsp;&nbsp;subtitle = {Functional, Reactive, Isomorphic},&#10;
&nbsp;&nbsp;&nbsp;&nbsp;author = {Wilson, Christopher J.},&#10;
&nbsp;&nbsp;&nbsp;&nbsp;year = {2018},&#10;
&nbsp;&nbsp;&nbsp;&nbsp;publisher = {Manning Publications},&#10;
&nbsp;&nbsp;&nbsp;&nbsp;isbn = {9781633430013}&#10;
}
</textarea>

<script>
    var code = document.querySelector('textarea.sourceCode.bibtex');
    var copyLink = document.querySelector('a.copy-bibtex');
    copyLink.addEventListener('click', function(evt) {
        evt.preventDefault();
        code.select();
        try {
            var successful = document.execCommand('copy');
            if (successful) {
                copyLink.innerHTML = 'copied';
            } else {
                copyLink.innerHTML = 'could not copy';
            }
        } catch (err) {
            copyLink.innerHTML = 'error, could not copy';
        }
        window.setTimeout(function() {
                copyLink.innerHTML = 'Copy to clipboard';
            },
            1000
        );
    });
</script>

Thanks for the citation!
