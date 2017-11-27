;;; talk-helpers.el --- org-reveal helper functions
;;
;;; Commentary:
;;
;;; Helper functions to export and spin up containerized presentations
;;; from `org-mode' files, using reveal.js.
;;
;;; Code:
(require 'ox-reveal)

(defun talk-helpers/up ()
  "Export `org-mode' file to HTML and spin up containerized presentation."
  (interactive)
  (let* ((fbase (file-name-base))
         (compose-cmd (talk-helpers/-build-compose-command fbase)))
    (org-reveal-export-to-html)
    (async-shell-command compose-cmd)))

(defun talk-helpers/up-no-toc ()
  "Export `org-mode' subtree to HTML and spin up containerized presentation.

Subtree is built from the first `org-mode' header.

This removes the table of contents."
  (interactive)
  (let* ((fbase (file-name-base))
         (compose-cmd (talk-helpers/-build-compose-command fbase)))
    (goto-char (point-min))
    (re-search-forward "^*" nil t)
    (org-reveal-export-current-subtree)
    (async-shell-command compose-cmd)))

(defun talk-helpers/-build-compose-command (presentation)
  "Build docker-compose command string with PRESENTATION."
  (format "presentation=%s.html docker-compose up -d --build" presentation))

(provide 'talk-helpers)
;;; talk-helpers.el ends here
