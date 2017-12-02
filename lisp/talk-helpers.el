;;; talk-helpers.el --- org-reveal helper functions
;;
;;; Commentary:
;;
;;; Helper functions to export and spin up containerized presentations
;;; from `org-mode' files, using reveal.js.
;;
;;; Code:
(require 'ox-reveal)
(setq org-reveal-base-dir "/Users/ovi/opt/talks/org-reveal")

(defun talk-helpers/up (suppressTOC)
  "Export `org-mode' file to HTML and spin up containerized presentation."
  (interactive "P")
  (let* ((fbase (file-name-base))
         (compose-cmd (talk-helpers/-build-compose-command fbase))
         (org-reveal-is-elsewhere-p (and (not (file-exists-p "./docker-compose.yml"))
                                      (boundp 'org-reveal-base-dir))))
    (when org-reveal-is-elsewhere-p
      (cd org-reveal-base-dir))

    (if (not suppressTOC)
        (org-reveal-export-to-html)
      (progn
        (goto-char (point-min))
        (re-search-forward "^*" nil t)
        (org-reveal-export-current-subtree))
      )
    (async-shell-command compose-cmd))
  )

(defun talk-helpers/up-no-toc ()
  "Export `org-mode' subtree to HTML and spin up containerized presentation.

Subtree is built from the first `org-mode' header.

This removes the table of contents."
  (interactive)
  (talk-helpers/up t))

(defun talk-helpers/-build-compose-command (presentation)
  "Build docker-compose command string with PRESENTATION. and clean up html file"
  (format "presentation=%s.html docker-compose up -d --build; rm %s.html" presentation presentation))

(provide 'talk-helpers)
;;; talk-helpers.el ends here
