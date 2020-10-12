;;; ~/.doom.d/autoload/org.el -*- lexical-binding: t; -*-

;;;###autoload (autoload '+gas/org-babel-hydra/body "~/.doom.d/autoload/org.el" nil t)
(defhydra +gas/org-babel-hydra (:hint nil)
    "
Org-Babel:
_n_:next      _c_:clear results  _i_:show all
_p_:previous  _h_:show/hide      _I_:hide all
_e_:edit      _RET_:execute      _l_:center screen
_g_:goto      _s_:split          _q_:cancel
"
    ("c" org-babel-remove-result)
    ("RET" org-babel-execute-src-block)
    ("e" org-edit-src-code)
    ("h" org-hide-block-toggle-maybe)
    ("s" org-babel-demarcate-block)
    ("g" org-babel-goto-named-src-block)
    ("i" org-show-block-all)
    ("I" org-hide-block-all)
    ("n" org-babel-next-src-block)
    ("p" org-babel-previous-src-block)
    ("l" recenter-top-bottom)
    ("q" nil :color blue))


;;;###autoload (autoload '+gas/clock-in-organisation-task-as-default "~/.doom.d/autoload/org.el" nil t)
 (defun gas/clock-in-organisation-task-as-default ()
          (interactive)
          (org-with-point-at (org-id-find gas/organisation-task-id 'marker)
            (org-clock-in '(16)))
          )

;;;###autoload (autoload '+gas/clock-in-default-task "~/.doom.d/autoload/org.el" nil t)
(defun gas/clock-in-default-task ()
          (save-excursion
            (org-with-point-at org-clock-default-task
              (org-clock-in))))

;; gas-punch-in
;; not sure how autoload -works
;;;###autoload (autoload '+gas/punch-in "~/.doom.d/autoload/org.el" nil t)
 (defun gas/punch-in (arg)
          "Start continuous clocking and set the default task to the
     selected task.  If no task is selected set the Organization task
     as the default task."
          (interactive "p")
          (setq gas/keep-clock-running t)
          (if (equal major-mode 'org-agenda-mode)
              ;;
              ;; We're in the agenda
              ;;
              (let* ((marker (org-get-at-bol 'org-hd-marker))
                     (tags (org-with-point-at marker (org-get-tags-at))))
                (if (and (eq arg 4) tags)
                    (org-agenda-clock-in '(16))
                  (gas/clock-in-organisation-task-as-default)))
            ;;
            ;; We are not in the agenda
            ;;
            (save-restriction
              (widen)
              ;; Find the tags on the current task
              (if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)) (eq arg 4))
                  (org-pomodoro '(16))
                (gas/clock-in-organisation-task-as-default)))))

;;;###autoload (autoload '+gas/punch-out "~/.doom.d/autoload/org.el" nil t)
 (defun gas/punch-out ()
          (interactive)
          (setq gas/keep-clock-running nil)
          (when (org-clock-is-active)
            (org-clock-out))
          (org-agenda-remove-restriction-lock))

;; Look in the arguments of source blocks for `:hidden' and hide those blocks
;; https://emacs.stackexchange.com/a/44923/9401
;;;###autoload (autoload '+gas/hide-source-blocks-maybe "~/.doom.d/autoload/org.el" nil t)
(defun +gas/hide-source-blocks-maybe ()
  "Fold blocks in the current buffer that have the argument `:hidden'."
  (interactive)
  (org-block-map
   (lambda ()
     (let ((case-fold-search t))
       (when (cl-assoc ':hidden (cl-third (org-babel-get-src-block-info)))
         (org-hide-block-toggle))))))
