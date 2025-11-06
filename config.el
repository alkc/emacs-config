;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; (setq debug-on-error t)

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'ef-dream)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(display-time)


;; Comment out not to skip over underscores when moving by word
;; For a majority of programming languages, an underscore is part of a word or symbol.
;;(modify-syntax-entry  ?_ "w" (standard-syntax-table))

(when (file-exists-p "/home/alkc/.config/emacs/modules/ui/doom-dashboard/banners/emacs-e-logo.png")
  (setq fancy-splash-image "/home/alkc/.config/emacs/modules/ui/doom-dashboard/banners/emacs-e-logo.png"))

;; Setup central bkp dir:
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; SHUT UP:
(setq custom-safe-themes t)

;; Config dark/light mode switcher
(use-package heaven-and-hell
  :ensure t
  :config
  (setq heaven-and-hell-theme-type 'dark) ;; Omit to use light by default
  (setq heaven-and-hell-themes
        '(
          (light . (modus-operandi))
          (dark . (ef-dream doom-gruvbox))
          )
        ) ;; Themes can be the list: (dark . (tsdh-dark wombat))
  ;; Optional, load themes without asking for confirmation.
  (setq heaven-and-hell-load-theme-no-confirm t)
  :hook (after-init . heaven-and-hell-init-hook)
  :bind (("C-c <f6>" . heaven-and-hell-load-default-theme)
         ("<f6>" . heaven-and-hell-toggle-theme)))

(use-package dired-narrow
  :ensure t
  :bind ((:map dired-mode-map
               ("C-s" . dired-narrow))))
;; treemacs workaround thingie:
;; (add-to-list 'image-types 'svg)

(setq confirm-kill-emacs nil)

