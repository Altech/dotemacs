;; for markdown
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t) (setq auto-mode-alist (cons '("\\.mkd" . markdown-mode) auto-mode-alist))
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t) (setq auto-mode-alist (cons '("\\.md" . markdown-mode) auto-mode-alist))
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t) (setq auto-mode-alist (cons '("\\.markdown" . markdown-mode) auto-mode-alist))


(key-chord-define-global "ac" 'rgrep)

(add-hook 'markdown-mode-hook
	  (lambda ()
	    (local-set-key (kbd "M-p") 'backward-paragraph)
	    (local-set-key (kbd "M-n") 'forward-paragraph)
	    ))

;; tunr off auto-complete-mode
(defadvice global-auto-complete-mode-enable-in-buffers (around my-centered-cursor-mode-turn-on-maybe)
  (unless (eq 'markdown-mode major-mode)
	  ad-do-it))

(ad-activate 'global-auto-complete-mode-enable-in-buffers)
