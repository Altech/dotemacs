(deftheme bear-style
  "Writing color theme")

(custom-theme-set-faces
 'bear-style
 ;; 背景・文字・カーソル
 '(cursor ((t (:background "#f85575" :foreground "#f85575"))))
 '(default ((t (:background "#fbfbfb" :foreground "#545454"))))

 ;; 選択範囲
 '(region ((t (:background "#b5d9fc"))))

 ;; ハイライト
 '(highlight ((t (:foreground "#000000" :background "#C4BE89"))))
 '(hl-line ((t (:background "#293739"))))

 ;; 関数名(見出し)
 '(font-lock-function-name-face ((t (:foreground "#333333"))))

 ;; 変数名・変数の内容
 '(font-lock-variable-name-face ((t (:foreground "#FFFFFF"))))
 '(font-lock-string-face ((t (:foreground "#999999"))))

 ;; 括弧
 '(show-paren-match-face ((t (:foreground "#1B1D1E" :background "#FD971F"))))
 '(paren-face ((t (:foreground "#A6E22A" :background nil))))
 
 ;; 特定キーワード
 '(font-lock-keyword-face ((t (:foreground "#F92672"))))

 ;; Boolean
 '(font-lock-constant-face((t (:foreground "#AE81BC"))))
)

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'bear-style)
(provide 'bear-style)
