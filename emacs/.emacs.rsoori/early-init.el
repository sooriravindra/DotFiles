;; Garbage collector trick to speed up init
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

;; Preventing frame resize saves some time
(setq frame-inhibit-implied-resize t)

;; Set font size and dracula theme's bg color to prevent flicker
(set-face-attribute 'default nil
                    :foreground "#ffffff"
                    :background "#282a36"
                    :height 200)

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

(defun rsoori/mode-line-format (left right)
  "Return a string of `window-width' length.
Containing LEFT, and RIGHT aligned respectively."
  (let ((available-width (- (window-width) (length left) 1)))
    (format (format "%%s %%%ds " available-width) left right)))

(defface evil-mode-line-face '((t (:foreground  "black"
                                                :background "orange")))
  "Face for evil state in mode-line.")

(setq-default
 mode-line-format
 '((:eval (rsoori/mode-line-format
           ;; left portion
           (format-mode-line
            (quote ("%e"
                    (:eval
                     (when (bound-and-true-p evil-local-mode)
                       (let ((formatted-evil-state
                              (concat
                               " "
                               (upcase
                                (substring (symbol-name evil-state) 0 1))
                               (substring (symbol-name evil-state) 1)
                               " "))) ;; normal -> Normal
                         (if (mode-line-window-selected-p)
                             (propertize formatted-evil-state
                                         'face 'evil-mode-line-face)
                           (propertize formatted-evil-state)))))
                    " " (:eval (when (buffer-modified-p) "[+]"))
                    " " mode-line-buffer-identification
                    " %l:%c")))
           ;; right portion
           (format-mode-line (quote ("%m " (vc-mode vc-mode))))))))
