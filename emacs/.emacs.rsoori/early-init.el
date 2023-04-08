;; Default dark theme to make emacs dark until real dark theme is loaded
(load-theme 'tango-dark)

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
