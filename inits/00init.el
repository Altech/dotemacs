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
;; exec path
(defvar my-exec-path (list
		      "/usr/sbin"
		      "/bin"
		      "/usr/bin"
		      "/opt/local/bin"
		      "/usr/local/bin"
		      (expand-file-name "~/.emacs.d/bin")))
(dolist (dir my-exec-path)
  (when (and (file-exists-p dir) (not (member dir exec-path)))
    (setenv "PATH" (concat dir ":" (getenv "PATH")))
    (setq exec-path (append (list dir) exec-path))))

;; scratch buffer
(setq initial-buffer-choice t)
(setq initial-scratch-message "# MEMO\n")
(setq initial-major-mode 'markdown-mode)
