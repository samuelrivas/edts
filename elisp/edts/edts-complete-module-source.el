;; Copyright 2012 Thomas Järvstrand <tjarvstrand@gmail.com>
;;
;; This file is part of EDTS.
;;
;; EDTS is free software: you can redistribute it and/or modify
;; it under the terms of the GNU Lesser General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; EDTS is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Lesser General Public License for more details.
;;
;; You should have received a copy of the GNU Lesser General Public License
;; along with EDTS. If not, see <http://www.gnu.org/licenses/>.
;;
;; auto-complete source for erlang modules.

(require 'auto-complete)
(require 'ferl)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Source

(defvar edts-complete-module-source
  '((candidates . edts-complete-module-candidates)
    (document   . nil)
    (symbol     . "m")
    (requires   . nil)
    (limit      . nil)
    (cache)
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Candidate functions

(defvar edts-complete-module-cache nil
  "The current list of module completions.")
(ac-clear-variable-after-save 'edts-complete-module-cache)

(defun edts-complete-module-candidates ()
  (case (edts-complete-point-inside-quotes)
    ('double-quoted  nil) ; Don't complete inside strings
    ('single-quoted (edts-complete-single-quoted-module-candidates))
    ('none          (edts-complete-normal-module-candidates))))

(defun edts-complete-normal-module-candidates ()
  "Produces the completion list for normal (unqoted) modules."
  (when (edts-complete-module-p)
    (or edts-complete-module-cache
        (setq edts-complete-module-cache (edts-get-modules)))))

(defun edts-complete-single-quoted-module-candidates ()
  "Produces the completion for single-qoted erlang modules, Same as normal
candidates, except we single-quote-terminate candidates."
  (mapcar
   #'edts-complete-single-quote-terminate
   edts-complete-normal-module-candidates))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Conditions
;;

(defun edts-complete-module-p ()
  "Returns non-nil if the current `ac-prefix' can be completed with a module."
  (let ((preceding (edts-complete-term-preceding-char)))
    (and
     (not (equal ?? preceding))
     (not (equal ?# preceding))
     (not (equal ?: preceding))
     (string-match erlang-atom-regexp ac-prefix))))

(provide 'edts-complete-module-source)
