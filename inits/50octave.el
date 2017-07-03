(setq auto-mode-alist
      (cons
       '("\\.m$" . octave-mode)
       auto-mode-alist))

(add-hook 'octave-mode-hook (lambda ()
  (setq indent-tabs-mode f)
  (setq tab-stop-list (number-sequence 2 200 2))
  (setq tab-width 4)
  (setq indent-line-function 'insert-tab) ))
