(setq gc-cons-threshold most-positive-fixnum ; 2^61 bytes
      gc-cons-percentage 0.6)
(add-hook 'after-init-hook #'(lambda ()
                               ;; restore after startup
                               (setq gc-cons-threshold (* 16 1024 1024)
                                     gc-cons-percentage 0.1)))

;; Measure time for startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs init in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

(setq frame-inhibit-implied-resize t)

;; Set font size and dracula theme's bg color to prevent flicker
(set-face-attribute 'default nil :background "#282a36" :height 200)

;; Display line numbers
(global-display-line-numbers-mode t)

;; Show column number in mode-line
(column-number-mode)

;; Don't show startup page
(setq inhibit-startup-message t)

;; Hide scrollbar, toolbar, menubar and tool tips
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
