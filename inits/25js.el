;; for JavaScript
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(add-hook 'js2-mode-hook
          #'(lambda ()
              (local-set-key (kbd "M-j") 'backward-word)
              ))

(defun my-indent-sexp ()
  (interactive)
  (save-restriction
    (save-excursion
      (widen)
      (let* ((inhibit-point-motion-hooks t)
             (parse-status (syntax-ppss (point)))
             (beg (nth 1 parse-status))
             (end-marker (make-marker))
             (end (progn (goto-char beg) (forward-list) (point)))
             (ovl (make-overlay beg end)))
        (set-marker end-marker end)
        (overlay-put ovl 'face 'highlight)
        (goto-char beg)
        (while (< (point) (marker-position end-marker))
          ;; don't reindent blank lines so we don't set the "buffer
          ;; modified" property for nothing
          (beginning-of-line)
          (unless (looking-at "\\s-*$")
            (indent-according-to-mode))
          (forward-line))
        (run-with-timer 0.5 nil '(lambda(ovl)
                                   (delete-overlay ovl)) ovl)))))

;;  - ejacs
(add-to-list 'load-path "~/.emacs.d/ejacs/")
;;; ejacs {{{2
;; C-c C-jでjs-consoleを起動
;; C-c rで選択範囲を実行 
(autoload 'js-console "js-console" nil t)
(defun js-console-execute-region (start end)
  "Execute region"
  (interactive "r")
  (let ((buf-name (buffer-name (current-buffer))))
    (copy-region-as-kill start end)
    (switch-to-buffer-other-window "*js*")
    (js-console-exec-input (car kill-ring))
    (switch-to-buffer-other-window buf-name)))
(defun run-js-console-and-split-window ()
  "Run js-console and split window horizontally."
  (interactive)
  (split-window-horizontally)
  (js-console)
  (other-window 1)
  )
(add-hook 'js2-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c C-j") 'run-js-console-and-split-window)
            (local-set-key (kbd "C-c r") 'js-console-execute-region)
            ))
