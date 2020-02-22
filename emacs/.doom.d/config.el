;;; .doom.d/config.el --- -*- lexical-binding: t; -*-
;;; Commentary:
;; gtasks syncs google tasks to an org buffer.

;;; Code:

(defvar rsoori/gtasks-file "/home/rsoori/tmp/todo.org")
(defvar rsoori/michel-exe "/home/rsoori/.local/bin/michel-orgmode")
(defvar rsoori/gtasks-list-name "ThingsToDo")
(defvar rsoori/gtasks-buf "*rsoori-gtasks*")
(defvar rsoori/gtasks-proc "gtasks-sync")

(defun rsoori/notify-update (process event)
  "Notify when PROCESS posts an EVENT."
  (if (string= event "finished\n")
      (progn
        (kill-buffer rsoori/gtasks-buf)
        (princ "Gtasks synced!!")
        )
    (princ (format "%s :: %s" process event))
    ))

(defun rsoori/sync-tasklist ()
  "Function to sync the current buffer to the gtasks-file."
  (progn
    (if (get-process rsoori/gtasks-proc) (kill-process rsoori/gtasks-proc))
    (write-region nil nil rsoori/gtasks-file)
    (start-process rsoori/gtasks-proc rsoori/gtasks-buf rsoori/michel-exe "--push" "--orgfile" rsoori/gtasks-file "--listname" rsoori/gtasks-list-name)
    (set-process-sentinel (get-process rsoori/gtasks-proc) 'rsoori/notify-update)
    t))

(defun rsoori/gtasks ()
  "Function to pull the tasks from Gtasks and show it in an org buffer."
  (interactive)
  (call-process rsoori/michel-exe nil nil nil "--pull" "--listname" rsoori/gtasks-list-name "--orgfile" rsoori/gtasks-file)
  (find-file rsoori/gtasks-file)
  (org-mode)
  (org-shifttab 2)
  (add-hook 'write-contents-functions 'rsoori/sync-tasklist nil t)
  )

(provide 'config.el)
;;; config.el ends here