(setq projectile-project-search-path '("~/projects/" ))
(setopt display-fill-column-indicator-column 100)
(add-hook 'python-mode #'display-fill-column-indicator-mode)

;; NEXTFLOW:
(use-package! nextflow-mode
  :config
  (set-docsets! 'nextflow-mode "Groovy"))

;; TODO: auto-enable LSP for all nextflow-mode buffers
;; enable nextflow lsp if exists.
(with-eval-after-load 'eglot
  (let ((nextflow-server-path "/home/alkc/.local/bin/nextflow-language-server-all.jar"))
    (when (file-exists-p nextflow-server-path)
      (add-to-list 'eglot-server-programs
                   '(nextflow-mode . ("java" "-jar" nextflow-server-path))))))

;; POMODORO TIMER DING
;; TODO: won't work on WSL2.
;;(setq org-clock-sound "/home/alkc/.config/emacs/.local/ding.wav")

;;(use-package keychain-environment
;;  :config (keychain-refresh-environment))

;; Connect to `main` workspace in new emacsclient sessions
(setq persp-emacsclient-init-frame-behaviour-override "main")

;; Use the docker compose plugin instead if docker-compose
(eval-after-load 'docker-compose
  '(setq docker-compose-command "docker compose"))

(use-package! nov
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  )


;; MIXED KEYBINDS
;; TODO: rebind:
(global-set-key (kbd "M-n") 'forward-paragraph)
(global-set-key (kbd "M-p") 'backward-paragraph)

(global-set-key (kbd "C-c o a") 'org-agenda-list)

;; TODO: Sometimes opens non-login shell? W/O sourcing .bashrc + precious aliases
(setq vterm-tramp-shells '(("docker" "sh")
                           ("ssh" "bash -l")))


(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "C-<tab>") 'next-buffer)
(global-set-key (kbd "C-<iso-lefttab>") 'previous-buffer)

;; Free up C-'
(global-set-key (kbd "M-'") 'consult-imenu)

(use-package! avy
  :ensure t
  :bind (("C-ä" . avy-goto-char)
         ("C-'" . avy-goto-char-2)
         ("M-ä" . avy-goto-char-timer)
         ("M-g g" . avy-goto-line)
         ("M-g M-g" . avy-goto-line)
         ("M-g w" . avy-goto-word-1)
         ("M-g e" . avy-goto-word-0)
         ("M-g k r" . avy-kill-region))
  :config
  (define-key isearch-mode-map (kbd "C-'") 'avy-isearch)
  )

(use-package! gptel
  :ensure t
  :bind (("C-c o g g" . gptel)
         ("C-c o g m" . gptel-menu)
         ("C-c o g r" . gptel-rewrite)
         ("C-c o g a" . gptel-add)
         ("C-c o g p" . gptel-system-prompt)
         ("C-c o g q" . gptel-context-remove-all))

  :config
  (setq gptel-api-key (gptel-api-key-from-auth-source))
  ;; Disable line numbering for gptel-mode
  (add-hook 'gptel-mode-hook (lambda ()
                               (line-number-mode -1)
                               (display-line-numbers-mode -1)))
  (add-hook 'gptel-post-response-functions 'gptel-end-of-response)
  (add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)
  (add-to-list
   'gptel-directives
   '(nextflow-expert . "You are a nextflow DSL2 expert. You give minimal replies, no explanations unless specifically required. If my problem description is unclear, then you will ask me questions about the problem, one question at a time, until you have gathered enough context about my problem to give an answer. Do not hallucinate answers. Do not invent functions/classes/ or code otherwise not supported in nextflow/groovy.")
   '(prompt-expert . "You are an AI expert. Help me to formulate the right prompt/question to ask a LLM to solve my problem. Please ask me questions about the problem, one question at a time, until you have gathered enough context about my problem in order to help me generate a good prompt.")
   )
  )


(after! gptel
  (use-package! gptel-quick
    :config
    (setq gptel-quick-backend gptel-backend)
    (setq gptel-quick-model 'gpt-4.1-nano)
    )
  )

(after! embark
  (keymap-set embark-general-map "?" #'gptel-quick)
  )

;; (use-package aidermacs
;;   :bind (("C-c o A" . aidermacs-transient-menu))
;;   :config
;;   (setenv "OPENAI_API_KEY" (auth-source-pick-first-password :host "api.openai.com"))
;;   )

;; (require 'acp)
;; (require 'agent-shell)
(use-package! agent-shell
  :config
  (setq agent-shell-openai-authentication
        (agent-shell-openai-make-authentication
         :api-key (lambda () (auth-source-pick-first-password :host "api.openai.com"))))
  )

;; TODO: Move to work config
;; (defun execute-remote-command-on-hopper (command)
;;   "Execute a remote COMMAND on hopper."
;;   (interactive "sCommand to run on hopper: ")
;;   (let ((default-directory "/ssh:hopper:/"))
;;     (shell-command command)))

;; FIXME This crashes the config:
;; (setf (alist-get 'python-mode apheleia-mode-alist)
;;      '(isort black))

;; ORG fun
(defun alkc/soppa-work ()
  "Dive straight into soup"
  (interactive)
  (find-file "~/org/soppa.org"))

(global-set-key (kbd "C-c o s") 'alkc/soppa-work)

(setq org-default-notes-file (concat org-directory "soppa.org"))
(setq +org-capture-notes-file (concat org-directory "soppa.org"))
(setq +org-capture-todo-file (concat org-directory "soppa.org"))
(setq +org-capture-calendar-file (concat org-directory "calendar.org"))
(setq +org-capture-projects-file (concat org-directory "soppa.org"))

(setq org-archive-location "./archive/%s_archive::")

(setq org-capture-templates
      '(("t" "TODO Inbox" entry (file+headline +org-capture-todo-file "Inbox")
         "* TODO %?\n%i" :prepend t)
        ("T" "TODO Inbox w/ link" entry (file+headline +org-capture-todo-file "Inbox")
         "* TODO %?\n%i\n%a" :prepend t)
        ("i" "IDEA Inbox" entry (file+headline +org-capture-todo-file "Inbox")
         "* IDEA %?\n%i" :prepend t)
        ("c" "Calendar" entry (file+headline +org-capture-calendar-file "Inbox")
         "* %?\n%i" :prepend t)
        ("n" "Personal notes" entry (file+headline +org-capture-notes-file "Inbox")
         "* %u %?\n%i" :prepend t)
        ("j" "Journal" entry (file+olp+datetree +org-capture-journal-file)
         "* %U %?\n%i" :prepend t)
        ("J" "Secret journal" entry (file+olp+datetree +org-capture-secret-journal-file)
         "* %U %?\n%i" :prepend t)
        )
      )

(when (string= (system-name) "RS30211241")
  (load-file "/home/alkc/projects/SMD-dotfiles/work.el"))
