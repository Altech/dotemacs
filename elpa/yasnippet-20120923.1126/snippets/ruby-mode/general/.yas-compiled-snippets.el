;;; Compiled snippets and support files for `ruby-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'ruby-mode
		     '(("#" "# => " "# =>" nil
			("general")
			nil nil nil nil)
		       ("=b" "=begin rdoc\n  $0\n=end" "=begin rdoc ... =end" nil
			("general")
			nil nil nil nil)
		       ("app" "if __FILE__ == $PROGRAM_NAME\n  $0\nend" "if __FILE__ == $PROGRAM_NAME ... end" nil
			("general")
			nil nil nil nil)
		       ("bm" "Benchmark.bmbm(${1:10}) do |x|\n  $0\nend" "Benchmark.bmbm(...) do ... end" nil
			("general")
			nil nil nil nil)
		       ("case" "case ${1:object}\nwhen ${2:condition}\n  $0\nend" "case ... end" nil
			("general")
			nil nil nil nil)
		       ("dee" "Marshal.load(Marshal.dump($0))" "deep_copy(...)" nil
			("general")
			nil nil nil nil)
		       ("rb" "#!/usr/bin/ruby -wKU" "/usr/bin/ruby -wKU" nil
			("general")
			nil nil nil nil)
		       ("req" "require \"$0\"" "require \"...\"" nil
			("general")
			nil nil nil nil)
		       ("rreq" "require File.join(File.dirname(__FILE__), $0)" "require File.join(File.dirname(__FILE__), ...)" nil
			("general")
			nil nil nil nil)
		       ("y" ":yields: $0" ":yields: arguments (rdoc)" nil
			("general")
			nil nil nil nil)))


;;; Do not edit! File generated at Thu Oct 11 13:21:56 2012
