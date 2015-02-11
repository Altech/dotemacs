(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'init-elpa)
(require 'init-loader-x)
(init-loader-load "~/.emacs.d/inits/")
