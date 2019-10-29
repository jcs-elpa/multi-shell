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


(defvar multi-shell--current-shell-id 0
  "Record the shell id.")

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

(defun multi-shell--form-name-by-id (id &optional base)
  "Form the shell name by BASE and ID."
  (unless base (setq base multi-shell-prefer-shell-type))
  (format "*%s: <%s>*" base id))

(defun multi-shell--prefix-name ()
  "Return shell name's prefix."
  (format "*%s: <" multi-shell-prefer-shell-type))

(defun multi-shell-opened-p ()
  "Check if at least one shell opened."
  (let ((index 0) (shell-list (multi-shell-select-list)) (break nil) (opened nil))
    (while (and (< index (length multi-shell--live-shells)) (not break))
      (when (get-process (nth index shell-list))
        (setq opened t)
        (setq break t))
      (setq index (1+ index)))
    opened))

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
  (unless id
    (setq multi-shell--current-shell-id (multi-shell--name-to-id (buffer-name)))
    (setq id multi-shell--current-shell-id))
  (let ((index 0) (break nil) (sp nil) (fn-index -1))
    (while (and (< index (length multi-shell--live-shells))
                (not break))
      (setq sp (nth index multi-shell--live-shells))
      (when (= (car sp) id)
        (setq fn-index index)
        (setq break t))
      (setq index (1+ index)))
    fn-index))

(defun multi-shell-select-list ()
  "Return the list of shell select."
  (let ((fn-lst '()))
    (dolist (sp multi-shell--live-shells)
      (push (multi-shell--form-name-by-id (car sp)) fn-lst))
    fn-lst))

(defun multi-shell--name-to-id (sp-name)
  "Turn SP-NAME to id."
  (let ((start (length (multi-shell--prefix-name))))
    (string-to-number (substring sp-name start (length sp-name)))))

(defun multi-shell--correct-buffer-name (killed-id)
  "Correct the buffer name by moving the id above the KILLED-ID."
  (setq multi-shell--live-shells (reverse multi-shell--live-shells))
  (dolist (sp multi-shell--live-shells)
    (with-current-buffer (cdr sp)
      (let ((shell-id (multi-shell--name-to-id (buffer-name))))
        (when (>= shell-id killed-id)
          (rename-buffer
           (multi-shell--form-name-by-id (1- shell-id)))))))
  (setq multi-shell--live-shells (reverse multi-shell--live-shells)))

;;;###autoload
(defun multi-shell-live-p ()
  "Check if any shell is alive."
  (not (= (length multi-shell--live-shells) 0)))

;;;###autoload
(defun multi-shell-prev ()
  "Switch to previous shell buffer."
  (interactive)
  (let* ((cur-index (multi-shell--get-current-shell-index-by-id))
         (sp-index (multi-shell--cycle-delta-live-shell-list cur-index 1))
         (sp (nth sp-index multi-shell--live-shells)))
    (multi-shell-select (multi-shell--form-name-by-id (car sp)))))

;;;###autoload
(defun multi-shell-next ()
  "Switch to next shell buffer."
  (interactive)
  (let* ((cur-index (multi-shell--get-current-shell-index-by-id))
         (sp-index (multi-shell--cycle-delta-live-shell-list cur-index -1))
         (sp (nth sp-index multi-shell--live-shells)))
    (multi-shell-select (multi-shell--form-name-by-id (car sp)))))

;;;###autoload
(defun multi-shell-select (sp-name)
  "Switch to shell buffer by SP-NAME."
  (interactive
   (list (completing-read "Select shell process: " (multi-shell-select-list))))
  (setq multi-shell--current-shell-id (multi-shell--name-to-id sp-name))
  (switch-to-buffer sp-name)
  sp-name)

;;;###autoload
(defun multi-shell-kill-all ()
  "Kill the all shell buffer."
  (interactive)
  (while (not (= 0 (length multi-shell--live-shells)))
    (multi-shell-kill (nth 0 multi-shell--live-shells))))

;;;###autoload
(defun multi-shell-kill (&optional sp)
  "Kill the current shell buffer SP."
  (interactive)
  (unless sp
    (setq sp (nth (multi-shell--get-current-shell-index-by-id) multi-shell--live-shells)))
  (when sp
    (with-current-buffer (cdr sp) (erase-buffer))
    (kill-process (cdr sp))
    (kill-buffer (cdr sp))
    (setq multi-shell--live-shells (remove sp multi-shell--live-shells))
    (multi-shell--correct-buffer-name multi-shell--current-shell-id)))

;;;###autoload
(defun multi-shell ()
  "Create a new shell buffer."
  (interactive)
  (let* ((id (length multi-shell--live-shells))
         (name (multi-shell--form-name-by-id id))
         (sh-name (multi-shell--form-name multi-shell-prefer-shell-type)))
    (unless (get-buffer sh-name) (multi-shell--run-shell-procss-by-type))
    (with-current-buffer sh-name
      (rename-buffer name)
      (when truncate-lines (toggle-truncate-lines) (message ""))
      (push (cons id (current-buffer)) multi-shell--live-shells))))


(provide 'multi-shell)
;;; multi-shell.el ends here
