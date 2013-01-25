(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
	     (local-set-key (kbd "M-e b") 'eval-buffer)
	     (local-set-key (kbd "M-e r") 'eval-region)))
