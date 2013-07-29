;; anything
(require 'anything-startup)
(setq migemo-isearch-min-length 2)
(anything-read-string-mode 0) ;; for ido-mode [TODO]
(require 'anything-match-plugin)
;; helm
(require 'helm-config)
;; tramp
(require 'tramp "~/.emacs.d/tramp/tramp")
;; popwin
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
(add-to-list 'popwin:special-display-config '("*quickrun*"))
(add-to-list 'popwin:special-display-config '("*compilation*"))
(add-to-list 'popwin:special-display-config '("* Oz Compiler*"))
(add-to-list 'popwin:special-display-config '("*buffer-selection*"))
(add-to-list 'popwin:special-display-config '("*git-gutter:diff*"))
(add-to-list 'popwin:special-display-config '("*refe:ACL*")) ;; [TODO]
(push '("\*refe" :regexp t :position top) popwin:special-display-config) ;; [TODO]
;; git
(add-to-list 'load-path "~/.emacs.d/magit")
(require 'magit)
(require 'git-gutter)
(global-git-gutter-mode 1)
(setq git-gutter:verbosity 0)
;; junk file
(require 'open-junk-file)
(global-set-key (kbd "C-x C-z") 'open-junk-file)
(setq open-junk-file-format "~/dev/junk/%Y-%m-%d-%H-%M.")


;; auto-complete
(add-to-list 'load-path "~/.emacs.d/auto-complete/")
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
			  ac-source-yasnippet
			  ac-source-words-in-same-mode-buffers
			  ac-source-filename
			  ac-source-functions
			  ac-source-variables
			  ;; ac-source-symbols
			  ac-source-features
			  ac-source-abbrev
			  ac-source-dictionary
			  ))

;; yasnippet
(add-to-list 'load-path "~/.emacs.d/elpa/yasnippet-20120923.1126")
(require 'yasnippet-config)
(require 'dropdown-list)
(yas/global-mode 1)
(call-interactively 'yas/reload-all)
(yas/load-directory "~/.emacs.d/snippets/")
;; if you use anything-complete.el, (yas/completing-prompt) is possible.
(setq yas/prompt-functions
      '(yas/dropdown-prompt yas/completing-prompt yas/ido-prompt yas/no-prompt))
;;; with anything
(require 'anything)
(require 'anything-c-yasnippet-2)
;;; with auto-complete
(yas/set-ac-modes)
(yas/enable-emacs-lisp-paren-hack)


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
;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
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

;; cooperate with tmux 
(require 'emamux)

(defun tmux-paste ()
  (interactive)
  (let ((tmpfile (make-temp-file "tmux-paste-"))) ; 一時ファイル作成
    (emamux:tmux-run-command (concat "save-buffer " tmpfile)) ; ペーストバッファを一時ファイルに書き込む
    (insert-file tmpfile)    ; 一時ファイルの内容をバッファに挿入
    (delete-file tmpfile))   ; 一時ファイルを削除
  (exchange-point-and-mark)) ; 末尾までカーソルを移動

(defun tmux-copy ()
  (interactive)
  (progn
    (kill-ring-save (region-beginning) (region-end))
    (emamux:copy-kill-ring 0)
    )
  )

(global-set-key (kbd "C-\\") 'emamux:send-command)
(global-set-key (kbd "C-]")     'tmux-paste)
(global-set-key (kbd "M-u M-w") 'tmux-copy)

;; layout
(require 'rotate)
;; (global-set-key (kbd "C-t") 'rotate-layout)
(global-set-key (kbd "M-t") 'rotate-window)


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

;; helm extension
(require 'helm-tags)
(setq helm-ctags-modes
  '( c-mode c++-mode awk-mode csharp-mode java-mode javascript-mode lua-mode
    makefile-mode pascal-mode perl-mode cperl-mode php-mode python-mode
    scheme-mode sh-mode slang-mode sql-mode tcl-mode
    ;; Added more modes
    lisp-mode emacs-lisp-mode asp-mode basic-mode cobol-mode
    objc-mode css-mode js2-mode matlab-mode ocaml-mode
    web-mode dos-mode batch-mode ntcmd-mode cmd-mode javascript-generic-mode
    eiffel-mode erlang-mode fortran-mode go-mode html-mode ruby-mode
    sml-mode tex-mode latex-mode yatex-mode vera-mode
    verilog-mode vhdl-mode
    ))
(defun helm-ctags-current-file ()
  (interactive)
  (helm :sources 'helm-source-ctags
        :buffer "*helm-ctags*"
        :candidate-number-limit nil))
