;; ** Initilialize ** 
;; default lunguage and encoding
(set-language-environment 'Japanese)
;; default encoding:utf-8                                                                       
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(prefer-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8)
;; garbage collection
(setq gc-cons-threshold (* 4 1024 1024))




;; initial frame-size,position
(setq initial-frame-alist
      (append (list
	       '(width . 100)
	       '(height . 55)
	       '(top . 50)
	       '(left . 500)
	       )
	      initial-frame-alist))
(setq default-frame-alist initial-frame-alist)


;; load path
(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/auto-install/")


;; exec path
(defvar my-exec-path (list
		      "/usr/sbin"
		      "/bin"
		      "/usr/bin"
		      "/opt/local/bin"
		      "/usr/local/bin"
		      (expand-file-name "~/.emacs.d/bin")
		      "/Users/Altech/.rvm/gems/ruby-1.9.3-p286/bin"
		      ))
(dolist (dir my-exec-path)
  (when (and (file-exists-p dir) (not (member dir exec-path)))
    (setenv "PATH" (concat dir ":" (getenv "PATH")))
    (setq exec-path (append (list dir) exec-path))))


;; auto-install
(add-to-list 'load-path "~/.emacs.d")
(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/auto-install/")
;; (auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup) ; for comatibility


;; package (24 later)
(require 'package)
;;; ELPA/Marmalade/MELPA
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(setq url-http-attempt-keepalives nil) ; To fix MELPA problem.


;; *scratch*
(setq initial-scratch-message "# This buffer is for notes you don't want to save, and for Ruby evaluation.")
(setq initial-major-mode 'ruby-mode)
