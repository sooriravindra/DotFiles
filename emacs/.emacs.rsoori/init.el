(setq-default rs/literate-config
              (concat user-emacs-directory "config.org")
              rs/bindings-file
              (concat user-emacs-directory "bindings.el")
              custom-file
              (concat user-emacs-directory "custom.el")
              rs/early-init-file
              (concat user-emacs-directory "early-init.el")
              rs/early-init-exists
              (file-exists-p rs/early-init-file))

;; Generate rs/bindings-file if it doesn't exist
(unless (file-exists-p rs/bindings-file)
  (find-file rs/literate-config)
  (setq org-confirm-babel-evaluate nil)
  (org-babel-goto-named-src-block "gen-bindings-src")
  (org-babel-execute-src-block)
  (setq org-confirm-babel-evaluate t)
  (set-buffer-modified-p nil)
  (kill-current-buffer))

;; Load rs/literate-config
(org-babel-load-file rs/literate-config)

(unless rs/early-init-exists restart-emacs)
