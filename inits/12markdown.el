(require-package 'markdown-mode)
(require 'markdown-mode)
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(dolist (extension '("\\.mkd" "\\.md" "\\.markdown"))
  (setq auto-mode-alist (cons `(,extension . markdown-mode) auto-mode-alist)))

(add-hook 'markdown-mode-hook
	  (lambda ()
	    (local-set-key (kbd "M-p") 'backward-paragraph)
	    (local-set-key (kbd "M-n") 'forward-paragraph)
            (local-set-key (kbd "<return>") 'newline)
            (local-set-key (kbd "<C-return>") 'markdown-add-item)
            (local-set-key (kbd "C-u <C-return>") 'markdown-add-deeper-item)
            (local-set-key (kbd "C-u C-u <C-return>") 'markdown-add-shallower-item)
            (setq mode-line-format nil) ;; Hide mode-line
	    ))

;; tunr off auto-complete-mode
(defadvice global-auto-complete-mode-enable-in-buffers (around my-centered-cursor-mode-turn-on-maybe)
  (unless (eq 'markdown-mode major-mode)
	  ad-do-it))

(ad-activate 'global-auto-complete-mode-enable-in-buffers)

(defun markdown-add-item-general (level)
  (let ((l (strip-text-properties (thing-at-point 'line))))
    (when (string-match "^\\(  \\)*- " l)
      (move-end-of-line nil)
      (newline)
      (move-beginning-of-line nil)
      (let ((n (length (match-string 1 (buffer-string)))))
        (case level
          (1  (insert (concat "  " (make-string n ?\s) "- ")))
          (0  (insert (concat (make-string n ?\s) "- ")))
          (-1 (insert (concat (make-string (- n 2) ?\s) "- "))))))))

(defun markdown-add-item ()
  (interactive)
  (markdown-add-item-general 0))

(defun markdown-add-shallower-item ()
  (interactive)
  (markdown-add-item-general -1))

(defun markdown-add-deeper-item ()
  (interactive)
  (markdown-add-item-general 1))

(defun strip-text-properties (txt)
  (set-text-properties 0 (length txt) nil txt)
      txt)
