(add-to-list 'load-path "~/.emacs.d/haskell-mode")
(require 'haskell-mode)
(require 'haskell-cabal)

;; ext
(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.lhs$" . literate-haskell-mode))
(add-to-list 'auto-mode-alist '("\\.cabal\\'" . haskell-cabal-mode))

;; shebang
(add-to-list 'interpreter-mode-alist '("runghc" . haskell-mode))     ;#!/usr/bin/env runghc 用
(add-to-list 'interpreter-mode-alist '("runhaskell" . haskell-mode)) ;#!/usr/bin/env runhaskell 用

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)


;; ghc-mod
;; cabal でインストールしたライブラリのコマンドが格納されている bin ディレクトリへのパスを exec-path に追加する
(add-to-list 'exec-path (concat (getenv "HOME") "/Library/Haskell/bin"));; ghc-flymake.el などがあるディレクトリ ghc-mod を ~/.emacs.d 以下で管理することにした
(add-to-list 'load-path "/Users/Altech/Library/Haskell/ghc-7.4.2/lib/ghc-mod-1.12.1/share/")
(autoload 'ghc-init "ghc" nil t)


(defun haskell-switch-test-and-src ()
  (interactive)
  (let ((path (buffer-file-name)))
    (when (string-match "\\.hs$" path)
      (cond ((string-match "\\(.*\\)src/\\(.*\\)\\.hs$" path)
	     (let ((test-path (concat (match-string 1 path) "test/" (match-string 2 path) "Spec.hs")))
	       (find-file test-path))))
      (cond ((string-match "\\(.*\\)test/\\(.*\\)Spec\\.hs$" path)
	     (princ (match-string 2 path))
	     (let ((src-path (concat (match-string 1 path) "src/" (match-string 2 path) ".hs")))
	       (find-file src-path)))))))

;; (setq enable-local-eval t)

(require 'anything)
(require 'anything-config)
(require 'anything-match-plugin)

(defvar anything-c-source-ghc-mod
  '((name . "ghc-browse-document")
    (init . anything-c-source-ghc-mod)
    (candidates-in-buffer)
    (candidate-number-limit . 9999999)
    (action ("Open" . anything-c-source-ghc-mod-action))))

(defun anything-c-source-ghc-mod ()
  (unless (executable-find "ghc-mod")
    (error "ghc-mod を利用できません。ターミナルで which したり、*scratch* で exec-path を確認したりしましょう"))
  (let ((buffer (anything-candidate-buffer 'global)))
    (with-current-buffer buffer
      (call-process "ghc-mod" nil t t "list"))))

(defun anything-c-source-ghc-mod-action (candidate)
  (interactive "P")
  (let* ((pkg (ghc-resolve-package-name candidate)))
    (anything-aif (and pkg candidate)
        (ghc-display-document pkg it nil)
      (message "No document found"))))

(defun anything-ghc-browse-document ()
  (interactive)
  (anything anything-c-source-ghc-mod))

;; M-x anything-ghc-browse-document() に対応するキーの割り当て
;; ghc-mod の設定のあとに書いた方がよいかもしれません
(add-hook 'haskell-mode-hook
  (lambda()
    (set (make-local-variable 'ac-auto-start) 1)
    (set (make-local-variable 'ac-auto-show-menu) 0.05)
    (ghc-init)
    (flymake-mode 1)
    (define-key haskell-mode-map (kbd "C-M-q") 'anything-ghc-browse-document)
    (define-key haskell-mode-map (kbd "C-M-j") 'backward-sexp)
    (define-key haskell-mode-map (kbd "C-M-k") 'kill-sexp)
    (define-key haskell-mode-map (kbd "C-x C-d") 'save-buffers-kill-terminal)
    (define-key haskell-mode-map (kbd "\'") 'self-insert-command)
    (define-key haskell-mode-map (kbd "C-c C-s") 'haskell-switch-test-and-src)
    ))


(defun anything-default-display-buffer (buf)
  (if anything-samewindow
      (switch-to-buffer buf)
    (progn
      (delete-other-windows)
      (split-window (selected-window) nil t)
      (pop-to-buffer buf)
      )))


;; https://github.com/m2ym/auto-complete
(ac-define-source ghc-mod
  '((depends ghc)
    (candidates . (ghc-select-completion-symbol))
    (symbol . "s")
    (cache)))

(defun my-ac-haskell-mode ()
  (setq ac-sources '(ac-source-words-in-same-mode-buffers ac-source-dictionary ac-source-ghc-mod)))
(add-hook 'haskell-mode-hook 'my-ac-haskell-mode)

;; ** my extension (open document and show type of functions) **

(defun haskell-open-doc ()
  (interactive)
  (if (ghc-extract-module)
      (haskell-open-doc-uri-with-uri-fragment (haskell-open-doc-resolve-uri (ghc-extract-module)))
    (let ((sym (thing-at-point 'symbol)))
      (let* ((list-string (shell-command-to-string (concat "hoogle " sym)))
	     (list (haskell-open-doc-select-candidate (remove-if 'haskell-open-doc-filter (haskell-open-doc-parse list-string)))))
	(if list
	    (let ((mod (nth 0 list)) (fun (nth 1 list)) (type (nth 2 list)))
	      (haskell-open-doc-uri-with-uri-fragment (haskell-open-doc-resolve-uri mod fun)))
	  (message "non function or no document"))))))

(defun haskell-open-doc-parse (str)
  (let ((list (remove "" (split-string str "\n"))))
    (mapcar (lambda (str)
	      (if (not (string-match "^\\([^ ]+\\) \\([^ ]+\\) :: \\(.+\\)" str))
		  nil ;(error "Unexpected hoogle output. \n%s" str)
		(list (match-string 1 str) (match-string 2 str) (match-string 3 str)))) list)))

(defun haskell-open-doc-filter (list)
  (not (and
	(string-equal (nth 1 list) sym)            ;; match the function name perfectly and
	(remove-if (lambda (module)                ;; prefix of the module name is included in loaded modules.
		     (not (and
			   (<= (length module) (length (nth 0 list)))
			   (string-equal module (substring (nth 0 list) 0 (length module)))))) ghc-loaded-module)
	(not (null list))))) 

(defun haskell-open-doc-select-candidate (candidate)
  (if (or (eq 1 (length candidate)) (eq 0 (length candidate)))
      (nth 0 candidate)
    (pop-to-buffer "*WhichModule*")
    (with-current-buffer "*WhichModule*"
      (setq buffer-read-only nil)
      (erase-buffer)
      (insert "Please select the function you want to browse.\n\n")
      (insert (join (mapcar (lambda (l) (format "[%s] %s %s :: %s" (char-to-string (nth 0 l)) (nth 1 l) (nth 2 l) (nth 3 l)))
			    (zip (string-to-list "abcdefghijklmnopqrstu") candidate)) "\n"))
      (goto-char (point-min))
      (setq buffer-read-only t)
      (let ((position (- (read-char "Type: ") ?a)))
	(other-buffer)
	(if (get-buffer-window "*WhichModule*")
	    (delete-window (get-buffer-window "*WhichModule*")))
	(kill-buffer "*WhichModule*")
	(if (< position (length candidate))
	    (nth position candidate)
	  nil)))))

(defun haskell-open-doc-uri-with-uri-fragment (uri)
  (let ((file-name (make-temp-file "haskell-doc-")))
    (find-file file-name)
    (with-current-buffer (file-name-nondirectory file-name)
      (insert (concat "<html><head><script>setTimeout(function () { document.location = '" uri "' } , 0)</script></head><body>" uri "</body></html>"))
      (save-buffer)
      (kill-buffer))
    (run-at-time "3 sec" nil (lambda (file-name) (delete-file file-name)) file-name)
    (shell-command (concat "open " file-name)) (message "")))

(defun haskell-open-doc-resolve-uri (mod &optional fun)
  (concat (ghc-display-document-without-browse (ghc-resolve-package-name mod) mod nil)
	  (if fun (concat "#v:" fun) "")))

(define-key haskell-mode-map (kbd "C-c h") 'haskell-open-doc)

;; if you use popwin.el
(add-to-list 'popwin:special-display-config '("*WhichModule*"))
(add-to-list 'popwin:special-display-config '("*GHC Info*"))




;; Extension
(defun ghc-show-type-in-minibuffer ()
  (interactive)
  (if (and (eq major-mode 'haskell-mode) (ghc-things-at-point))
      (ignore-errors
	(let* ((ask nil)
	       (modname (or (ghc-find-module-name) "Main"))
	       (expr (ghc-things-at-point))
	       (file (buffer-file-name))
	       (cmds (list "info" file modname expr)))
	  (let* ((output (with-temp-buffer
			   (apply 'call-process ghc-module-command nil t nil (append (ghc-make-ghc-options) cmds))
			   (replace-regexp-in-string "\n[ \t]+" " " (buffer-substring (point-min) (1- (point-max))))))
		 (type (progn (unless (string-match "^Dummy:" output) (string-match "\\(.+\\)--" output) (match-string 1 output)))))
	    (with-current-buffer (window-buffer (minibuffer-window))
	      (erase-buffer)
	      (if type
		(insert (propertize type 'face 'bold)))))))
    (with-current-buffer (window-buffer (minibuffer-window))
      (erase-buffer))))

;; This behavior is configured in haskell-doc-mode.el
;; (run-with-idle-timer 3.0 t 'haskell-show-type-in-minibuffer)

(defun ghc-display-document-without-browse (pkg-ver mod haskell-org)
  (when (and pkg-ver mod)
    (let* ((mod- (ghc-replace-character mod ?. ?-))
	   (pkg (ghc-pkg-ver-get-pkg pkg-ver))
	   (ver (ghc-pkg-ver-get-ver pkg-ver))
	   (pkg-with-ver (format "%s-%s" pkg ver))
	   (path (ghc-resolve-document-path pkg-with-ver))
	   (local (format ghc-doc-local-format path mod-))
	   (remote (format ghc-doc-hackage-format pkg ver mod-))
	   (file (format "%s/%s.html" path mod-))
           (url (if (or haskell-org (not (file-exists-p file))) remote local)))
      url)))

(require 'haskell-indentation)
(require 'haskell-process) ; => haskell-process
(require 'haskell-interactive-mode) ; => haskell-interactive-mode

;; (custom-set-variables
;;  ;; Use cabal-dev for the GHCi session. Ensures our dependencies are in scope.
;;  '(haskell-process-type 'cabal-dev))

(setq haskell-interactive-mode-eval-pretty t)



(define-key haskell-mode-map [?\C-c ?\C-z] 'haskell-interactive-switch)
(define-key haskell-interactive-mode-map [f5] '(lambda ()
						 (interactive)
						 (haskell-interactive-mode-clear)
						 (haskell-process-clear)))

(setq ghc-ghc-options (list "-package-conf=/Users/Altech/.ghc/x86_64-darwin-7.4.2/package.conf.d" "-fno-warn-missing-signatures")) ;; "-fno-warn-missing-signatures"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; Sample file for the new session/process stuff
;; Based on my own configuration. Well, it IS my configuration.
;;
;; NOTE: If you don't have cabal-dev, or you don't want to use it, you
;; should change haskell-process-type (see below) to 'ghci.
;;
;; To merely TRY this mode (and for debugging), do the below:
;;
;;     cd into haskell-mode's directory, and run
;;     $ emacs --load examples/init.el
;;
;; To get started, open a .hs file in one of your projects, and hit…
;;
;;   1. F5 to load the current file (and start a repl session), or
;;   2. C-` to just start a REPL associated with this project, or
;;   3. C-c C-c to build the cabal project (and start a repl session).

;; Add the current dir for loading haskell-site-file.
(add-to-list 'load-path ".")
;; Always load via this. If you contribute you should run `make all`
;; to regenerate this.
(load "haskell-site-file")

;; Customization
(custom-set-variables
 ;; Use cabal-dev for the GHCi session. Ensures our dependencies are in scope.
 ;; '(haskell-process-type 'cabal-dev)
 '(haskell-process-type 'ghci)
 
 ;; Use notify.el (if you have it installed) at the end of running
 ;; Cabal commands or generally things worth notifying.
 '(haskell-notify-p t)

 ;; To enable tags generation on save.
 '(haskell-tags-on-save t)

 ;; To enable stylish on save.
 '(haskell-stylish-on-save t))

(add-hook 'haskell-mode-hook 'haskell-hook)
(add-hook 'haskell-cabal-mode-hook 'haskell-cabal-hook)

;; Haskell main editing mode key bindings.
(defun haskell-hook ()
  ;; Use simple indentation.
  (turn-on-haskell-simple-indent)
  (define-key haskell-mode-map (kbd "<return>") 'haskell-simple-indent-newline-same-col)
  (define-key haskell-mode-map (kbd "C-<return>") 'haskell-simple-indent-newline-indent)

  ;; Load the current file (and make a session if not already made).
  (define-key haskell-mode-map [?\C-c ?\C-l] 'haskell-process-load-file)
  (define-key haskell-mode-map [f5] 'haskell-process-load-file)

  ;; Switch to the REPL.
  (define-key haskell-mode-map [?\C-c ?\C-z] 'haskell-interactive-switch)
  ;; “Bring” the REPL, hiding all other windows apart from the source
  ;; and the REPL.
  (define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring)

  ;; Build the Cabal project.
  (define-key haskell-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
  ;; Interactively choose the Cabal command to run.
  (define-key haskell-mode-map (kbd "C-c c") 'haskell-process-cabal)

  ;; Get the type and info of the symbol at point, print it in the
  ;; message buffer.
  ;; [Modified
  ;; (define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
  ;; (define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)

  ;; Contextually do clever things on the space key, in particular:
  ;;   1. Complete imports, letting you choose the module name.
  ;;   2. Show the type of the symbol after the space.
  (define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)

  ;; Jump to the imports. Keep tapping to jump between import
  ;; groups. C-u f8 to jump back again.
  (define-key haskell-mode-map [f8] 'haskell-navigate-imports)

  ;; Jump to the definition of the current symbol.
  (define-key haskell-mode-map (kbd "M-.") 'haskell-mode-tag-find)

  ;; Indent the below lines on columns after the current column.
  (define-key haskell-mode-map (kbd "C-<right>")
    (lambda ()
      (interactive)
      (haskell-move-nested 1)))
  ;; Same as above but backwards.
  (define-key haskell-mode-map (kbd "C-<left>")
    (lambda ()
      (interactive)
      (haskell-move-nested -1))))

;; Useful to have these keybindings for .cabal files, too.
(defun haskell-cabal-hook ()
  (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
  (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)
  (define-key haskell-cabal-mode-map (kbd "C-`") 'haskell-interactive-bring)
  (define-key haskell-cabal-mode-map [?\C-c ?\C-z] 'haskell-interactive-switch))

