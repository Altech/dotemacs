;; desiplay line-number
(dolist (hook (list
              'c-mode-hook
              'java-mode-hook
              'js2-mode-hook
	      'ruby-mode-hook
	      'oz-mode-hook
              ;;'emacs-lisp-mode-hook
              'lisp-interaction-mode-hook
              'lisp-mode-hook
              'java-mode-hook
              'sh-mode-hook
              ))
(add-hook hook (lambda () (linum-mode t))))
;; Bucket supplement
(global-set-key (kbd "(") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "{") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "[") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\'") 'skeleton-pair-insert-maybe)
(setq skeleton-pair 1)
;; Compile
(require 'quickrun)
(global-set-key (kbd "C-c c") 'compile)
(global-set-key (kbd "C-c r") 'quickrun)
(global-set-key (kbd "C-c a") 'quickrun-with-args)
;; "chmod +x" when shebang
(defun make-file-executable ()
  "Make the file of this buffer executable, when it is a script source."
  (save-restriction
    (widen)
    (if (string= "#!" (buffer-substring-no-properties 1 (min 3 (point-max))))
        (let ((name (buffer-file-name)))
          (or (equal ?. (string-to-char (file-name-nondirectory name)))
              (let ((mode (file-modes name)))
                (set-file-modes name (logior mode (logand (/ mode 4) 73)))
                (message (concat "Wrote " name " (+x)"))))))))
(add-hook 'after-save-hook 'make-file-executable)
