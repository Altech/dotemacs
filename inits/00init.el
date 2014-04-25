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
	       '(left . 500))
	      initial-frame-alist))

(setq default-frame-alist initial-frame-alist)


;; load path
(add-to-list 'load-path "~/.emacs.d")

;; exec path
(defvar my-exec-path (list
		      "/usr/sbin"
		      "/bin"
		      "/usr/bin"
		      "/opt/local/bin"
		      "/usr/local/bin"
		      (expand-file-name "~/.emacs.d/bin")
		      "/Users/Altech/dev/scripts"
		      ))
(dolist (dir my-exec-path)
  (when (and (file-exists-p dir) (not (member dir exec-path)))
    (setenv "PATH" (concat dir ":" (getenv "PATH")))
    (setq exec-path (append (list dir) exec-path))))

;; bookmark
(set-default 'bookmark-default-file "~/.emacs.d/emacs.bmk")

