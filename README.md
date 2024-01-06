# clay.el

<img src="https://raw.githubusercontent.com/scicloj/graphic-design/live/icons/Clay.svg" alt="Clay" align="right" width="128"/>
<img src="https://www.gnu.org/savannah-checkouts/gnu/emacs/images/emacs.png" alt="Emacs" align="right" width="128"/>

Emacs binding for the [Clay](https://scicloj.github.io/clay/) tool (data visualization and literate programming in Clojure)


## Usage

Using [use-package](https://github.com/jwiegley/use-package) and [straight](https://github.com/radian-software/straight.el), you may load the package as follows:

```elisp
(use-package clay
  :straight (clay
             :type git
             :host github
             :repo "scicloj/clay.el"))
```

Using [use-package](https://github.com/jwiegley/use-package) and [vc-use-package](https://github.com/slotThe/vc-use-package), you may load the package as follows:

```elisp
(use-package clay
  :vc (:fetcher github :repo scicloj/clay.el))
```
  
  The package offers the following functions, that you may wish to create keybindings for:
  |name|function|
  |--|--|
  |`clay/start`|start clay if not started yet|
  |`clay/make-ns-html`|save clj buffer, render it as html, and show that in the browser view|
  |`clay/make-ns-quarto-html`|save clj buffer, render it as quarto, render that as html, and show that in the browser view|
  |`clay/make-ns-quarto-revealjs`|save clj buffer, render it as quarto, render that as a revealjs slideshow, and show that in the browser view|
  |`clay/make-last-sexp`|render the last s-expression|
  |`clay/make-defun-at-point`|render the [defun-at-point](https://www.emacswiki.org/emacs/ThingAtPoint)|

