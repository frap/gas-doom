;; -*- no-byte-compile: t; -*-
;; .doom.d/packages.el

;; Examples:
;; (package! another-package :recipe (:host github :repo "username/repo"))
;; (package! builtin-package :disable t)
(package! dired-narrow)
(package! deadgrep)
;;(package! org-gcal)
(package! org-fc :recipe (:host github :repo "l3kn/org-fc"))
(package! org-clock-convenience)
(package! company-posframe
  :recipe (:host github :repo "jethrokuan/company-org-roam"))

(package! doom-snippets :ignore t)
;; If you want to replace it with yasnippet's default snippets
(package! yasnippet-snippets)
(package! obtt :recipe (:host github :repo "timotheosh/obtt"))
;;(package! flycheck-clj-kondo)
(package! doct
  :recipe (:host github :repo "progfolio/doct")
  :pin "dabb30ebea866ef225b81561c8265d740b1e81c3")
