;; for iimage-mode
(setq iimage-mode-map (make-sparse-keymap))
(define-key iimage-mode-map (kbd "C-l") nil)
;; for yaml-mode
(require-package 'yaml-mode)
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;; for dired
(require-package 'dired-details)
(require 'dired) ;; [TODO]
(define-key dired-mode-map (kbd "C-t") 'other-window-or-split)
(require 'dired-x)
(setq dired-omit-files "^\\...+$")
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1)))
;; hide detail on dired
(require 'dired-details)
(dired-details-install)
(setq dired-details-hidden-string "")
