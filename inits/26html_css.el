
;; for HTML
;; (require 'zencoding-mode) 
;; (add-hook 'zencoding-mode-hook
;; 	  (lambda ()
;; 	     (local-set-key (kbd "k") 'self-insert-command)
;; 	     (global-set-key (kbd "C-j") 'backward-char)
;; 	     (local-set-key (kbd "C-j") 'backward-char)))
;; (add-hook 'sgml-mode-hook 'zencoding-mode)
(define-key html-mode-map (kbd "C-c p") 'browse-url-of-buffer)

;; for SCSS
(autoload 'scss-mode "scss-mode")
(setq scss-compile-at-save nil) ;; 自動コンパイルをオフにする
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))
(setq cssm-indent-function #'cssm-c-style-indenter)
(add-hook 'css-mode-hook
              (lambda ()
                (setq css-indent-offset 2)
                ))

;; for LESS
(require 'less-css-mode)

;; for Slim
(require 'slim-mode)

(add-hook 'slim-mode-hook
	  (lambda ()
	    (local-set-key (kbd "<M-right>") 'slim-indent-region-deeply)
	    (local-set-key (kbd "<M-left>") 'slim-indent-region-shallowly)
	    (local-set-key (kbd "DEL") 'delete-backward-char)
	    (local-set-key (kbd "<backspace>") 'delete-backward-char)))

(defun slim-compile-and-browse-url-of-buffer ()
  (interactive)
  (with-temp-buffer
    (shell-command (concat "slimrb" " " "--trace" " " "-p" " " (buffer-file-name)) (current-buffer))
    (browse-url-of-buffer)))

(define-key slim-mode-map (kbd "C-c p") 'slim-compile-and-browse-url-of-buffer)

(defun slim-indent-region-deeply (s e)
  (interactive "r")
  (if (use-region-p)
      (progn
	(save-restriction
	  (narrow-to-region s e)
	  (let ((buf-lines (count-lines (point-min) (point-max))))
	    (beginning-of-buffer)
	    (dotimes (i buf-lines)
	      (insert "  ")
	      (next-line)
	      (beginning-of-line)))))))


(defun slim-indent-region-shallowly (s e)
  (interactive "r")
  (if (use-region-p)
      (progn
	(save-restriction
	  (narrow-to-region s e)
	  (let ((buf-lines (count-lines (point-min) (point-max))))
	    (beginning-of-buffer)
	    (dotimes (i buf-lines)
	      (if (equal (thing-at-point 'char) " ")
		  (delete-char 1))
	      (if (equal (thing-at-point 'char) " ")
		  (delete-char 1))
	      (next-line)
	      (beginning-of-line)))))))
