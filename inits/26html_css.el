;; for HTML
(require 'zencoding-mode) 
(add-hook 'zencoding-mode-hook
	  (lambda ()
	     (local-set-key (kbd "k") 'self-insert-command)
	     (global-set-key (kbd "C-j") 'backward-char)
	     (local-set-key (kbd "C-j") 'backward-char)))
(add-hook 'sgml-mode-hook 'zencoding-mode)

;; for SCSS
(autoload 'scss-mode "scss-mode")
(setq scss-compile-at-save nil) ;; 自動コンパイルをオフにする
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))
(setq cssm-indent-function #'cssm-c-style-indenter)
(add-hook 'css-mode-hook
              (lambda ()
                (setq css-indent-offset 2)
                ))
