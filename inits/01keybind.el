;; Perefix
(global-unset-key (kbd "C-l")) 
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
;; (global-set-key (kbd "C-x C-f") 'anything-find-files)
;; Eshell
(global-set-key (kbd "<f8>") 'eshell)
;; Reload
(global-set-key (kbd "<f5>") 'revert-buffer-force)
;; Recenter
(global-set-key (kbd "C-l C-l") 'recenter-top-bottom)
;; Replace
(global-set-key (kbd "C-l r") 'query-replace)
(global-set-key (kbd "C-l s") 'query-replace-regexp)
;; Switch buffer
(global-set-key (kbd "C-b") 'iswitchb-buffer)
;; Show buffer list which is easy to see
(global-set-key (kbd "C-x C-b") 'bs-show)
;; Remove mule toggle-input
(global-unset-key (kbd "C-\\")) 


(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1))

(defun revert-buffer-force()
  (interactive)
  (revert-buffer nil t)
)


