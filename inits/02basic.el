;; trucate lines
(defun toggle-truncate-lines ()
  (interactive)
  (if truncate-lines
      (setq truncate-lines nil)
    (setq truncate-lines t))
  (recenter))
(setq-default truncate-partial-width-windows t)
(setq-default truncate-lines nil)
;; bar setting
(if window-system (menu-bar-mode 1) (menu-bar-mode 0))
(if window-system (tool-bar-mode 0))
;; coloring region 
(setq transient-mark-mode t)
;; show another bracket
(show-paren-mode 1)
;; return at end of line
(setq truncate-partial-width-windows nil)
;; "yes or no" to "y or n"
(fset 'yes-or-no-p 'y-or-n-p)
;; buffer switching
(iswitchb-mode 1)
;; find file
(require 'ido)
(ido-mode t)
;; [TODO]
;; ;; window switching (using shift-key)
;; (windmove-default-keybindings)
;; ;; window switching (反対側のウィンドウに飛べる)
;; (setq windmove-wrap-around t)
;; alarm sign from sound to vision
;; (setq visible-bell t)
;; kill beep at error
(setq ring-bell-function 'ignore)
;; delete region by backspace
(delete-selection-mode t)
;; kill hole line by one stroke
(setq kill-whole-line t)
;; cursor position
(column-number-mode t) 
(line-number-mode t)
;; Undo limit
(setq undo-limit 100000)
(setq undo-strong-limit 130000)

;; [TODO]
;; ;; set backup directory
;; (setq backup-directory-alist '(("." . "~/.emacs.d/backup")))
;; ;; backup to particular dir
(setq make-backup-files t)
(setq backup-directory-alist
      (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/backup"))
	    backup-directory-alist))




;; transparent
;; (setq default-frame-alist 
;;       (append (list 
;;                '(alpha . (85 75))) default-frame-alist))
;; display cursor coordinates

