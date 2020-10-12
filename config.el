
;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(setq-default user-full-name "Andrés Gasson"
  user-mail-address "agasson@red-elvis.net"
  github-account-name "frap")

(setq default-directory "~")

;; Global settings
(setq! show-paren-mode 1
       doom-scratch-initial-major-mode t)
(setq! auth-sources '("~/.authinfo.gpg"))
(display-time-mode 1)
(setq display-time-day-and-date t)

(when (equal (window-system) nil)
  (and
   (bind-key "C-<down>" #'+org/insert-item-below)
   (setq doom-theme 'doom-monokai-pro)
    (setq doom-font (font-spec :family "Input Mono" :size 20))))


;; Load Personalised bindings
(load! "+bindings")
;(load! "+functions")
;; Theme related things
(load! "+themes")
;;gas org customisations
(load! "+org")
(load! "+lang")
;; Configuration of DOOM ui
(load! "+ui")
;; disable org-mode's auto wrap
;(remove-hook 'org-mode-hook 'auto-fill-mode)

;; mu4e setup
;;
;(if IS-MAC
;  (load! "+mail"))

;(add-to-list 'org-structure-template-alist '("r" . "src rust"))
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

;; *** deadgrep
(use-package! deadgrep
:if (executable-find "rg")
:init
(map! "M-s" #'deadgrep)
:commands (deadgrep)
)

(use-package! smartparens
  :init
  (map! :map smartparens-mode-map
        "C-M-f" #'sp-forward-sexp
        "C-M-b" #'sp-backward-sexp
        "C-M-u" #'sp-backward-up-sexp
        "C-M-d" #'sp-down-sexp
        "C-M-p" #'sp-backward-down-sexp
        "C-M-n" #'sp-up-sexp
        "C-M-s" #'sp-splice-sexp
        "C-)" #'sp-forward-slurp-sexp
        "C-}" #'sp-forward-barf-sexp
        "C-(" #'sp-backward-slurp-sexp
        "C-M-)" #'sp-backward-slurp-sexp
        "C-M-)" #'sp-backward-barf-sexp))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
  '(custom-safe-themes
     '("425cf02839fa7c5ebd6cb11f8074f6b8463ae6ed3eeb4cf5a2b18ffc33383b0b" "b5fff23b86b3fd2dd2cc86aa3b27ee91513adaefeaa75adc8af35a45ffb6c499" "7a994c16aa550678846e82edc8c9d6a7d39cc6564baaaacc305a3fdc0bd8725f" "99ea831ca79a916f1bd789de366b639d09811501e8c092c85b2cb7d697777f93" "7b3d184d2955990e4df1162aeff6bfb4e1c3e822368f0359e15e2974235d9fa8" "76bfa9318742342233d8b0b42e824130b3a50dcc732866ff8e47366aed69de11" "be9645aaa8c11f76a10bcf36aaf83f54f4587ced1b9b679b55639c87404e2499" "9b272154fb77a926f52f2756ed5872877ad8d73d018a426d44c6083d1ed972b1" "e074be1c799b509f52870ee596a5977b519f6d269455b84ed998666cf6fc802a" default))
 '(org-fc-directories '("~/org/spaced-repetition/") t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-roam-link ((t (:inherit org-link :foreground "#005200")))))
