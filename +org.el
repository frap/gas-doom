;;; ~/.enfer.d/+org.el -*- lexical-binding: t; -*-

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org"
  org-ellipsis " ▼ "
 ;; org-archive-location (concat org-directory ".archive/%s::")
 ;; org-roam-directory "~/org/roam"
 )


(use-package! org
  :mode ("\\.org\\'" . org-mode)
  :init
  (map! :leader
        :prefix "n"
         "c" #'org-capture)
  (map! :map org-mode-map
        "M-n" #'outline-next-visible-heading
        "M-p" #'outline-previous-visible-heading)
  (setq org-src-window-setup 'current-window
        org-return-follows-link t
    org-babel-load-languages '((emacs-lisp . t)
                                (shell . t)
                                (clojure . t)
                                (dot . t)
                                (R . t)
                                (sql . t)
                                (awk . t)
                                (css . t)
                                (js . t)
                                (plantuml . t)
;;                                (make . t)
                                (sed . t))
        org-confirm-babel-evaluate nil
        org-use-speed-commands t
        org-catch-invisible-edits 'show
        org-preview-latex-image-directory "/tmp/ltximg/"
        org-structure-template-alist '(("a" . "export ascii")
                                       ("c" . "center")
                                       ("C" . "comment")
                                       ("e" . "example")
                                       ("E" . "export")
                                       ("h" . "export html")
                                       ("l" . "export latex")
                                       ("q" . "quote")
                                       ("s" . "src")
                                       ("v" . "verse")
                                       ("el" . "src emacs-lisp")
                                       ("cl" . "src clojure")
                                       ("d" . "definition")
                                       ("t" . "theorem"))))


