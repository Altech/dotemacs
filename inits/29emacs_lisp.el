(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
	     (local-set-key (kbd "M-e M-b") 'eval-buffer)
	     (local-set-key (kbd "M-e M-r") 'eval-region)))
