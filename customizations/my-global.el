; Increase the working space
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

; Use global-hl-line-mode
(global-hl-line-mode 1)

; Some generic configurations
(setq default-buffer-file-coding-system 'utf-8)
(setq-default indent-tabs-mode nil)
(show-paren-mode 1)
(setq column-number-mode t)
(setq-default c-indent-level 4)
(setq-default tab-width 4)
(delete-selection-mode 1)
(setq x-select-enable-clipboard t)
