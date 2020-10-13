;;; ~/.doom.d/+editor.el -*- lexical-binding: t; -*-

;;It’s nice to see ANSI colour codes displayed
(after! text-mode
  (add-hook! 'text-mode-hook
             ;; Apply ANSI color codes
             (with-silent-modifications
               (ansi-color-apply-on-region (point-min) (point-max)))))
