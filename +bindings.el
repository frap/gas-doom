;;; +bindings.el -*- lexical-binding: t; -*-

(if IS-MAC (setq
             mac-right-command-modifier 'super
             mac-command-modifier 'super
             mac-option-modifier 'meta
             mac-left-option-modifier 'meta
             mac-right-option-modifier 'hyper
             ))


(after! org
  (map! :leader
  (:prefix-map ("a" . "applications")
    (:prefix ("r" . "roam")
      :desc "org-roam" "l" #'org-roam
      :desc "org-roam-insert" "i" #'org-roam-insert
      :desc "org-roam-switch-to-buffer" "b" #'org-roam-switch-to-buffer
      :desc "org-roam-find-file" "f" #'org-roam-find-file
      :desc "org-roam-show-graph" "g" #'org-roam-show-graph
      :desc "org-roam-insert" "i" #'org-roam-insert
      :desc "org-roam-capture" "c" #'org-roam-capture)
    (:prefix ("s" . "spaced-repetition")
      :desc "org-fc-hydra" "h" #'org-fc-hydra/body
    )
    (:prefix ("j" . "journal")
         :desc "New journal entry" "j" #'org-journal-new-entry
      :desc "Search journal entry" "s" #'org-journal-search)))
  )



;; Prefix key to invoke doom related commands
;(setq doom-leader-alt-key "C-c")
;(setq doom-localleader-alt-key "C-c l")

;(setq mac-option-modifier 'meta)
;(setq mac-command-modifier 'super)

;; (map!
;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Defaults
;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Text scaling
;;  "<C-mouse-4>" #'text-scale-increase
;;  "<C-mouse-5>" #'text-scale-decrease
;;  "<C-down-mouse-2>" (λ! (text-scale-set 0))
;;  "M-+" (λ! (text-scale-set 0))
;;  "M-=" #'text-scale-increase
;;  "M--" #'text-scale-decrease
;;  "C-+" 'text-scale-increase
;;  "C--" 'text-scale-decrease
;;  (:when (featurep! :completion ivy)
;;    "C-S-s"        #'swiper
;;    "C-S-r"        #'ivy-resume)

;;  "C-a" 'beginning-of-line

;;  "M-b" 'backward-word
;;  "M-f" 'forward-word

;;  "M-v" 'scroll-down-command
;;  "C-v" 'scroll-up-command

;;  "M-w" 'copy-region-as-kill
;;  "s-c" 'copy-region-as-kill

;;  ;; smartparens
;;  "C-M-a" #'sp-beginning-of-sexp
;;  "C-M-e" #'sp-end-of-sexp
;;  "C-M-f" #'sp-forward-sexp
;;  "C-M-b" #'sp-backward-sexp
;;  "C-M-d" #'sp-splice-sexp
;;  ;; company mode
;;  "<C-tab>" #'+company/complete
;;  ;; Counsel Bindings
;;  "C-h b" #'counsel-descbinds
;;  ;; Repl Toggle
;;  "C-c C-z" #'+eval/open-repl

;;  "M-x"           #'execute-extended-command
;;  "C-x C-b"       #'ibuffer-list-buffers
;;  "M-n"           #'+boy/down-scroll
;;  "M-p"           #'+boy/up-scroll
;;  "M-d"           #'+boy/delete-word
;;  "C-M-<backspace>" #'sp-backward-kill-sexp
;;  "<M-backspace>" #'+boy/backward-delete-word
;;  "C-k"           #'+boy/kill-line
;;  "C-M-q"         #'+boy/unfill-paragraph
;;  "S-<f1>"        #'+boy/macro-on
;;  "<f1>"          #'call-last-kbd-macro
;;  ;; Editor related bindings
;;  "C-a"           #'doom/backward-to-bol-or-indent
;;  [remap newline] #'newline-and-indent
;;  ;"C-j"           #'+default/newline


;;  ;; Buffer related bindings
;;  "C-x b"       #'persp-switch-to-buffer
;;  "C-x C-b"     #'ibuffer-list-buffers
;;  "C-x B"       #'switch-to-buffer
;;  "C-x k"       #'doom/kill-this-buffer-in-all-windows
;;  ;; Popup bindigns
;;  "C-x p"   #'+popup/other
;;  "C-`"     #'+popup/toggle
;;  "C-~"     #'+popup/raise
;;  "C-x C-o" #'+boy/switch-to-last-window
;;  "C-x O"   #'switch-window-then-swap-buffer
;;  "s-z"     #'undo
;;  "s-Z"     #'redo
;;  "s-s"     #'save-buffer
;;  "s-w"     #'delete-window
;;  "s-v"     #'yank

;;  ;; Restore common editing keys (and ESC) in minibuffer
;;  (:map (minibuffer-local-map
;;         minibuffer-local-ns-map
;;         minibuffer-local-completion-map
;;         minibuffer-local-must-match-map
;;         minibuffer-local-isearch-map
;;         read-expression-map)
;;    "C-g" #'abort-recursive-edit
;;    "C-a" #'move-beginning-of-line)

;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Doom
;;  ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;  (:leader

;;    (:prefix ("d" . "doom")
;;      :desc "Dashboard"                 "d" #'+doom-dashboard/open
;;      :desc "Recent files"              "f" #'recentf-open-files
;;      (:when (featurep! :ui neotree)
;;        :desc "Open neotree"            "n" #'+neotree/open
;;        :desc "File in neotree"         "N" #'neotree/find-this-file)
;;      (:when (featurep! :ui treemacs)
;;        :desc "Toggle treemacs"         "n" #'+treemacs/toggle
;;        :desc "File in treemacs"        "N" #'+treemacs/find-file)
;;      :desc "Popup other"               "o" #'+popup/other
;;      :desc "Popup toggle"              "t" #'+popup/toggle
;;      :desc "Popup close"               "c" #'+popup/close
;;      :desc "Popup close all"           "C" #'+popup/close-all
;;      :desc "Popup raise"               "r" #'+popup/raise
;;      :desc "Popup restore"             "R" #'+popup/restore
;;      :desc "Scratch buffer"            "s" #'doom/open-scratch-buffer
;;      :desc "Switch to scratch buffer"  "S" #'doom/switch-to-scratch-buffer
;;      :desc "Sudo this file"            "u" #'doom/sudo-this-file
;;      :desc "Sudo find file"            "U" #'doom/sudo-find-file
;;      :desc "Terminal popup"            "l" #'+term/open-popup
;;      :desc "Terminal open"             "L" #'+term/open
;;      :desc "Reload Private Config"     "R" #'doom/reload
;;      :desc "Open Lisp REPL"            ";" #'+eval/open-repl
;;      :desc "Toggle frame fullscreen"   "F" #'toggle-frame-fullscreen
;;      :desc "Toggle modal edition mode" "m" #'modalka-global-mode)

;;    (:prefix ("e" . "editor")
;;      :desc "iedit"                "e" #'iedit-mode
;;      :desc "Switch header/source" "s" #'ff-find-other-file
;;      :desc "Make header"          "m" #'make-header
;;      :desc "Make box comment"     "c" #'make-box-comment
;;      :desc "Make divider"         "d" #'make-divider
;;      :desc "Make revision"        "r" #'make-revision
;;      :desc "Update file header"   "g" #'update-file-header
;;      :desc "Duplicate line"       "l" #'+private/duplicate-line)

;;    "o" nil

;;    (:prefix ("o". "org")
;;      :desc "Do what I mean"           "o"   #'+org/dwim-at-point
;;      :desc "Sync org caldav"          "s"   #'org-caldav-sync

;;      :desc "Capture"                  "c"   #'org-capture
;;      :desc "Goto capture"             "C"   (λ! (require 'org-capture) (call-interactively #'org-capture-goto-target))
;;      :desc "Switch org buffers"       "b"   #'org-switchb
;;      (:prefix ("e" . "org export")
;;        :desc "Export beamer to latex" "l b" #'org-beamer-export-to-latex
;;        :desc "Export beamer as latex" "l B" #'org-beamer-export-as-latex
;;        :desc "Export beamer as pdf"   "l P" #'org-beamer-export-to-pdf)
;;      :desc "Link store"               "l"   #'org-store-link)

;;    "a" nil
;;    (:prefix ("a" . "org agenda")
;;        :desc "Agenda"                 "a"   #'org-agenda
;;        :desc "Capture"                "c"   #'org-capture
;;        :desc "Todo list"              "t"   #'org-todo-list
;;        :desc "Tags view"              "m"   #'org-tags-view
;;        :desc "View search"            "v"   #'org-search-view)
;;  ;; Quit/Restart
;;    (:prefix ("q" . "quit/restart")
;;      :desc "Quit Emacs"                   "q" #'kill-emacs
;;      :desc "Save and quit Emacs"          "Q" #'save-buffers-kill-terminal
;;      (:when (featurep! :feature workspaces)
;;        :desc "Quit Emacs & forget session"  "X" #'+workspace/kill-session-and-quit
;;        :desc "Restart & restore Emacs"      "r" #'+workspace/restart-emacs-then-restore)
;;      :desc "Restart Emacs"                "R" #'restart-emacs)
;;    ;; Snippets
;;    "&" nil ; yasnippet creates this prefix, we use a different one

;;    (:prefix ("s" . "snippets")
;;      :desc "New snippet"           "n" #'yas-new-snippet
;;      :desc "Insert snippet"        "i" #'yas-insert-snippet
;;      :desc "Find global snippet"   "v" #'yas-visit-snippet-file
;;      :desc "Reload snippets"       "r" #'yas-reload-all)

;;    (:prefix ("v" . "versioning")
;;      :desc "Browse issues tracker" "i" #'+vc/git-browse-issues
;;      :desc "Browse remote"         "o" #'+vc/git-browse
;;      :desc "Diff current file"     "d" #'magit-diff-buffer-file
;;      :desc "Git revert hunk"       "r" #'git-gutter:revert-hunk
;;      :desc "Git stage file"        "S" #'magit-stage-file
;;      :desc "Git stage hunk"        "s" #'git-gutter:stage-hunk
;;      :desc "Git time machine"      "t" #'git-timemachine-toggle
;;      :desc "Git unstage file"      "U" #'magit-unstage-file
;;      :desc "Initialize repo"       "I" #'magit-init
;;      :desc "List repositories"     "L" #'magit-list-repositories
;;      :desc "Magit blame"           "b" #'magit-blame-addition
;;      :desc "Magit buffer log"      "l" #'magit-log-buffer-file
;;      :desc "Magit commit"          "c" #'magit-commit-create
;;      :desc "Magit status"          "m" #'magit-status
;;      :desc "Next hunk"             "]" #'git-gutter:next-hunk
;;      :desc "Previous hunk"         "[" #'git-gutter:previous-hunk)

;;    (:prefix ("w". "workspaces")
;;      :desc "Autosave session"             "a" #'+workspace/save-session
;;      :desc "Display workspaces"           "d" #'+workspace/display
;;      :desc "Rename workspace"             "r" #'+workspace/rename
;;      :desc "Create workspace"             "c" #'+workspace/new
;;      :desc "Delete workspace"             "k" #'+workspace/delete
;;      :desc "Save session"                 "s" (λ! (let ((current-prefix-arg '(4))) (call-interactively #'+workspace/save-session)))
;;      :desc "Save workspace"               "S" #'+workspace/save
;;      :desc "Load session"                 "l" #'+workspace/load-session
;;      :desc "Load last autosaved session"  "L" #'+workspace/load-last-session
;;      :desc "Kill other buffers"           "o" #'doom/kill-other-buffers
;;      :desc "Undo window config"           "u" #'winner-undo
;;      :desc "Redo window config"           "U" #'winner-redo
;;      :desc "Switch to left workspace"     "p" #'+workspace/switch-left
;;      :desc "Switch to right workspace"    "n" #'+workspace/switch-right
;;      :desc "Switch to workspace 1"        "1" (λ! (+workspace/switch-to 0))
;;      :desc "Switch to workspace 2"        "2" (λ! (+workspace/switch-to 1))
;;      :desc "Switch to workspace 3"        "3" (λ! (+workspace/switch-to 2))
;;      :desc "Switch to workspace 4"        "4" (λ! (+workspace/switch-to 3))
;;      :desc "Switch to workspace 5"        "5" (λ! (+workspace/switch-to 4))
;;      :desc "Switch to workspace 6"        "6" (λ! (+workspace/switch-to 5))
;;      :desc "Switch to workspace 7"        "7" (λ! (+workspace/switch-to 6))
;;      :desc "Switch to workspace 8"        "8" (λ! (+workspace/switch-to 7))
;;      :desc "Switch to workspace 9"        "9" (λ! (+workspace/switch-to 8))
;;      :desc "Switch to last workspace"     "0" #'+workspace/switch-to-last)

;;    (:when (featurep! :editor multiple-cursors)
;;      (:prefix ("m" . "multiple cursors")
;;        :desc "Edit lines"         "l"         #'mc/edit-lines
;;        :desc "Mark next"          "n"         #'mc/mark-next-like-this
;;        :desc "Unmark next"        "N"         #'mc/unmark-next-like-this
;;        :desc "Mark previous"      "p"         #'mc/mark-previous-like-this
;;        :desc "Unmark previous"    "P"         #'mc/unmark-previous-like-this
;;        :desc "Mark all"           "t"         #'mc/mark-all-like-this
;;        :desc "Mark all DWIM"      "m"         #'mc/mark-all-like-this-dwim
;;        :desc "Edit line endings"  "e"         #'mc/edit-ends-of-lines
;;        :desc "Edit line starts"   "a"         #'mc/edit-beginnings-of-lines
;;        :desc "Mark tag"           "s"         #'mc/mark-sgml-tag-pair
;;        :desc "Mark in defun"      "d"         #'mc/mark-all-like-this-in-defun
;;        :desc "Add cursor w/mouse" "<mouse-1>" #'mc/add-cursor-on-click)))

;;  (:after smartparens
;;    (:map smartparens-mode-map
;;      "C-M-a"     #'sp-beginning-of-sexp
;;      "C-M-e"     #'sp-end-of-sexp
;;      "C-M-f"     #'sp-forward-sexp
;;      "C-M-b"     #'sp-backward-sexp
;;      "C-M-d"     #'sp-splice-sexp
;;      "C-M-k"     #'sp-kill-sexp
;;      "C-M-t"     #'sp-transpose-sexp
;;      "C-<right>" #'sp-forward-slurp-sexp
;;      "M-<right>" #'sp-forward-barf-sexp
;;      "C-<left>"  #'sp-backward-slurp-sexp
;;      "M-<left>"  #'sp-backward-barf-sexp))

;;  (:when (featurep! :completion ivy)
;;    (:after counsel
;;      (:map counsel-ag-map
;;        [backtab]  #'+ivy/wgrep-occur      ; search/replace on results
;;        "C-SPC"    #'ivy-call-and-recenter ; preview
;;        "M-RET"    (+ivy-do-action! #'+ivy-git-grep-other-window-action))
;;      "C-h b" #'counsel-descbinds
;;      "C-M-y" #'counsel-yank-pop
;;      "C-h F" #'counsel-faces
;;      "C-h p" #'counsel-package
;;      "C-h a" #'counsel-apropos
;;      "C-h V" #'counsel-set-variable
;;      "C-'"   #'counsel-imenu))

;;  (:after company
;;    (:map company-active-map
;;      "C-o"        #'company-search-kill-others
;;      "C-n"        #'company-select-next
;;      "C-p"        #'company-select-previous
;;      "C-h"        #'company-quickhelp-manual-begin
;;      "C-S-h"      #'company-show-doc-buffer
;;      "C-s"        #'company-search-candidates
;;      "M-s"        #'company-filter-candidates
;;      "<C-tab>"    #'company-complete-common-or-cycle
;;      [tab]        #'company-complete-common-or-cycle
;;      [backtab]    #'company-select-previous
;;      "C-RET"      #'counsel-company)
;;    (:map company-search-map
;;      "C-n"        #'company-search-repeat-forward
;;      "C-p"        #'company-search-repeat-backward
;;      "C-s"        (λ! (company-search-abort) (company-filter-candidates))))

;;  (:after neotree
;;    :map neotree-mode-map
;;    "q"       #'neotree-hide
;;    [return]  #'neotree-enter
;;    "RET"     #'neotree-enter
;;    "SPC"     #'neotree-quick-look
;;    "v"       #'neotree-enter-vertical-split
;;    "s"       #'neotree-enter-horizontal-split
;;    "c"       #'neotree-create-node
;;    "d"       #'neotree-delete-node
;;    "g"       #'neotree-refresh
;;    "r"       #'neotree-rename-node
;;    "R"       #'neotree-refresh
;;    "h"       #'+neotree/collapse-or-up
;;    "l"       #'+neotree/expand-or-open
;;    "n"       #'neotree-next-line
;;    "p"       #'neotree-previous-line
;;    "N"       #'neotree-select-next-sibling-node
;;    "P"       #'neotree-select-previous-sibling-node)

;;  (:after help-mode
;;    (:map help-mode-map
;;      "o" #'ace-link-help
;;      ">" #'help-go-forward
;;      "<" #'help-go-back))

;;  (:after info
;;    (:map Info-mode-map
;;      "o" #'ace-link-info))

;;  ;; Yasnippet
;;  (:after yasnippet
;;    ;; keymap while editing an inserted snippet
;;    (:map yas-keymap
;;      "C-e"           #'snippets/goto-end-of-field
;;      "C-a"           #'snippets/goto-start-of-field
;;      "<S-tab>"       #'yas-prev-field
;;      "<M-backspace>" #'+snippets/delete-to-start-of-field
;;      [backspace]     #'+snippets/delete-backward-char
;;      [delete]        #'+snippets/delete-forward-char-or-field))

;;  ;; Flycheck
;;  (:after flycheck
;;    (:map flycheck-error-list-mode-map
;;      "C-n" #'flycheck-error-list-next-error
;;      "C-p" #'flycheck-error-list-previous-error
;;      "RET" #'flycheck-error-list-goto-error))

;;  (:after ivy
;;    (:map ivy-minibuffer-map
;;      "TAB" #'ivy-alt-done
;;      "C-g" #'keyboard-escape-quit)))


;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;
;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; (setq persp-keymap-prefix (kbd "C-c e"))

;; (after! projectile
;;   (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Which key hints
;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (which-key-add-key-based-replacements "C-c d" "doom")
;; (which-key-add-key-based-replacements "C-c e" "editor")
;; (which-key-add-key-based-replacements "C-c o" "org")
;; (which-key-add-key-based-replacements "C-c m" "multiple")
;; (which-key-add-key-based-replacements "C-c p" "projects")
;; (which-key-add-key-based-replacements "C-c s" "snippets")
;; (which-key-add-key-based-replacements "C-c v" "versioning")
;; (which-key-add-key-based-replacements "C-c w" "workspace")
;; (which-key-add-key-based-replacements "C-c !" "checking")

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide '+bindings)

;;; +bindings.el ends here
