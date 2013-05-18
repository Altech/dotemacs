(defun altech:rinkou ()
  (interactive)
  ;; >><<で囲まれた部分を強調
  (altech:rinkou-emp-buffer)
  ;; `C-;`で下線
  (define-key (current-local-map) (kbd "C-;") 'altech:underline-region)
  ;; `C-'`で強調
  (define-key (current-local-map) (kbd "C-'") 'altech:bold-region))

(defun altech:rinkou-emp-buffer ()
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (while (re-search-forward "[^>]\\(>>\\) *\\(.+?\\) *\\(<<\\)" nil t)
      (remove-overlays (match-beginning 0) (match-end 0) 'category 'rinkou)
      (let ((o (make-overlay (match-beginning 1) (match-end 1))))
	(overlay-put o 'category 'rinkou)
	(overlay-put o 'invisible t))
      (let ((o (make-overlay (match-beginning 3) (match-end 3))))
	(overlay-put o 'category 'rinkou)
	(overlay-put o 'invisible t))
      (let ((o (make-overlay (match-beginning 2) (match-end 2))))
	(overlay-put o 'category 'rinkou)
	(overlay-put o 'invisible nil)
	(overlay-put o 'face 'bold))))
  (save-excursion
    (beginning-of-buffer)
    (while (re-search-forward "[^>]\\(>>>\\) *\\(.+?\\) *\\(<<<\\)" nil t)
      (remove-overlays (match-beginning 0) (match-end 0) 'category 'rinkou)
      (let ((o (make-overlay (match-beginning 1) (match-end 1))))
	(overlay-put o 'category 'rinkou)
	(overlay-put o 'invisible t))
      (let ((o (make-overlay (match-beginning 3) (match-end 3))))
	(overlay-put o 'category 'rinkou)
	(overlay-put o 'invisible t))
      (let ((o (make-overlay (match-beginning 2) (match-end 2))))
	(overlay-put o 'category 'rinkou)
	(overlay-put o 'invisible nil)
	(overlay-put o 'face 'underline)))))

(defun altech:rinkou-remove-modification (s e)
  (interactive "r")
  (if (use-region-p)
      (progn
	(save-restriction
	  (narrow-to-region s e)
	  (beginning-of-buffer)
	  (while (re-search-forward "\\(>>>\\)\\(.+?\\)\\(<<<\\)" nil t)
	    (remove-overlays (match-beginning 0) (match-end 0) 'category 'rinkou)
	    (princ (buffer-substring (match-beginning 2) (match-end 2)))
	    (replace-match (buffer-substring (match-beginning 2) (match-end 2))))
	  (while (re-search-forward "\\(>>\\)\\(.+?\\)\\(<<\\)" nil t)
	    (remove-overlays (match-beginning 0) (match-end 0) 'category 'rinkou)
	    (princ (buffer-substring (match-beginning 2) (match-end 2)))
	    (replace-match (buffer-substring (match-beginning 2) (match-end 2))))
	  ))))

(defun altech:rinkou-emp-region ()
  (interactive)
  (let ((modified-p (buffer-modified-p)))
    (altech:wrap-or-insert ">>" "<<")
    (save-restriction
      (narrow-to-region (point-at-bol) (point-at-eol))
      (altech:rinkou-emp-buffer))
    (unless modified-p
      (message "save!")
      (save-buffer))))

(defun altech:rinkou-und-region ()
  (interactive)
  (let ((modified-p (buffer-modified-p)))
    (altech:wrap-or-insert ">>>" "<<<")
    (save-restriction
      (narrow-to-region (point-at-bol) (point-at-eol))
      (altech:rinkou-emp-buffer))
    (unless modified-p
      (save-buffer))))

(defun altech:wrap-or-insert (s1 s2)
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

(defun altech:underline-region (s e)
  (interactive "r")
  (if (use-region-p)
      (let ((o (make-overlay s e)))
	(overlay-put o 'category 'modification)
	(overlay-put o 'face 'underline)
	(keyboard-quit)
	(message "\n"))))

(defun altech:bold-region (s e)
  (interactive "r")
  (if (use-region-p)
      (let ((o (make-overlay s e)))
	(overlay-put o 'category 'modification)
	(overlay-put o 'face 'bold)
	(keyboard-quit)
	(message "\n"))))
