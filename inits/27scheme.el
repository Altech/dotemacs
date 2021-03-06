(setq scheme-program-name "gosh -i")
(autoload 'scheme-mode "cmuscheme" "Major mode for Scheme." t)
(autoload 'run-scheme "cmuscheme" "Run an inferior Scheme process." t)
(defun scheme-other-window ()
  "Run scheme on other window"
  (interactive)
  (switch-to-buffer-other-window
   (get-buffer-create "*scheme*"))
  (run-scheme scheme-program-name))

(add-hook 'scheme-mode-hook
          '(lambda ()
	     (local-set-key (kbd "M-e M-b") 'eval-buffer)
	     (local-set-key (kbd "M-e M-r") 'eval-region)
	     (local-set-key (kbd "\'") 'self-insert-command)
	     (local-set-key (kbd "C-M-j") 'paredit-backward)
	     (local-set-key (kbd "C-M-r") 'paredit-forward-down)
	     (local-set-key (kbd "C-M-k") 'kill-sexp)
	     (local-set-key (kbd "C-c C-s") 'scheme-other-window)
	     ))

(require-package 'paredit)
(require 'paredit)
(add-hook 'scheme-mode-hook 'enable-paredit-mode)

