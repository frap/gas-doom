;;; ~/.enfer.d/+org.el -*- lexical-binding: t; -*-

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq
  org-directory "~/org/gtd"
  org-use-property-inheritance t              ; it's convenient to have properties inherited
  org-log-done 'time                          ; having the time a item is done sounds convininet
  org-list-allow-alphabetical t               ; have a. A. a) A) list bullets
  org-export-in-background t                  ; run export processes in external emacs process
  org-catch-invisible-edits 'smart            ; try not to accidently do weird stuff in invisible regions
  org-re-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js"
  org-ellipsis " ▼ "

 ;; org-archive-location (concat org-directory ".archive/%s::")
  org-roam-directory "~/org/roam"
 )


;; like the comments header-argument
(setq org-babel-default-header-args
      '((:session . "none")
        (:results . "replace")
        (:exports . "code")
        (:cache . "no")
        (:noweb . "no")
        (:hlines . "no")
        (:tangle . "no")
         (:comments . "link")))

(use-package! org
  :mode ("\\.org\\'" . org-mode)
  :init
  (setq
    org-babel-load-languages
    '((emacs-lisp . t)
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
    org-structure-template-alist
    '(("a" . "export ascii")
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

;; My Spelling is atrocious
(after! org (add-hook 'org-mode-hook 'turn-on-flyspell))

(use-package! doct
  :commands (doct))

(after! org-capture
  (defun org-capture-select-template-prettier (&optional keys)
  "Select a capture template, in a prettier way than default
Lisp programs can force the template by setting KEYS to a string."
  (let ((org-capture-templates
         (or (org-contextualize-keys
              (org-capture-upgrade-templates org-capture-templates)
              org-capture-templates-contexts)
             '(("t" "Tâche" entry (file+headline "" "Tâches")
                "* TODO %?\n  %u\n  %a")))))
    (if keys
        (or (assoc keys org-capture-templates)
            (error "Aucun modèle de capture mentionné par \"%s\" les clés" keys))
      (org-mks org-capture-templates
               "Sélectionnez un modèle de capture\n━━━━━━━━━━━━━━━━━━━━━━━━━"
               "Clé de modèle: "
               `(("q" ,(concat (all-the-icons-octicon "stop" :face 'all-the-icons-red :v-adjust 0.01) "\tAbort")))))))
  (advice-add 'org-capture-select-template :override #'org-capture-select-template-prettier)

  (defun org-mks-pretty (table title &optional prompt specials)
    "Select a member of an alist with multiple keys. Prettified.

TABLE is the alist which should contain entries where the car is a string.
There should be two types of entries.

1. prefix descriptions like (\"a\" \"Description\")
   This indicates that `a' is a prefix key for multi-letter selection, and
   that there are entries following with keys like \"ab\", \"ax\"…

2. Select-able members must have more than two elements, with the first
   being the string of keys that lead to selecting it, and the second a
   short description string of the item.

The command will then make a temporary buffer listing all entries
that can be selected with a single key, and all the single key
prefixes.  When you press the key for a single-letter entry, it is selected.
When you press a prefix key, the commands (and maybe further prefixes)
under this key will be shown and offered for selection.

TITLE will be placed over the selection in the temporary buffer,
PROMPT will be used when prompting for a key.  SPECIALS is an
alist with (\"key\" \"description\") entries.  When one of these
is selected, only the bare key is returned."
    (save-window-excursion
      (let ((inhibit-quit t)
             (buffer (org-switch-to-buffer-other-window "*Org Select*"))
             (prompt (or prompt "Sélectionner: "))
             case-fold-search
             current)
        (unwind-protect
          (catch 'exit
            (while t
              (setq-local evil-normal-state-cursor (list nil))
              (erase-buffer)
              (insert title "\n\n")
              (let ((des-keys nil)
                     (allowed-keys '("\C-g"))
                     (tab-alternatives '("\s" "\t" "\r"))
                     (cursor-type nil))
                ;; Populate allowed keys and descriptions keys
                ;; available with CURRENT selector.
                (let ((re (format "\\`%s\\(.\\)\\'"
                            (if current (regexp-quote current) "")))
                       (prefix (if current (concat current " ") "")))
                  (dolist (entry table)
                    (pcase entry
                      ;; Description.
                      (`(,(and key (pred (string-match re))) ,desc)
                        (let ((k (match-string 1 key)))
                          (push k des-keys)
                          ;; Keys ending in tab, space or RET are equivalent.
                          (if (member k tab-alternatives)
                            (push "\t" allowed-keys)
                            (push k allowed-keys))
                          (insert (propertize prefix 'face 'font-lock-comment-face) (propertize k 'face 'bold) (propertize "›" 'face 'font-lock-comment-face) "  " desc "…" "\n")))
                      ;; Usable entry.
                      (`(,(and key (pred (string-match re))) ,desc . ,_)
                        (let ((k (match-string 1 key)))
                          (insert (propertize prefix 'face 'font-lock-comment-face) (propertize k 'face 'bold) "   " desc "\n")
                          (push k allowed-keys)))
                      (_ nil))))
                ;; Insert special entries, if any.
                (when specials
                  (insert "─────────────────────────\n")
                  (pcase-dolist (`(,key ,description) specials)
                    (insert (format "%s   %s\n" (propertize key 'face '(bold all-the-icons-red)) description))
                    (push key allowed-keys)))
                ;; Display UI and let user select an entry or
                ;; a sub-level prefix.
                (goto-char (point-min))
                (unless (pos-visible-in-window-p (point-max))
                  (org-fit-window-to-buffer))
                (let ((pressed (org--mks-read-key allowed-keys prompt)))
                  (setq current (concat current pressed))
                  (cond
                    ((equal pressed "\C-g") (user-error "Abort"))
                    ;; Selection is a prefix: open a new menu.
                    ((member pressed des-keys))
                    ;; Selection matches an association: return it.
                    ((let ((entry (assoc current table)))
                       (and entry (throw 'exit entry))))
                    ;; Selection matches a special entry: return the
                    ;; selection prefix.
                    ((assoc current specials) (throw 'exit current))
                    (t (error "No entry available")))))))
          (when buffer (kill-buffer buffer))))))
  (advice-add 'org-mks :override #'org-mks-pretty)
  (setq +org-capture-uni-units (split-string (f-read-text "~/org/.study-units")))
  (setq +org-capture-recipies  "~/org/recipies.org")

  (defun +doct-icon-declaration-to-icon (declaration)
    "Convert :icon declaration to icon"
    (let ((name (pop declaration))
          (set  (intern (concat "all-the-icons-" (plist-get declaration :set))))
          (face (intern (concat "all-the-icons-" (plist-get declaration :color))))
          (v-adjust (or (plist-get declaration :v-adjust) 0.01)))
      (apply set `(,name :face ,face :v-adjust ,v-adjust))))

  (defun +doct-iconify-capture-templates (groups)
    "Add declaration's :icon to each template group in GROUPS."
    (let ((templates (doct-flatten-lists-in groups)))
      (setq doct-templates (mapcar (lambda (template)
                                     (when-let* ((props (nthcdr (if (= (length template) 4) 2 5) template))
                                                 (spec (plist-get (plist-get props :doct) :icon)))
                                       (setf (nth 1 template) (concat (+doct-icon-declaration-to-icon spec)
                                                                      "\t"
                                                                      (nth 1 template))))
                                     template)
                                   templates))))

  (setq doct-after-conversion-functions '(+doct-iconify-capture-templates))

  (add-transient-hook! 'org-capture-select-template
    (setq org-capture-templates
          (doct `(("Tâche personnelle" :keys "t"
                   :icon ("checklist" :set "octicon" :color "green")
                   :file +org-capture-todo-file
                   :prepend t
                   :headline "Boîte de réception"
                   :type entry
                   :template ("* TODO %?"
                              "%i %a")
                   )
                  ("Note personnelle" :keys "n"
                   :icon ("sticky-note-o" :set "faicon" :color "green")
                   :file +org-capture-todo-file
                   :prepend t
                   :headline "Boîte de réception"
                   :type entry
                   :template ("* %?"
                              "%i %a")
                   )
                  ("Étude" :keys "u"
                   :icon ("graduation-cap" :set "faicon" :color "purple")
                   :file +org-capture-todo-file
                   :headline "Études"
                   :unit-prompt ,(format "%%^{Unit|%s}" (string-join +org-capture-uni-units "|"))
                   :prepend t
                   :type entry
                   :children (("Test" :keys "t"
                               :icon ("timer" :set "material" :color "red")
                               :template ("* TODO [#C] %{unit-prompt} %? :uni:tests:"
                                          "SCHEDULED: %^{Test date:}T"
                                          "%i %a"))
                              ("Assignment" :keys "a"
                               :icon ("library_books" :set "material" :color "orange")
                               :template ("* TODO [#B] %{unit-prompt} %? :uni:assignments:"
                                          "DEADLINE: %^{Due date:}T"
                                          "%i %a"))
                              ("Lecture" :keys "l"
                               :icon ("keynote" :set "fileicon" :color "orange")
                               :template ("* TODO [#C] %{unit-prompt} %? :uni:lecture:"
                                          "%i %a"))
                              ("Miscellaneous task" :keys "u"
                               :icon ("list" :set "faicon" :color "yellow")
                               :template ("* TODO [#D] %{unit-prompt} %? :uni:"
                                          "%i %a"))))
                  ("Email" :keys "e"
                   :icon ("envelope" :set "faicon" :color "blue")
                   :file +org-capture-todo-file
                   :prepend t
                   :headline "Inbox"
                   :type entry
                   :template ("* TODO %^{type|reply to|contact} %\\3 %? :email:"
                              "Send an email %^{urgency|soon|ASAP|anon|at some point|eventually} to %^{recipiant}"
                              "about %^{topic}"
                              "%U %i %a"))
                  ("Intéressante" :keys "i"
                   :icon ("eye" :set "faicon" :color "lcyan")
                   :file +org-capture-todo-file
                   :prepend t
                   :headline "Intéressante"
                   :type entry
                   :template ("* [ ] %{desc}%? :%{i-type}:"
                              "%i %a")
                   :children (("Webpage" :keys "w"
                               :icon ("globe" :set "faicon" :color "green")
                               :desc "%(org-cliplink-capture) "
                               :i-type "read:web"
                               )
                              ("Article" :keys "a"
                               :icon ("file-text" :set "octicon" :color "yellow")
                               :desc ""
                               :i-type "read:reaserch"
                               )
                              ("\tRecipie" :keys "r"
                               :icon ("spoon" :set "faicon" :color "dorange")
                               :file +org-capture-recipies
                               :headline "Unsorted"
                               :template "%(org-chef-get-recipe-from-url)"
                               )
                              ("Information" :keys "i"
                               :icon ("info-circle" :set "faicon" :color "blue")
                               :desc ""
                               :i-type "read:info"
                               )
                              ("Idée" :keys "I"
                               :icon ("bubble_chart" :set "material" :color "silver")
                               :desc ""
                               :i-type "idea"
                               )))
                  ("Tâches" :keys "k"
                   :icon ("inbox" :set "octicon" :color "yellow")
                   :file +org-capture-todo-file
                   :prepend t
                   :headline "Boîte de réception"
                   :type entry
                   :template ("* TODO %? %^G%{extra}"
                              "%i %a")
                   :children (("Tâche Générale" :keys "k"
                               :icon ("inbox" :set "octicon" :color "yellow")
                               :extra ""
                               )
                              ("Tâche avec date limite" :keys "d"
                               :icon ("timer" :set "material" :color "orange" :v-adjust -0.1)
                               :extra "\nDEADLINE: %^{Deadline:}t"
                               )
                              ("Tâche Planifiée" :keys "s"
                               :icon ("calendar" :set "octicon" :color "orange")
                               :extra "\nSCHEDULED: %^{Start time:}t"
                               )
                              ))
                  ("Projet" :keys "p"
                   :icon ("repo" :set "octicon" :color "silver")
                   :prepend t
                   :type entry
                   :headline "Boîte de réception"
                   :template ("* %{time-or-todo} %?"
                              "%i"
                              "%a")
                   :file ""
                   :custom (:time-or-todo "")
                   :children (("Projet-local tâche" :keys "t"
                               :icon ("checklist" :set "octicon" :color "green")
                               :time-or-todo "TODO"
                               :file +org-capture-project-todo-file)
                              ("Project-local note" :keys "n"
                               :icon ("sticky-note" :set "faicon" :color "yellow")
                               :time-or-todo "%U"
                               :file +org-capture-project-notes-file)
                              ("Project-local changelog" :keys "c"
                               :icon ("list" :set "faicon" :color "blue")
                               :time-or-todo "%U"
                               :heading "Unreleased"
                               :file +org-capture-project-changelog-file))
                   )
                  ("\tModèles centralisés pour les projets"
                   :keys "o"
                   :type entry
                   :prepend t
                   :template ("* %{time-or-todo} %?"
                              "%i"
                              "%a")
                   :children (("Projet tâche"
                               :keys "t"
                               :prepend nil
                               :time-or-todo "TODO"
                               :heading "Tâches"
                               :file +org-capture-central-project-todo-file)
                              ("Projet note"
                               :keys "n"
                               :time-or-todo "%U"
                               :heading "Notes"
                               :file +org-capture-central-project-notes-file)
                              ("Projet changelog"
                               :keys "c"
                               :time-or-todo "%U"
                               :heading "Unreleased"
                               :file +org-capture-central-project-changelog-file))
                    ))))))


;; ORG config
(after! org
  (require 'find-lisp)
;; set org file directory
  (setq gas/org-agenda-directory "~/org/gtd/")
 ; (defconst gas-org-agenda-file (concat gas/org-agenda-directory "inbox.org"))
;  (setq +org-capture-todo-file gas-org-agenda-file)
;  (defconst gas-org-work-file (concat gas/org-agenda-directory "atea.org"))
  ;;(defconst gas-org-journal-file (concat org-directory "journal.org"))
;  ''(defconst gas-org-refile-file (concat org-directory "refile.org"))
  ;; set agenda files
  ;;(setq org-agenda-files (list gas/org-agenda-directory))
  (setq org-agenda-files
    (find-lisp-find-files gas/org-agenda-directory "\.org$"))

  (defvar +org-capture-projects-file "projets.org"
  "Default, centralised target for org-capture templates.")

(setf (alist-get 'height +org-capture-frame-parameters) 15)
;; (alist-get 'name +org-capture-frame-parameters) "❖ Capture") ;; ATM hardcoded in other places, so changing breaks stuff
(setq +org-capture-fn
      (lambda ()
        (interactive)
        (set-window-parameter nil 'mode-line-format 'none)
        (org-capture)))

  (setq org-todo-keywords
    '((sequence
        "TODO(t)"  ; A task that needs doing & is ready to do
        "PROJ(p)"  ; A project, which usually contains other tasks
        "SUIV(s)"  ; A task that is in progress
        "ATTE(w)"  ; Something external is holding up this task
        "SUSP(h)"  ; This task is paused/on hold because of me
        "|"
        "FINI(d)"  ; Task successfully completed
        "KILL(k)") ; Task was cancelled, aborted or is no longer applicable
       (sequence
         "[ ](T)"   ; A task that needs doing
         "[-](S)"   ; Task is in progress
         "[?](W)"   ; Task is being held up or paused
         "|"
         "[X](D)")) ; Task was completed
    org-todo-keyword-faces
    '(("[-]"  . +org-todo-active)
       ("SUIV" . +org-todo-active)
       ("[?]"  . +org-todo-onhold)
       ("ATTE" . +org-todo-onhold)
       ("SUSP" . +org-todo-onhold)
       ("PROJ" . +org-todo-project)))
;  (setq org-capture-templates
;        `(("i" "inbox" entry (file ,(concat gas/org-agenda-directory "inbox.org"))
 ;          "* TODO %?")
 ;         ("e" "email" entry (file+headline ,(concat gas/org-agenda-directory "emails.org") "Emails")
 ;              "* TODO [#A] Reply: %a :@maison:@bureau:"
;               :immediate-finish t)
;          ("c" "org-protocol-capture" entry (file ,(concat gas/org-agenda-directory "inbox.org"))
;               "* TODO [[%:link][%:description]]\n\n %i"
;               :immediate-finish t)
;          ("w" "Weekly Review" entry (file+olp+datetree ,(concat gas/org-agenda-directory "reviews.org"))
;           (file ,(concat gas/org-agenda-directory "templates/weekly_review.org")))
;           ))



  ;(setq org-todo-keywords
  ;  '((sequence "TODO(t)" "SUIV(n)" "|" "FINI(d)")
  ;     (sequence "ATTENDRE(w@/!)" "SUSPENDUÉ(h@/!)" "|" "ANNULÉ(c@/!)")))

 ; (setq org-log-done 'time
 ;   org-log-into-drawer t
 ;   org-log-state-notes-insert-after-drawers nil)

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

 ; (setq  org-highest-priority ?A
 ;   org-default-priority ?C
 ;   org-lowest-priority  ?D)

;  (setq org-fast-tag-selection-single-key nil)

;; (defvar gas/org-agenda-bulk-process-key ?f
;;   "Default key for bulk processing inbox items.")

;; (defun gas/org-process-inbox ()
;;   "Called in org-agenda-mode, processes all inbox items."
;;   (interactive)
;;   (org-agenda-bulk-mark-regexp "inbox:")
;;   (gas/bulk-process-entries))

;; (defvar gas/org-current-effort "1:00"
;;   "Current effort for agenda items.")

;; (defun gas/my-org-agenda-set-effort (effort)
;;   "Set the effort property for the current headline."
;;   (interactive
;;    (list (read-string (format "Effort [%s]: " gas/org-current-effort) nil nil gas/org-current-effort)))
;;   (setq gas/org-current-effort effort)
;;   (org-agenda-check-no-diary)
;;   (let* ((hdmarker (or (org-get-at-bol 'org-hd-marker)
;;                        (org-agenda-error)))
;;          (buffer (marker-buffer hdmarker))
;;          (pos (marker-position hdmarker))
;;          (inhibit-read-only t)
;;          newhead)
;;     (org-with-remote-undo buffer
;;       (with-current-buffer buffer
;;         (widen)
;;         (goto-char pos)
;;         (org-show-context 'agenda)
;;         (funcall-interactively 'org-set-effort nil gas/org-current-effort)
;;         (end-of-line 1)
;;         (setq newhead (org-get-heading)))
;;       (org-agenda-change-all-lines newhead hdmarker))))

;; (defun gas/org-agenda-process-inbox-item ()
;;   "Process a single item in the org-agenda."
;;   (org-with-wide-buffer
;;    (org-agenda-set-tags)
;;    (org-agenda-priority)
;;    (call-interactively 'gas/my-org-agenda-set-effort)
;;    (org-agenda-refile nil nil t)))

;; (defun gas/bulk-process-entries ()
;;   (if (not (null org-agenda-bulk-marked-entries))
;;       (let ((entries (reverse org-agenda-bulk-marked-entries))
;;             (processed 0)
;;             (skipped 0))
;;         (dolist (e entries)
;;           (let ((pos (text-property-any (point-min) (point-max) 'org-hd-marker e)))
;;             (if (not pos)
;;                 (progn (message "Skipping removed entry at %s" e)
;;                        (cl-incf skipped))
;;               (goto-char pos)
;;               (let (org-loop-over-headlines-in-active-region) (funcall 'gas/org-agenda-process-inbox-item))
;;               ;; `post-command-hook' is not run yet.  We make sure any
;;               ;; pending log note is processed.
;;               (when (or (memq 'org-add-log-note (default-value 'post-command-hook))
;;                         (memq 'org-add-log-note post-command-hook))
;;                 (org-add-log-note))
;;               (cl-incf processed))))
;;         (org-agenda-redo)
;;         (unless org-agenda-persistent-marks (org-agenda-bulk-unmark-all))
;;         (message "Acted on %d entries%s%s"
;;                  processed
;;                  (if (= skipped 0)
;;                      ""
;;                    (format ", skipped %d (disappeared before their turn)"
;;                            skipped))
;;                  (if (not org-agenda-persistent-marks) "" " (kept marked)")))))

;(defun gas/org-inbox-capture ()
;  (interactive)
;  "Capture a task in agenda mode."
;  (org-capture nil "i"))

;(setq org-agenda-bulk-custom-functions `((,gas/org-agenda-bulk-process-key gas/org-agenda-process-inbox-item)))

;(map! :map org-agenda-mode-map
;      "i" #'org-agenda-clock-in
;      "r" #'gas/org-process-inbox
;      "R" #'org-agenda-refile
;      "c" #'gas/org-inbox-capture)

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

  (use-package! org-superstar
    :config
    (setq  org-superstar-todo-bullet-alist
        '(("TODO" . 9744)
          ("[ ]"  . 9744)
          ("FINI" . 9745)
           ("[X]"  . 9745))))

  (use-package! org-agenda
    :init
    (map! "<f1>" #'gas/switch-to-agenda)
;  (setq org-agenda-block-separator nil
;        org-agenda-start-with-log-mode t)
    (defun gas/switch-to-agenda ()
      (interactive)
      (org-agenda nil " "))
    :config
;  (setq org-columns-default-format "%40ITEM(Task) %Effort(EE){:} %CLOCKSUM(Time Spent) %SCHEDULED(Scheduled) %DEADLINE(Deadline)" )
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
                 ((agenda ""
                    ((org-agenda-overriding-header "Calendrier Eisenhower:")
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
                 ((agenda ""
                    ((org-agenda-overriding-header "Calendrier d'aujourd'hui:")
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
                       (org-tags-match-list-sublevels nil))))))))
    )


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
;(require 'org-roam-protocol)
;(setq org-protocol-default-template-key "d")
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
    :config
    (require 'org-fc-hydra)
    (org-fc-directories '("~/org/spaced-repetition/"))
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
     )


  (use-package! obtt
    :init
    (setq! obtt-templates-dir
      (concat
        (if (boundp 'doom-private-dir)
          doom-private-dir
          user-emacs-directory)
        "obtt")
      obtt-seed-name ".obtt"))

  (when (not (file-directory-p obtt-templates-dir))
    (make-directory obtt-templates-dir))
     ;;   (add-hook 'org-agenda-mode-hook (lambda () (org-gcal-sync) ))

  );; end of after! org

(after! org
  (appendq! +ligatures-extra-symbols
            `(:checkbox      "☐"
              :pending       "◼"
              :checkedbox    "☑"
              :list_property "∷"
              :results       "🠶"
              :property      "☸"
              :properties    "⚙"
              :end           "∎"
              :options       "⌥"
              :title         "𝙏"
              :subtitle      "𝙩"
              :author        "𝘼"
              :date          "𝘿"
              :latex_header  "⇥"
              :latex_class   "🄲"
              :beamer_header "↠"
              :begin_quote   "❮"
              :end_quote     "❯"
              :begin_export  "⯮"
              :end_export    "⯬"
              :priority_a   ,(propertize "⚑" 'face 'all-the-icons-red)
              :priority_b   ,(propertize "⬆" 'face 'all-the-icons-orange)
              :priority_c   ,(propertize "■" 'face 'all-the-icons-yellow)
              :priority_d   ,(propertize "⬇" 'face 'all-the-icons-green)
              :priority_e   ,(propertize "❓" 'face 'all-the-icons-blue)
              :em_dash       "—"))
  (set-ligatures! 'org-mode
    :merge t
    :checkbox      "[ ]"
    :pending       "[-]"
    :checkedbox    "[X]"
    :list_property "::"
    :results       "#+results:"
    :property      "#+property:"
    :property      ":PROPERTIES:"
    :end           ":END:"
    :options       "#+options:"
    :title         "#+title:"
    :subtitle      "#+subtitle:"
    :author        "#+author:"
    :date          "#+date:"
    :latex_class   "#+latex_class:"
    :latex_header  "#+latex_header:"
    :beamer_header "#+beamer_header:"
    :begin_quote   "#+begin_quote"
    :end_quote     "#+end_quote"
    :begin_export  "#+begin_export"
    :end_export    "#+end_export"
    :priority_a    "[#A]"
    :priority_b    "[#B]"
    :priority_c    "[#C]"
    :priority_d    "[#D]"
    :priority_e    "[#E]"
    :em_dash       "---"))
(plist-put +ligatures-extra-symbols :name "⁍") ; or › could be good?

(provide '+org)
;;; +org ends here
