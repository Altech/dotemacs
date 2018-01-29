(require-package 'coffee-mode)
(require 'coffee-mode)

(setq whitespace-action '(auto-cleanup)) ;; automatically clean up bad whitespace
(setq whitespace-style '(trailing space-before-tab indentation empty space-after-tab)) ;; only show bad whitespace

(add-hook 'coffee-mode-hook
  '(lambda()
		 (set (make-local-variable 'tab-width) 2)
		 (setq coffee-tab-width 2)
		 (local-set-key (kbd "C-c b") 'coffee-compile-buffer)
		 ))
