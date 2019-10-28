;;; multi-shell.el --- Managing multiple shell buffers.  -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Shen, Jen-Chieh
;; Created date 2019-10-28 16:46:14

;; Author: Shen, Jen-Chieh <jcs090218@gmail.com>
;; Description: Managing multiple shell buffers.
;; Keyword: multiple shell terminal
;; Version: 0.0.1
;; Package-Requires: ((emacs "24.3"))
;; URL: https://github.com/jcs090218/multi-shell

;; This file is NOT part of GNU Emacs.

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
;;
;; Managing multiple shell buffers.
;;

;;; Code:

(require 'shell)
(require 'eshell)


(defgroup multi-shell nil
  "Managing multiple shell buffers in Emacs."
  :prefix "multi-shell-"
  :group 'tool
  :link '(url-link :tag "Repository" "https://github.com/jcs090218/multi-shell"))

(defcustom multi-shell-prefer-shell-type 'shell
  "Prefer shell type."
  :type '(choice (const :tag "shell" shell)
                 (const :tag "eshell" eshell))
  :group 'multi-shell)


(defvar multi-shell--current-shell-index 0
  "Record the shell index.")

(defvar multi-shell--live-shells '()
  "Record of list of shell that are still alive.")


(defun multi-shell--run-shell-procss-by-type ()
  "Run the shell process by current type."
  (cl-case multi-shell-prefer-shell-type
    ('shell (shell))
    ('eshell (eshell))))


(defun multi-shell--form-name (base)
  "Form the shell name by BASE."
  (format "*%s*" base))

(defun multi-shell--form-name-by-id (base id)
  "Form the shell name by BASE and ID."
  (format "*%s: <%s>*" base id))

;;;###autoload
(defun multi-shell-dedicated-open ()
  "Open dedicated shell window."
  (interactive)
  )

;;;###autoload
(defun multi-shell-dedicated-close ()
  "Close dedicated shell window."
  (interactive)
  )

;;;###autoload
(defun multi-shell-dedicated-toggle ()
  "Toggle dedicated shell window."
  (interactive)
  )

(defun multi-shell--cycle-delta-live-shell-list (st val)
  "Cycle through the live shell list the delta VAL and ST."
  (let ((target-index (+ st val)))
    (cond
     ((< target-index 0)
      (setq target-index (+ (length multi-shell--live-shells) target-index)))
     ((>= target-index (length multi-shell--live-shells))
      (setq target-index (% target-index (length multi-shell--live-shells)))))
    target-index))

(defun multi-shell--get-current-shell-index-by-id (&optional id)
  "Return the current shell index by ID."
  (unless id (setq id multi-shell--current-shell-index))
  (let ((index 0) (break nil) (sp nil) (fn-index -1))
    (while (and (< index (length multi-shell--live-shells))
                (not break))
      (setq sp (nth index multi-shell--live-shells))
      (when (= (car sp) id)
        (setq fn-index index)
        (setq break t))
      (setq index (1+ index)))
    fn-index))

;;;###autoload
(defun multi-shell-prev ()
  "Switch to previous shell buffer."
  (interactive)
  (let* ((cur-index (multi-shell--get-current-shell-index-by-id))
         (sp (multi-shell--cycle-delta-live-shell-list cur-index -1)))
    (setq multi-shell--current-shell-index (car sp))
    (multi-shell-switch sp)))

;;;###autoload
(defun multi-shell-next ()
  "Switch to next shell buffer."
  (interactive)
  (let* ((cur-index (multi-shell--get-current-shell-index-by-id))
         (sp (multi-shell--cycle-delta-live-shell-list cur-index 1)))
    (setq multi-shell--current-shell-index (car sp))
    (multi-shell-switch sp)))

;;;###autoload
(defun multi-shell-switch (sp)
  "Switch to shell buffer by SP."
  (interactive
   (list
    (completing-read
     "Select shell process: "
     multi-shell--live-shells)))
  (switch-to-buffer (cdr sp)))

;;;###autoload
(defun multi-shell-kill (&optional sp)
  "Kill the current shell buffer SP."
  (interactive)
  (unless sp (setq sp (nth multi-shell--current-shell-index multi-shell--live-shells)))
  (when sp
    (with-current-buffer (cdr sp) (erase-buffer))
    (kill-process (cdr sp))
    (kill-buffer (multi-shell--form-name-by-id multi-shell-prefer-shell-type (car sp)))
    (setq multi-shell--live-shells (remove sp multi-shell--live-shells))))

;;;###autoload
(defun multi-shell ()
  "Create a new shell buffer."
  (interactive)
  (let* ((id (length multi-shell--live-shells))
         (name (multi-shell--form-name-by-id multi-shell-prefer-shell-type id))
         (sh-name (multi-shell--form-name multi-shell-prefer-shell-type)))
    (unless (get-buffer sh-name) (multi-shell--run-shell-procss-by-type))
    (with-current-buffer sh-name
      (rename-buffer name)
      (when truncate-lines (toggle-truncate-lines))

      (push (cons id (current-buffer)) multi-shell--live-shells))
    (message "Start terminal <%s> at '%s'" id default-directory)))


(provide 'multi-shell)
;;; multi-shell.el ends here
