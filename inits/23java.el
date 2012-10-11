(defun my-java-mode-hook ()
  (setq-default compile-command (concat "javac " (file-relative-name (buffer-file-name))))
  (local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "{") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "[") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
  (setq c-basic-offset 2)
  (setq java-indent-level 2)
  )
(add-hook 'java-mode-hook 'my-java-mode-hook)
;; (add-to-list 'load-path "~/.emacs.d/ajc-java-complete") ;; IDE-like?
;; (require 'ajc-java-complete-config) ;;補完
;; (add-hook 'java-mode-hook 'ajc-java-complete-mode)
