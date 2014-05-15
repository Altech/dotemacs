(add-to-list 'auto-mode-alist '("\\.h$" . objc-mode))

(define-key objc-mode-map (kbd "C-x x")   'objc-switch-header-and-implementation)

(defun objc-switch-header-and-implementation ()
  (interactive)
  (let* ((basename (file-name-nondirectory (buffer-file-name)))
         (extension (file-name-extension basename))
         (sans-extension (file-name-sans-extension basename))
         (reversed-extension (cond
                              ((string-equal extension "h") "m")
                              ((string-equal extension "m") "h")
                              (t nil)))
         (reversed-filename (concat sans-extension "." reversed-extension)))
    (when (and reversed-extension (file-exists-p reversed-filename))
      (find-file reversed-filename))))
