;; [TODO] ON
(add-to-list 'load-path "~/.emacs.d/scala")
(require 'scala-mode-auto)
;; (setq yas/my-directory "~/.emacs.d/scala/contrib/yasnippet/snippets")
;; (yas/load-directory yas/my-directory)

(add-hook 'scala-mode-hook
	  '(lambda ()
	     (local-set-key (kbd "C-m") 'newline-and-indent)))
;;	     (yas/minor-mode-on)))

;; - IDE
;; (add-to-list 'load-path "~/.emacs.d/ensime/elisp/")
;; (require 'ensime)
;; (add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
