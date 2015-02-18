(require-package 'anything)
;; (require-package 'helm)
(require-package 'magit)
(add-to-list 'load-path "~/.emacs.d/lisp/magit")
(require 'magit)
(require-package 'git-gutter)
(require-package 'dropdown-list)
(require-package 'highlight-symbol)
(require-package 'popwin)
(require-package 'auto-complete)

;; anything
(require 'anything-startup)
(setq migemo-isearch-min-length 2)
(anything-read-string-mode 0) ;; for ido-mode [TODO]
(require 'anything-match-plugin)
;; ;; helm
;; (require 'helm-config)
;; popwin
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
(dolist (buffer-name '("*quickrun*"
                       "*compilation*"
                       "*buffer-selection*"
                       "*git-gutter:diff*"
                       "* Oz Compiler*"
                       "*refe:ACL*"))
  (add-to-list 'popwin:special-display-config (list buffer-name)))
(push '("\*refe" :regexp t :position top) popwin:special-display-config) ;; [TODO]
;; git
(require 'magit)
(require 'git-gutter)
(global-git-gutter-mode 1)
(setq git-gutter:verbosity 0)

;; auto-complete
(require 'auto-complete)
(global-auto-complete-mode t)
(setq ac-auto-start 4)
(setq ac-auto-show-menu 0.5)
(setq ac-use-comphist t)
(setq ac-candidate-limit nil)
(setq ac-use-quick-help nil)
(setq ac-use-menu-map t)
(define-key ac-menu-map (kbd "C-n")         'ac-next)
(define-key ac-menu-map (kbd "C-p")         'ac-previous)
(define-key ac-completing-map (kbd "<tab>") 'ac-complete)
(define-key ac-completing-map (kbd "M-/")   'ac-stop)
(define-key ac-completing-map (kbd "RET") nil) ;; and modified auto-complete-el for cocoa-emcas.
(require 'auto-complete-config)
(setq-default ac-sources (list
                          ac-source-words-in-same-mode-buffers
			  ac-source-filename
			  ac-source-functions
			  ac-source-variables
			  ;; ac-source-symbols
			  ac-source-features
			  ac-source-abbrev
			  ac-source-dictionary
			  ))

;; server start for emacs-client
(require 'server)
(unless (server-running-p)
  (server-start))
;; server editing
(defun quit-editing ()
  (interactive)
  (progn
    (save-buffer)
    (server-edit)))
(global-set-key (kbd "M-RET") 'quit-editing)

;; highlight symbol
(require 'highlight-symbol)

;; file rename
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive (list (read-string "new file name: "
                                  (file-name-nondirectory buffer-file-name)
                                  nil
                                  (file-name-nondirectory buffer-file-name)
                                  (file-name-nondirectory buffer-file-name))))
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

(defun altech:git-gutter:popup-hunk (&optional diffinfo)
  "popup current diff hunk"
  (interactive)
  (git-gutter:awhen (or diffinfo
                        (git-gutter:search-here-diffinfo git-gutter:diffinfos))
    (with-current-buffer (get-buffer-create git-gutter:popup-buffer)
      (erase-buffer)
      (insert (plist-get it :content))
      (insert "\n")
      (goto-char (point-min))
      (diff-mode)
      (pop-to-buffer (current-buffer))
      )))

;; ;; helm extension
;; (require 'helm-tags)
;; (setq helm-ctags-modes
;;   '(c-mode c++-mode awk-mode csharp-mode java-mode javascript-mode lua-mode
;;     makefile-mode pascal-mode perl-mode cperl-mode php-mode python-mode
;;     scheme-mode sh-mode slang-mode sql-mode tcl-mode
;;     ;; Added more modes
;;     lisp-mode emacs-lisp-mode asp-mode basic-mode cobol-mode
;;     objc-mode css-mode js2-mode matlab-mode ocaml-mode
;;     web-mode dos-mode batch-mode ntcmd-mode cmd-mode javascript-generic-mode
;;     eiffel-mode erlang-mode fortran-mode go-mode html-mode ruby-mode
;;     sml-mode tex-mode latex-mode yatex-mode vera-mode
;;     verilog-mode vhdl-mode
;;     ))
;; (defun helm-ctags-current-file ()
;;   (interactive)
;;   (helm :sources 'my-helm-source-ctags
;;         :buffer "*helm-ctags*"
;;         :candidate-number-limit nil))

;; (defvar my-helm-source-ctags
;;   (cons
;;    '(action . (("Execute helm command" .
;; 		(lambda (candidate)
;; 		  (string-match "[0-9]+" candidate)
;; 		  (princ (current-buffer))
;; 		  (goto-line (string-to-number (match-string 0 candidate)))
;; 		  (recenter)))
;; 	       ("Describe command" . describe-command)))
;;    helm-source-ctags))
