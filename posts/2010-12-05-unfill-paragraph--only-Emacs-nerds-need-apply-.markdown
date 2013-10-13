---
title: unfill-paragraph (only Emacs nerds need apply)
---

I usually keep plain text at a nice and tidy 72 columns (give or take, but certainly under 80!). But there are times when it is necessary to have code that will be folded (word-wrapped) by the end user. Think of those text boxes on websites where the result is going to be displayed on some website in a totally unformatted way. In this case you want the text to be one long line per paragraph with a blank line separating each. That way, the text is as wide as the browser window or otherwise follows user preferences (see <http://www.mozilla.org/unix/customizing.html#usercss> for how to do this in Firefox). Since I'm always hitting M-q in Emacs, my code's always formatted at 72ish columns. The following bit of Emacs Lisp lets you unfill-lines, that is it strips out newline characters within a paragraph.

    ;; Stefan Monnier <foo at acm.org>. It is the opposite of fill-paragraph
    ;; Takes a multi-line paragraph and makes it into a single line of text.

    (defun unfill-paragraph ()
        (interactive)
        (let ((fill-column (point-max)))
        (fill-paragraph nil)))

    (global-set-key (kbd "C-c M-q") 'unfill-paragraph)
