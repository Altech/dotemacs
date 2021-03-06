(require-package 'helm)
(require-package 'magit)
(add-to-list 'load-path "~/.emacs.d/lisp/magit")
(require 'magit)
(require-package 'git-gutter)
;; (require-package 'dropdown-list)
(require-package 'highlight-symbol)
(require-package 'popwin)
(require-package 'auto-complete)
(require-package 'helm-open-github)

;; anything
(setq migemo-isearch-min-length 2)
;; ;; helm
;; (require 'helm-config)
;; popwin
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
(dolist (buffer-name '("*Help*"
                       "*quickrun*"
                       "*compilation*"
                       "*buffer-selection*"
                       "*git-gutter:diff*"
                       "* Oz Compiler*"
                       "*refe:ACL*"))
  (add-to-list 'popwin:special-display-config (list buffer-name)))
(push '("\*refe" :regexp t :position top) popwin:special-display-config) ;; [TODO]
;; git
(require 'magit)
(setq magit-push-always-verify nil)
(setq git-commit-summary-max-length 100)
(require 'git-gutter)
(global-git-gutter-mode 1)
(setq git-gutter:verbosity 0)
(setq magit-push-always-verify 1)

;; github
(require 'helm-open-github)

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
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive (list (read-string "new file name: "
                                  (file-name-nondirectory buffer-file-name)
                                  nil
                                  (file-name-nondirectory buffer-file-name)
                                  (file-name-nondirectory buffer-file-name))))
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

;; dash
(require-package 'dash-at-point)

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

(defun altech:magit-push-current-branch ()
  "git push <current buranch> origin <upstream>"
  (interactive)
  (if (string= (magit-get-current-branch) "master")
      (message "Don't push master to upstream!")
    (call-interactively 'magit-push-current-to-upstream)))

(defun altech:magit-pull-current-branch ()
  "git push <current buranch> origin <upstream>"
  (interactive)
  (magit-pull-current "origin" (magit-get-current-branch)))

(defun altech:magit-checkout-master ()
  "git checkout master"
  (interactive)
  (magit-checkout "master"))

;; mark of column width
(require 'column-marker)
(if (eq window-system 'x) (progn
  (defface my-face-folding '((t (:background "#444444"))) nil)
  (defvar my-face-folding 'my-face-folding)
) (progn
  (defface my-face-folding '((t (:background "#dddddd"))) nil)
  (defvar my-face-folding 'my-face-folding)
))
(column-marker-create column-marker-9 my-face-folding)
(add-hook 'enh-ruby-mode-hook (lambda () (interactive) (column-marker-9 80)))
