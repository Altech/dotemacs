(defun my-c++-mode-hook ()
  (setq-default compile-command (concat "g++ " (file-relative-name (buffer-file-name)))))
(add-hook 'c++-mode-hook 'my-c++-mode-hook)
