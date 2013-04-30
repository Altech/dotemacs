(load-file "~/.emacs.d/ProofGeneral-4.2/generic/proof-site.el")
(define-key coq-mode-map (kbd "C-l") (lambda ()
					   (interactive)
					   (recenter 0)))