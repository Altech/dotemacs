;;; Compiled snippets and support files for `ruby-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'ruby-mode
		     '(("Comp" "include Comparable\n\ndef <=> other\n  $0\nend" "include Comparable; def <=> ... end" nil
			("definitions")
			nil nil nil nil)
		       ("am" "alias_method :${new_name}, :${old_name}" "alias_method new, old" nil
			("definitions")
			nil nil nil nil)
		       ("cla" "class << ${self}\n  $0\nend" "class << self ... end" nil
			("definitions")
			nil nil nil nil)
		       ("cls" "class ${1:`(let ((fn (capitalize (file-name-nondirectory\n                                 (file-name-sans-extension\n				 (or (buffer-file-name)\n				     (buffer-name (current-buffer))))))))\n           (cond\n             ((string-match \"_\" fn) (replace-match \"\" nil nil fn))\n              (t fn)))`}\n  $0\nend" "class ... end" nil
			("definitions")
			nil nil nil nil)
		       ("mm" "def method_missing(method, *args)\n  $0\nend" "def method_missing ... end" nil
			("definitions")
			nil nil nil nil)
		       ("mod" "module ${1:`(let ((fn (capitalize (file-name-nondirectory\n                                 (file-name-sans-extension\n         (or (buffer-file-name)\n             (buffer-name (current-buffer))))))))\n           (cond\n             ((string-match \"_\" fn) (replace-match \"\" nil nil fn))\n              (t fn)))`}\n  $0\nend" "module ... end" nil
			("definitions")
			nil nil nil nil)
		       ("r" "attr_reader :" "attr_reader ..." nil
			("definitions")
			nil nil nil nil)
		       ("rw" "attr_accessor :" "attr_accessor ..." nil
			("definitions")
			nil nil nil nil)
		       ("w" "attr_writer :" "attr_writer ..." nil
			("definitions")
			nil nil nil nil)))


;;; Do not edit! File generated at Thu Oct 11 13:21:56 2012
