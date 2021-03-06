; trucate lines
(defun toggle-truncate-lines ()
  (interactive)
  (if truncate-lines
      (setq truncate-lines nil)
    (setq truncate-lines t))
  (recenter))
(setq-default truncate-partial-width-windows t)
(setq-default truncate-lines t)
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
;; find file
(require 'ido)
(ido-mode t)
;; alarm sign from sound to vision
(setq visible-bell t)
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
;; Revert buffer
(global-auto-revert-mode t) ; no effect?
;; Improve same buffer name
(require 'uniquify)
;; Find function routines
(find-function-setup-keys)
;; Backup to a particular dir
(setq make-backup-files nil)
;; Generic mode
(require 'generic-x)
;; Indent
(setq-default tab-width 8 indent-tabs-mode nil)
;; Buffer Switching
(icomplete-mode 1)
(setq ido-ignore-buffers
      '(
        "\\` "
        "*Help*"
        "*init log*"
        "*anything apropos*"
        "*grep*"
        "^\*magit.+"
        "^*git-gutter"
        ))
;; Highlight trailing whitespace
(setq-default show-trailing-whitespace t)
