(defun replace-logic-symbol (s e)
  (interactive "r")
  (if (use-region-p)
      (save-restriction 
	(narrow-to-region s e)
	(dolist (ls (list (cons "&&" "∧") (cons "||" "∨") (cons "!" "¬") (cons "->" "→")))
	      (goto-char (point-min))
	      (replace-string (car ls) (cdr ls))))))

(require 'es6-mode)
