;; Quickrun ES2016
(define-derived-mode es6-mode
  js2-mode "es6"
  "Major mode for javascript(es6).
\\{es6-mode-map}"
  (setq case-fold-search nil))
(let* ((bin-path "/usr/local/Cellar/node/7.4.0/bin/")
       (babel-node (concat bin-path "babel-node"))
       (babel (concat bin-path "babel %s")))
  (add-to-list 'auto-mode-alist '("\\.es6$" . es6-mode))
  (add-to-list 'quickrun-file-alist '("\\.es6" . "javascript/es6"))
  (add-to-list 'quickrun/language-alist
               `("javascript/es6"
                 (:command . ,babel-node)
                 (:compile-only . ,babel)
                 (:description . "Run es6 file"))))

(provide 'es6-mode)