;; ORG config
(after! org
  (defun gas/org-archive-done-tasks ()
    "Archive all done tasks."
    (interactive)
    (org-map-entries 'org-archive-subtree "/DONE" 'file))
  (require 'find-lisp)
;; set org file directory
  (setq gas/org-agenda-directory "~/org/gtd/")
  (defconst gas-org-agenda-file (concat gas/org-agenda-directory "inbox.org"))
  (defconst gas-org-work-file (concat gas/org-agenda-directory "atea.org"))
  ;;(defconst gas-org-journal-file (concat org-directory "journal.org"))
  ''(defconst gas-org-refile-file (concat org-directory "refile.org"))
  ;; set agenda files
  ;;(setq org-agenda-files (list gas/org-agenda-directory))
  (setq org-agenda-files
    (find-lisp-find-files gas/org-agenda-directory "\.org$"))

  (setq org-capture-templates
        `(("i" "inbox" entry (file ,(concat gas/org-agenda-directory "inbox.org"))
           "* TODO %?")
          ("e" "email" entry (file+headline ,(concat gas/org-agenda-directory "emails.org") "Emails")
               "* TODO [#A] Reply: %a :@maison:@bureau:"
               :immediate-finish t)
          ("c" "org-protocol-capture" entry (file ,(concat gas/org-agenda-directory "inbox.org"))
               "* TODO [[%:link][%:description]]\n\n %i"
               :immediate-finish t)
          ("w" "Weekly Review" entry (file+olp+datetree ,(concat gas/org-agenda-directory "reviews.org"))
           (file ,(concat gas/org-agenda-directory "templates/weekly_review.org")))
           ))

  (setq org-todo-keywords
    '((sequence "TODO(t)" "SUIV(n)" "|" "FINI(d)")
       (sequence "ATTENDRE(w@/!)" "SUSPENDUÉ(h@/!)" "|" "ANNULÉ(c@/!)")))

  (setq org-log-done 'time
    org-log-into-drawer t
    org-log-state-notes-insert-after-drawers nil)

  (setq-default org-tag-alist (quote (("@errand"     . ?e)
                                       ("@bureau"    . ?o)
                                       ("@maison"    . ?h)
                                       ("important"  . ?i)
                                       ("urgent"     . ?u)

                                       (:newline)
                                       ("ATTENDRE"  . ?w)
                                       ("SUSPENDUÉ" . ?h)
                                       ("ANNULÉ"    . ?c)
                                       ("RÉUNION"   . ?m)
                                       ("TÉLÉPHONE" . ?p)
                                       ("french"    . ?f)
                                       ("spanish"   . ?s))))

  (setq  org-highest-priority ?A
    org-default-priority ?C
    org-lowest-priority  ?D)

  (setq org-fast-tag-selection-single-key nil)
(setq org-refile-use-outline-path 'file
      org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes 'confirm)
(setq org-refile-targets '(("next.org" :level . 0)
                           ("someday.org" :level . 0)
                           ("reading.org" :level . 1)
                           ("projects.org" :maxlevel . 1)))

(defvar gas/org-agenda-bulk-process-key ?f
  "Default key for bulk processing inbox items.")

(defun gas/org-process-inbox ()
  "Called in org-agenda-mode, processes all inbox items."
  (interactive)
  (org-agenda-bulk-mark-regexp "inbox:")
  (gas/bulk-process-entries))

(defvar gas/org-current-effort "1:00"
  "Current effort for agenda items.")

(defun gas/my-org-agenda-set-effort (effort)
  "Set the effort property for the current headline."
  (interactive
   (list (read-string (format "Effort [%s]: " gas/org-current-effort) nil nil gas/org-current-effort)))
  (setq gas/org-current-effort effort)
  (org-agenda-check-no-diary)
  (let* ((hdmarker (or (org-get-at-bol 'org-hd-marker)
                       (org-agenda-error)))
         (buffer (marker-buffer hdmarker))
         (pos (marker-position hdmarker))
         (inhibit-read-only t)
         newhead)
    (org-with-remote-undo buffer
      (with-current-buffer buffer
        (widen)
        (goto-char pos)
        (org-show-context 'agenda)
        (funcall-interactively 'org-set-effort nil gas/org-current-effort)
        (end-of-line 1)
        (setq newhead (org-get-heading)))
      (org-agenda-change-all-lines newhead hdmarker))))

(defun gas/org-agenda-process-inbox-item ()
  "Process a single item in the org-agenda."
  (org-with-wide-buffer
   (org-agenda-set-tags)
   (org-agenda-priority)
   (call-interactively 'gas/my-org-agenda-set-effort)
   (org-agenda-refile nil nil t)))

(defun gas/bulk-process-entries ()
  (if (not (null org-agenda-bulk-marked-entries))
      (let ((entries (reverse org-agenda-bulk-marked-entries))
            (processed 0)
            (skipped 0))
        (dolist (e entries)
          (let ((pos (text-property-any (point-min) (point-max) 'org-hd-marker e)))
            (if (not pos)
                (progn (message "Skipping removed entry at %s" e)
                       (cl-incf skipped))
              (goto-char pos)
              (let (org-loop-over-headlines-in-active-region) (funcall 'gas/org-agenda-process-inbox-item))
              ;; `post-command-hook' is not run yet.  We make sure any
              ;; pending log note is processed.
              (when (or (memq 'org-add-log-note (default-value 'post-command-hook))
                        (memq 'org-add-log-note post-command-hook))
                (org-add-log-note))
              (cl-incf processed))))
        (org-agenda-redo)
        (unless org-agenda-persistent-marks (org-agenda-bulk-unmark-all))
        (message "Acted on %d entries%s%s"
                 processed
                 (if (= skipped 0)
                     ""
                   (format ", skipped %d (disappeared before their turn)"
                           skipped))
                 (if (not org-agenda-persistent-marks) "" " (kept marked)")))))

(defun gas/org-inbox-capture ()
  (interactive)
  "Capture a task in agenda mode."
  (org-capture nil "i"))

