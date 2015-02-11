(add-hook 'c++-mode-hook
 (lambda ()
  (setq-default compile-command
                (concat "g++ "
                        (file-relative-name
                         (buffer-file-name))))))
