
;; ;; view-mode ;; 環境が変わるとなぜか使えない
;; (setq pager-keybind
;;       `( ;; vi-like
;; 	("h" . backward-char)
;; 	("l" . forward-char)
;; 	("j" . next-line)
;; 	("k" . previous-line)
;; 	("b" . scroll-down)
;; 	(" " . scroll-up)
;; 	("w" . forward-word)
;; 	("e" . backward-word)
;; 	("J" . ,(lambda () (interactive) (scroll-up 1)))
;; 	("K" . ,(lambda () (interactive) (scroll-down 1)))
;; 	))
;; (defun define-many-keys (keymap key-table &optional includes)
;;   (let (key cmd)
;;     (dolist (key-cmd key-table)
;;       (setq key (car key-cmd)
;; 	    cmd (cdr key-cmd))
;;       (if (or (not includes) (member key includes))
;; 	  (define-key keymap key cmd))))
;;   keymap)
;; (defun view-mode-hook--pager ()
;;   (define-many-keys view-mode-map pager-keybind))
;; (add-hook 'view-mode-hook 'view-mode-hook--pager)

;; ;; for MacBookPro [TODO]
;; (if window-system (global-set-key [f10] 'view-mode))
;; ;; change color for each mode
;; (if window-system (require 'viewer))
;; (if window-system (viewer-stay-in-setup))
;; (if window-system (setq viewer-modeline-color-unwritable "tomato"
;;       viewer-modeline-color-view "orange"))
;; (if window-system (viewer-change-modeline-color-setup))


;; *scratch*
(setq initial-scratch-message "# This buffer is for notes you don't want to save, and for Ruby evaluation.")
(setq initial-major-mode 'ruby-mode)




;; view-buffer-other-window の switch-to-buffer-other-window を switch-to-buffer にしたもの. letf でもよい.
(defun my-view-buffer-other-window (buffer &optional not-return exit-action)
  (let* ((win				; This window will be selected by
	  (get-lru-window))		; switch-to-buffer-other-window below.
	 (return-to
	  (and (not not-return)
	       (cons (selected-window)
		     (if (eq win (selected-window))
			 t			; Has to make new window.
		       (list
			(window-buffer win)	; Other windows old buffer.
			(window-start win)
			(window-point win)))))))
    (switch-to-buffer buffer) ;変更
    (view-mode-enter (and return-to (cons (selected-window) return-to))
		     exit-action)))

(add-hook 'ruby-mode-hook
  (lambda()
    (define-key ruby-mode-map (kbd "C-;") 'anything-refe)))



(require 'evernote-mode)
(global-set-key "\C-cec" 'evernote-create-note)
(global-set-key "\C-ceo" 'evernote-open-note)
(global-set-key "\C-ces" 'evernote-search-notes)
(global-set-key "\C-ceS" 'evernote-do-saved-search)
(global-set-key "\C-cew" 'evernote-write-note)



;; *refe*
(defvar anything-c-source-refe
      `((name . "refe")
        (candidates-file . "~/.emacs.d/ruby-refm-1.9.2/bitclust/refe.index")    
        (action ("Show" . anything-refe-action))))

(defun anything-refe-action (word)
  (let ((buf-name (concat "*refe:" word "*")))
    (with-current-buffer (get-buffer-create buf-name)
      (call-process "refe" nil t t word)
      (goto-char (point-min))
      (my-view-buffer-other-window buf-name t
                                (lambda (dummy)
                                  (kill-buffer-and-window))))))

;;
(defun anything-refe ()
  (interactive)
  (anything anything-c-source-refe))


(add-hook 'ruby-mode-hook
          '(lambda ()
             ;; (inf-ruby-keys)
	     (local-set-key (kbd "M-i") 'ruby-indent-command)
             ))
