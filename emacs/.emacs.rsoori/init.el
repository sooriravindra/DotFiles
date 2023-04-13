;; Author  : Raveendra Soori
;; Created : 7th April 2023

;; load early-init.el in earlier versions
(when (version< emacs-version "27")
  (load (concat user-emacs-directory "early-init.el")))

(setq-default custom-file (concat user-emacs-directory "custom-file.el")
              indent-tabs-mode nil
              create-lockfiles nil
              frame-title-format '("%b"))

;; Set font size. This might need adjustment
(set-face-attribute 'default nil :height 130)

;; Use y-or-n instead of yes-or-no
(fset 'yes-or-no-p 'y-or-n-p)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; With GPG 2.1+, this forces gpg-agent to use the Emacs minibuffer to prompt
;; for the key passphrase.
(defconst EMACS27+ (not (version< emacs-version "27")))
(set (if EMACS27+
         'epg-pinentry-mode
       'epa-pinentry-mode) ; DEPRECATED `epa-pinentry-mode'
     'loopback)

(show-paren-mode 1)

(global-visual-line-mode t)

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

;; No need to ensure each package
(setq use-package-always-ensure t)

;; Show keystrokes in a buffer
(use-package command-log-mode
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
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

;; ;; ivy completion framework
;; (use-package ivy
;;   :config (ivy-mode 1))
;; 
;; ;; ivy enhanced versions of common Emacs commands
;; (use-package counsel
;;   :bind (("M-x" . counsel-M-x)
;; 	 ("C-x b" . counsel-ibuffer)
;; 	 ("C-x C-f" . counsel-find-file)
;; 	 :map minibuffer-local-map
;; 	 ("C-r" . 'counsel-minibuffer-history)))
;; 
;; ;; Better sorting for ivy
;; (use-package ivy-prescient
;;   :after counsel
;;   :custom
;;   (ivy-prescient-enable-filtering t)
;;   :config
;;   (prescient-persist-mode 1)
;;   (ivy-prescient-mode 1))

(use-package vertico
  :init (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package savehist
  :config (savehist-mode t))

(use-package marginalia
  :bind
  (:map minibuffer-local-map
        ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

;; Pretty themes
(use-package doom-themes
  :init (load-theme 'doom-dracula t))

(use-package all-the-icons)

;; Pretty mode-line
(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; Apparently the best git interface
(use-package magit
  :bind ("C-x g" . magit-status))

;; Better help
(use-package helpful
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

(use-package beacon
  :config (beacon-mode))

(use-package which-key
  :defer 0
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

(if (eq system-type `gnu/linux)
    (use-package vterm
      :defer t))

(use-package writeroom-mode
  :defer t)

;; Load custom configuration
(load-file custom-file)
