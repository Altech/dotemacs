(defun my-c-mode-hook ()
  (progn 
    (setq-default compile-command (concat "gcc " (file-relative-name (buffer-file-name))))
    (setq tab-width 4)
    ;; ;; センテンスの終了である ';' を入力したら、自動改行+インデント
    (c-toggle-auto-hungry-state 1)
    ;; RET キーで自動改行+インデント
    ;; (define-key c-mode-base-map (kbd "C-m") 'newline-and-indent)
    (local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
    (local-set-key (kbd "{") 'skeleton-pair-insert-maybe)
    (local-set-key (kbd "[") 'skeleton-pair-insert-maybe)
    (local-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
))

(add-hook 'c-mode-common-hook 'my-c-mode-hook)
