;; ** View **
;; basic face
(set-face-attribute 'default nil
		    :family "menlo";;"monaco"
		    :height 110) ;;110
(set-fontset-font
 (frame-parameter nil 'font)
 'japanese-jisx0208
 ;;  '("Hiragino Maru Gothic Pro" . "iso10646-1"))
 '("Hiragino Kaku Gothic ProN W3" . "iso10646-1"))
(set-fontset-font
 (frame-parameter nil 'font)
 'japanese-jisx0212
 '("Hiragino Maru Gothic Pro" . "iso10646-1"))
(set-fontset-font
 (frame-parameter nil 'font)
 'mule-unicode-0100-24ff
 '("monaco" . "iso10646-1"))
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
                    :height 130) ;; 130 markdown/org // 200
;; edit face
(dolist (mode-hook (list 'org-mode-hook 'markdown-mode-hook))
  (add-hook mode-hook
	    '(lambda()
	       (buffer-face-set 'variable-pitch)
	       (setq line-spacing 0.8) ;;0.4
	       (setq truncate-lines nil))))


;; ** Other **
;; Kill and hide
(global-set-key (kbd "C-x C-c") 'close-on-mac)
(global-set-key (kbd "C-x C-d") 'save-buffers-kill-terminal)
;; fullscreen
(global-set-key (kbd "<f11>") 'ns-toggle-fullscreen)



(require 'cl)
(defun close-buffers-without-default ()
  (interactive)
  (loop for buffer being the buffers
	do ((lambda (buffer)
	      (if (and (not (string= (buffer-name buffer) "*GNU Emacs*"))
		       (not (string= (buffer-name buffer) "*scratch*"))
		       (not (string= (buffer-name buffer) "*Messages*")))
		  (kill-buffer buffer))) buffer)))

(defun close-on-mac ()
  (interactive)
  (close-buffers-without-default)
  (switch-to-buffer "*GNU Emacs*")
  (delete-other-windows)
  (delete-other-frames)
  (beginning-of-buffer)
  (ns-do-hide-emacs)
  (if (and (> (frame-width) 175) (> (frame-height) 60))
      (ns-toggle-fullscreen)))


;; Oz
;; (add-to-list 'load-path "/Applications/Mozart.app/Contents/Resources/share/elisp")
;; (require 'oz)
;; ;; Cursor move (paragraph) for Oz ;; for MacBookPro
;; (global-set-key (kbd "M-[") 'backward-paragraph)
;; (global-set-key (kbd "M-]") 'forward-paragraph)


;; hide at start
(add-hook 'emacs-startup-hook 'iconify-frame)


;; Convert utf-16lc -> utf-8
;; [TODO] Remove(this code require revert-buffer.)
(require 'ucs-normalize)
(prefer-coding-system 'utf-8-hfs)
(setq file-name-coding-system 'utf-8-hfs)
(setq locale-coding-system 'utf-8-hfs)
(defun ucs-normalize-NFC-buffer ()
  (interactive)
  (ucs-normalize-NFC-region (point-min) (point-max))
  )
(global-set-key (kbd "C-x RET u") 'ucs-normalize-NFC-buffer)


;; rdefsx
(setq rdefsx-ruby-command "/Users/Altech/.rvm/rubies/ruby-1.9.3-p286/bin/ruby")

(set-scroll-bar-mode nil)

(setq ns-pop-up-frames nil)

;; color-theme
(require 'color-theme)
(color-theme-initialize)
(color-theme-tango)

;; transparency
;; (setq default-frame-alist 
;;       (append (list 
;;                '(alpha . (85 75))) default-frame-alist))

;; ever-mode
(add-to-list 'load-path "~/dev/ever-mode")
(require 'ever-mode)
(defconst ever-rendered-dir "/Users/Altech/Documents/Dropbox/RNotes/")
(defun ever-open-rendered ()
  (interactive)
  (let ((this-file-name-sans-extension (file-name-sans-extension (file-name-nondirectory (buffer-file-name (current-buffer))))))
    (string-match "^[^_]+" this-file-name-sans-extension)
    (let ((path (concat ever-rendered-dir (match-string 0 this-file-name-sans-extension) ".html")))
      (shell-command (concat "open " path)))))
(global-set-key (kbd "C-c p") 'ever-open-rendered)
