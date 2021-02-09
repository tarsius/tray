;;; tray.el --- Various transient menus            -*- lexical-binding: t -*-

;; Copyright (C) 2021  Jonas Bernoulli

;; Author: Jonas Bernoulli <jonas@bernoul.li>
;; Homepage: https://git.sr.ht/~tarsius/tray
;; Keywords: compile, convenience, lisp

;; Package-Requires: ((emacs "27.1") (transient "0.3.0"))

;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Transient menus for a wide variety of things.

;; For suggest key bindings see
;; (find-function 'tray-add-suggested-bindings).

;; A few of my transient menus are distributed separately:
;; - [[https://git.sr.ht/~tarsius/notmuch-transient][notmuch-transient]]

;;; Code:

(require 'transient)

(eval-when-compile
  (require 'epa)
  (require 'epa-mail)
  )

(defvar tray-add-suggested-bindings nil
  "Whether to add all suggested key bindings.
This has to be set before `tray' is loaded.  Afterwards
you have to call the function by the same name instead.")

(defun tray-add-suggested-bindings ()
  "Add all suggested key bindings.
If you would rather cherry-pick some bindings, then
start by looking at the definition of this function."
  (define-key global-map            (kbd "C-c C-e") 'tray-epa-dispatch)
  (define-key epa-key-list-mode-map (kbd "C-c C-e") 'tray-epa-key-list-dispatch)
  (define-key epa-mail-mode-map     (kbd "C-c C-e") 'tray-epa-mail-dispatch)
  )

(when tray-add-suggested-bindings
  (tray-add-suggested-bindings))

;;; epa, epa-mail

;;;###autoload (autoload 'tray-epa-dispatch "tray" nil t)
(transient-define-prefix tray-epa-dispatch ()
  "Select and invoke an EasyPG command from a list of available commands."
  [[("l p" "list public keys"   epa-list-keys)
    ("l s" "list secret keys"   epa-list-secret-keys)
    ("i p" "insert public keys" epa-insert-keys)]])

;;;###autoload (autoload 'tray-epa-mail-dispatch "tray" nil t)
(transient-define-prefix tray-epa-mail-dispatch ()
  "Select and invoke an EasyPG command from a list of available commands."
  [[("e"  "encrypt"     epa-mail-encrypt)
    ("d"  "decrypt"     epa-mail-decrypt)]
   [("s"  "sign"        epa-mail-sign)
    ("v"  "verify"      epa-mail-verify)]
   [("i"  "import keys" epa-mail-import-keys)
    ("o"  "insert keys" epa-insert-keys)]])

;;;###autoload (autoload 'tray-epa-key-list-dispatch "tray" nil t)
(transient-define-prefix tray-epa-key-list-dispatch ()
  "Select and invoke an EasyPG command from a list of available commands."
  :transient-suffix     'transient--do-call
  :transient-non-suffix 'transient--do-stay
  [[("m" "mark"      epa-mark-key)
    ("u" "unmark"    epa-unmark-key)]
   [("e" "encrypt"   epa-encrypt-file)
    ("d" "decrypt"   epa-decrypt-file)]
   [("s" "sign"      epa-sign-file)
    ("v" "verify"    epa-verify-file)]
   [("i" "import"    epa-import-keys)
    ("o" "export"    epa-export-keys)
    ("r" "delete"    epa-delete-keys)]
   [("g  " "refresh"          revert-buffer)
    ("l p" "list public keys" epa-list-keys)
    ("l s" "list secret keys" epa-list-secret-keys)]
   [("n" "move up"   next-line)
    ("p" "move down" previous-line)
    ("q" "exit"      epa-exit-buffer :transient nil)]])

;;; _
(provide 'tray)
;;; tray.el ends here
