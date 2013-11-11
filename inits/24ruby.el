(add-to-list 'load-path "~/.emacs.d/ruby/")
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)

;; open ruby-mode
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("gemspec" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.pryrc" . ruby-mode))

(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                                     interpreter-mode-alist))



(defun insert-block-params ()
  (interactive)
  (insert "||")
  (forward-char -1))

(defun insert-block-pair ()
  (interactive)
  (insert "{}")
  (forward-char -1))

;; (autoload 'run-ruby "inf-ruby"
;;   "Run an inferior Ruby process")
;; (autoload 'inf-ruby-keys "inf-ruby"
;;   "Set local key defs for inf-ruby in ruby-mode")

(require 'smartchr)
(add-hook 'ruby-mode-hook
          '(lambda ()
             ;; (inf-ruby-keys)
	     (local-set-key (kbd "C-M-j") 'ruby-backward-sexp)
	     (local-set-key (kbd "C-M-SPC") 'ruby-mark-sexp)
	     (local-set-key (kbd "C-m") 'ruby-reindent-then-newline-and-indent)
	     (local-set-key (kbd "C-j") 'backward-char)
	     (local-set-key (kbd "M-j") 'backward-word)
	     (local-set-key (kbd "|") 'insert-block-params)
	     (local-set-key (kbd "{") 'insert-block-pair)
	     (local-set-key (kbd "M-u h") 'anything-refe)
	     (local-set-key (kbd "M-i") 'ruby-indent-command)
	     (local-set-key (kbd "{") (smartchr '("{`!!'}" "#{`!!'}" "{")))
	     ))

(defun ruby-mark-sexp ()
  (interactive)
  (push-mark nil t t)
  (ruby-forward-sexp))


;; for Rails [TODO]
;;  - Rinari
;; (add-to-list 'load-path "~/.emacs.d/rinari")
;; (require 'rinari)
;;  - rhtml-mode
(add-to-list 'load-path "~/.emacs.d/rhtml")
(require 'rhtml-mode)
;; (lambda () (rinari-launch)))


 ;; (add-to-list 'ruby-encoding-map '(utf-8-hfs . utf-8))
 (add-to-list 'ruby-encoding-map '(undecided . utf-8))

;; rdefsx
(require 'rdefsx)
(define-key ruby-mode-map (kbd "C-;") 'anything-rdefsx)
(if tool-bar-mode
    (rdefsx-auto-update-mode 1)
  )


;; refe
(defvar anything-c-source-refe
      `((name . "refe")
        (candidates-file . "~/.emacs.d/ruby-refm-1.9.2/bitclust/refe.index")    
        (action ("Show" . anything-refe-action))))

(defun anything-refe-action (word)
  (let ((buf-name (concat "*refe:" word "*")))
    (with-current-buffer (get-buffer-create buf-name)
      (call-process "refe" nil t t word)
      (goto-char (point-min))
      (my-view-buffer-other-window buf-name t
                                (lambda (dummy)
                                  (kill-buffer-and-window))))))

(defun anything-refe ()
  (interactive)
  (anything anything-c-source-refe))


;; diff: switch-to-buffer-other-window -> switch-to-buffer 
(defun my-view-buffer-other-window (buffer &optional not-return exit-action)
  (let* ((win				; This window will be selected by
	  (get-lru-window))		; switch-to-buffer-other-window below.
	 (return-to
	  (and (not not-return)
	       (cons (selected-window)
		     (if (eq win (selected-window))
			 t			; Has to make new window.
		       (list
			(window-buffer win)	; Other windows old buffer.
			(window-start win)
			(window-point win)))))))
    (switch-to-buffer buffer) ;変更
    (view-mode-enter (and return-to (cons (selected-window) return-to))
		     exit-action)))


;; rdefsx
(setq rdefsx-ruby-command "/usr/local/bin/ruby")

(defun helm-ruby ()
  (interactive)
  (with-temp-buffer
    (cd "~/dev/ruby-2.0.0-p247")
    (helm-etags-select (thing-at-point 'symbol))))

;; gem
(defun trim-string (string)
  "Remove white spaces in beginning and ending of STRING.
   White space here is any of: space, tab, emacs newline (line feed, ASCII 10)."
  (replace-regexp-in-string "\\`[ \t\n]*" "" 
    (replace-regexp-in-string "[ \t\n]*\\'" "" string)))
 
 
(defun shell-command-to-string-with-return-code (command)
  "Execute shell command COMMAND and return its output as a string."
  (let* ((return-code)
	 (result (with-output-to-string
           (with-current-buffer standard-output
              (setq return-code 
               (call-process shell-file-name nil 
                 t nil shell-command-switch command))))))
    (list return-code result)))
 
 
(defun find-gem (gem)
  "Open a directory with the gem via Bundler."
  (interactive "sGem: ")
  (let* ((cmd (concat "bundle show " gem " --no-color"))
         (result (shell-command-to-string-with-return-code cmd)))
    (if (= (car result) 0)
	(find-file (trim-string (cadr result)))
      (message (trim-string (cadr result))))))

;; ====================== Rails ====================
(add-to-list 'load-path "~/.emacs.d/rinari/")
(add-to-list 'load-path "~/.emacs.d/jump")
(require 'rinari)
(global-rinari-mode 1)

(add-hook 'rinari-minor-mode-hook
	  (lambda ()
	    ;; specialized rgrep
	    (key-chord-define rinari-minor-mode-map "rg" 'rinari-rgrep)
	    ;; Correspond file
	    (local-set-key (kbd "C-x c") 'rinari-find-controller)
	    (local-set-key (kbd "C-x m") 'rinari-find-model)
	    (local-set-key (kbd "C-x v") 'rinari-find-view)
	    (local-set-key (kbd "C-x s") 'rinari-find-stylesheet)
	    (local-set-key (kbd "C-x j") 'rinari-find-javascript)
	    (local-set-key (kbd "C-x t") 'rinari-find-rspec)
	    (local-set-key (kbd "C-x M") 'rinari-find-migration)
	    ;; Specific file
	    (local-set-key (kbd "C-x r") 'rinari-find-routes)
	    (local-set-key (kbd "C-x g") 'rinari-find-gemfile)
	    (local-set-key (kbd "C-x a") 'rinari-find-application)
	    ;; Specific dir
	    (local-set-key (kbd "C-x e") 'rinari-find-environment)
	    (local-set-key (kbd "C-x b") 'rinari-find-bin)
	    (local-set-key (kbd "C-x C") 'rinari-find-configuration)
	    ;; Command
	    (local-set-key (kbd "C-c c") 'rinari-console)
	    (local-set-key (kbd "C-c C") 'rinari-console-restart)
	    (local-set-key (kbd "C-c r") 'rinari-rake)
	    (local-set-key (kbd "C-c s") 'rinari-web-server)
	    (local-set-key (kbd "C-c S") 'rinari-web-server-restart)
	    (add-to-list 'popwin:special-display-config '("*rails console*"))
	    (add-to-list 'popwin:special-display-config '("*rake*"))
	    ))
(require 'compile24); to use rinari-server in Emacs23

;; (define-key pd-rinari-map1 "'" 'rinari-find-by-context)
;; (define-key pd-rinari-map1 ";" 'rinari-find-by-context)
;; (define-key pd-rinari-map1 "c" 'rinari-console)
;; (define-key pd-rinari-map1 "d" 'rinari-cap)
;; (define-key pd-rinari-map1 "e" 'rinari-insert-erb-skeleton)
;; (define-key pd-rinari-map1 "g" 'rinari-rgrep)
;; (define-key pd-rinari-map1 "p" 'rinari-goto-partial)
;; (define-key pd-rinari-map1 "q" 'rinari-sql)
;; (define-key pd-rinari-map1 "r" 'rinari-rake)
;; (define-key pd-rinari-map1 "s" 'rinari-script)
;; (define-key pd-rinari-map1 "t" 'rinari-test)
;; (define-key pd-rinari-map1 "w" 'rinari-web-server)
;; (define-key pd-rinari-map1 "x" 'rinari-extract-partial)

;; (define-key pd-rinari-map2 ";" 'rinari-find-by-context)
;; (define-key pd-rinari-map2 "C" 'rinari-find-cells)
;; (define-key pd-rinari-map2 "F" 'rinari-find-features)
;; (define-key pd-rinari-map2 "M" 'rinari-find-mailer)
;; (define-key pd-rinari-map2 "S" 'rinari-find-steps)
;; (define-key pd-rinari-map2 "Y" 'rinari-find-sass)
;; ;; (define-key pd-rinari-map2 "a" 'rinari-find-application)
;; ;; (define-key pd-rinari-map2 "c" 'rinari-find-controller)
;; ;; (define-key pd-rinari-map2 "e" 'rinari-find-environment)
;; (define-key pd-rinari-map2 "f" 'rinari-find-file-in-project)
;; (define-key pd-rinari-map2 "h" 'rinari-find-helper)
;; (define-key pd-rinari-map2 "i" 'rinari-find-migration)
;; ;; (define-key pd-rinari-map2 "j" 'rinari-find-javascript)
;; (define-key pd-rinari-map2 "l" 'rinari-find-lib)
;; ;; (define-key pd-rinari-map2 "m" 'rinari-find-model)
;; ;; (define-key pd-rinari-map2 "n" 'rinari-find-configuration)
;; (define-key pd-rinari-map2 "o" 'rinari-find-log)
;; (define-key pd-rinari-map2 "p" 'rinari-find-public)
;; ;; (define-key pd-rinari-map2 "r" 'rinari-find-rspec)
;; (define-key pd-rinari-map2 "s" 'rinari-find-script)
;; (define-key pd-rinari-map2 "t" 'rinari-find-test)
;; (define-key pd-rinari-map2 "u" 'rinari-find-plugin)
;; ;; (define-key pd-rinari-map2 "v" 'rinari-find-view)
;; (define-key pd-rinari-map2 "w" 'rinari-find-worker)
;; (define-key pd-rinari-map2 "x" 'rinari-find-fixture)
;; ;; (define-key pd-rinari-map2 "y" 'rinari-find-stylesheet)
;; (define-key pd-rinari-map2 "z" 'rinari-find-rspec-fixture)
