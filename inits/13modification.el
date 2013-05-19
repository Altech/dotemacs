(define-minor-mode modi-temporary-mode
  "presentation mode of modi."
  nil
  " modi:temporary"
  (list
   (cons (kbd "C-;") 'modi:underline-region-temporary)
   (cons (kbd "C-'") 'modi:bold-region-temporary)
   (cons (kbd "C-.") 'modi:remove-decorations-of-region))
  (modi:visualize-decorations-of-buffer))

(define-minor-mode modi-permanently-mode
  "presentation mode of modi."
  nil
  " modi:permanently"
  (list
   (cons (kbd "C-;") 'modi:underline-region-permanently)
   (cons (kbd "C-'") 'modi:bold-region-permanently)
   (cons (kbd "C-.") 'modi:remove-decorations-of-region))
  (modi:visualize-decorations-of-buffer))

(defun modi:visualize-decorations-of-buffer ()
  (interactive)
  (flet ((add-face (face-value)
		   (remove-overlays (match-beginning 0) (match-end 0) 'category 'modification)
		   (let ((o (make-overlay (match-beginning 1) (match-end 1))))
		     (overlay-put o 'category 'modification)
		     (overlay-put o 'invisible t))
		   (let ((o (make-overlay (match-beginning 3) (match-end 3))))
		     (overlay-put o 'category 'modification)
		     (overlay-put o 'invisible t))
		   (let ((o (make-overlay (match-beginning 2) (match-end 2))))
		     (overlay-put o 'category 'modification)
		     (overlay-put o 'invisible nil)
		     (overlay-put o 'face face-value))))
    (save-excursion
      (beginning-of-buffer)
      (while (re-search-forward "\\(=>-\\)\\(.+?\\)\\(-<=\\)" nil t)
	(add-face 'bold)))
    (save-excursion
      (beginning-of-buffer)
      (while (re-search-forward "\\(>>>\\)\\(.+?\\)\\(<<<\\)" nil t)
	(add-face 'underline)))))

(defun modi:remove-decorations-of-region (s e)
  (interactive "r")
  (if (use-region-p)
      (progn
	(save-restriction
	  (narrow-to-region s e)
	  (remove-overlays s e 'category 'modification)
	  (beginning-of-buffer)
	  (while (re-search-forward "\\(=>-\\)\\(.+?\\)\\(-<=\\)" nil t)
	    (replace-match (buffer-substring (match-beginning 2) (match-end 2))))
	  (beginning-of-buffer)
	  (while (re-search-forward "\\(>>>\\)\\(.+?\\)\\(<<<\\)" nil t)
	    (replace-match (buffer-substring (match-beginning 2) (match-end 2))))))))

(defun modi:bold-region-permanently ()
  (interactive)
  (let ((modified-p (buffer-modified-p)))
    (modi:wrap-or-insert "=>-" "-<=")
    (save-restriction
      (narrow-to-region (point-at-bol) (point-at-eol))
      (modi:visualize-decorations-of-buffer))
    (unless modified-p
      (save-buffer))))

(defun modi:underline-region-permanently ()
  (interactive)
  (let ((modified-p (buffer-modified-p)))
    (modi:wrap-or-insert ">>>" "<<<")
    (save-restriction
      (narrow-to-region (point-at-bol) (point-at-eol))
      (modi:visualize-decorations-of-buffer))
    (unless modified-p
      (save-buffer))))

(defun modi:underline-region-temporary (s e)
  (interactive "r")
  (if (use-region-p)
      (let ((o (make-overlay s e)))
	(overlay-put o 'category 'modification)
	(overlay-put o 'face 'underline)
	(keyboard-quit)
	(message "\n"))))

(defun modi:bold-region-temporary (s e)
  (interactive "r")
  (if (use-region-p)
      (let ((o (make-overlay s e)))
	(overlay-put o 'category 'modification)
	(overlay-put o 'face 'bold)
	(keyboard-quit)
	(message "\n"))))

(defun modi:wrap-or-insert (s1 s2)
 "Insert the strings S1 and S2.
If Transient Mark mode is on and a region is active, wrap the strings S1
and S2 around the region."
 (if (and transient-mark-mode mark-active)
     (let ((a (region-beginning)) (b (region-end)))
       (goto-char a)
       (insert s1)
       (goto-char (+ b (length s1)))
       (insert s2))
   (insert s1 s2)))
