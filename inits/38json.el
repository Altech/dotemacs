(require-package 'json-mode)
(require 'json-mode)

(defun jq-format (beg end)
  (interactive "r")
  (shell-command-on-region beg end "jq ." nil t))

(require-package 'flymake-json)
(require 'flymake-json); require `npm install -g jsonlint`

(add-hook 'json-mode-hook
  (lambda ()
    (setq js-indent-level 2) ;; indent width : 4
    (add-hook 'after-save-hook 'flymake-json-load nil 'make-it-local)))
