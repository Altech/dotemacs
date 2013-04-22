(require 'lispxmp)
(define-key emacs-lisp-mode-map (kbd "C-c C-d") 'lispxmp)

(require 'paredit)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'ielm-mode-hook 'enable-paredit-mode)

(set-face-foreground 'font-lock-regexp-grouping-backslash "green3")
(set-face-foreground 'font-lock-regexp-grouping-construct "green")

(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
	     (local-set-key (kbd "M-e M-b") 'eval-buffer)
	     (local-set-key (kbd "M-e M-r") 'eval-region)
	     (local-set-key (kbd "\'") 'self-insert-command)
	     (local-set-key (kbd "C-M-j") 'paredit-backward)
	     (local-set-key (kbd "C-M-r") 'paredit-forward-down)
	     (local-set-key (kbd "C-M-k") 'kill-sexp)
	     (local-set-key (kbd "C-c C-e") 'toggle-debug-on-error)
	     ))

(add-hook 'ielm-mode-hook
          '(lambda ()
	     (local-set-key (kbd "\'") 'self-insert-command)
	     (local-set-key (kbd "C-M-j") 'paredit-backward)
	     (local-set-key (kbd "C-M-r") 'paredit-forward-down)
	     (local-set-key (kbd "C-M-k") 'kill-sexp)
	     ))

(define-key paredit-mode-map (kbd "C-j") 'backward-char)


;; Keybind for S-Expression
;; C-M-f   next
;; C-M-j   prev
;; C-M-r   internal
;; C-M-u   external
;; C-M-SPC mark
;; C-M-k   kill
;; C-M-t   exchange
;; C-M-q   indent

;; M-( wrap   round
;; M-) delete round




