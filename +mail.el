;;; ~/.doom.d/+mail.el -*- lexical-binding: t; -*-

(setq mu4e-mu-binary "/usr/local/bin/mu")

(set-email-account! "atea"
  '((mu4e-sent-folder       . "/atea/sent")
    (mu4e-drafts-folder     . "/atea/drafts")
    (mu4e-trash-folder      . "/atea/trash")
    (mu4e-refile-folder     . "/atea/all")
    (smtpmail-smtp-user     . "agasson@ateasystems.com")
    (user-mail-address      . "agasson@ateasystems.com")
    (mu4e-compose-signature . "\nAndrés Gasson(Gas)"))
  t)
