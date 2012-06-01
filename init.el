; CL package is often required at runtime.
(require 'cl)

; This might be necessary
(setq exec-path (append exec-path (list "/usr/bin" "/usr/local/bin" "~/.emacs.d/bin")))

; Marmalade package manager
(require 'package)
(add-to-list 'package-archives
             '("elpa" . "http://tromey.com/elpa/"))
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

; handy function to load all elisp files in a directory
(load-file "~/.emacs.d/load-directory.el")

; Add directories to the load path.
(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/customizations")
(add-to-list 'load-path "~/.emacs.d/vendor")
(add-to-list 'load-path "~/.emacs.d/vendor/ensime/elisp")
(add-to-list 'load-path "~/.emacs.d/vendor/scala")

; Get required packages
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages '(color-theme org magit flymake xml-rpc org2blog)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

; Load custom plugins
(mapcar 'load-directory '("~/.emacs.d/vendor"))

; load personal customizations (keybindings, colors, etc.)
(mapcar 'load-directory '("~/.emacs.d/customizations"))

; theme
(load-file "~/.emacs.d/vendor/almost-monokai/color-theme-almost-monokai.el")
(color-theme-almost-monokai)

(set-face-attribute 'default nil
		:family "Menlo" :height 140 :weight 'normal)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(initial-buffer-choice t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
