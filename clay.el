;;; clay.el --- Emacs commands Clay - literate in Clojure  -*- lexical-binding: t; -*-

;; Copyright (C) 2023 Scicloj

;; Author: daslu
;; Keywords: lisp
;; URL: https://github.com/scicloj/clay.el
;; Version: 1.5

;; Package-Requires: ((emacs "26.1") (cider "1.0"))

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
(require 'cider-client)
(require 'cider-eval)
(require 'nrepl-client)

(defvar clay-require
  "
    (require '[scicloj.clay.v2.api])"
  "Require the Clay API in your Clojure REPL.")

(defun clay-clean-buffer-file-name ()
  "Clean up the buffer file name in TRAMP situations.
E.g., \"/ssh:myserver:/home/myuSER/myfile\" `-->' \"/home/myuser/myfile\""
  (replace-regexp-in-string "^.*:"
                            ""
                            (buffer-file-name)))

(defun clay-make (filename code &optional assoc-repls)
  "Prepare call to Clay scicloj.clay.v2.api/make! to render CODE from FILENAME and pass connection strings for other REPLs from ASSOC-REPLS."
  (concat clay-require
          "
    (scicloj.clay.v2.api/make! {:base-source-path nil :source-path \""
          filename
          "\" :single-form (quote " code ") "
          (when assoc-repls
            assoc-repls)
          "})"))

(defun clay-make-file (filename format &optional assoc-repls)
  "Prepare call to Clay scicloj.clay.v2.api/make! to render FILENAME with FORMAT and pass connection strings for other REPLs from ASSOC-REPLS."
  (concat clay-require
          "
    (scicloj.clay.v2.api/make! {:format "
          format
          " :base-source-path nil "
          ":source-path \"" filename "\" "
          (when assoc-repls
            assoc-repls)
          "})"))

(defun clay-find-repl (type repls)
  "Find a REPL with connection capability TYPE in REPLS."
  (seq-find (apply-partially #'cider-connection-has-capability-p type)
            repls))

(defun clay-assoc-dialect-repls (cider-repls)
  "Discover REPLs for Clojure dialects in CIDER-REPLS and prepare :<repl-capability> conn-str for a map passed to Clay."
  (let ((babashka-repl (clay-find-repl 'babashka cider-repls)))
    (when babashka-repl
      (with-current-buffer babashka-repl
        (format ":babashka-nrepl \"%s:%s\" "
                (plist-get nrepl-endpoint :host)
                (plist-get nrepl-endpoint :port))))))

(defun clay-eval (&rest args)
  "Evaluates Clojure code in a project Clojure REPL, passing other Clojure Dialects nREPL-connection strings along to Clay.
ARGS can be
:code <code> which just evaluates the given code
:make-file <format> which calls make for the :filename and <format>
:make <code> which calls scicloj.clay.v2.api/make! with <code> and :filename
:filename filename (option :source-path) for which scicloj.clay.v2.api/make! is called

:file and :make get any non-clojure REPLs passed with the options."
  (let* ((code (plist-get args :code))
         (make-file (plist-get args :make-file))
         (make (plist-get args :make))
         (filename (plist-get args :filename))
         (cider-merge-sessions 'project)
         (cider-repls (cider-repls))
         (clojure-repl (clay-find-repl 'clojure cider-repls))
         (assoc-repls (when (not code)
                        (clay-assoc-dialect-repls cider-repls)))
         (eval-code (cond (code code)
                          ((and filename make-file)
                           (clay-make-file filename make-file assoc-repls))
                          ((and make filename)
                           (clay-make filename make assoc-repls)))))
    (when eval-code
      (cider-tooling-eval
       eval-code
       (nrepl-make-response-handler clojure-repl nil
                                    #'cider-repl-emit-stdout
                                    #'cider-repl-emit-stderr
                                    nil)
       (cider-get-ns-name)
       clojure-repl))))

(defun clay-start ()
  "Start Clay if not started yet."
  (interactive)
  (clay-eval :code (concat clay-require
                             "
    (scicloj.clay.v2.api/start!)"))
  t)

(defun clay-make-ns (format)
  "Save this Clojure buffer, and render it at the desired FORMAT."
  (save-buffer)
  (let ((filename (clay-clean-buffer-file-name)))
    (when filename
      (clay-eval :filename filename :make-file format))))

(defun clay-make-ns-html ()
  "Save this Clojure buffer, render it as HTML, and show that in the browser view."
  (interactive)
  (clay-make-ns "[:html]"))

(defun clay-make-ns-quarto-html ()
  "Save this Clojure buffer, render it as Quarto, render that as HTML.
Show that in the browser view."
  (interactive)
  (clay-make-ns "[:quarto :html]"))

(defun clay-make-ns-quarto-revealjs ()
  "Save this Clojure buffer, render it as Quarto, render that as reveal.js.
Show that in the browser view."
  (interactive)
  (clay-make-ns "[:quarto :revealjs]"))

(defun clay-make-form (code)
  "Render a given piece of Clojure CODE."
  (let ((filename (clay-clean-buffer-file-name)))
    (clay-eval :filename filename :make code)))

(defun clay-make-last-sexp ()
  "Render the last Clojure form before the cursor (using the format specified by Clay defaults or user configuration)."
  (interactive)
  (clay-make-form (cider-last-sexp)))

(defun clay-make-defun-at-point ()
  "Render the top-level Clojure form at the cursor (using the format specified by Clay defaults or user configuration)."
  (interactive)
  (clay-make-form (cider-defun-at-point)))

(provide 'clay)
;;; clay.el ends here
