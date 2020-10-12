;;; ~/.doom.d/+themes.el -*- lexical-binding: t; -*-

(if IS-MAC
  (setq default-frame-alist '((left . 0) (width . 150) (fullscreen . fullheight)))
  )
;; Font setup
(if IS-MAC
  (setq
    doom-font (font-spec :family "Hack" :size 13)
    doom-variable-pitch-font (font-spec :family "Fira Sans")
    doom-unicode-font (font-spec :family "DejaVu Sans Mono")
    doom-big-font (font-spec :family "Hack" :size 19)
    doom-theme 'doom-tomorrow-day ))


(when IS-LINUX
  (setq doom-font (font-spec :family "Fira Code" :size 16)
      doom-big-font (font-spec :family "Fira Code" :size 20)))
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-ephemeral)
;; Main theme


;; All themes are safe to load
(setq custom-safe-themes t)

;; Splash image
(if IS-MAC
  (setq
    +doom-dashboard-banner-dir (concat doom-private-dir "banners/")
    +doom-dashboard-banner-file "black-hole.png"
    +doom-dashboard-banner-padding '(0 . 1)))
