(global-whitespace-mode t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
