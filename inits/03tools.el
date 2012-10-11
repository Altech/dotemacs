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

;; input
(add-to-list 'load-path "~/.emacs.d/auto-complete/")
(require 'auto-complete)
(global-auto-complete-mode t)
(define-key ac-complete-mode-map (kbd "C-n") 'ac-next)
(define-key ac-complete-mode-map (kbd "C-p") 'ac-previous)
;; (setq ac-modes (cons 'js-mode ac-modes))


;;; yasnippet
(add-to-list 'load-path "~/.emacs.d/elpa/yasnippet-20120923.1126")
(require 'yasnippet-config)
(require 'dropdown-list)
(yas/global-mode 1)
(call-interactively 'yas/reload-all)    ;workaround
;; if you use anything-complete.el, (yas/completing-prompt) is possible.
(setq yas/prompt-functions
      '(yas/dropdown-prompt yas/completing-prompt yas/ido-prompt yas/no-prompt))
