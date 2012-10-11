;; for Common Lisp (Clozure CL)
(add-to-list 'load-path "~/.emacs.d/slime/")
;;; Note that if you save a heap image, the character
;;; encoding specified on the command line will be preserved,
;;; and you won't have to specify the -K utf-8 any more.
(setq inferior-lisp-program "/usr/bin/dx86cl64 -K utf-8")
(require 'slime)
(setq slime-net-coding-system 'utf-8-unix)
(slime-setup '(slime-fancy))
