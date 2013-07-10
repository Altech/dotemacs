(load-file "~/.emacs.d/ProofGeneral-4.2/generic/proof-site.el")


(defun turn-on-my-coq-settings ()
  (interactive)
  (iimage-mode t)
  (modi-permanently-mode t)
  (color-theme-my-xp)
  (blink-cursor-mode -1)
  (set-cursor-color "#8b4513") 
  (define-key coq-mode-map (kbd "\'") 'self-insert-command)
  (define-key coq-mode-map (kbd "M-l M-d") 'altech:git-gutter:popup-hunk)
  (define-key coq-mode-map (kbd "C-c C-s c") 'altech:rinkou-emp-region)
  (define-key coq-mode-map (kbd "C-c C-s u") 'altech:rinkou-und-region)
  (define-key coq-mode-map (kbd "C-;") 'altech:rinkou-und-region)
  (define-key coq-mode-map (kbd "C-'") 'altech:rinkou-emp-region)
  (define-key coq-mode-map (kbd "C-.") 'altech:rinkou-remove-modification)
  (define-key coq-mode-map (kbd "C-c C-s r") 'altech:rinkou-remove-modification)
  (define-key coq-mode-map (kbd "M-d") 'look-up-current-word-in-dictionary-app)
  (define-key coq-mode-map (kbd "C-l") (lambda ()
					(interactive)
					(recenter 0)))
  (define-key coq-mode-map (kbd "C-M-f") 'super-coq:proof-next)
  (define-key coq-mode-map (kbd "C-M-g") 'proof-assert-next-command-interactive)
  (define-key coq-mode-map (kbd "C-M-j") 'proof-undo-last-successful-command))


(defadvice proof-assert-next-command-interactive (after back-one-char)
  (goto-char (1- (point))))

;; ==============================
;; ** parser and pre-processor **
;; ==============================

(defun super-coq:parse-goals (s)
  (super-coq:bundle-premises
   (super-coq:cleansing
    (super-coq:merge-first-alist
     (mapcar
      (lambda (l) (cond
		   ((string-match "\\([0-9]+\\) subgoals, subgoal [0-9]+ (ID \\([0-9]+\\))" l) (cons 'current-subgoal (list (cons 'nsubgoals (match-string 1 l)) (cons 'id (match-string 2 l)))))
		   ((string-match "(ID \\([0-9]+\\))" l) (cons 'id (match-string 1 l)))
		   ((string-match "^  \\([^ ].*?\\) : \\(.+\\)" l) (cons 'premise (cons (match-string 1 l) (match-string 2 l))))
		   ((string-match "===============" l) 'induction-line)
		   ((string-match "^   \\(.+\\)" l) (cons 'maybe-goal (match-string 1 l)))
		   (t nil)))
      (split-string s "\n"))))))

(defun super-coq:get-colors-info-from-buffer ()
  (with-current-buffer (get-buffer "*goals*")
    (save-excursion
      (beginning-of-buffer)
      (let ((mapping '()))
	(while (re-search-forward "(ID \\([0-9]+\\)).*\\(  \\)$" nil t)
	  (let ((maybe-color-overlay
		 (super-coq:find
		  (lambda (o) (eq (overlay-get o 'category) 'coq-improver-color))
		  (overlays-in (match-beginning 2) (match-end 2)))))
	    (if maybe-color-overlay
		(add-to-list 'mapping
			     (cons
			      (buffer-substring-no-properties (match-beginning 1) (match-end 1))
			      (cadr (assoc :background (overlay-get maybe-color-overlay 'font-lock-face))))))))
	(reverse mapping)))))

(defun super-coq:merge-first-alist (ls)
  (if (and (consp ls) (listp (car ls)))
      (append (cdar ls) (cdr ls))
    ls))

(defun super-coq:cleansing (ls)
  (if (null ls)
      nil
    (let ((d (car ls)))
      (if (null d)
	  (super-coq:cleansing (cdr ls))
	(if (consp d)
	    (cons d (super-coq:cleansing (cdr ls)))
	  (if (eq d 'induction-line)
	      (cons (cons 'goal (cdadr ls)) (remove-if (lambda (e) (null e)) (cddr ls)))))))))

(defun super-coq:bundle-premises (ls)
  (if (null ls)
      nil
    (if (and (consp (car ls)) (eq (caar ls) 'premise))
	(let ((bundled (super-coq:bundle-premises-main ls)))
	  (cons (cons 'premises (super-coq:init bundled)) (super-coq:last bundled)))
      (cons (car ls) (super-coq:bundle-premises (cdr ls))))))

(defun super-coq:bundle-premises-main (ls)
  (if (and (not (null ls)) (consp (car ls)) (eq (caar ls) 'premise))
      (cons (cdar ls) (super-coq:bundle-premises-main (cdr ls)))
    (cons ls nil)))

(defun super-coq:ids (ls)
  (if (null ls)
      nil
    (if (consp (car ls))
	(if (eq 'id (caar ls))
	    (cons (cdar ls) (super-coq:ids (cdr ls)))
	  (super-coq:ids (cdr ls))))))

(defun super-coq:init (ls)
  (if (null (cddr ls))
      (cons (car ls) nil)
    (cons (car ls) (super-coq:init (cdr ls)))))

(defun super-coq:last (ls)
  (if (null (cdr ls))
      (car ls)
    (super-coq:last (cdr ls))))

(defun super-coq:find (p ls)
  (let ((removed (remove-if-not p ls)))
    (if (null removed)
	nil
      (car removed))))

(defun super-coq:zip (list1 list2)
  (cond
   ((null list1) nil)
   ((null list2) nil) 
   (t (cons (cons (car list1) (car list2)) (super-coq:zip (cdr list1) (cdr list2))))))

(defun super-coq:next-element-randomly (element list)
  (let ((removed-list (remove-if (lambda (e) (equal element e)) list)))
    (nth (random (length removed-list)) removed-list)))

;; ==================
;; ** main command **
;; ==================

(defun super-coq:proof-next ()
  (interactive)
  (let* ((before-color-info (super-coq:get-colors-info-from-buffer))
	 (before-goals (progn (super-coq:remove-info)
			      (super-coq:parse-goals (with-current-buffer (get-buffer "*goals*") (buffer-string))))))
    (proof-assert-next-command-interactive)
    (sleep-for 0.15)
    (let* ((after-goals (super-coq:parse-goals (with-current-buffer (get-buffer "*goals*") (buffer-string)))))
      (if (not (equal (cdr (assq 'nsubgoals before-goals)) (cdr (assq 'nsubgoals after-goals))))
	  (super-coq:display-before-nsubgoals)
	(let ((before-premises (cdr (assq 'premises before-goals)))
	      (after-premises  (cdr (assq 'premises after-goals))))
	  (mapc 'super-coq:display-new-or-rewrited-premise after-premises)
	  (mapc 'super-coq:display-deleted-premise before-premises))
	(let ((before-goal (cdr (assq 'goal before-goals)))
	      (after-goal  (cdr (assq 'goal after-goals))))
	  (super-coq:display-before-goal-if-changed)))
      (let ((before-ids (super-coq:ids before-goals)) (after-ids (super-coq:ids after-goals)))
	(super-coq:display-subgoals-color (cdr (super-coq:update-color-mapping before-color-info)))
	(super-coq:display-new-subgoals)))))

;; ==========================================
;; ** display routines (use dynamic scope) **
;; ==========================================

(defun super-coq:display-new-or-rewrited-premise (premise)
  (let ((before-premise (assoc (car premise) before-premises)))
    (if (not before-premise)
	(super-coq:add-faces-to-goals (concat "^ *\\(" (car premise) "\\) : \\(.+\\)")
	  (dolist (i '(1 2))
	    (overlay-put (make-overlay (match-beginning i) (match-end i)) 'face 'bold)))
      (if (not (equal (cdr premise) (cdr before-premise)))
	  (super-coq:add-faces-to-goals (concat "^ *\\(" (car premise) "\\) : \\(.+\\)")
	    (overlay-put (make-overlay (match-beginning 2) (match-end 2)) 'face 'underline)
	    (goto-char (match-end 2))
	    (super-coq:add-before-info (concat " (" (cdr before-premise)  ")")))))))

(defun super-coq:display-deleted-premise (premise)
		  (let ((after-premise (assoc (car premise) after-premises)))
		    (unless after-premise
		      (let ((rest (cdr (member premise (reverse before-premises)))))
			(if (consp rest)
			    (super-coq:add-faces-to-goals (concat "^  " (caar rest) " : .+$")
			      (goto-char (match-end 0))
			      (super-coq:add-before-info (concat "\n  " (car premise) " : " (cdr premise))))
			  ;; case : first premise
			  (goto-line 3)
			  (beginning-of-line)
			  (super-coq:add-before-info (concat "  " (car premise) " : " (cdr premise) "\n")))))))

(defun super-coq:display-before-goal-if-changed ()
  (if (not (equal before-goal after-goal))
      (super-coq:add-faces-to-goals "==============\n   \\(.+\\)"
	(goto-char (match-beginning 1))
	(super-coq:add-before-info (concat before-goal "\n-> ")))))

(defun super-coq:display-before-nsubgoals ()
  (super-coq:add-faces-to-goals "^\\([0-9]+\\)"
	    (overlay-put (make-overlay (match-beginning 1) (match-end 1)) 'face 'underline)
	    (super-coq:add-before-info (concat " (" (cdr (assq 'nsubgoals before-goals)) ")"))))

(defun super-coq:display-new-subgoals ()
  (mapc (lambda (id)
	  (unless (member id before-ids)
	    (super-coq:add-faces-to-goals (concat "subgoal [0-9]+ (ID " id ").*$")
	      (overlay-put (make-overlay (match-beginning 0) (match-end 0)) 'font-lock-face 'bold))))
	after-ids))

(defun super-coq:display-subgoals-color (map)
  (mapc
   (lambda (pair)
     (let ((id (car pair)) (color (cdr pair)))
       (super-coq:add-faces-to-goals (concat "(ID \\(" id "\\)).*$")
	 (goto-char (match-end 0))
	 (insert "  ") ;; color box
	 (let ((o (make-overlay (match-end 0) (+ (match-end 0) 2))))
	   (overlay-put o 'category 'coq-improver-color)
	   (overlay-put o 'font-lock-face (list '(:box "gray")
						'(:foreground "black")
						`(:background ,color)))))))
   map))

(defun super-coq:update-color-mapping (before-mapping)
  (let ((current-color (if before-mapping (cdar before-mapping) (car super-coq:subgoal-color-list))))
    (reverse
     (mapcar
      (lambda (id)
	(let ((pair (assoc id before-mapping)))
	  (if pair
	      (progn
		(setq current-color (cdr pair))
		pair)
	    (progn
	      (let ((next-color (super-coq:next-element-randomly current-color super-coq:subgoal-color-list)))
		(setq current-color next-color)
		(cons id next-color))))))
      (reverse after-ids)))))

;; ==========================
;; ** modificatin routines **
;; ==========================

(defvar super-coq:subgoal-color-list '("red" "blue" "green" "yellow" "purple" "sienna4" "cyan"))

(defun super-coq:add-before-info (info)
  (let* ((s (concat ">>>" info "<<<")) (p1 (point)) (p2 (+ p1 (length s))))
    (insert s)
    (overlay-put (make-overlay p1 p2) 'face '(:foreground "gray49"))
    (save-restriction
      (narrow-to-region p1 p2)
      (beginning-of-buffer)
      (while (re-search-forward "\\(>>>\\)\\(.\\|\n\\)+?\\(<<<\\)" nil t)
	(let ((o1 (make-overlay (match-beginning 1) (match-end 1))) (o3 (make-overlay (match-beginning 3) (match-end 3))))
	  (dolist (i '(1 3))
	    (let ((o (make-overlay (match-beginning i) (match-end i))))
	      (overlay-put o 'category 'coq-improver)
	      (overlay-put o 'invisible t))))))))

(defun super-coq:remove-info ()
  (with-current-buffer (get-buffer "*goals*")
    (setq buffer-read-only nil)
    (let ((s (point-min)) (e (point-max)))
      (save-restriction
	(narrow-to-region s e)
	(remove-overlays s e 'category 'coq-improver)
	(remove-overlays s e 'category 'coq-improver-color)
	(beginning-of-buffer)
	(while (re-search-forward ">>>\\(.\\|\n\\)+?<<<" nil t)
	  (replace-match ""))))
    (setq buffer-read-only t)))

(defmacro super-coq:add-faces-to-goals (regexp &rest body)
  (declare (indent 1))
  `(with-current-buffer (get-buffer "*goals*")
     (setq buffer-read-only nil)
     (save-excursion
       (beginning-of-buffer)
       (while (re-search-forward ,regexp nil t)
	 ,@body))
     (setq buffer-read-only t)))

;; (super-coq:remove-info)
;; (defvar sample-goals (with-current-buffer (get-buffer "*goals*") (buffer-string)))
;; (super-coq:parse-goals sample-goals) ; => 

;; [TODO]
;; - deal multi-line goal rightly (line:985).
