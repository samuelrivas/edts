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
;; auto-complete source for exported erlang functions.

(require 'auto-complete)
(require 'ferl)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Source

(defvar edts-complete-exported-function-source
  '((candidates . edts-complete-exported-function-candidates)
    (document   . nil)
    (symbol     . "f")
    (requires   . nil)
    (limit      . nil)
    (cache)
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Candidate functions

(defun edts-complete-exported-function-candidates ()
  (case (edts-complete-point-inside-quotes)
    ('double-quoted nil) ; Don't complete inside strings
    ('single-quoted (edts-complete-single-quoted-exported-function-candidates))
    ('none          (edts-complete-normal-exported-function-candidates))))


(defun edts-complete-normal-exported-function-candidates ()
  "Produces the completion list for normal (unqoted) exported functions."
  (when (edts-complete-exported-function-p)
    (let ((module (symbol-at (- ac-point 1))))
      (edts-get-module-exported-functions module))))

(defun edts-complete-single-quoted-exported-function-candidates ()
  "Produces the completion for single-qoted erlang modules, Same as normal
candidates, except we single-quote-terminate candidates."
  (mapcar
   #'edts-complete-single-quote-terminate
   edts-complete-normal-module-candidates))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Conditions
;;

(defun edts-complete-exported-function-p ()
  "Returns non-nil if the current `ac-prefix' can be completed with an
exported function."
  (let ((case-fold-search nil))
    (and
     (equal ?: (edts-complete-term-preceding-char))
     (string-match erlang-atom-regexp (symbol-at (- ac-point 1))))))

(provide 'edts-complete-exported-function-source)
