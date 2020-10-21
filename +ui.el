;;; ~/.doom.d/+ui.el -*- lexical-binding: t; -*-

;; Modeline config
(setq doom-modeline-icon t
      doom-modeline-major-mode-icon t
      doom-modeline-minor-modes nil
      doom-modeline-enable-word-count t
      doom-modeline-checker-simple-format t
      doom-modeline-persp-name t
      doom-modeline-persp-name-icon t
      doom-modeline-lsp t)

;; Show trailing white spaces
(setq show-trailing-whitespace t)

;; Disable trailing whitespaces in the minibuffer
(add-hook! '(minibuffer-setup-hook doom-popup-mode-hook)
  (setq-local show-trailing-whitespace nil))
