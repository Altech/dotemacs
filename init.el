(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'init-elpa)
(require 'init-loader-x)
(init-loader-load "~/.emacs.d/inits/")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(js2-strict-trailing-comma-warning nil)
 '(package-selected-packages
   '(helm column-marker dash-at-point helm-open-github auto-complete highlight-symbol dropdown-list git-gutter magit rbenv popwin haml-mode color-theme plantuml-mode flymake-json json-mode lua-mode swift-mode go-eldoc go-mode coffee-mode erlang elixir-mode haskell-mode lispxmp slime paredit slim-mode scss-mode js2-mode back-button quickrun markdown-mode dired-details yaml-mode anything key-chord fullframe)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
