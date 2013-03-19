(add-to-list 'load-path "~/.emacs.d/haskell-mode")
(require 'haskell-mode)
(require 'haskell-cabal)

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.lhs$" . literate-haskell-mode))
(add-to-list 'auto-mode-alist '("\\.cabal\\'" . haskell-cabal-mode))

;; shebang
(add-to-list 'interpreter-mode-alist '("runghc" . haskell-mode))     ;#!/usr/bin/env runghc 用
(add-to-list 'interpreter-mode-alist '("runhaskell" . haskell-mode)) ;#!/usr/bin/env runhaskell 用



;; ;; ghc-mod
;; ;; cabal でインストールしたライブラリのコマンドが格納されている bin ディレクトリへのパスを exec-path に追加する
;; (add-to-list 'exec-path (concat (getenv "HOME") "/.cabal/bin"))
;; ;; ghc-flymake.el などがあるディレクトリ ghc-mod を ~/.emacs.d 以下で管理することにした
;; (add-to-list 'load-path "~/.emacs.d/elisp/ghc-mod") 

;; (autoload 'ghc-init "ghc" nil t)

;; (add-hook 'haskell-mode-hook
;;   (lambda () (ghc-init)))