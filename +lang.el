;; lsp-ui-sideline is redundant with eldoc and much more invasive
;; (setq lsp-ui-sideline-enable nil
;;       lsp-enable-symbol-highlighting nil)

(setq ispell-dictionary "en")
(setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     "))

;; (defun cider-eval-n-defuns (n)
;;   "Evaluate N top-level forms, starting with the current one."
;;   (interactive "P")
;;   (cider-eval-region (car (bounds-of-thing-at-point 'defun))
;;                      (save-excursion
;;                        (dotimes (i (or n 2))
;;                          (end-of-defun))
;;                        (point))))

(use-package! clojure-mode
  :mode ("\\.edn\\'" . clojure-mode)
;;  :bind ("C-c C-a" . cider-eval-n-defuns)
  :config
  (require 'flycheck-clj-kondo))


(after! tramp
  (setenv "SHELL" "/bin/bash")
  ;(setq tramp-shell-prompt-pattern "\\(?:^\\|\\)[^]#$%>\n]*#?[]#$%>] *\\(�\\[[0-9;]*[a-zA-Z] *\\)*")
  ) ;; default + 

;; Nested snippets are good, enable that.
;(setq yas-triggers-in-field t)
