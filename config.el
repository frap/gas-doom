
;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(if IS-MAC
  (setq
    user-full-name "Andrés Gasson"
    user-mail-address "agasson@red-elvis.net"
    github-account-name "frap")
  (setq
    user-full-name "atearoot"
    user-mail-address "support@ateasystems.com"))


(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 window-combination-resize t                      ; take new window space from all other windows (not just current)
 x-stretch-cursor t)                              ; Stretch cursor to the glyph width

(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      truncate-string-ellipsis "…")               ; Unicode ellispis are nicer than "...", and also save /precious/ space

(display-time-mode 1)                             ; Enable time in the mode-line
;(setq display-time-day-and-date t)                ;
(unless (equal "Battery status not available"
               (battery))
  (display-battery-mode 1))                       ; On laptops it's nice to know how much power you have
(global-subword-mode 1)                           ; Iterate through CamelCase words

(setq default-directory "~")

;; Global settings
;(setq! show-paren-mode 1
;       doom-scratch-initial-major-mode t)

;; default is in .emacs.d and can be deleted -- used for gpg
(setq!
  auth-sources '("~/.authinfo.gpg")
  auth-source-cache-expiry nil) ; default is 7200 (2h)


(setq display-line-numbers-type 'relative)

;; I’d like some slightly nicer default buffer names
;;(setq doom-fallback-buffer-name "► Doom"
;;      +doom-dashboard-name "► Doom")

;; Load Personalised bindings
;;(load! "+bindings")
;(load! "+functions")
;; Theme related things
(load! "+themes")
;;gas org customisations
(load! "+org")
(load! "+lang")
;; Configuration of DOOM ui
;;(load! "+ui")
;; Editor add aka ANSI codes
(load! "+editor")
;; disable org-mode's auto wrap
;(remove-hook 'org-mode-hook 'auto-fill-mode)
;; mu4e setup
;;
;(if IS-MAC
;  (load! "+mail"))

;; Which key - make it pop up faster
(setq which-key-idle-delay 0.5) ;; I need the help, I really do



;; ** tools
;;
;; ** features
;; Feature `windmove' provides keybindings S-left, S-right, S-up, and
;; S-down to move between windows. This is much more convenient and
;; efficient than using the default binding, C-x o, to cycle through
;; all of them in an essentially unpredictable order.
(use-package! windmove
  :demand t
  :config

  (windmove-default-keybindings)

  ;; Introduced in Emacs 27:

  (when (fboundp 'windmove-display-default-keybindings)
    (windmove-display-default-keybindings))

  (when (fboundp 'windmove-delete-default-keybindings)
    (windmove-delete-default-keybindings)))

;; Feature `winner' provides an undo/redo stack for window
;; configurations, with undo and redo being C-c left and C-c right,
;; respectively. (Actually "redo" doesn't revert a single undo, but
;; rather a whole sequence of them.) For instance, you can use C-x 1
;; to focus on a particular window, then return to your previous
;; layout with C-c left.
(use-package! winner
 :demand t
 :config
  (map! :map winner-mode-map
       "<M-right>" #'winner-redo
       "<M-left>" #'winner-undo)
 (winner-mode +1))

(setq search-highlight t
      search-whitespace-regexp ".*?"
      isearch-lax-whitespace t
      isearch-regexp-lax-whitespace nil
      isearch-lazy-highlight t
      isearch-lazy-count t
      lazy-count-prefix-format " (%s/%s) "
      lazy-count-suffix-format nil
      isearch-yank-on-move 'shift
      isearch-allow-scroll 'unlimited)


(after! dired
  (setq dired-listing-switches "-aBhl  --group-directories-first"
        dired-dwim-target t
        dired-recursive-copies (quote always)
        dired-recursive-deletes (quote top)))

(use-package! dired-narrow
  :commands (dired-narrow-fuzzy)
  :init
  (map! :map dired-mode-map
        :desc "narrow" "/" #'dired-narrow-fuzzy))

;; Reuse dired buffers
(put 'dired-find-alternate-file 'disabled nil)

;; *** deadgrep
(use-package! deadgrep
:if (executable-find "rg")
:init
(map! "M-s" #'deadgrep)
:commands (deadgrep)
)

(use-package! smartparens
  ;; :init
  ;; (map! :map smartparens-mode-map
  ;;       "C-M-f" #'sp-forward-sexp
  ;;       "C-M-b" #'sp-backward-sexp
  ;;       "C-M-u" #'sp-backward-up-sexp
  ;;       "C-M-d" #'sp-down-sexp
  ;;       "C-M-p" #'sp-backward-down-sexp
  ;;       "C-M-n" #'sp-up-sexp
  ;;       "C-M-s" #'sp-splice-sexp
  ;;       "C-M-k"     #'sp-kill-sexp
  ;;       "C-M-t"     #'sp-transpose-sexp
  ;;       "C-<right>" #'sp-forward-slurp-sexp
  ;;       "M-<right>" #'sp-forward-barf-sexp
  ;;       "C-<left>"  #'sp-backward-slurp-sexp
  ;;       "M-<left>"  #'sp-backward-barf-sexp
  ;;       "C-)" #'sp-forward-slurp-sexp
  ;;       "C-}" #'sp-forward-barf-sexp
  ;;       "C-(" #'sp-backward-slurp-sexp
  ;;       "C-M-)" #'sp-backward-slurp-sexp
  ;;       "C-M-)" #'sp-backward-barf-sexp)
  :config
  ;; Load the default pair definitions for Smartparens.
  (require 'smartparens-config)

  ;; Enable Smartparens functionality in all buffers.
  (smartparens-global-mode +1)

  ;; When in Paredit emulation mode, Smartparens binds M-( to wrap the
  ;; following s-expression in round parentheses. By analogy, we
  ;; should bind M-[ to wrap the following s-expression in square
  ;; brackets. However, this breaks escape sequences in the terminal,
  ;; so it may be controversial upstream. We only enable the
  ;; keybinding in windowed mode.
  ;;(when (display-graphic-p)
  ;;  (setf (map-elt sp-paredit-bindings "M-[") #'sp-wrap-square))

  ;; Set up keybindings for s-expression navigation and manipulation
  ;; in the style of Paredit.
  ;(sp-use-paredit-bindings)

  ;; Highlight matching delimiters.
  (show-smartparens-global-mode +1)

  ;; Prevent all transient highlighting of inserted pairs.
  (setq sp-highlight-pair-overlay nil)
  (setq sp-highlight-wrap-overlay nil)
  (setq sp-highlight-wrap-tag-overlay nil)

  ;; Don't disable autoskip when point moves backwards. (This lets you
  ;; open a sexp, type some things, delete some things, etc., and then
  ;; type over the closing delimiter as long as you didn't leave the
  ;; sexp entirely.)
  (setq sp-cancel-autoskip-on-backward-movement nil)
  ;; Make C-k kill the sexp following point in Lisp modes, instead of
  ;; just the current line.
  (bind-key [remap kill-line] #'sp-kill-hybrid-sexp smartparens-mode-map
            (apply #'derived-mode-p sp-lisp-modes))



  )
