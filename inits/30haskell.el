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
;; cabal でインストールしたライブラリのコマンドが格納されている bin ディレクトリへのパスを exec-path に追加する
(add-to-list 'exec-path (concat (getenv "HOME") "/Library/Haskell/bin"));; ghc-flymake.el などがあるディレクトリ ghc-mod を ~/.emacs.d 以下で管理することにした
(add-to-list 'load-path "/Users/Altech/Library/Haskell/ghc-7.4.2/lib/ghc-mod-1.12.1/share/")

(autoload 'ghc-init "ghc" nil t)

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
    (error "ghc-mod を利用できません。ターミナルで which したり、*scratch* で exec-path を確認したりしましょう"))
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
;; ghc-mod の設定のあとに書いた方がよいかもしれません
(add-hook 'haskell-mode-hook
  (lambda()
    (set (make-local-variable 'ac-auto-start) 1)
    (set (make-local-variable 'ac-auto-show-menu) 0.05)
    (ghc-init)
    (flymake-mode 1)
    (define-key haskell-mode-map (kbd "C-M-q") 'anything-ghc-browse-document)
    (define-key haskell-mode-map (kbd "C-M-j") 'backward-sexp)
    (define-key haskell-mode-map (kbd "C-M-k") 'kill-sexp)
    (define-key haskell-mode-map (kbd "C-x C-d") 'save-buffers-kill-terminal)))



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

;; (defun my-ac-haskell-mode ()
;;   (setq ac-sources '(ac-source-ghc-mod)))
;; (add-hook 'haskell-mode-hook 'my-ac-haskell-mode)

;; (defun my-haskell-ac-init ()
;;   (when (member (file-name-extension buffer-file-name) '("hs" "lhs"))
;;     (auto-complete-mode t)
;;     (setq ac-sources '(ac-source-words-in-same-mode-buffers ac-source-dictionary ac-source-ghc-mod))))

;; (add-hook 'find-file-hook 'my-haskell-ac-init)



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
      (insert (concat "<html><head><script>setTimeout(function () { document.location = '" uri "' } , 0)</script></head>"))
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
		 (type (progn (string-match "\\(.+\\)--" output) (match-string 1 output))))
	    (with-current-buffer (window-buffer (minibuffer-window))
	      (erase-buffer)
	      (unless (string-match "^Dummy:" type)
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
