;;; tray.el --- Various transient menus  -*- lexical-binding:t -*-

;; Copyright (C) 2021-2025 Jonas Bernoulli

;; Author: Jonas Bernoulli <emacs.tray@jonas.bernoulli.dev>
;; Homepage: https://github.com/tarsius/tray
;; Keywords: convenience

;; Package-Version: 0.1.7
;; Package-Requires: (
;;     (emacs    "27.1")
;;     (compat   "30.1")
;;     (transient "0.10"))

;; SPDX-License-Identifier: GPL-3.0-or-later

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published
;; by the Free Software Foundation, either version 3 of the License,
;; or (at your option) any later version.
;;
;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Transient menus for a wide variety of things.

;; For suggested key bindings see
;; (find-function 'tray-add-suggested-bindings).

;; A few of my transient menus are distributed separately:
;; - [[https://git.sr.ht/~tarsius/notmuch-transient][notmuch-transient]]

;;; Code:

(require 'compat)
(require 'transient)

(eval-when-compile (require 'epa))
(eval-when-compile (require 'epa-mail))
(eval-when-compile (require 'mml))

(defvar tray-add-suggested-bindings nil
  "Whether to add all suggested key bindings.
This has to be set before `tray' is loaded.  Afterwards
you have to call the function by the same name instead.")

(defun tray-add-suggested-bindings ()
  "Add all suggested key bindings.
If you would rather cherry-pick some bindings, then
start by looking at the definition of this function."
  (keymap-set global-map            "C-c C-e" #'tray-epa-dispatch)
  (keymap-set epa-key-list-mode-map "C-c C-e" #'tray-epa-key-list-dispatch)
  (keymap-set epa-mail-mode-map     "C-c C-e" #'tray-epa-mail-dispatch)
  (keymap-set mml-mode-map          "C-c C-m" #'tray-mml)
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
  :transient-suffix     #'transient--do-call
  :transient-non-suffix #'transient--do-stay
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

;;; mml

;;;###autoload (autoload 'tray-mml "tray" nil t)
(transient-define-prefix tray-mml ()
  "Transient menu for MML documents."
  [["Attach"
    ("f" "file"      mml-attach-file)
    ("b" "buffer"    mml-attach-buffer)
    ("e" "external"  mml-attach-external)]
   ["Insert"
    ("m" "multipart" mml-insert-multipart)
    ("p" "part"      mml-insert-part)]]
  [["Sign"
    ("s p" "pgpmime" mml-secure-message-sign-pgpmime)
    ("s o" "pgp"     mml-secure-message-sign-pgp)
    ("s s" "smime"   mml-secure-message-sign-smime)]
   ["Sign part"
    ("S p" "pgpmime" mml-secure-sign-pgpmime)
    ("S o" "pgp"     mml-secure-sign-pgp)
    ("S s" "smime"   mml-secure-sign-smime)]
   ["Encrypt"
    ("c p" "pgpmime" mml-secure-message-encrypt-pgpmime)
    ("c o" "pgp"     mml-secure-message-encrypt-pgp)
    ("c s" "smime"   mml-secure-message-encrypt-smime)]
   ["Encrypt part"
    ("C p" "pgpmime" mml-secure-encrypt-pgpmime)
    ("C o" "pgp"     mml-secure-encrypt-pgp)
    ("C s" "smime"   mml-secure-encrypt-smime)]]
  [["Misc"
    ;;("n  " "narrow"       mml-narrow-to-part)
    ("C-n" "unsecure"     mml-unsecure-message)
    ("q  " "quote region" mml-quote-region)
    ("v  " "validate"     mml-validate)
    ("P  " "preview"      mml-preview)]
   ["Dwim"
    ("C-s" "sign"           mml-secure-message-sign)
    ("C-c" "encrypt"        mml-secure-message-encrypt)
    ("C-e" "sign & encrypt" mml-secure-message-sign-encrypt)]
   ["Dwim part"
    ("C-p C-s" "sign"       mml-secure-sign)
    ("C-p C-c" "encrypt"    mml-secure-encrypt)]])

;;; _
(provide 'tray)
;;; tray.el ends here
