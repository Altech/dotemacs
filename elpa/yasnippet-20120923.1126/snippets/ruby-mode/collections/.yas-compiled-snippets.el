;;; Compiled snippets and support files for `ruby-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'ruby-mode
		     '(("all" "all? { |${e}| $0 }" "all? { |...| ... }" nil
			("collections")
			nil nil nil nil)
		       ("any" "any? { |${e}| $0 }" "any? { |...| ... }" nil
			("collections")
			nil nil nil nil)
		       ("classify" "classify { |${e}| $0 }" "classify { |...| ... }" nil
			("collections")
			nil nil nil nil)
		       ("collect" "collect { |${e}| $0 }" "collect { |...| ... }" nil
			("collections")
			nil nil nil nil)
		       ("deli" "delete_if { |${e} $0 }" "delete_if { |...| ... }" nil
			("collections")
			nil nil nil nil)
		       ("det" "detect { |${e}| $0 }" "detect { |...| ... }" nil
			("collections")
			nil nil nil nil)
		       ("ea" "each { |${e}| $0 }" "each { |...| ... }" nil
			("collections")
			nil nil nil nil)
		       ("eac" "each_cons(${1:2}) { |${group}| $0 }" "each_cons(...) { |...| ... }" nil
			("collections")
			nil nil nil nil)
		       ("eai" "each_index { |${i}| $0 }" "each_index { |i| ... }" nil
			("collections")
			nil nil nil nil)
		       ("eav" "each_value { |${val}| $0 }" "each_value { |val| ... }" nil
			("collections")
			nil nil nil nil)
		       ("eawi" "each_with_index { |${e}, ${i}| $0 }" "each_with_index { |e, i| ... }" nil
			("collections")
			nil nil nil nil)
		       ("inject" "inject(${1:0}) { |${2:injection}, ${3:element}| $0 }" "inject(...) { |...| ... }" nil
			("collections")
			nil nil nil nil)
		       ("reject" "reject { |${1:element}| $0 }" "reject { |...| ... }" nil
			("collections")
			nil nil nil nil)
		       ("select" "select { |${1:element}| $0 }" "select { |...| ... }" nil
			("collections")
			nil nil nil nil)
		       ("collectionszip" "zip(${enums}) { |${row}| $0 }" "zip(...) { |...| ... }" nil
			("collections")
			nil nil nil nil)))


;;; Do not edit! File generated at Thu Oct 11 13:21:56 2012
