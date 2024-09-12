;;; clay.el --- Emacs commands Clay - literate in Clojure  -*- lexical-binding: t; -*-

;; Copyright (C) 2023 Scicloj

;; Author: daslu
;; Keywords: lisp
;; URL: https://github.com/scicloj/clay.el
;; Version: 1.5

;; Package-Requires: ((emacs "27.1") (cider "1.0"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Emacs commands for the Clay tool for literate programming in Clojure

;;; Code:

(require 'cider)
(require 'tramp)


(defgroup clay nil
  "Clay Emacs integration."
  :prefix "clay-"
  :group 'applications
  :link '(url-link :tag "GitHub" "https://github.com/scicloj/clay.el"))

;; These variables are not intended to be customized,
;; but can be overridden for hotfixes.
(defvar clay-api-ns
  "scicloj.clay.v2.api"
  "Clay API default namespace.")

(defvar clay-require-form
  (format "(require '[%s])" clay-api-ns))

(defvar clay-start-form
  (format "(%s/start!)" clay-api-ns))

(defvar clay-ns-fmt
  (format
   "(%s/make! {:format %%s :base-source-path nil :source-path \"%%s\"})"
   clay-api-ns))

(defvar clay-form-fmt
  (format
   "(%s/make! {:base-source-path nil :source-path \"%%s\" :single-form (quote %%s)})"
   clay-api-ns))

(defun clay-require ()
  "Require the Clay API in your Clojure REPL."
  (interactive)
  (cider-interactive-eval clay-require-form))

(defun clay-start ()
  "Start Clay if not started yet."
  (interactive)
  (clay-require)
  (cider-interactive-eval clay-start-form))

(defun clay-eval-from-file (fmt code &optional save)
  "Eval CODE, formatted with FMT, optionally SAVE before evaluation."
  (when save
	(save-buffer))
  (clay-require)
  (when-let ((filename (tramp-file-local-name (buffer-file-name))))
    (cider-interactive-eval
	 (format fmt filename code))))

(defun clay-make-ns-html ()
  "Save this Clojure buffer, render it as HTML, and show that in the browser view."
  (interactive)
  (clay-eval-from-file clay-ns-fmt "[:html]" 'save))

(defun clay-make-ns-quarto-html ()
  "Save this Clojure buffer, render it as Quarto, render that as HTML.
Show that in the browser view."
  (interactive)
  (clay-eval-from-file clay-ns-fmt "[:quarto :html]" 'save))

(defun clay-make-ns-quarto-revealjs ()
  "Save this Clojure buffer, render it as Quarto, render that as reveal.js.
Show that in the browser view."
  (interactive)
  (clay-eval-from-file clay-ns-fmt "[:quarto :revealjs]" 'save))

(defun clay-make-last-sexp ()
  "Render the last Clojure form before the cursor (using the format specified by Clay defaults or user configuration)."
  (interactive)
  (clay-eval-from-file clay-form-fmt (cider-last-sexp)))

(defun clay-make-defun-at-point ()
  "Render the top-level Clojure form at the cursor (using the format specified by Clay defaults or user configuration)."
  (interactive)
  (clay-eval-from-file clay-form-fmt (cider-defun-at-point)))

(provide 'clay)
;;; clay.el ends here
