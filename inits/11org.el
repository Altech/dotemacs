(add-to-list 'load-path  "~/.emacs.d/org-mode/lisp")
(setq load-path (cons "~/.emacs.d/org-mode/lisp" load-path))
(require 'org)
(defun org-insert-upheading (arg)
  "1レベル上の見出しを入力する。"
  (interactive "P")
  (org-insert-heading arg)
  (cond ((org-on-heading-p) (org-do-promote))
        ((org-at-item-p) (org-outdent-item))))
(defun org-insert-heading-dwim (arg)
  "現在と同じレベルの見出しを入力する。
C-uをつけると1レベル上、C-u C-uをつけると1レベル下の見出しを入力する。"
  (interactive "p")
  (case arg
    (4 (org-insert-subheading nil))
    (16 (org-insert-upheading nil))
    (t (org-insert-heading nil))))
(define-key org-mode-map (kbd "<C-return>") 'org-insert-heading-dwim)
(add-hook 'org-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-j") 'backward-char)))

;;; 言語は日本語
(setq org-export-default-language "ja")
;;; 文字コードはUTF-8
(setq org-export-html-coding-system 'utf-8)
;;; 行頭の:は使わない BEGIN_EXAMPLE ～ END_EXAMPLE で十分
(setq org-export-with-fixed-width nil)
;;; ^と_を解釈しない
(setq org-export-with-sub-superscripts nil)
;;; --や---をそのまま出力する
(setq org-export-with-special-strings nil)

;; (require 'org-install)
;; (setq org-startup-truncated nil)
;; (setq org-return-follows-link t)
;; (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; (org-remember-insinuate)
;; (setq org-directory "~/Notes/")
;; (setq org-default-notes-file (concat org-directory "何でもリスト.org"))
;; (setq org-remember-templates
;;       '(("Todo" ?t "** TODO %?\n   %i\n   %a\n   %t" nil "Inbox")
;;         ("Bug" ?b "** TODO %?   :bug:\n   %i\n   %a\n   %t" nil "Inbox")
;;         ("Idea" ?i "** %?\n   %i\n   %a\n   %t" nil "New Ideas")
;;         ))


(defun org-open-help ()
  (interactive)
  (shell-command "open http://www.geocities.jp/km_pp1/org-mode/org-mode-document.html"))
(define-key org-mode-map (kbd "C-c C-h") 'org-open-help)

;; Latex
(require 'org-compat)
(require 'org-list)
(require 'org-latex)
(add-to-list 'org-export-latex-classes
  '("jreport"
    "\\documentclass[a4j]{jreport}"
    ("\\chapter{%s}" . "\\chapter*{%s}")
    ("\\section{%s}" . "\\section*{%s}")
    ("\\subsection{%s}" . "\\subsection*{%s}")
    ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
    ("\\paragraph{%s}" . "\\paragraph*{%s}")
    ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
))
;; (setq org-export-with-TeX-macros nil)
;; (setq org-export-with-LaTeX-fragments nil)

(setq org-export-latex-packages-alist nil); => nil

;; export PDF with convert.rb
(add-to-list 'popwin:special-display-config '("*eshell*"))
(define-key org-mode-map (kbd "C-c c")
  (lambda ()
    (interactive)
    (eshell)
    (insert "./convert.rb")
    (eshell-send-input)))
