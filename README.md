# clay.el

[![License GPL 3][badge-license]](http://www.gnu.org/licenses/gpl-3.0.txt)

Emacs binding for the [Clay](https://scicloj.github.io/clay) Clojure tool for data visualization and literate programming

:star: Note that API function names have changed (2024-01-10), see below. :star:


## Usage

### Walkthrough

:movie_camera: [Clay v2 pre-release with CIDER, 2023-12-17](https://www.youtube.com/watch?v=fd4kjlws6Ts)

### Installing

The Clay package is in [MELPA](https://melpa.org/):
[![MELPA](https://melpa.org/packages/clay-badge.svg)](https://melpa.org/#/clay)

### API
  
  The package offers the following functions, that you may wish to create keybindings for:
  | name                           | function                                                                                                      |
  |--------------------------------|---------------------------------------------------------------------------------------------------------------|
  | `clay-start`                   | Start clay if not started yet.                                                                                |
  | `clay-make-ns-html`            | Save clj buffer, render it as html, and show that in the browser view.                                        |
  | `clay-make-ns-quarto-html`     | Save clj buffer, render it as quarto, render that as html, and show that in the browser view.                 |
  | `clay-make-ns-quarto-revealjs` | Save clj buffer, render it as quarto, render that as a revealjs slideshow, and show that in the browser view. |
  | `clay-make-last-sexp`          | Render the last Clojure form before the cursor.                                                               |
  | `clay-make-defun-at-point`     | Render the the top-level Clojure form at the cursor.                                                          |

## License

Clay.el is distributed under the GNU General Public License, version 3.

Copyright © 2024 Scicloj

[badge-license]: https://img.shields.io/badge/license-GPL_3-green.svg
