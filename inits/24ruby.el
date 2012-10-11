(add-to-list 'load-path "~/.emacs.d/ruby/")
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)

;; open ruby-mode
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("gemspec" . ruby-mode))

(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                                     interpreter-mode-alist))
;; (autoload 'run-ruby "inf-ruby"
;;   "Run an inferior Ruby process")
;; (autoload 'inf-ruby-keys "inf-ruby"
;;   "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
          '(lambda ()
             ;; (inf-ruby-keys)
	     (local-set-key (kbd "C-m") 'ruby-reindent-then-newline-and-indent)
             ))



;; for Rails [TODO]
;;  - Rinari
;; (add-to-list 'load-path "~/.emacs.d/rinari")
;; (require 'rinari)
;;  - rhtml-mode
(add-to-list 'load-path "~/.emacs.d/rhtml")
(require 'rhtml-mode)
;; (lambda () (rinari-launch)))

(yas/load-directory "~/.emacs.d/snippets/rails-snippets")