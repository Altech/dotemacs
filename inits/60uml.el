(require-package 'plantuml-mode)
(require 'plantuml-mode)

(setq plantuml-jar-path (expand-file-name "~/.emacs.d/bin/plantuml.jar"))
(setq plantuml-output-type "png")
(add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))