(setq org-agenda-bulk-custom-functions `((,gas/org-agenda-bulk-process-key gas/org-agenda-process-inbox-item)))

(map! :map org-agenda-mode-map
      "i" #'org-agenda-clock-in
      "r" #'gas/org-process-inbox
      "R" #'org-agenda-refile
      "c" #'gas/org-inbox-capture)

(defun gas/set-todo-state-next ()
  "Visit each parent task and change NEXT states to TODO"
  (org-todo "SUIV"))

  (add-hook 'org-clock-in-hook 'gas/set-todo-state-next 'append)

  (use-package! org-clock-convenience
  :bind (:map org-agenda-mode-map
              ("<S-up>" . org-clock-convenience-timestamp-up)
              ("<S-down>" . org-clock-convenience-timestamp-down)
              ("o" . org-clock-convenience-fill-gap)
          ("e" . org-clock-convenience-fill-gap-both)))

  (defvar gas/organisation-task-id "eb155a82-92b2-4f25-a3c6-0304591af2f9")

(use-package! org-agenda
  :init
  (map! "<f1>" #'gas/switch-to-agenda)
  (setq org-agenda-block-separator nil
        org-agenda-start-with-log-mode t)
  (defun gas/switch-to-agenda ()
    (interactive)
    (org-agenda nil " "))
  :config
  (setq org-columns-default-format "%40ITEM(Task) %Effort(EE){:} %CLOCKSUM(Time Spent) %SCHEDULED(Scheduled) %DEADLINE(Deadline)" )
  (setq org-agenda-custom-commands
      (quote (
              ("N" "Notes" tags "NOTE"
               ((org-agenda-overriding-header "Notes")
                (org-tags-match-list-sublevels t)))
              ("h" "Habitudes" tags-todo "STYLE=\"habit\""
               ((org-agenda-overriding-header "Habitudes")
                (org-agenda-sorting-strategy
                 '(todo-state-down priority-down category-keep))))
              ("e" "Eisenhower Matrix"
               ((agenda "" ((org-agenda-overriding-header "Calendrier Eisenhower:")
                            (org-agenda-show-log t)
                            (org-agenda-log-mode-items '(clock state))
                            (org-agenda-category-filter-preset '("-Habitudes"))
                            (org-agenda-span 5)
                            (org-agenda-start-on-weekday t)
                            ;;            (org-agenda-ndays 5)
                            ;;            (org-agenda-start-day "-2d")
                            (org-deadline-warning-days 30)))
                (tags-todo  "+important+urgent\!FINI"
                            ((org-agenda-overriding-header "Tâches importantes et urgentes")
                             (org-tags-match-list-sublevels nil)))
                (tags-todo  "+important-urgent"
                            ((org-agenda-overriding-header "Tâches importantes mais non urgentes")
                             (org-tags-match-list-sublevels nil)))
                (tags-todo "-important+urgent"
                           ((org-agenda-overriding-header "Tâches urgentes mais sans importance")
                            (org-tags-match-list-sublevels nil)))
                (tags-todo "-important-urgent/!TODO"
                           ((org-agenda-overriding-header "Tâches non importantes ni urgentes")
                            (org-agenda-category-filter-preset '("-Habitudes"))
                            (org-tags-match-list-sublevels nil)))
                (tags-todo "VALUE"
                           ((org-agenda-overriding-header "Valeurs")
                            (org-tags-match-list-sublevels nil)))
                ))
              (" " "Agenda"
               ((agenda "" ((org-agenda-overriding-header "Calendrier d'aujourd'hui:")
                            (org-agenda-show-log t)
                            (org-agenda-log-mode-items '(clock state))
                            ;;   (org-agenda-span 'day)
                            ;;   (org-agenda-ndays 3)
                            (org-agenda-start-on-weekday nil)
                            (org-agenda-start-day "-d")
                            (org-agenda-todo-ignore-deadlines nil)))
                (tags-todo "+important"
                           ((org-agenda-overriding-header "Tâches Importantes à Venir")
                            (org-tags-match-list-sublevels nil)))
                (tags-todo "-important"
                           ((org-agenda-overriding-header "Tâches de Travail")
                            (org-agenda-category-filter-preset '("-Habitudes"))
                            (org-agenda-sorting-strategy
                             '(todo-state-down priority-down))))
                (tags "REFILE"
                      ((org-agenda-overriding-header "Tâches à la Représenter")
                       (org-tags-match-list-sublevels nil)))))))))


  (setq  gas/keep-clock-running nil)

;;(use-package! org-gcal
;;  :after '(auth-source-pass password-store)
;;  :config
;;  (setq org-gcal-client-id "887865341451-orrpnv3cu0fnh8hdtge77sv6csqilqtu.apps.googleusercontent.com"
;;        org-gcal-client-secret "WmOGOCr_aWPJSqmwXHV-29bv"
;;        org-gcal-file-alist
;;        '(("agasson@ateasystems.com" . "~/org/gtd/calendars/atea-cal.org")
;;          ;;("ateasystems.com_0ie21uc26j0a41g60b8f99mh1k@group.calendar.google.com" . "~/org/gtd/calendars/changecontrol-cal.org")
 ;;         )))
 ;;
;;   (use-package! org-roam
;;     :commands (org-roam-insert org-roam-find-file org-roam-switch-to-buffer org-roam)
;;     :hook
;;     (after-init . org-roam-mode)
;;     :custom-face
;;   ;;  (org-roam-link ((t (:inherit org-link :foreground "#005200"))))
;;     :init
;;       (setq org-roam-directory "~/org/roam/"
;;       org-roam-db-location "~/org/roam/org-roam.db"
;;       org-roam-db-gc-threshold most-positive-fixnum
;;       org-roam-graph-exclude-matcher "private"
;;       org-roam-tag-sources '(prop last-directory)
;;       org-id-link-to-org-use-id t)
;;     :config
;;     (setq org-roam-capture-templates
;;       '(("l" "lit" plain (function org-roam--capture-get-point)
;;           "%?"
;;           :file-name "lit/${slug}"
;;           :head "#+setupfile:./hugo_setup.org
;; #+hugo_slug: ${slug}
;; #+title: ${title}\n"
;;           :unnarrowed t)
;;          ("c" "concept" plain (function org-roam--capture-get-point)
;;            "%?"
;;            :file-name "concepts/${slug}"
;;            :head "#+setupfile:./hugo_setup.org
;; #+hugo_slug: ${slug}
;; #+title: ${title}\n"
;;            :unnarrowed t)
;;           ("p" "private" plain (function org-roam-capture--get-point)
;;            "%?"
;;            :file-name "private/${slug}"
;;            :head "#+title: ${title}\n"
;;            :unnarrowed t)))
;;   (setq org-roam-capture-ref-templates
;;         '(("r" "ref" plain (function org-roam-capture--get-point)
;;            "%?"
;;            :file-name "lit/${slug}"
;;            :head "#+setupfile:./hugo_setup.org
;; #+roam_key: ${ref}
;; #+hugo_slug: ${slug}
;; #+roam_tags: website
;; #+title: ${title}
;; - source :: ${ref}"
;;             :unnarrowed t))))

;;   (use-package! org-roam-protocol
;;   :after org-protocol)
(require 'org-roam-protocol)
(setq org-protocol-default-template-key "d")
;; (use-package! company-posframe
;;   :hook (company-mode . company-posframe-mode))

;; (use-package company-org-roam
;;   :when (featurep! :completion company)
;;   :after org-roam
;;   :config
;;   (set-company-backend! 'org-mode '(company-org-roam company-yasnippet company-dabbrev)))

;;   (after! (org-roam)
;;     (winner-mode +1)
;;     (map! :map winner-mode-map
;;       "<M-right>" #'winner-redo
;;       "<M-left>" #'winner-undo))

  (setq org-roam-directory "~/org/roam")

 (use-package! org-fc
   :commands org-fc-hydra/body
   :bind ("C-c n r p" . org-fc-hydra/body)

   :defer t
   :custom
   (org-fc-directories '("~/org/spaced-repetition/"))
   :config
   (require 'org-fc-hydra)
   (add-to-list 'org-fc-custom-contexts
  '(french-cards . (:filter (tag "french")))))



   (use-package! org-journal
  ;; :bind
  ;; ("C-c n j" . org-journal-new-entry)
  ;; ("C-c n t" . org-journal-today)
   :config
  ;; (defun org-journal-file-header-func (time)
  ;; "Custom function to create journal header."
  ;; (concat
  ;;   (pcase org-journal-file-type
  ;;     (`daily "#+TITLE: Daily Journal\n#+STARTUP: showeverything")
  ;;     (`weekly "#+TITLE: Weekly Journal\n#+STARTUP: folded")
  ;;     (`monthly "#+TITLE: Monthly Journal\n#+STARTUP: folded")
  ;;     (`yearly "#+TITLE: Yearly Journal\n#+STARTUP: folded"))))

  ;;   (setq org-journal-file-header 'org-journal-file-header-func)
     (setq
  ;;     ;;org-journal-date-prefix "#+TITLE: "
       org-journal-file-format "%Y-%m-%d.org"
       org-journal-dir "~/org/roam/"
  ;;     org-journal-skip-carryover-drawers (list "LOGBOOK")
  ;;     ;;org-journal-carryover-items nil
       org-journal-date-format "%A, %d %B %Y")
     (setq org-journal-enable-agenda-integration t)
  ;;   (defun org-journal-today ()
  ;;     (interactive)
  ;;     (org-journal-new-entry t))
     )

  ;; (use-package org-download
  ;; :after org
  ;; :bind
  ;; (:map org-mode-map
  ;;       (("s-Y" . org-download-screenshot)
  ;;         ("s-y" . org-download-yank))))

  (use-package! obtt
    :init
    (setq! obtt-templates-dir (concat
                                (if (boundp 'doom-private-dir)
                                  doom-private-dir
                                  user-emacs-directory) "obtt")
      obtt-seed-name ".obtt"))

  (when (not (file-directory-p obtt-templates-dir))
          (make-directory obtt-templates-dir))
     ;;   (add-hook 'org-agenda-mode-hook (lambda () (org-gcal-sync) ))

  )


(provide '+org)
;;; +org ends here
