(require-package 'erlang)

(setq erlang-root-dir "/usr/local/lib/erlang/")
(setq exec-path (cons "/usr/local/lib/erlang/bin/" exec-path))

(require 'erlang-start)
(require 'erlang)
(define-key erlang-mode-map (kbd "M-.") 'helm-etags-select)

(add-hook 'erlang-mode-hook
          (lambda ()
            (erlang-comment-out-log-functions)
            (add-hook 'after-save-hook 'erlang-comment-out-log-functions nil 'make-it-local)))

(setq erlang-indent-level 2)
