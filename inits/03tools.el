;; anything
(require 'anything-startup)
(setq migemo-isearch-min-length 2)
(global-set-key (kbd "C-;") 'anything)
(anything-read-string-mode 0) ;; for ido-mode [TODO]
;; tramp
(require 'tramp "~/.emacs.d/tramp/tramp")
;; popwin
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
(add-to-list 'popwin:special-display-config '("*quickrun*"))
(add-to-list 'popwin:special-display-config '("*compilation*"))
(add-to-list 'popwin:special-display-config '("* Oz Compiler*"))
(add-to-list 'popwin:special-display-config '("*buffer-selection*"))
(add-to-list 'popwin:special-display-config '("*refe:ACL*")) ;; [TODO]
(push '("\*refe" :regexp t :position top) popwin:special-display-config) ;; [TODO]
;; git
(add-to-list 'load-path "~/.emacs.d/magit")
(require 'magit)
;; gist
;; [TODO]


;; auto-complete
(add-to-list 'load-path "~/.emacs.d/auto-complete/")
(require 'auto-complete)
(global-auto-complete-mode t)
(setq ac-auto-start 4)
(setq ac-auto-show-menu 0.5)
(setq ac-use-comphist t)
(setq ac-candidate-limit nil)
(setq ac-use-quick-help nil)
(setq ac-use-menu-map t)
(define-key ac-menu-map (kbd "C-n")         'ac-next)
(define-key ac-menu-map (kbd "C-p")         'ac-previous)
(define-key ac-completing-map (kbd "<tab>") 'ac-complete)
(define-key ac-completing-map (kbd "M-/")   'ac-stop)
(define-key ac-completing-map (kbd "RET") nil)
(require 'auto-complete-config)
(setq-default ac-sources (list
			  ac-source-yasnippet
			  ac-source-words-in-same-mode-buffers
			  ac-source-filename
			  ac-source-functions
			  ac-source-variables
			  ;; ac-source-symbols
			  ac-source-features
			  ac-source-abbrev
			  ac-source-dictionary
			  ))

;; yasnippet
(add-to-list 'load-path "~/.emacs.d/elpa/yasnippet-20120923.1126")
(require 'yasnippet-config)
(require 'dropdown-list)
(yas/global-mode 1)
(call-interactively 'yas/reload-all)
(yas/load-directory "~/.emacs.d/snippets/")
;; if you use anything-complete.el, (yas/completing-prompt) is possible.
(setq yas/prompt-functions
      '(yas/dropdown-prompt yas/completing-prompt yas/ido-prompt yas/no-prompt))
;;; with anything
(require 'anything)
(require 'anything-c-yasnippet-2)
;;; with auto-complete
(yas/set-ac-modes)
(yas/enable-emacs-lisp-paren-hack)


;; server start for emacs-client
(require 'server)
(unless (server-running-p)
  (server-start))
;; server editing
(defun quit-editing ()
  (interactive)
  (progn
    (save-buffer)
    (server-edit)))
(global-set-key (kbd "M-RET") 'quit-editing)
