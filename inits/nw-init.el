;; fullscreen
(global-set-key (kbd "<f11>") 'ns-toggle-fullscreen)

(add-hook 'rhtml-mode-hook
	  (lambda ()
	    (set-face-background 'erb-face nil)
	    (set-face-underline-p 'erb-face t)
	    (set-face-background 'erb-exec-face nil)
	    (set-face-underline-p 'erb-exec-face t)
	    ))

;; highlight cursor-line
(setq hl-line-face 'underline)
(global-hl-line-mode)