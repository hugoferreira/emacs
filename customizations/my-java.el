; Indentation stuff
(add-hook 'java-mode-hook
          '(lambda ()
             (setq indent-tabs-mode nil)
             (setq c-basic-offset 4)
             (c-set-offset 'substatement-open 0)
             (c-set-offset 'topmost-intro-cont 0)
             (c-set-offset 'substatement-open 0)
             (c-set-offset 'case-label 4)))
