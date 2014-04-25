(require-package 'erlang)

(setq erlang-root-dir "/usr/local/lib/erlang/")
(setq exec-path (cons "/usr/local/lib/erlang/bin/" exec-path))

(require 'erlang-start)
(require 'erlang)
(define-key erlang-mode-map (kbd "M-.") 'helm-etags-select)
