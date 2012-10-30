This is my Emacs(Ver.23) configuration.

Entry point is init.el. It uses `init-loader-x` and loads elisp under inits directory. Everything else are third party library.

    git clone https://github.com/Altech/emacs-config.git ~/.emacs.d

Please byte-compile js2.el, if using JavaScript.

    emacs -batch -f batch-byte-compile ~/.emacs.d/js/js2.el
