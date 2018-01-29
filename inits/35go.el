(require-package 'go-mode)
(require 'go-mode)

(require-package 'go-eldoc)
(require 'go-eldoc)

(add-to-list 'load-path "/Users/Sohei/src/github.com/nsf/gocode/emacs")

(add-hook 'go-mode-hook (lambda ()
                          (company-mode)
                          (local-set-key (kbd "M-.") 'godef-jump)
                          (local-set-key (kbd "M-,") 'pop-tag-mark)
                          (go-eldoc-setup)
                          ;; company
                          (set (make-local-variable 'company-backends) '(company-go))
                          (company-mode)
                          ))

(add-hook 'before-save-hook 'gofmt-before-save)

;; comapny

(require 'company)                                   ; load company mode
(require 'company-go)                                ; load company mode go backend

(setq company-tooltip-limit 20)                      ; bigger popup window
(setq company-idle-delay .3)                         ; decrease delay before autocompletion popup shows
(setq company-echo-delay 0)                          ; remove annoying blinking
(setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing
(setq company-go-show-annotation t)

(custom-set-faces
 '(company-preview
   ((t (:foreground "darkgray" :underline t))))
 '(company-preview-common
   ((t (:inherit company-preview))))
 '(company-tooltip
   ((t (:background "lightgray" :foreground "black"))))
 '(company-tooltip-selection
   ((t (:background "steelblue" :foreground "white"))))
 '(company-tooltip-common
   ((((type x)) (:inherit company-tooltip :weight bold))
    (t (:inherit company-tooltip))))
 '(company-tooltip-common-selection
   ((((type x)) (:inherit company-tooltip-selection :weight bold))
    (t (:inherit company-tooltip-selection)))))
