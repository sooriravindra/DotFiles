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
                bindings-file (concat user-emacs-directory "bindings.el")
                bindings-source-file
                (concat user-emacs-directory "bindings.org")
                native-comp-async-report-warnings-errors nil
                indent-tabs-mode nil
                use-package-always-ensure t
                create-lockfiles nil
                visible-bell t
                make-backup-files nil
                confirm-kill-emacs #'y-or-n-p
                find-file-visit-truename t
                frame-title-format '("Evil Emacs - %b"))
  ;; Disable line numbers for some modes
  (dolist (mode '(term-mode-hook
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
  (winner-mode 1)
  (global-visual-line-mode 1))

;; Keep things organized
(use-package no-littering
  :config (setq auto-save-file-name-transforms
                `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

;; org-mode
(use-package org
  :config
  (dolist (face '((org-document-title . 1.8)
                  (org-level-1 . 1.5)
                  (org-level-2 . 1.3)
                  (org-level-3 . 1.2)
                  (org-level-4 . 1.1)
                  (org-level-5 . 1.0)
                  (org-level-6 . 1.0)
                  (org-level-7 . 1.0)
                  (org-level-8 . 1.0)))
    (set-face-attribute (car face) nil :weight 'regular :height (cdr face)))
  (setq org-hide-emphasis-markers t)
  :hook (org-mode . org-indent-mode)
  :defer t)

;; Profiler
(use-package esup
  :defer t
  :pin melpa
  :config (setq esup-depth 0))

;; Show keystrokes in a buffer
(use-package command-log-mode
  :defer t
  :commands command-log-mode)

;; Vim you shall
(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-set-undo-system 'undo-redo)
  (evil-select-search-module 'evil-search-module 'evil-search)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)
  ;; Make <ctrl><space> leader in all modes
  (evil-set-leader nil (kbd "C-SPC"))
  ;; In addition, make <space> leader in normal and visual mode.
  (evil-set-leader 'normal (kbd "SPC"))
  (evil-set-leader 'visual (kbd "SPC"))
  ;; Local leader is <leader> m
  (evil-set-leader nil (kbd "<leader> m") t)
  (evil-ex-define-cmd "smile" '(lambda () (interactive) (message ":D"))))

(use-package async
  :defer t)

;; Save command history
(use-package savehist
  :config (savehist-mode t))

;; Completion system
(use-package vertico
  :init (vertico-mode)
  :config
  (setq vertico-posframe-parameters
        '((left-fringe . 20)
          (right-fringe . 20)))
  (setq vertico-cycle t))

;; Display vertico in posframe
(use-package vertico-posframe
  :config (vertico-posframe-mode 1))

;; Orderless completion style
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Commands that make use of completion
(use-package consult
  :init
  (setq completion-in-region-function
        (lambda (&rest args)
          (apply (if vertico-mode
                     #'consult-completion-in-region
                   #'completion--in-region)
                 args)))
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

(use-package all-the-icons
  :defer t)

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

;; Snipe 'em
(use-package evil-snipe
  :config (evil-snipe-mode 1))

;; Commenting
(use-package evil-commentary
  :config (evil-commentary-mode 1))

;; Use gs to make jumps
(use-package evil-easymotion
  :config (evilem-default-keybindings "gs"))

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

;; Fuzzy finder
(use-package affe
  :init
  (setq affe-find-command "rg --color=never --no-ignore --hidden --files")
  (setq affe-grep-command "rg --null --color=never --max-columns=1000 --no-heading --line-number --no-ignore --hidden -v ^$")
  :defer t)

;; Still editing vim config files?
(use-package vimrc-mode
  :defer t)

;; Also include FZF
(use-package fzf
  :defer t)


;; Custom functions

(defun rs/gen-input(KEYS)
  "Generates the input key sequence KEYS. KEYS must be kbd compatible string."
  (interactive)
  (setq  unread-command-events (nconc (listify-key-sequence (kbd KEYS)) unread-command-events)))

(defun rs/help ()
  (interactive)
  (rs/gen-input "C-h"))

(defun rs/zen--get-mode-state (mode)
  "Returns t if MODE is set to non-nil else returns -1"
  (if (boundp mode) (if (eq (eval mode) nil) -1 t) -1))

(defun rs/toggle-zen (&optional arg)
  "Zen for intense focus"
  (interactive "P")
  (let ((arg (or arg 0)))
    (if (and (<= arg 0) (boundp 'rs/zen-restore-line-num)) ;; Use this to determine if zen is on
        (progn
          (display-line-numbers-mode rs/zen-restore-line-num)
          (hide-mode-line-mode rs/zen-restore-mode-line)
          (olivetti-mode -1)
          (kill-local-variable 'rs/zen-restore-line-num)
          (kill-local-variable 'rs/zen-restore-mode-line))
      (if (and (not (boundp 'rs/zen-restore-line-num))
               (not (boundp 'rs/zen-restore-mode-line))
               (>= arg 0))
          (progn
            (make-local-variable 'rs/zen-restore-line-num)
            (setq rs/zen-restore-line-num
                  (rs/zen--get-mode-state 'display-line-numbers-mode))
            (make-local-variable 'rs/zen-restore-mode-line)
            (setq rs/zen-restore-mode-line
                  (rs/zen--get-mode-state 'hide-mode-line-mode))
            (display-line-numbers-mode 0)
            (hide-mode-line-mode t)
            (olivetti-mode t))))))

;; Load leader key bindings
(unless (file-exists-p bindings-file)
  (find-file bindings-source-file)
  (setq org-confirm-babel-evaluate nil)
  (org-babel-execute-buffer)
  (setq org-confirm-babel-evaluate t)
  (set-buffer-modified-p nil)
  (kill-current-buffer))

(load-file bindings-file)

;; Finally load the custom file
(when (file-exists-p custom-file)
  (load-file custom-file))
