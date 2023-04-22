;; Author  : Raveendra Soori
;; Created : 7th April 2023

;; Convenient constants to be used later
(defconst EMACS27+ (not (version< emacs-version "27")))
(defconst EMACS28+ (not (version< emacs-version "28")))

;; load early-init.el in earlier versions
(when (not EMACS27+)
  (load (concat user-emacs-directory "early-init.el")))

;; Initialize package sources
(require 'package)

;; Enable obtaining packages from melpa and elpa devel (required for compat-28.x)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa-devel" . "https://elpa.gnu.org/devel/")))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

;; Club generic config here 
(use-package emacs
  :config
  (global-set-key (kbd "<escape>") 'keyboard-escape-quit)
  ;; C-u is used to scroll, use C-M-u as alternative for universal argument
  (global-set-key (kbd "C-M-u") 'universal-argument)
  (setq-default custom-file (concat user-emacs-directory "custom-file.el")
                native-comp-async-report-warnings-errors nil
                indent-tabs-mode nil
                use-package-always-ensure t
                create-lockfiles nil
                visible-bell t
                frame-title-format '("Evil Emacs - %b"))
  ;; Disable line numbers for some modes
  (dolist (mode '(org-mode-hook
                  term-mode-hook
                  vterm-mode-hook
                  shell-mode-hook
                  treemacs-mode-hook
                  eshell-mode-hook))
    (add-hook mode (lambda () (display-line-numbers-mode 0))))
  ;; Use y/n instead of yes/no
  (if EMACS28+ (setq-default use-short-answers t) (fset 'yes-or-no-p 'y-or-n-p))
  ;; Prompt for Gpg password in minibuffer
  (set (if EMACS27+ 'epg-pinentry-mode 'epa-pinentry-mode) 'loopback)
  (show-paren-mode 1)
  (global-visual-line-mode t))

;; Keep things organized
(use-package no-littering
  :config (setq auto-save-file-name-transforms
                `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

;; Profiler
(use-package esup
  :defer t
  :pin melpa
  :config (setq esup-depth 0))

;; Show keystrokes in a buffer
(use-package command-log-mode
  :defer 2
  :commands command-log-mode)

;; Vim you shall
(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-set-undo-system 'undo-redo)
  (evil-select-search-module 'evil-search-module 'evil-search)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

;; Save command history
(use-package savehist
  :config (savehist-mode t))

;; Completion system
(use-package vertico
  :init (vertico-mode)
  :config (setq vertico-cycle t))

;; Orderless completion style
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Commands that make use of completion
(use-package consult
  :defer t)

;; Add annotations to minibuffer completion
(use-package marginalia
  :bind
  (:map minibuffer-local-map
        ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

;; Themes
(use-package doom-themes
  :init (load-theme 'doom-dracula t))

(use-package all-the-icons)

;; Cool mode-line
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config (setq doom-modeline-modal-icon nil)) ;; Let's use text

;; Apparently the best git interface
(use-package magit
  :bind ("C-x g" . magit-status))

;; Better help
(use-package helpful
  :defer t
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key))

;; Morreee Vim
(use-package evil-collection
  :after evil
  :config (evil-collection-init))

;; Highlight cursor
(use-package beacon
  :defer t)

;; Show possible keys and bindings
(use-package which-key
  :config (which-key-mode))

;; Frame wide text scaling
(use-package default-text-scale
  :config (default-text-scale-mode 1))

;; Git gutter
(use-package git-gutter
  :hook (prog-mode . git-gutter-mode)
  :config
  (setq git-gutter:update-interval 0.02))

(use-package git-gutter-fringe
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom))

;; The most loved terminal in Emacs
(use-package vterm
  :if (eq system-type `gnu/linux)
  :defer t)

;; Hide modeline
(use-package hide-mode-line
  :defer t)

;; Distraction free writing
(use-package olivetti
  :defer t)

;; Handy command to restart
(use-package restart-emacs
  :defer t)

;; Cat in the modeline
(use-package nyan-mode
  :defer t)

;; Text completion framework
(use-package company
  :hook (prog-mode . company-mode)
  :bind (:map company-active-map
              ("<return>" . nil)
              ("RET" . nil)
              ("<tab>" . company-complete-selection)))

;; Fancier bullets for org mode
(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;; UI for org-roam mode
(use-package org-roam-ui
  :defer t)

;; Custom functions

(defun rsoori/zen-mode--get-mode-var (mode)
  "Returns t if MODE is set to non-nil else returns -1"
  (if (boundp mode) (if (eq (eval mode) nil) -1 t) -1))

(defun rsoori/zen-mode ()
  "Zen mode for intense focus"
  (interactive)
  (if (and (boundp 'rsoori/zen-mode)
           (eq rsoori/zen-mode 1))
      (progn
        (display-line-numbers-mode rsoori/zen-mode-restore-line-num)
        (hide-mode-line-mode rsoori/zen-mode-restore-mode-line)
        (olivetti-mode -1)
        (setq rsoori/zen-mode 0))
    (progn
      (make-local-variable 'rsoori/zen-mode)
      (make-local-variable 'rsoori/zen-mode-restore-line-num)
      (make-local-variable 'rsoori/zen-mode-restore-mode-line)
      (setq rsoori/zen-mode-restore-line-num
            (rsoori/zen-mode--get-mode-var 'display-line-numbers-mode))
      (setq rsoori/zen-mode-restore-mode-line
            (rsoori/zen-mode--get-mode-var 'hide-mode-line-mode))
      (display-line-numbers-mode 0)
      (hide-mode-line-mode t)
      (olivetti-mode t)
      (setq rsoori/zen-mode 1))))

;; Finally load the custom file
(load-file custom-file)
