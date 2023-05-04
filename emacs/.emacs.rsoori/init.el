(setq rs/early-init-exists
      (file-exists-p (concat user-emacs-directory "early-init.el")))
(org-babel-load-file (concat user-emacs-directory "config.org"))
