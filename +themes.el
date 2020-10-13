;;; ~/.doom.d/+themes.el -*- lexical-binding: t; -*-

;; Font ans Screen setup
(if IS-MAC
  (setq
    doom-font (font-spec :family "Hack" :size 13)
    doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13)
    doom-unicode-font (font-spec :family "Fira Code" :size 12)
    doom-big-font (font-spec :family "Hack" :size 24)
    doom-theme 'doom-vibrant
    ;; splash image
    +doom-dashboard-banner-dir (concat doom-private-dir "banners/")
    +doom-dashboard-banner-file "black-hole.png"
    +doom-dashboard-banner-padding '(0 . 1)
    ;; screen size
     default-frame-alist '((left . 0) (width . 200) (fullscreen . fullheight)))
  )

(when (or IS-LINUX  (equal (window-system) nil))
  (and
    (bind-key "C-<down>" #'+org/insert-item-below)
    (setq
      doom-font (font-spec :family "Fira Code" :size 16)
      doom-big-font (font-spec :family "Input Mono" :size 20)
      doom-theme 'doom-monokai-pro)))


;; delete the theme defaults
(delq! t custom-theme-load-path)

;; All themes are safe to load
(setq custom-safe-themes t)

;; make default modify orange not red!
(custom-set-faces!
  '(doom-modeline-buffer-modified :foreground "orange"))

;; UTF-8 is default encoding remove it form modeline
(defun doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is not the case"
  (setq-local doom-modeline-buffer-encoding
              (unless (or (eq buffer-file-coding-system 'utf-8-unix)
                          (eq buffer-file-coding-system 'utf-8)))))

(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)

;; window title
;;; I’d like to have just the buffer name, then if applicable the project folder

(setq frame-title-format
      '(""
        (:eval
         (if (s-contains-p org-roam-directory (or buffer-file-name ""))
             (replace-regexp-in-string ".*/[0-9]*-?" "🢔 " buffer-file-name)
           "%b"))
        (:eval
         (let ((project-name (projectile-project-name)))
           (unless (string= "-" project-name)
             (format (if (buffer-modified-p)  " ◉ %s" "  ●  %s") project-name))))))
