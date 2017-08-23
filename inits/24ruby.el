(require 'enh-ruby-mode)
(add-to-list 'load-path "~/.emacs.d/lisp/ruby/")
;; (autoload 'ruby-mode "ruby-mode"
;;   "Mode for editing ruby source files" t)


;; open ruby-mode
(dolist (pattern '("\\.rb$" "Gemfile" "Rakefile" "Guardfile"
                   "\\.rake$" "gemspec" "\\.pryrc"))
  (add-to-list 'auto-mode-alist `(,pattern . enh-ruby-mode)))

(setq interpreter-mode-alist (append '(("ruby" . enh-ruby-mode))
                                     interpreter-mode-alist))

(defun insert-block-params ()
  (interactive)
  (insert "||")
  (forward-char -1))

(defun insert-block-pair ()
  (interactive)
  (insert "{}")
  (forward-char -1))

(setq enh-ruby-deep-indent-paren nil)
(setq enh-ruby-add-encoding-comment-on-save nil)
(add-hook 'enh-ruby-mode-hook
          '(lambda ()
             ;; (inf-ruby-keys)
	     (local-set-key (kbd "C-M-j") 'ruby-backward-sexp)
	     (local-set-key (kbd "C-M-SPC") 'ruby-mark-sexp)
	     (local-set-key (kbd "C-m") 'ruby-reindent-then-newline-and-indent)
	     (local-set-key (kbd "C-j") 'backward-char)
	     (local-set-key (kbd "M-j") 'backward-word)
	     (local-set-key (kbd "|") 'insert-block-params)
	     (local-set-key (kbd "{") 'insert-block-pair)
             (local-set-key (kbd "M-i") 'ruby-indent-command)
	     ))

(defun ruby-mark-sexp ()
  (interactive)
  (push-mark nil t t)
  (ruby-forward-sexp))

;; rdefsx
(require-package 'back-button)
(require 'rdefsx)
(define-key ruby-mode-map (kbd "C-;") 'anything-rdefsx)
(custom-set-variables `(rdefsx-command ,(expand-file-name "~/.emacs.d/bin/rdefsx")))
(if tool-bar-mode
    (rdefsx-auto-update-mode 1))
(setq rdefsx-ruby-command "/usr/bin/ruby")

;; ;; [TODO]
;; (defun helm-ruby ()
;;   (interactive)
;;   (with-temp-buffer
;;     (cd "~/dev/ruby-2.0.0-p247")
;;     (helm-etags-select (thing-at-point 'symbol))))

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


;; ====================== rbenv ====================
(require-package 'rbenv)
(global-rbenv-mode)


;; ====================== Rails ====================

(require-package 'haml-mode)
(add-hook 'haml-mode-hook
          (lambda ()
            (define-key haml-mode-map (kbd "M-.") 'anything-rdefsx-find-definition)))

;; ====================== Gem ====================
(defun gem-cd (gem)
  "Open a directory with the gem via Bundler."
  (interactive "sGem: ")
  (let ((dir (gem-dir gem)))
    (if (file-exists-p dir)
        (find-file dir)
      (message (concat "No such directory: " dir)))))

(defun gem-dir (gem)
  (let ((ruby (shell-command-to-string "rbenv which ruby | ruby -e 'print $stdin.read.strip'")))
    (shell-command-to-string (concat ruby " " (expand-file-name "~/.bin/gem-cd") " --print " gem))))
