(require 'anything)
(require 'back-button nil t)
(require 'ruby-mode)

;; (@* " rdefsx")
(defvar rdefsx-keyword-regexp
  (rx "def"
      (1+ space)
      (group (1+ (or alnum "_" "!" "?")))))

(defgroup anything-c-rdefsx nil
  "anything with rdefsx"
  :group 'anything
  :group 'ruby)

(defcustom rdefsx-command (expand-file-name "~/.emacs.d/rdefsx/rdefsx")
  "*rdefsx command name"
  :type 'string
  :group 'anything-c-rdefsx)

(defcustom rdefsx-ruby-command "ruby"
  "*ruby command name"
  :type 'string
  :group 'anything-c-rdefsx)

(defun anything-c-source-rdefsx-base (attrs)
  (append attrs
          '((candidates-in-buffer)
            (major-mode ruby-mode el4r-mode)
            (action ("Goto line" . anything-c-rdefsx-goto-entry)
                    ("Insert method" . anything-c-rdefsx-insert-method)))))

(defvar anything-c-source-rdefsx
  (anything-c-source-rdefsx-base
   '((name . "Ruby Defines")
     (init . anything-c-rdefsx-init)
     (candidate-number-limit))))

(defvar anything-c-source-rdefsx-file
  (anything-c-source-rdefsx-base
   '((name . "Ruby Defines (Other files)")
     (candidates-in-buffer)
     (init . anything-c-rdefsx-file-init))))

(defvar anything-c-source-rdefsx-find-definition
  (anything-c-source-rdefsx-base
   '((name . "Find definition by rdefsx")
     (init . anything-c-rdefsx-find-definition-init)
     (before-jump-hook . anything-c-rdefsx-mark-position)
     (after-jump-hook . view-mode)
     (adjust)
     (no-new-window))))

(defvar anything-c-rdefsx-find-definition-word nil)
(defun anything-rdefsx-find-definition (&optional word)
  (interactive)
  (setq anything-c-rdefsx-find-definition-word (or word (thing-at-point 'symbol)))
  (anything :sources 'anything-c-source-rdefsx-find-definition
            :quit-if-no-candidate (lambda () (message "No definition"))
            :execute-action-at-once-if-one t))

(defun anything-rdefsx ()
  (interactive)
  (anything :sources '(anything-c-source-rdefsx
                       anything-c-source-rdefsx-file)
            :buffer "*anything-rdefsx*"))

(defun anything-c-rdefsx-mark-position ()
  (if (fboundp 'back-button-push-mark-local-and-global)
      (back-button-push-mark-local-and-global)
    (push-mark)))

(defun anything-c-rdefsx-goto-line (line)
  (goto-char (point-min))
  (forward-line (1- line))
  (set-window-start (selected-window) (point)))

(defun anything-c-rdefsx-goto-entry (candidate)
  (cond ((string-match "^\\([0-9]+\\)" candidate)
         (save-match-data (find-file anything-buffer-file-name))
         (anything-c-rdefsx-goto-line (string-to-number (match-string 1 candidate))))
        ((string-match "^\\(.+?\\):\\([0-9]+\\)" candidate)
         (let ((file (match-string 1 candidate))
               (line (string-to-number (match-string 2 candidate))))
           (anything-c-rdefsx-mark-position)
           (find-file file)
           (anything-c-rdefsx-goto-line line)))))

(defun anything-c-rdefsx-insert-method (candidate)
  (when (string-match rdefsx-keyword-regexp candidate)
    (insert (match-string 1 candidate))))

(defun anything-c-rdefsx-init ()
  (when (and buffer-file-name (memq major-mode '(ruby-mode el4r-mode))
             (anything-current-buffer-is-modified))
    (call-process-shell-command
     (format "%s %s -nP %s"
             (shell-quote-argument rdefsx-ruby-command)
             (shell-quote-argument rdefsx-command)
             (buffer-local-value 'buffer-file-name anything-current-buffer))
     nil (anything-candidate-buffer 'local))))

(defun anything-c-rdefsx-file-init ()
  (with-current-buffer (anything-candidate-buffer 'global)
    (call-process-shell-command
     rdefsx-ruby-command nil '(t nil) nil
     rdefsx-command "-s" "-x" anything-buffer-file-name)))

(defun anything-c-rdefsx-find-definition-init ()
  (with-current-buffer (anything-candidate-buffer 'global)
    (call-process
     rdefsx-ruby-command nil '(t nil) nil
     rdefsx-command "-s" "-m" anything-c-rdefsx-find-definition-word anything-buffer-file-name)))

(define-minor-mode rdefsx-auto-update-mode
  :group 'ruby
  :global t
  (cond
   (rdefsx-auto-update-mode
    (add-hook 'after-save-hook 'rdefsx-after-save-hook)
    (when (called-interactively-p 'interactive)
      (message "rdefsx auto-update mode enabled")))
   (t
    (remove-hook 'after-save-hook 'rdefsx-after-save-hook)
    (when (called-interactively-p 'interactive)
      (message "rdefsx auto-update mode disabled")))))

(defun rdefsx-after-save-hook ()
  (when (derived-mode-p 'ruby-mode)
    (run-with-idle-timer 1 nil 'start-process "rdefsx-u" nil rdefsx-ruby-command rdefsx-command "-u")))

(define-key ruby-mode-map (kbd "M-.") 'anything-rdefsx-find-definition)
(when (fboundp 'back-button-global-backward)
  (define-key ruby-mode-map (kbd "M-,") 'back-button-global-backward))

(provide 'rdefsx)
