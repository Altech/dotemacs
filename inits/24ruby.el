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

(defun ido-set-gem-dir (&optional dir)
  (ido-set-current-directory major-gem-dir))

;; Define new ido-prefix "-/" to jump to major gem directory
(defun ido-exhibit ()
  "Post command hook for `ido'."
  ;; Find matching files and display a list in the minibuffer.
  ;; Copied from `icomplete-exhibit' with two changes:
  ;; 1. It prints a default file name when there is no text yet entered.
  ;; 2. It calls my completion routine rather than the standard completion.

  (when (ido-active)
    (let ((contents (buffer-substring-no-properties (minibuffer-prompt-end) (point-max)))
	  (buffer-undo-list t)
	  try-single-dir-match
	  refresh)

      (when ido-trace-enable
	(ido-trace "\nexhibit" this-command)
	(ido-trace "dir" ido-current-directory)
	(ido-trace "contents" contents)
	(ido-trace "list" ido-cur-list)
	(ido-trace "matches" ido-matches)
	(ido-trace "rescan" ido-rescan))

      (save-excursion
	(goto-char (point-max))
	;; Register the end of input, so we know where the extra stuff (match-status info) begins:
	(unless (boundp 'ido-eoinput)
	  ;; In case it got wiped out by major mode business:
	  (make-local-variable 'ido-eoinput))
	(setq ido-eoinput (point))

	;; Handle explicit directory changes
	(cond
	 ((memq ido-cur-item '(buffer list))
	  )

	 ((= (length contents) 0)
	  )

	 ((= (length contents) 1)
	  (cond
	   ((and (ido-is-tramp-root) (string-equal contents "/"))
	    (ido-set-current-directory ido-current-directory contents)
	    (setq refresh t))
	   ((and (ido-unc-hosts) (string-equal contents "/")
		 (let ((ido-enable-tramp-completion nil))
		   (ido-is-root-directory)))
	    (ido-set-current-directory "//")
	    (setq refresh t))
	  ))

	 ((and (string-match (if ido-enable-tramp-completion ".[:@]\\'" ".:\\'") contents)
	       (ido-is-root-directory) ;; Ange-ftp or tramp
	       (not (ido-local-file-exists-p contents)))
	  (ido-set-current-directory ido-current-directory contents)
	  (when (ido-is-slow-ftp-host)
	    (setq ido-exit 'fallback)
	    (exit-minibuffer))
	  (setq refresh t))

	 ((ido-final-slash contents)  ;; xxx/
	  (ido-trace "final slash" contents)
	  (cond
	   ((string-equal contents "~/")
	    (ido-set-current-home)
	    (setq refresh t))
	   ((string-equal contents "../")
	    (ido-up-directory t)
	    (setq refresh t))
           ((string-equal contents "-/")
            (ido-set-gem-dir t)
	    (setq refresh t))
	   ((string-equal contents "./")
	    (setq refresh t))
	   ((string-match "\\`~[-_a-zA-Z0-9]+[$]?/\\'" contents)
	    (ido-trace "new home" contents)
	    (ido-set-current-home contents)
	    (setq refresh t))
	   ((string-match "[$][A-Za-z0-9_]+/\\'" contents)
	    (let ((exp (condition-case ()
			   (expand-file-name
			    (substitute-in-file-name (substring contents 0 -1))
			    ido-current-directory)
			 (error nil))))
	      (ido-trace contents exp)
	      (when (and exp (file-directory-p exp))
		(ido-set-current-directory (file-name-directory exp))
		(setq ido-text-init (file-name-nondirectory exp))
		(setq refresh t))))
	   ((and (memq system-type '(windows-nt ms-dos))
		 (string-equal (substring contents 1) ":/"))
	    (ido-set-current-directory (file-name-directory contents))
	    (setq refresh t))
	   ((string-equal (substring contents -2 -1) "/")
	    (ido-set-current-directory
	     (if (memq system-type '(windows-nt ms-dos))
		 (expand-file-name "/" ido-current-directory)
	       "/"))
	    (setq refresh t))
	   ((and (or ido-directory-nonreadable ido-directory-too-big)
		 (file-directory-p (concat ido-current-directory (file-name-directory contents))))
	    (ido-set-current-directory
	     (concat ido-current-directory (file-name-directory contents)))
	    (setq refresh t))
	   (t
	    (ido-trace "try single dir")
	    (setq try-single-dir-match t))))

	 ((and (string-equal (substring contents -2 -1) "/")
	       (not (string-match "[$]" contents)))
	  (ido-set-current-directory
	   (cond
	    ((= (length contents) 2)
	     "/")
	    (ido-matches
	     (concat ido-current-directory (ido-name (car ido-matches))))
	    (t
	     (concat ido-current-directory (substring contents 0 -1)))))
	  (setq ido-text-init (substring contents -1))
	  (setq refresh t))

	 ((and (not ido-use-merged-list)
	       (not (ido-final-slash contents))
	       (eq ido-try-merged-list t)
	       (numberp ido-auto-merge-work-directories-length)
	       (> ido-auto-merge-work-directories-length 0)
	       (= (length contents) ido-auto-merge-work-directories-length)
	       (not (and ido-auto-merge-inhibit-characters-regexp
			 (string-match ido-auto-merge-inhibit-characters-regexp contents)))
	       (not (input-pending-p)))
	  (setq ido-use-merged-list 'auto
		ido-text-init contents
		ido-rotate-temp t)
	  (setq refresh t))

	 (t nil))

	(when refresh
	  (ido-trace "refresh on /" ido-text-init)
	  (setq ido-exit 'refresh)
	  (exit-minibuffer))

	;; Update the list of matches
	(setq ido-text contents)
	(ido-set-matches)
	(ido-trace "new    " ido-matches)

	(when (and ido-enter-matching-directory
		   ido-matches
		   (or (eq ido-enter-matching-directory 'first)
		       (null (cdr ido-matches)))
		   (ido-final-slash (ido-name (car ido-matches)))
		   (or try-single-dir-match
		       (eq ido-enter-matching-directory t)))
	  (ido-trace "single match" (car ido-matches))
	  (ido-set-current-directory
	   (concat ido-current-directory (ido-name (car ido-matches))))
	  (setq ido-exit 'refresh)
	  (exit-minibuffer))

	(when (and (not ido-matches)
		   (not ido-directory-nonreadable)
		   (not ido-directory-too-big)
		   ;; ido-rescan ?
		   ido-process-ignore-lists
		   ido-ignored-list)
	  (let ((ido-process-ignore-lists nil)
		(ido-rotate ido-rotate)
		(ido-cur-list ido-ignored-list))
	    (ido-trace "try all" ido-ignored-list)
	    (ido-set-matches))
	  (when ido-matches
	    (ido-trace "found  " ido-matches)
	    (setq ido-rescan t)
	    (setq ido-process-ignore-lists-inhibit t)
	    (setq ido-text-init ido-text)
	    (setq ido-exit 'refresh)
	    (exit-minibuffer)))

	(when (and
	       ido-rescan
	       (not ido-matches)
	       (memq ido-cur-item '(file dir))
	       (not (ido-is-root-directory))
	       (> (length contents) 1)
	       (not (string-match "[$]" contents))
	       (not ido-directory-nonreadable)
	       (not ido-directory-too-big))
	  (ido-trace "merge?")
	  (if ido-use-merged-list
	      (ido-undo-merge-work-directory contents nil)
	    (when (and (eq ido-try-merged-list t)
		       (numberp ido-auto-merge-work-directories-length)
		       (= ido-auto-merge-work-directories-length 0)
		       (not (and ido-auto-merge-inhibit-characters-regexp
				 (string-match ido-auto-merge-inhibit-characters-regexp contents)))
		       (not (input-pending-p)))
	      (ido-trace "\n*start timer*")
	      (setq ido-auto-merge-timer
		    (run-with-timer ido-auto-merge-delay-time nil 'ido-initiate-auto-merge (current-buffer))))))

	(setq ido-rescan t)

	(if (and ido-use-merged-list
		 ido-matches
		 (not (string-equal (car (cdr (car ido-matches))) ido-current-directory)))
	    (progn
	      (ido-set-current-directory (car (cdr (car ido-matches))))
	      (setq ido-use-merged-list t
		    ido-exit 'keep
		    ido-text-init ido-text)
	      (exit-minibuffer)))

	;; Insert the match-status information:
	(ido-set-common-completion)
	(let ((inf (ido-completions contents)))
	  (setq ido-show-confirm-message nil)
	  (ido-trace "inf" inf)
	  (insert inf))
	))))
