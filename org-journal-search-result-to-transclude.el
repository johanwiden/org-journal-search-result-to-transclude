;;; org-journal-search-result-to-transclude.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2022 Johan Widén
;;
;; Author: Johan Widén <j.e.widen@gmail.com>
;; Maintainer: Johan Widén <j.e.widen@gmail.com>
;; Created: september 08, 2022
;; Modified: september 08, 2022
;; Version: 0.0.1
;; Keywords: docs hypermedia lisp outlines
;; Homepage: https://github.com/johanwiden/org-journal-search-result-to-transclude
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(defun my-org-journal-search-result-to-transclude ()
  "Transform contents of org-journal-search buffer to transclude links.
Invoke in buffer where the transclude links should be created.
Not in org-journal-search buffer."
  (interactive)
  (let ((target-buffer (current-buffer))
        (search-buffer (get-buffer "*Org-journal search*")))
    (if search-buffer
        (with-current-buffer search-buffer
          (goto-char (point-min))
          (let ((button (forward-button 1 nil nil t)))
            (while button
              (let* ((target (button-get button 'org-journal-link))
                     ;; (point (car target))
                     (time (cdr target))
                     (org-journal-file (org-journal--get-entry-path time))
                     (date-string "not found")
                     (header-string "not found"))
                (if (re-search-forward "\\(.*\\)\\*\\* \\(.*\\)")
                    (progn
                      (setq date-string (match-string 1))
                      (setq header-string (match-string 2))))
                (with-current-buffer target-buffer
                  (insert "#+transclude: " "[[" org-journal-file "::* " header-string "][" date-string header-string "]]\n"))
                ;; (goto-char point)
                (setq button (forward-button 1 nil nil t))))))
      (user-error "Buffer *Org-journal search* unavailable"))))

(provide 'org-journal-search-result-to-transclude)
;;; org-journal-search-result-to-transclude.el ends here
