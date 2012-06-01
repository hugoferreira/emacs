; Generic flymake stuff
(require 'flymake)
(add-hook 'find-file-hook 'flymake-find-file-hook)
(setq flymake-log-level 3)

; Disable flymake for java and malabar
(add-hook 'java-mode-hook 'flymake-mode-off)
(add-hook 'malabar-mode-hook 'flymake-mode-off)

; Only do checks after save
(eval-after-load "flymake"
  '(progn
     (defun flymake-after-change-function (start stop len)
       "Start syntax check for current buffer if it isn't already running."
       ;; Do nothing, don't want to run checks until I save.
       )))

; C/C++ stuff for flymake
(defun search-makefile ()
  (if (file-exists-p "Makefile")
      t
    (if (string= (shell-command "pwd") "/")
        nil
      (progn (cd "../")
             (search-makefile)))))

(defun flymake-cc-init ()
  (if (search-makefile)
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))
             (local-file (file-relative-name
                          temp-file
                          (file-name-directory buffer-file-name))))
        (list "make" (list "-s"
                           (format "-C%s" default-directory)
                           (format "CHK_SOURCES=%s" temp-file)
                           "SYNTAX_CHECK_MODE=1"
                           "check-syntax")))))

(add-hook 'c++-mode-hook
          (lambda ()
            (push '("\\.cpp$" flymake-cc-init) flymake-allowed-file-name-masks)
            (push '("\\.h$" flymake-cc-init) flymake-allowed-file-name-masks)
            (if (and (not (null buffer-file-name))
                     (file-writable-p buffer-file-name))
                (flymake-mode t))))

; Java/Eclim stuff for flymake
(defvar flymake-eclipse-batch-compiler-path
  "/Applications/eclipse/plugins/org.eclipse.jdt.core_3.7.3.v20120119-1537.jar")

;; TODO fix hardcoded 1.6
(defvar flymake-java-version "1.6")

(defun flymake-java-ecj-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-ecj-create-temp-file))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "java" (list "-jar" flymake-eclipse-batch-compiler-path "-Xemacs" "-d" "none"
                       "-warn:+over-ann,uselessTypeCheck";;,allJavadoc"
                       "-source" flymake-java-version "-target" flymake-java-version "-proceedOnError"
                       "-classpath" (eclim/project-classpath)
                       ;; "-log" "c:/temp/foo.xml"
                       local-file))))

(defun flymake-java-ecj-cleanup ()
  "Cleanup after `flymake-java-ecj-init' -- delete temp file and dirs."
  (flymake-safe-delete-file flymake-temp-source-file-name)
  (when flymake-temp-source-file-name
    (flymake-safe-delete-directory (file-name-directory flymake-temp-source-file-name))))

(defun flymake-ecj-create-temp-file (file-name prefix)
  "Create the file FILE-NAME in a unique directory in the temp directory."
  (file-truename (expand-file-name (file-name-nondirectory file-name)
                                   (expand-file-name  (int-to-string (abs (random))) (flymake-get-temp-dir)))))

(push '(".+\\.java$" flymake-java-ecj-init flymake-java-ecj-cleanup) flymake-allowed-file-name-masks)

(provide 'flymake-eclim-java)
