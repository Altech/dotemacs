;; ** View **
;; basic face
(set-face-attribute 'default nil
		    :family "menlo";;"monaco"
		    :height 110)
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
                    :height 130)
;; edit face
(dolist (mode-hook (list 'org-mode-hook 'markdown-mode-hook))
  (add-hook mode-hook
	    '(lambda()
	       (buffer-face-set 'variable-pitch)
	       (setq line-spacing 0.4)
	       (setq truncate-lines nil))))



;; ** Other **
;; Kill and hide
(if window-system (global-set-key (kbd "C-x C-c") 'close-on-mac))
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
  (ns-do-hide-emacs)
  )


;; Oz
;; (add-to-list 'load-path "/Applications/Mozart.app/Contents/Resources/share/elisp")
;; (require 'oz)
;; ;; Cursor move (paragraph) for Oz ;; for MacBookPro
;; (global-set-key (kbd "M-[") 'backward-paragraph)
;; (global-set-key (kbd "M-]") 'forward-paragraph)


;; hide at start
(add-hook 'emacs-startup-hook 'iconify-frame)