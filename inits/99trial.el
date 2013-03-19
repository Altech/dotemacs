


;; *scratch*
(setq initial-scratch-message "# This buffer is for notes you don't want to save, and for Ruby evaluation.")
(setq initial-major-mode 'ruby-mode)




;; diff: switch-to-buffer-other-window -> switch-to-buffer 
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




(require 'evernote-mode)
(global-set-key "\C-cec" 'evernote-create-note)
(global-set-key "\C-ceo" 'evernote-open-note)
(global-set-key "\C-ces" 'evernote-search-notes)
(global-set-key "\C-ceS" 'evernote-do-saved-search)
(global-set-key "\C-cew" 'evernote-write-note)




(global-auto-revert-mode -1)
