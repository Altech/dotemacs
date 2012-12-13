;; fullscreen
(global-set-key (kbd "<f11>") 'ns-toggle-fullscreen)

(add-hook 'rhtml-mode-hook
	  (lambda ()
	    (set-face-background 'erb-face "black")
	    (set-face-underline-p 'erb-face t)
	    (set-face-background 'erb-exec-face "red")
	    (set-face-underline-p 'erb-exec-face t)
	    ))

;; highlight cursor-line
;; (setq hl-line-face 'underline)
;; (global-hl-line-mode)


;; fix on terminal
(global-set-key (kbd "TAB") 'yas-expand)
(setq yas/prompt-functions '(yas/dropdown-prompt yas/x-prompt))
(add-hook 'ruby-mode-hook
	  (lambda ()
	    (local-set-key (kbd "TAB") 'yas-expand-from-trigger-key)
	    ))
