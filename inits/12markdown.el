;; for markdown
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t) (setq auto-mode-alist (cons '("\\.mkd" . markdown-mode) auto-mode-alist))
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t) (setq auto-mode-alist (cons '("\\.md" . markdown-mode) auto-mode-alist))
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t) (setq auto-mode-alist (cons '("\\.markdown" . markdown-mode) auto-mode-alist))
(add-hook 'markdown-mode-hook
	  (lambda ()
	    (local-set-key (kbd "M-p") 'backward-paragraph)
	    (local-set-key (kbd "M-n") 'forward-paragraph)
	    ))
