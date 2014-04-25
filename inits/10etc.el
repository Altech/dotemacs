;; for iimage-mode
(setq iimage-mode-map (make-sparse-keymap))
(define-key iimage-mode-map (kbd "C-l") nil)
(add-hook 'text-mode-hook 'turn-on-iimage-mode)
;; for yaml-mode
(require-package 'yaml-mode)
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))


;; for dired
(require-package 'dired-details)
(require 'dired) ;; [TODO]
(defun dired-start-eshell (arg)
 "diredで選択されたファイル名がペーストされた状態で、eshellを起動する。"
 (interactive "P")
 (let ((files (mapconcat 'shell-quote-argument
                         (dired-get-marked-files (not arg))
                         " ")))
   (if (fboundp 'shell-pop) (shell-pop) (eshell t))
   (save-excursion (insert " " files))))
(define-key dired-mode-map [remap dired-do-shell-command] 'dired-start-eshell)
(define-key dired-mode-map (kbd "C-t") 'other-window-or-split)
(require 'dired-x)
(setq dired-omit-files "^\\...+$")
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1)))
;; hide detail on dired
(require 'dired-details)
(dired-details-install)
(setq dired-details-hidden-string "")
;; use dired like finder ;; for MacBookPro ;; it makes something wrong under other environment.
;; [TODO] こわれるか調べる
(require 'dired)
(require 'dired-view)
(add-hook 'dired-mode-hook 'dired-view-minor-mode-on)
(define-key dired-mode-map (kbd ":") 'dired-view-minor-mode-dired-toggle) ;; e.g. :p => popwin.el
