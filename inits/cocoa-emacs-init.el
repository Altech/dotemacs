;; ** Kill and Hide Emacs
(global-set-key (kbd "C-x C-c") 'close-on-mac)
(global-set-key (kbd "C-x C-d") 'save-buffers-kill-terminal)

(defun close-on-mac ()
  (interactive)
  (close-buffers-without-default)
  (switch-to-buffer "*scratch*")
  (delete-other-windows)
  (delete-other-frames)
  (end-of-buffer)
  (ns-do-hide-emacs)
  (if (and (> (frame-width) 155) (> (frame-height) 43))
      (ns-toggle-fullscreen)))

;; ** View **
;; font
(set-face-attribute 'default nil
		    :family "menlo";; or "monaco"
		    :height 130) ;; or 110
(set-fontset-font
 (frame-parameter nil 'font)
 'japanese-jisx0208  ;; )
 '("Hiragino Kaku Gothic ProN W3" . "iso10646-1")) ;; or '("Hiragino Maru Gothic Pro" . "iso10646-1")

(setq face-font-rescale-alist
      '(("^-apple-hiragino.*" . 1.0)
	(".*osaka-bold.*" . 1.0)
	(".*osaka-medium.*" . 1.0)
	(".*courier-bold-.*-mac-roman" . 1.0)
	(".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
	(".*monaco-bold-.*-mac-roman" . 0.9)
	("-cdac$" . 1.0)))
(set-face-attribute 'variable-pitch nil
                    :family "Arial"
                    :height 136) ;; 130 markdown/org // 200
;; ** initial frame-size,position
(setq initial-frame-alist
      (append (list
	       '(width . 82)
	       '(height . 55)
	       '(top . 50)
	       '(left . 500))
	      initial-frame-alist))
(setq default-frame-alist initial-frame-alist)

;; theme
(defun programming-theme ()
  (interactive)
  (require-package 'color-theme)
  (color-theme-initialize)
  (require 'color-theme-tango)
  (color-theme-tango))
(defun writing-theme ()
  (interactive)
  (require 'bear-style)
  (load-theme 'bear-style t)
  (enable-theme 'bear-style))
(programming-theme)

;; transparency
(defun set-frame-transparent ()
  (interactive)
  (setq default-frame-alist 
      (append (list 
               '(alpha . (85 75))) default-frame-alist)))

;; at editing japanese plain text
(defun set-japanese-text-style ()
  (interactive)
  (buffer-face-set 'variable-pitch)
  (setq line-spacing 0.6)
  (setq truncate-lines nil))
(dolist (mode-hook (list 'org-mode-hook 'markdown-mode-hook 'text-mode-hook))
  (add-hook mode-hook 'set-japanese-text-style))

;; print
;; (load "ps-mule")
;; (setq ps-multibyte-buffer (quote non-latin-printer))
;; (setq ps-print-header nil)
(global-set-key (kbd "s-p") 'ps-print-buffer)

;; ** Other **
;; fullscreen
(setq ns-use-native-fullscreen nil)
(global-set-key (kbd "<f11>") 'toggle-frame-fullscreen)
;; hide at start
(add-hook 'emacs-startup-hook 'iconify-frame)
;; remove scroll bar
(set-scroll-bar-mode nil)
;; open a file without pop-up when click the icon.
(setq ns-pop-up-frames nil)
;; dictionary
(global-set-key (kbd "C-c w") 'look-up-current-word-in-dictionary-app)
;; eshell
(dolist (path (reverse (split-string (getenv "PATH") ":")))
  (add-to-list 'exec-path path))
(load-file "~/.emacs.d/shellenv.el")

;; Convert utf-16lc -> utf-8
;; [TODO] Remove(this code require revert-buffer.)
(require 'ucs-normalize)
(defun ucs-normalize-NFC-buffer ()
  (interactive)
  (ucs-normalize-NFC-region (point-min) (point-max)))

(require 'cl)
(defun close-buffers-without-default ()
  (interactive)
  (loop for buffer being the buffers
	do ((lambda (buffer)
	      (if (and (not (string= (buffer-name buffer) "*GNU Emacs*"))
		       (not (string= (buffer-name buffer) "*scratch*"))
		       (not (string= (buffer-name buffer) "*Messages*")))
		  (kill-buffer buffer))) buffer)))

(defun look-up-current-word-in-dictionary-app ()
  (interactive)
  (browse-url (concat "dict://" (current-word))))
