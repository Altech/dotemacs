;; fix on terminal
(global-set-key (kbd "TAB") 'yas-expand)
(setq yas/prompt-functions '(yas/dropdown-prompt yas/x-prompt))
(add-hook 'ruby-mode-hook
	  (lambda ()
	    (local-set-key (kbd "TAB") 'yas-expand-from-trigger-key)
	    ))

;; for magit
(set-face-background 'magit-item-highlight "white")
