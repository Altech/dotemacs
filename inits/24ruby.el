(add-to-list 'load-path "~/.emacs.d/lisp/ruby/")
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)

;; open ruby-mode
(dolist (pattern '("\\.rb$" "Gemfile" "Rakefile"
                   "\\.rake$" "gemspec" "\\.pryrc"))
  (add-to-list 'auto-mode-alist `(,pattern . ruby-mode)))

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
             (local-set-key (kbd "M-i") 'ruby-indent-command)
	     ))

(defun ruby-mark-sexp ()
  (interactive)
  (push-mark nil t t)
  (ruby-forward-sexp))

;; rdefsx
(require 'rdefsx)
(define-key ruby-mode-map (kbd "C-;") 'anything-rdefsx)
(custom-set-variables `(rdefsx-command ,(expand-file-name "~/.emacs.d/bin/rdefsx")))
(if tool-bar-mode
    (rdefsx-auto-update-mode 1))
(setq rdefsx-ruby-command "/usr/local/bin/ruby")

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
 

;; ====================== Rails ====================

;; removed

;; ====================== Gem ====================
(defun gem-cd (gem)
  "Open a directory with the gem via Bundler."
  (interactive "sGem: ")
  (find-file (gem-dir gem)))

(defun gem-dir (gem)
  (if (file-exists-p "Gemfile")
      (let ((bundler-output (shell-command-to-string (concat "bundle show " gem))))
        (if (string-match "^/" bundler-output) ;; file path?
            (trim-string bundler-output)
          nil))
    (let ((gem-exists-p (string-equal "true" (trim-string (shell-command-to-string
                                                           (concat "ruby -e 'print !Gem::Specification.find_all_by_name(\"" gem "\").empty?'"))))))
      (if gem-exists-p
          (trim-string (shell-command-to-string
                        (concat "ruby -e 'print Gem::Specification.find_all_by_name(\"" gem "\").sort_by(&:version).first.full_gem_path'")))
        nil))))

(defvar major-gem-dir
  (shell-command-to-string "ruby -e 'print Gem::Specification.find.to_a.map(&:full_gem_path).map{|path| File.dirname(path)}.inject(Hash.new(0)){|hash, a| hash[a] += 1; hash}.sort_by(&:last).last.first'")
  "The directory which includes the most of rubygems")
