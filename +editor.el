;;; ~/.doom.d/+editor.el -*- lexical-binding: t; -*-

;;It’s nice to see ANSI colour codes displayed
(after! text-mode
  (add-hook! 'text-mode-hook
             ;; Apply ANSI color codes
             (with-silent-modifications
               (ansi-color-apply-on-region (point-min) (point-max)))))

;; word-wrap
;; disable global word-wrap in emacs-lisp-mode
(add-to-list '+word-wrap-disabled-modes 'emacs-lisp-mode)
(add-to-list '+word-wrap-disabled-modes 'clojure-mode)

(modify-coding-system-alist 'file "" 'utf-8-unix)

;; yasnipeet enabel nested snippets
;;(setq yas-triggers-in-field t)
