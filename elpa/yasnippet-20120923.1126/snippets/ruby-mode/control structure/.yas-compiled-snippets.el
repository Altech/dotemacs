;;; Compiled snippets and support files for `ruby-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'ruby-mode
		     '(("forin" "for ${1:element} in ${2:collection}\n  $0\nend" "for ... in ...; ... end" nil
			("control structure")
			nil nil nil nil)
		       ("if" "if ${1:condition}\n  $0\nend" "if ... end" nil
			("control structure")
			nil nil nil nil)
		       ("ife" "if ${1:condition}\n  $2\nelse\n  $3\nend" "if ... else ... end" nil
			("control structure")
			nil nil nil nil)
		       ("tim" "times { |${n}| $0 }" "times { |n| ... }" nil
			("control structure")
			nil nil nil nil)
		       ("until" "until ${condition}\n  $0\nend" "until ... end" nil
			("control structure")
			nil nil nil nil)
		       ("upt" "upto(${n}) { |${i}|\n  $0\n}" "upto(...) { |n| ... }" nil
			("control structure")
			nil nil nil nil)
		       ("when" "when ${condition}\n  $0\nend" "when ... end" nil
			("control structure")
			nil nil nil nil)
		       ("while" "while ${condition}\n  $0\nend" "while ... end" nil
			("control structure")
			nil nil nil nil)))


;;; Do not edit! File generated at Thu Oct 11 13:21:56 2012
