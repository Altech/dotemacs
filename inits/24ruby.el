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