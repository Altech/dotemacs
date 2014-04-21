;; perefix
;; (global-unset-key (kbd "C-u")) ;; Utility
(global-unset-key (kbd "M-u")) ;; Utility
;; Find file from yank
(global-set-key (kbd "C-x y") 'find-file-from-yank)
;; Save buffer
(global-set-key (kbd "C-x C-s") 'save-buffer-with-mkdir)
;; Kill buffer
(global-set-key (kbd "C-x K") 'kill-this-buffer)
;; Cursor move (paragraph)
(global-set-key (kbd "M-p") 'backward-paragraph)
(global-set-key (kbd "M-n") 'forward-paragraph)
;; Cursor move (for j)
(global-set-key (kbd "C-j") 'backward-char)
(global-set-key (kbd "M-j") 'backward-word)
;; Edit (use h-key as backspace-key)
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "M-h") 'backward-kill-word)
;; Undo
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-q") 'undo)
;; Indent
(global-set-key (kbd "C-m") 'newline-and-indent)
(global-set-key (kbd "C-M-\\") 'my-indent-region)
;; Open terminal
;; 折り返し表示ON/OFF
(global-set-key (kbd "C-c C-l") 'toggle-truncate-lines)
;; Window-move
(global-set-key (kbd "C-t") 'other-window-or-split)
(global-set-key (kbd "C-M-k") 'windmove-up)
(global-set-key (kbd "C-M-j") 'windmove-down)
(global-set-key (kbd "C-M-l") 'windmove-right)
(global-set-key (kbd "C-M-h") 'windmove-left)
;; Frame change
(global-set-key (kbd "M-'") 'other-frame)
;; Goto line
(global-set-key (kbd "M-g") 'goto-line)
;; Exchange command-key for meta-key
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))
;; Change window size
(global-set-key (kbd "C-]") 'enlarge-window-horizontally)
;; Find file
(global-set-key (kbd "C-x C-f") 'ido-find-file)
(global-set-key (kbd "C-x f") 'ido-find-file-from-home)
;; Eshell
(global-set-key (kbd "<f8>") 'eshell)
;; Reload
(global-set-key (kbd "<f5>") 'revert-buffer-force)
;; ;; Recenter
(global-set-key (kbd "C-l") 'recenter-top-bottom)
;; Replace
(global-unset-key (kbd "M-%"))
(global-set-key (kbd "M-u M-r") 'query-replace)
(global-set-key (kbd "M-u M-s") 'query-replace-regexp)
;; Switch buffer
(global-set-key (kbd "C-b") 'iswitchb-buffer)
;; Show buffer list which is easy to see
(global-set-key (kbd "C-x C-b") 'bs-show)
;; Show buffer list
(global-set-key (kbd "C-x C-l") 'list-buffers-and-switch)
;; Remove mule toggle-input
(global-unset-key (kbd "C-\\")) 
;; Anything
(global-set-key (kbd "M-u M-y") 'anything-yasnippet-2) 
(global-set-key (kbd "M-u y") 'anything-yasnippet-2) 
(global-set-key (kbd "M-x") 'anything-M-x)
(global-set-key (kbd "<f2>") 'anything-apropos)
;; Scroll
(global-set-key (kbd "<wheel-up>") 'scroll-down-with-lines)
(global-set-key (kbd "<wheel-down>") 'scroll-up-with-lines)
(global-set-key (kbd "<up>") 'scroll-down-with-lines)
(global-set-key (kbd "<down>") 'scroll-up-with-lines)
;; Git
(global-unset-key (kbd "M-l"))
(global-set-key (kbd "M-l M-s") 'magit-status)
(global-set-key (kbd "M-l M-b") 'magit-branch-manager)
(global-set-key (kbd "M-l M-l") 'magit-log)
(global-set-key (kbd "M-l M-d") 'altech:git-gutter:popup-hunk)
(global-set-key (kbd "M-l M-n") 'git-gutter:next-diff)
(global-set-key (kbd "M-l M-p") 'git-gutter:previous-diff)
;; Hihglight
(global-set-key (kbd "M-u M-u") 'highlight-symbol-at-point)
;; GTD
(global-set-key (kbd "<f7>") 'org-remember)
;; Utils
(global-set-key (kbd "M-u M-y") 'paste-from-os-x)
;; Code Reading
(global-set-key (kbd "C-;") 'helm-ctags-current-file)
(global-set-key (kbd "M-.") 'helm-etags-select)

;; Pressing simultaneously
(require 'key-chord)
(setq key-chord-two-keys-delay 0.04)
(key-chord-mode 1)

;; Grep
(key-chord-define-global "rg" 'rgrep)
;; Evernote
(key-chord-define-global (kbd "jf") 'ever-notes)

(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1))

(defun revert-buffer-force()
  (interactive)
  (revert-buffer nil t)
)

;; wheel scroll
(defun scroll-down-with-lines ()
  ""
  (interactive)
  (scroll-down 1)
  )
(defun scroll-up-with-lines ()
   ""
   (interactive)
   (scroll-up 1)
)


(defun save-buffer-with-mkdir ()
  (interactive)
  (progn
    (when buffer-file-name
      (let ((dir (file-name-directory buffer-file-name)))
	(when (and (not (file-exists-p dir))
		   (y-or-n-p (format "Directory %s does not exist. Create it?" dir)))
	  (make-directory dir t))))
    (save-buffer)
    )
  )

(defun list-buffers-and-switch ()
  (interactive)
  (if (get-buffer "*Buffer List*")
       (switch-to-buffer "*Buffer List*")
       (list-buffers)))

(defun ido-find-file-from-home ()
  (interactive)
  (ido-find-file-in-dir "~"))

(defun my-indent-region (s e)
  (interactive "r")
  (if (not (use-region-p))
      (indent-region (point-min) (point-max) nil)
    (indent-region s e nil)))


(defun paste-from-os-x ()
  (interactive)
  (insert (shell-command-to-string "pbpaste")))

(defun find-file-from-yank ()
  (interactive)
  (let ((path (get-path-to-find-file-from-yank)))
    (if path
        (if (file-exists-p path)
            (find-file path)
          (message "No such file or directory."))
      (message "There is no path in clipboard."))))

(defun get-path-to-find-file-from-yank ()
  (let ((osx-pasteboard (trim-string (shell-command-to-string "pbpaste"))) (emacs-killring (substring-no-properties (current-kill 0))))
    (cond
     ((or (string-match "^/" osx-pasteboard) (string-match "^~/" osx-pasteboard)) osx-pasteboard)
     ((or (string-match "^/" emacs-killring) (string-match "^~/" emacs-killring)) emacs-killring)
     (t nil))))
