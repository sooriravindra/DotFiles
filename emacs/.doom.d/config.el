;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(defun rsoori/notify-update (process event)
  (if (string= event "finished\n")
      (progn
        (kill-buffer "*rsoori-gtasks*")
        (princ "Gtasks synced!!")
        )
    (princ (format "%s :: %s" process event))
    ))

(defun rsoori/sync-tasklist ()
  (progn
    (write-region nil nil "/home/rsoori/tmp/todo.org")
    (start-process "gtasks-sync" "*rsoori-gtasks*" "/home/rsoori/.local/bin/michel-orgmode" "--push" "--orgfile" "/home/rsoori/tmp/todo.org" "--listname" "ThingsToDo")
    (set-process-sentinel (get-process "gtasks-sync") 'rsoori/notify-update)
    t))

(defun rsoori/gtasks ()
  (interactive)
  (call-process "/home/rsoori/.local/bin/michel-orgmode" nil nil nil "--pull" "--listname" "ThingsToDo" "--orgfile" "/home/rsoori/tmp/todo.org")
  (find-file "/home/rsoori/tmp/todo.org")
  (org-shifttab 2)
  (add-hook 'write-contents-functions 'rsoori/sync-tasklist nil t)
  )
