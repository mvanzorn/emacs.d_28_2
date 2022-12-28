;;; package --- Sumamry
;;;https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-20-04
  ;; npm i -g prettier
  ;; in Project dir, npm init, eslint --init

  ;; Needed after 28.2 install and byte recompile of all packages?


;; Bootstrapper for package/use-package, only needed on fresh installations
;; ;;{{{ Set up package and use-package
;; (require 'package)
;; (add-to-list 'package-archives
;; 	                  '("melpa" . "https://melpa.org/packages/") t)
;; (package-initialize)
;; ;;
;; ;; Bootstrap 'use-package'
;; (eval-after-load 'gnutls
;; 		   '(add-to-list 'gnutls-trustfiles "/etc/ssl/cert.pem"))
;; (unless (package-installed-p 'use-package)
;;    (package-refresh-contents)
;;      (package-install 'use-package))
;; (eval-when-compile
;;    (require 'use-package))
;; (require 'bind-key)
;; (setq use-package-always-ensure t)

;; ;;}}}
;; ;; End use-package bootstrapper

(require 'use-package)


(unless window-system
  (xterm-mouse-mode)
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line))

(when (eq window-system nil)
  (xterm-mouse-mode t))

;; https://emacs.stackexchange.com/questions/7191/copy-and-paste-to-system-clipboard-in-tmux
(setq x-select-enable-clipboard t
      x-select-enable-primary t)


;; From https://justinchips.medium.com/have-vim-emacs-tmux-use-system-clipboard-4c9d901eef40
(defun yank-to-clipboard ()
  "Use ANSI OSC 52 escape sequence to attempt clipboard copy"
  ;; https://sunaku.github.io/tmux-yank-osc52.html
  (interactive)
  (let ((tmx_tty (concat "/dev/" (shell-command-to-string "ps l | grep 'tmux attach' | grep -v grep | awk '{print $11}'")))
        (base64_text (base64-encode-string (encode-coding-string (substring-no-properties (nth 0 kill-ring)) 'utf-8) t)))
    ;; Check if inside TMUX
    (if (getenv "TMUX")
        (shell-command
         (format "printf \"\033]52;c;%s\a\" > %s" base64_text tmx_tty))
      ;; Check if inside SSH
      (if (getenv "SSH_TTY")
          (shell-command (format "printf \"\033]52;c;%s\a\" > %s" base64_text (getenv "SSH_TTY")))
        ;; Send to current TTY
        (send-string-to-terminal (format "\033]52;c;%s\a" base64_text))))))


;; MVZ 12-11-2022 https://stackoverflow.com/questions/1558178/wrap-selection-in-open-close-tag-like-textmate
;; Wrap each selected line in HTML tags
(defun my-tag-lines (b e tag)
  "'tag' every line in the region with a tag"
  (interactive "r\nMTag for line: ")
  (save-restriction
    (narrow-to-region b e)
    (save-excursion
      (goto-char (point-min))
      (while (< (point) (point-max))
        (beginning-of-line)
        (insert (format "<%s>" tag))
        (end-of-line)
        (insert (format "</%s>" tag))
        (forward-line 1)))))


  (eval-and-compile
    (customize-set-variable
     'package-archives '(
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("org" . "https://orgmode.org/elpa/")
                         ))
    (package-initialize)
    (unless (package-installed-p 'use-package)
      (package-refresh-contents)
      (package-install 'use-package)))

;; Bootstrapping straght.el
;; Install straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq package-enable-at-startup nil)


  ;; TRAMP DEBUGGIN / OPTIMIZATION
  (setq vc-handled-backends '(Git))
  (setq -verbose 1)
  (setq tramp-default-method "ssh")
  ;; https://stackoverflow.com/questions/56105716/magit-over-tramp-re-use-ssh-connection
  (customize-set-variable
   'tramp-ssh-controlmaster-options
   (concat
    "-o ControlPath=/tmp/ssh-ControlPath-%%r@%%h:%%p "
    "-o ControlMaster=auto -o ControlPersist=yes"))
  (customize-set-variable 'tramp-use-ssh-controlmaster-options nil)

  ;; End TRAMP

  ;; BROWSER  ;; Chromium browser installed in wsl2
  (setq browse-url-browser-function 'browse-url-generic
        browse-url-generic-program "google-chrome")

  (delete-selection-mode t)
  ;;(tool-bar-mode -1)
  (setq gc-cons-threshold 100000000)
  (setq read-process-output-max (* 1024 1024)) ;; 1mb
  (setq auto-save-default nil)
  (setq make-backup-files nil)
  (setq create-lockfiles nil)
  (global-display-line-numbers-mode)
  (global-prettify-symbols-mode 1)

;;;  (global-hl-line-mode 1)
;;;(set-face-background 'hl-line "#3e4446")
;;;(set-face-foreground 'highlight nil)

  (setq tab-line-close-button-show nil)
  (setq tab-line-tabs-function 'tab-line-tabs-mode-buffers)
  (global-tab-line-mode t)
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark))

  (when (eq window-system 'mac)n``
        (mac-auto-operator-composition-mode))


  (use-package exec-path-from-shell
    :ensure t
    :config
    (exec-path-from-shell-initialize))

  (use-package add-node-modules-path
    :ensure t)

  (use-package which-key
    :ensure t
    :config
    (which-key-mode))

;; Allow C-h to trigger which-key before it is done automatically
(setq which-key-show-early-on-C-h t)
;; make sure which-key doesn't show normally but refreshes quickly after it is
;; triggered.
(setq which-key-idle-delay 10000)
(setq which-key-idle-delay 0)
(setq which-key-idle-secondary-delay 0.05)
(setq which-key-popup-type 'side-window)
;;(setq which-key-side-window-location 'bottom)

(use-package expand-region
    :ensure t
    :bind (("<f9>" . er/expand-region)
           ("C--" . er/contract-region)))


;;; MVZ 12-27-2022 More from Emacs Rocks
(defun my-more-like-this (arg)
  (interactive "p")
  (if (not (region-active-p))
      (select-at-point)
    (mc/mark-next-like-this arg)
    )
  )

(defun my-previous-like-this (arg)
  (interactive "p")
  (if (not (region-active-p))
      (select-at-point)
    (mc/mark-previous-like-this arg)
    )
  )

(defun select-at-point ()
  (interactive)
  (setq default (thing-at-point 'word))
  (setq bds (bounds-of-thing-at-point 'word))
  (setq p1 (car bds))
  (setq p2 (cdr bds))
  (set-mark p1)
  (goto-char p2)
)




;;MVZ 12-3-2022
(define-key input-decode-map "\e\eOA" [(meta up)])
(define-key input-decode-map "\e\eOB" [(meta down)])
(global-set-key [(meta up)] 'move-text-line-up)
(global-set-key [(meta down)] 'move-text-line-down)


;; MVZ 12-21-2022
;; Dirvish instead of dired
;; https://github.com/alexluigit/dirvish
;; (straight-use-package 'dirvish)
;; (dirvish-override-dired-mode)
(use-package dirvish
  :init
  (dirvish-override-dired-mode)
  :custom
  (dirvish-quick-access-entries ; It's a custom option, `setq' won't work
   '(("h" "~/"                          "Home")
     ("d" "~/Downloads/"                "Downloads")
     ("m" "/mnt/"                       "Drives")
     ("t" "~/.local/share/Trash/files/" "TrashCan")))
  :config
  ;; (dirvish-peek-mode) ; Preview files in minibuffer
  ;; (dirvish-side-follow-mode) ; similar to `treemacs-follow-mode'
  (setq dirvish-mode-line-format
        '(:left (sort symlink) :right (omit yank index)))
  (setq dirvish-attributes
        '(all-the-icons file-time file-size collapse subtree-state vc-state git-msg))
  (setq delete-by-moving-to-trash t)
  (setq dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group")
  :bind ; Bind `dirvish|dirvish-side|dirvish-dwim' as you see fit
  (("C-c f" . dirvish-fd)
   :map dirvish-mode-map ; Dirvish inherits `dired-mode-map'
   ("a"   . dirvish-quick-access)
   ("f"   . dirvish-file-info-menu)
   ("y"   . dirvish-yank-menu)
   ("N"   . dirvish-narrow)
   ("^"   . dirvish-history-last)
   ("h"   . dirvish-history-jump) ; remapped `describe-mode'
   ("s"   . dirvish-quicksort)    ; remapped `dired-sort-toggle-or-edit'
   ("v"   . dirvish-vc-menu)      ; remapped `dired-view-file'
   ("TAB" . dirvish-subtree-toggle)
   ("M-f" . dirvish-history-go-forward)
   ("M-b" . dirvish-history-go-backward)
   ("M-l" . dirvish-ls-switches-menu)
   ("M-m" . dirvish-mark-menu)
   ("M-t" . dirvish-layout-toggle)
   ("M-s" . dirvish-setup-menu)
   ("M-e" . dirvish-emerge-menu)
   ("M-j" . dirvish-fd-jump)))
;; END Dirvish


;; MVZ 12-24-2022
;; Figlet.el

;;; oooooooooooo  o8o             oooo                .
;;; `888'     `8  `"'             `888              .o8
;;;  888         oooo   .oooooooo  888   .ooooo.  .o888oo
;;;  888oooo8    `888  888' `88b   888  d88' `88b   888
;;;  888    "     888  888   888   888  888ooo888   888
;;;  888          888  `88bod8P'   888  888    .o   888 .
;;; o888o        o888o `8oooooo.  o888o `Y8bod8P'   "888"
;;;                    d"     YD
;;;                    "Y88888P'
;;;
;;; http://www.figlet.org/figlet.el  ;;; Hardcoded to use roman as default font
;;; Fonts: http://www.figlet.org/examples.html
;;;
;;; M-x figlet      to get a figlet comment in standard font.
;;; C-u M-x figlet  to be asked for the font first.
;;; M-x banner      for an old-fashioned banner font.
(load "~/.emacs.d/packages/figlet.el")


;; json-mode
  (use-package json-mode
    :ensure t)

;; move-text
  (use-package move-text
    :ensure t)
  (move-text-default-bindings)



;;;   .oooooo.                           .oooooo..o ooooooooooooo
;;;  d8P'  `Y8b                         d8P'    `Y8 8'   888   `8
;;; 888      888 oooo d8b  .oooooooo    Y88bo.           888
;;; 888      888 `888""8P 888' `88b      `"Y8888o.       888
;;; 888      888  888     888   888          `"Y88b      888
;;; `88b    d88'  888     `88bod8P'     oo     .d8P      888
;;;  `Y8bood8P'  d888b    `8oooooo.     8""88888P'      o888o
;;;                       d"     YD
;;;                       "Y88888P'


;;;; ORG-MODE
;;;;(use-package org-contrib)
;;
;;(use-package org
;;  :ensure org-plus-contrib)
;;
;;(use-package org-notify
;;  :ensure nil
;;  :after org
;;  :config
;;  (org-notify-start))
;;
;;'(org-file-apps
;;  '((auto-mode . emacs)
;;    (directory . emacs)
;;    ("\\.mm\\'" . default)
;;    ("\\.x?html?\\'" . system)
;;    ("\\.pdf\\'" . system)))
;;
;;;; Wrapping to window, not quite as good as fill paragraph, but better with proportional font
;;;; M-q to adjust paragraph now and then
;;(add-hook 'org-mode-hook 'visual-line-mode)
;;
;;(with-eval-after-load 'org
;;  ;;(setq org-startup-indented t)
;;  )
;;
;;;; Lines between headings, always
;;(setq org-cycle-separator-lines 1)
;;
;;
;;;; Log stuff into the LOGBOOK drawer by default
;;;;(setq org-log-into-drawer t)
;;
;;
;;;;(require 'org)
;;;; The following lines are always needed. Choose your own keys.
;;(global-set-key "\C-cl" 'org-store-link)
;;(global-set-key "\C-ca" 'org-agenda)
;;(global-set-key "\C-cc" 'org-capture)
;;(global-set-key "\C-cb" 'org-switchb)
;;;;(setq org-directory "~/Dropbox/org")
;;
;;;; Org Mode Capture Templates from http://cachestocaches.com/2016/9/my-workflow-org-agenda/
;;;; Define the custum capture templates
;;(setq org-capture-templates
;;      '(("t" "todo" entry (file org-default-notes-file)
;;         "* TODO %?\n%u\n%a\n" :clock-in t :clock-resume t)
;;        ("m" "Meeting" entry (file org-default-notes-file)
;;         "* MEETING with %? :MEETING:\n%t" :clock-in t :clock-resume t)
;;        ("d" "Diary" entry (file+datetree "~/OneDrivee/Org/diary.org")
;;         "* %?\n%U\n" :clock-in t :clock-resume t)
;;        ("i" "Idea" entry (file org-default-notes-file)
;;         "* %? :IDEA: \n%t" :clock-in t :clock-resume t)
;;        ("n" "Next Task" entry (file+headline org-default-notes-file "Tasks")
;;         "** NEXT %? \nDEADLINE: %t") ))
;;
;;(setq org-refile-targets (quote ((nil :maxlevel . 9)
;;                                 (org-agenda-files :maxlevel . 9))))
;;
;;(use-package org-super-agenda
;;  :ensure t
;;  :after org-agenda
;;  :config
;;  (org-super-agenda-mode))
;;
;;(setq
;; org-super-agenda-groups
;; '((:name "Today"
;;          :time-grid t
;;          :todo "TODAY")
;;   (:name "High Priority"
;;          :priority "A"
;;          :order 1)
;;   (:name "Work"
;;          :category "work"
;;          :tag "work"
;;          :order 2)
;;   (:name "Shopping List"
;;          :category "shopping"
;;          :tag "shopping"
;;          :order 3)
;;   (:name "Cleaning"
;;          :category "cleaning"
;;          :tag "cleaning"
;;          :order 4)
;;   ))
;;
;;;; Improving Agenda
;;;; https://blog.aaronbieber.com/2016/09/24/an-agenda-for-life-with-org-mode.html
;;;; Part 1: Eliminating Priority and Habit redudancy
;;
;;(defun air-org-skip-subtree-if-priority (priority)
;;  "Skip an agenda subtree if it has a priority of PRIORITY.
;;        PRIORITY may be one of the characters ?A, ?B, or ?C."
;;  (let ((subtree-end (save-excursion (org-end-of-subtree t)))
;;        (pri-value (* 1000 (- org-lowest-priority priority)))
;;        (pri-current (org-get-priority (thing-at-point 'line t))))
;;    (if (= pri-value pri-current)
;;        subtree-end
;;      nil)))
;;
;;(setq org-agenda-custom-commands
;;      '(("c" "Simple agenda view"
;;         ((tags "PRIORITY=\"A\""
;;                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
;;                 (org-agenda-overriding-header "High-priority unfinished tasks:")))
;;          (agenda "")
;;          (alltodo ""
;;                   ((org-agenda-skip-function
;;                     '(or (air-org-skip-subtree-if-priority ?A)
;;                          (org-agenda-skip-if nil '(scheduled deadline))))))))))
;;
;;(defun air-org-skip-subtree-if-habit ()
;;  "Skip an agenda entry if it has a STYLE property equal to \"habit\"."
;;  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
;;    (if (string= (org-entry-get nil "STYLE") "habit")
;;        subtree-end
;;      nil)))
;;
;;;; Manually assign priority ranges for tasks
;;(setq org-highest-priority ?A)
;;(setq org-default-priority ?B)
;;(setq org-lowest-priority ?C)
;;
;;(setq org-agenda-custom-commands
;;      '(("d" "Daily agenda and all TODOs"
;;         ((tags "PRIORITY=\"A\""
;;                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
;;                 (org-agenda-overriding-header "High-priority unfinished tasks:")))
;;          (agenda "" ((org-agenda-ndays 1)))
;;          (alltodo ""
;;                   ((org-agenda-skip-function '(or (air-org-skip-subtree-if-habit)
;;                                                   (air-org-skip-subtree-if-priority ?A)
;;                                                   (org-agenda-skip-if nil '(scheduled deadline))))
;;                    (org-agenda-overriding-header "ALL normal priority tasks:"))))
;;         ((org-agenda-compact-blocks t)))))
;;
;;
;;;; Navigating Agenda
;;;; https://blog.aaronbieber.com/2016/09/25/agenda-interactions-primer.html
;;;; Part 2: Customizing
;;
;;(defun air-pop-to-org-agenda (&optional split)
;;  "Visit the org agenda, in the current window or a SPLIT."
;;  (interactive "P")
;;  (org-agenda nil "d")
;;  (when (not split)
;;    (delete-other-windows)))
;;
;;(define-key global-map (kbd "S-SPC") 'air-pop-to-org-agenda)
;;
;;
;;;; TAGGING
;;(setq org-tag-alist '(("AAAHQ" . ?a) ("PAP" . ?p) ("consult" . ?c) ("@home" . ?h) ("learning" . ?l) ("emacs" . ?e) ("ARCHIVE" .?r)))
;;
;;
;;
;;;; org-mode addons
;;;; https://code.orgmode.org/bzg/org-mode/src/master/contrib
;;
;;;; (use-package org-checklist
;;;; 	:load-path "~/.emacs.d/packages/org-checklist/org-checklist.el")
;;
;;;; (use-package org-panel
;;;;   :load-path "~/.emacs.d/packages/org-panel.el")
;;
;;;; (use-package org-drill
;;;;   :load-path "~/.emacs.d/elpa/org-plus-contrib-20190527/org-drill.el")
;;
;;
;;;; mvz 4-25-2019
;;;; library functions and commands useful for retrieving web page content and processing it into Org-mode content
;;;; For example, you can copy a URL to the clipboard or kill-ring, then run a command that downloads the page, isolates the “readable” content with eww-readable, converts it to Org-mode content with Pandoc, and displays it in an Org-mode buffer. Another command does all of that but inserts it as an Org entry instead of displaying it in a new buffer.
;;;; https://github.com/alphapapa/org-web-tools
;;(use-package org-web-tools
;;  :defer 1)
;;
;;
;;(setq org-modules '(org-habit))
;;(setq org-modules '(org-checklist))
;;;;(setq org-modules '(org-panel))
;;
;;;; Disabled org-learn while testing straight.el 20200214
;;;; (setq org-modules '(org-learn))
;;;;(setq org-modules '(org-drill))
;;
;;
;;
;;
;;;; (setq org-agenda-files (list
;;;;                         ;;"~/Dropbox/org/rainer-konig-orgmode-videos.org"
;;;;                         "~/OneDrive/Org/aaahq.org"
;;;;                         "~/OneDrive/Org/home.org"
;;;;                         "~/OneDrive/Org/notes.org"
;;;;                         "~/OneDrive/Org/education.org"
;;;;                         "~/OneDrive/Org/pap.org"
;;
;;;;                         ))
;;
;;;; Attempt to create a shortcut for org links
;;(setq org-link-abbrev-alist
;;      '(("ss"  . "~/OneDrive/Screenshots/"))) ;; Linux/OSX
;;
;;
;;;; Display images in org-mode by default
;;;; (setq org-display-inline-images t)
;;;; (setq org-redisplay-inline-images t)
;;;; (setq org-startup-with-inline-images "inlineimages")
;;
;;
;;
;;
;;(setq org-log-done 'time)
;;                                        ;(setq org-log-done 'note)
;;;;(use-package org-bullets)
;;;;(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;;
;;
;;(use-package org-bullets
;;  :hook (org-mode . org-bullets-mode)
;;  :custom
;;  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))
;;
;;;; (defun efs/org-mode-visual-fill ()
;;;;   (setq visual-fill-column-width 140
;;;;         visual-fill-column-center-text nil)
;;;;   (visual-fill-column-mode 1))
;;
;;;; (use-package visual-fill-column
;;;;   :hook (org-mode . efs/org-mode-visual-fill))
;;
;;
;;
;;;; (setq org
;;;;      -hide-leading-stars t)
;;
;;;; TODO Notes
;;;; #+SEQ_TODO:TODO(t@/!)
;;;; t - hotkey assigned to that TODO Keyword
;;;; @ - log a timestamp and a note when this is entered
;;;; ! - log a timestamp when you leave that keyword
;;(setq org-todo-keywords '(
;;                          (sequence " NEXT(n/!)" "✪ TODO(t@/!)" "⌚ WAITING(w@/!)" "∵ PROJECT(p)" "↺ SOMEDAY(s)" " DELEGATED(g@/!)")
;;                          (sequence "|" "✘ CANCELED(c)" " DONE(d)" " ARCHIVE(a)")))
;;
;;
;;;; File Locations
;;(global-set-key (kbd "C-c o")
;;                (lambda () (interactive) (find-file "~/OneDrive/Orgnotes.org")))
;;
;;(setq org-default-notes-file "~/OneDrive/Org/notes.org")
;;
;;;; CAPTURE MODE
;;;;(setq org-default-notes-file (concat org-directory "~/Dropbox/org/notes.org"))
;;;;(define-key global-map "\C-cc" 'org-capture)
;;
;;
;;
;;
;;
;;;; from https://explog.in/dot/emacs/config.html
;;;;(pixel-scroll-mode)
;;
;;
;;;; UTF-8 checkboxes
;;;; From Sacha Chua
;;;;(setq org-html-checkbox-type 'unicode)
;;;; (setq org-html-checkbox-type 'html)
;;;; (setq org-html-checkbox-types
;;;;  '((unicode (on . "<span class=\"task-done\">&#x2611;</span>")
;;;;             (off . "<span class=\"task-todo\">&#x2610;</span>")
;;;;             (trans . "<span class=\"task-in-progress\">[-]</span>"))))
;;
;;
;;
;;;; Hugo org-mode exporting
;;;; https://ox-hugo.scripter.co/doc/usage/
;;(use-package ox-hugo
;;                                        ;Auto-install the package from Melpa (optional)
;;  :after ox)
;;
;;;; Replacement for deprecated org-timeline feature
;;;; https://www.reddit.com/r/orgmode/comments/7hps9j/rip_orgtimeline/
;;
;;
;;;; Uppercasing headlines
;;;; https://emacs.stackexchange.com/questions/51239/showing-org-headings-in-uppercase
;;(defvar headline-overlay-p nil)
;;(defvar headline-overlay-point nil)
;;
;;(defun edit-headline ()
;;  (when (and (eq major-mode 'org-mode)
;;             headline-overlay-p)
;;    ;; First, upcase the last visited headline
;;    (when-let (point headline-overlay-point)
;;      (save-excursion
;;        (goto-char point)
;;        (when (save-excursion
;;                (forward-line 0)
;;                (looking-at org-complex-heading-regexp))
;;          (let* ((beg (match-beginning 4))
;;                 (end (match-end 4))
;;                 (headline (match-string 4))
;;                 (ov (make-overlay beg end)))
;;            (overlay-put ov 'name 'upcased)
;;            (overlay-put ov 'display (upcase headline))))
;;        (setq headline-overlay-point nil)))
;;    ;; Then remove the overlay of the current headline
;;    (when (save-excursion
;;            (forward-line 0)
;;            (looking-at org-complex-heading-regexp))
;;      (let ((beg (match-beginning 4))
;;            (end (match-end 4))
;;            (headline (match-string 4)))
;;        (if (and (overlays-at beg)
;;                 (eq (overlay-get (car (overlays-at beg)) 'name) 'upcased))
;;            (let ((ov (car (overlays-in beg end))))
;;              (when (eq (overlay-get ov 'name) 'upcased)
;;                (delete-overlay ov)
;;                (save-excursion
;;                  (goto-char beg)
;;                  (setq headline-overlay-point
;;                        (line-beginning-position))))))))))
;;
;;(add-hook 'post-command-hook 'edit-headline)
;;
;;(defun toggle-headline-overlay ()
;;  (interactive)
;;  (org-map-entries
;;   (lambda ()
;;     (when (looking-at org-complex-heading-regexp)
;;       (let ((beg (match-beginning 4))
;;             (end (match-end 4))
;;             (headline (match-string 4)))
;;         ;; Do we have an upcase overlay?
;;         (if (and (overlays-at beg)
;;                  (eq (overlay-get (car (overlays-at beg)) 'name) 'upcased))
;;             ;; If so delete the overlay
;;             (dolist (ov (overlays-in beg end))
;;               (when (eq (overlay-get ov 'name) 'upcased)
;;                 (delete-overlay ov)
;;                 (setq headline-overlay-p nil)))
;;           ;; Otherwise add the overlay
;;           (let ((ov (make-overlay beg end)))
;;             (overlay-put ov 'name 'upcased)
;;             (overlay-put ov 'display (upcase headline))
;;             (setq headline-overlay-p t))))))))
;;
;;;; Helm-Org
;;;; https://github.com/emacs-helm/helm-org
;;;;(use-package helm-org)
;;
;;;; Customizing DRAWERS
;;(setq org-log-into-drawer t)
;;
;;;; With c-u argument before adding a note (C-x C-z)
;;;; this function will add the note to the body,
;;;; otherwise notes go into LOGBOOK
;;
;;;; (defun with-no-drawer (func &rest args)
;;;;   (interactive "P")
;;;;   (let ((org-log-into-drawer (not (car args))))
;;;;     (funcall func)))
;;
;;;; (advice-add 'org-add-note :around #'with-no-drawer)
;;
;;
;;
;;
;;;;(add-to-list 'helm-completing-read-handlers-alist '(org-capture . helm-org-completing-read-tags))
;;;;(add-to-list 'helm-completing-read-handlers-alist '(org-set-tags . helm-org-completing-read-tags))
;;
;;
;;;; Edward Tufteifying org
;;;; https://lepisma.xyz/2017/10/28/ricing-org-mode/
;;
;;(setq org-startup-indented t
;;      org-bullets-bullet-list '(" ") ;; no bullets, needs org-bullets package
;;      org-ellipsis "  " ;; folding symbol
;;      org-pretty-entities t
;;      org-hide-emphasis-markers t
;;      ;; show actually italicized text instead of /italicized text/
;;      org-agenda-block-separator ""
;;      org-fontify-whole-heading-line t
;;      org-fontify-done-headline t
;;      org-fontify-quote-and-verse-blocks t)
;;
;;(defface fixed-pitch-face
;;  '((t :family "Iosevka Nerd Font" ))
;;  "Fixed pitch font for org-mode"
;;  :group 'basic-faces)
;;
;;
;;(custom-theme-set-faces
;; 'user
;; ;;'changed-from-user-to-disable
;; `(fixed-pitch-face ((t (:family "Iosevka Nerd Font" :slant normal :weight normal :height 1.2 :width normal))))
;; `(outline-1 ((t (:family "ETBembo"))))
;; `(outline-2 ((t (:family "ETBembo"))))
;; `(outline-3 ((t (:family "ETBembo"))))
;; `(outline-4 ((t (:family "ETBembo"))))
;; `(org-level-1 ((t (:inherit outline-1 :foreground "#999999" :weight bold :height 1.6 :family "ETBembo"))))
;; ;; `(org-level-1 ((t (:inherit outline-1 :weight light :height 1.5 :family "ETBembo"))))
;; `(org-level-2 ((t (:inherit outline-2 :foreground "#999999" :weight light :slant italic :height 1.3 :family "ETBembo"))))
;; `(org-level-3 ((t (:inherit outline-3 :foreground "#999999" :weight light :slant italic :height 1.1 :family "ETBembo"))))
;; `(org-level-4 ((t (:inherit outline-4 :foreground "#999999" :weight light :slant italic :height 1.0 :family "ETBembo"))))
;; `(org-document-title ((t (:inherit outline-1 :foreground "#999999" :weight light :height 1.7 :family "ETBembo"))))
;; `(org-headline-done ((t (:inherit height :foreground "#888888" :weight light :slant italic :family "ETBembo"))))
;; `(org-block ((t (:inherit fixed-pitch-face))))
;; `(org-code ((t (:inherit (fixed-pitch-face)))))
;; `(org-document-info ((t (:foreground "dark orange"))))
;; `(org-document-info-keyword ((t (:inherit (fixed-pitch-face)))))
;; `(org-indent ((t (:inherit (org-hide fixed-pitch-face)))))
;; `(org-link ((t (:foreground "royal blue" :underline t :family "ETBembo"))))
;; `(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch-face) :background "#fbf8ef"))))
;; `(org-property-value ((t (:inherit fixed-pitch-face))) t)
;; `(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch-face) :foreground "#990000" :background "#fbf8ef" ))))
;; `(org-table ((t (:inherit (fixed-pitch-face) :foreground "#83a598"))))
;; `(org-tag ((t (:inherit (fixed-pitch-face) :weight bold :height 0.7 :foreground "#fbf8ef" :background "#660022"))))
;; `(org-todo ((t (:inherit (fixed-pitch-face) :weight bold :foreground "#990000" :background "#fbf8ef"))))
;; `(org-verbatim ((t (:inherit (fixed-pitch-face)))))
;; `(org-agenda-date-today ((t (:inherit (outline-1) :foreground "#999999" :height 1.3))))
;; `(org-agenda-date ((t (:inherit outline-3 (fixed-pitch-face) ))))
;; `(org-super-agenda-header ((t (:inherit outline-3 ) :family ETBembo :height 1.2)))
;; `(org-agenda-structure ((t (:inherit outline-1 :foreground "#999999" :weight bold ))))
;; `(hl-line ((t (:background "#444444"))))
;; `(font-lock-comment-face ((t (:foreground "#AA77BB" :slant italic))))
;; ;;`(org-tag-faces (quote (("Euclid" . "#FBF8EF"))))
;; ;;`(org-tag-faces (quote (("Euclid" . "#FBF8EF"))))
;; )
;;
;;
;;;; Org-mode completions
;;
;;(add-to-list 'org-src-lang-modes
;;             '("js" . js2)
;;             )
;;
;;
;;;; Clipboard HTML to Org
;;;; https://emacs.stackexchange.com/questions/12121/org-mode-parsing-rich-html-directly-when-pasting
;;(defun kdm/html2org-clipboard ()
;;  "Convert clipboard contents from HTML to Org and then paste (yank)."
;;  (interactive)
;;  (kill-new (shell-command-to-string "xclip -o -t text/html | pandoc -f html -t json | pandoc -f json -t org"))
;;  (yank))
;;
;;
;;;; Org-Roam
;;;; Inspired use of straight.el as replacement package manager
;;;; 20200214
;;;; (use-package org-roam
;;;;       :after org
;;;;       :hook (org-mode . org-roam-mode)
;;;;       :straight (:host github :repo "jethrokuan/org-roam")
;;;;       :custom
;;;;       (org-roam-directory "~/OneDrive/Org")
;;;;       :bind
;;;;       ("C-c n l" . org-roam)
;;;;       ("C-c n t" . org-roam-today)
;;;;       ("C-c n f" . org-roam-find-file)
;;;;       ("C-c n i" . org-roam-insert)
;;;;       ("C-c n g" . org-roam-show-graph))
;;
;;;; (setq org-roam-directory "~/OneDrive/Org")
;;;; (setq org-roam-buffer-width 0.4)
;;;; (setq org-roam-link-title-format "R:%s")
;;;; (setq org-roam-graphviz-executable "/usr/local/bin/dot")
;;;; (setq org-roam-graph-viewer "/usr/bin/dot")
;;
;;
;;
;;;; Customizations
;;;; https://carlhu.com/orgmode
;;
;;        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Add copy a whole line to clipboard to Emacs, bound to meta-c.
;;(defun quick-copy-line ()
;;  "Copy the whole line that point is on and move to the beginning of the next line.
;;            Consecutive calls to this command append each line to the
;;            kill-ring."
;;  (interactive)
;;  (let ((beg (line-beginning-position 1))
;;        (end (line-beginning-position 2)))
;;    (if (eq last-command 'quick-copy-line)
;;        (kill-append (buffer-substring beg end) (< end beg))
;;      (kill-new (buffer-substring beg end))))
;;  (beginning-of-line 2)
;;  (message "Line appended to kill-ring."))
;;(define-key global-map (kbd "M-c") 'quick-copy-line)
;;
;;
;;        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Add inserting current date time.
;;(defun my-insert-date (prefix)
;;  "Insert the current date. With prefix-argument, use ISO format. With
;;           two prefix arguments, write out the day and month name."
;;  (interactive "P")
;;  (let ((format (cond
;;                 ((not prefix) "%Y-%m-%d %H:%M")
;;                 ((equal prefix '(4)) "%Y-%m-%d")
;;                 ((equal prefix '(16)) "%A, %d. %B %Y")))
;;        )
;;    (insert (format-time-string format))))
;;(define-key global-map (kbd "C-M-S-d") 'my-insert-date) ;; This may override settings from smartparens delete-sexp
;;
;;
;;;; Suggestion for moving in org-mode from
;;;; https://www.gnu.org/software/emacs/manual/html_node/org/Handling-links.html
;;                                        ;(add-hook 'org-load-hook
;;;; (lambda ()
;;;;   (define-key org-mode-map "\C-n" 'org-next-link)
;;;;   (define-key org-mode-map "\C-p" 'org-previous-link)))
;;
;;
;;;; Add archive flag to any done tagged items
;;;; https://emacs.stackexchange.com/questions/21947/make-all-done-org-mode-items-invisible-collapsed
;;;; Not working in emacs 28.0.50 2-24-2020
;;(org-map-entries
;; '(org-toggle-tag "ARCHIVE" 'on )
;; "/+DONE" 'file 'archive 'comment)
;;
;;
;;;; END ORG-MODE


;;;   .oooooo.                          oooooooooooo ooooo      ooo oooooooooo.
;;;  d8P'  `Y8b                         `888'     `8 `888b.     `8' `888'   `Y8b
;;; 888      888 oooo d8b  .oooooooo     888          8 `88b.    8   888      888
;;; 888      888 `888""8P 888' `88b      888oooo8     8   `88b.  8   888      888
;;; 888      888  888     888   888      888    "     8     `88b.8   888      888
;;; `88b    d88'  888     `88bod8P'      888       o  8       `888   888     d88'
;;;  `Y8bood8P'  d888b    `8oooooo.     o888ooooood8 o8o        `8  o888bood8P'
;;;                       d"     YD
;;;                       "Y88888P'

;;
;;;; ORG-ROAM 3-16-2022
;;;; https://github.com/org-roam/org-roam
;;
;;(setq org-directory (concat (getenv "HOME") "/OneDrive/Org/"))
;;(use-package org-roam
;;  :ensure t
;;  :custom
;;  (org-roam-directory (file-truename "~/OneDrive/Org/"))
;;  :bind (("C-c n l" . org-roam-buffer-toggle)
;;         ("C-c n f" . org-roam-node-find)
;;         ("C-c n g" . org-roam-graph)
;;         ("C-c n i" . org-roam-node-insert)
;;         ("C-c n c" . org-roam-capture)
;;         ;; Dailies
;;         ("C-c n j" . org-roam-dailies-capture-today))
;;  :config
;;  ;; If you're using a vertical completion framework, you might want a more informative completion interface
;;  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
;;  (org-roam-db-autosync-mode)
;;  ;; If using org-roam-protocol
;;  (require 'org-roam-protocol))
;;
;;
;;
;;;; Org-modern setup 5-9-2022
;;;; Choose some fonts
;;;; (set-face-attribute 'default nil :family "Iosevka")
;;;; (set-face-attribute 'variable-pitch nil :family "Iosevka Aile")
;;;; (set-face-attribute 'org-modern-symbol nil :family "Iosevka")
;;
;;;; Add frame borders and window dividers
;;(modify-all-frames-parameters
;; '((right-divider-width . 40)
;;   (internal-border-width . 40)))
;;(dolist (face '(window-divider
;;                window-divider-first-pixel
;;                window-divider-last-pixel))
;;  (face-spec-reset-face face)
;;  (set-face-foreground face (face-attribute 'default :background)))
;;(set-face-background 'fringe (face-attribute 'default :background))
;;
;;(setq
;; ;; Edit settings
;; org-auto-align-tags nil
;; org-tags-column 0
;; org-catch-invisible-edits 'show-and-error
;; org-special-ctrl-a/e t
;; org-insert-heading-respect-content t
;;
;; ;; Org styling, hide markup etc.
;; org-hide-emphasis-markers t
;; org-pretty-entities t
;; org-ellipsis "…"
;;
;; ;; Agenda styling
;; org-agenda-block-separator ?─
;; org-agenda-time-grid
;; '((daily today require-timed)
;;   (800 1000 1200 1400 1600 1800 2000)
;;   " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
;; org-agenda-current-time-string
;; "⭠ now ─────────────────────────────────────────────────")
;;
;;(global-org-modern-mode)
;;
;;(use-package org-download
;;  :ensure t)
;;
;;(setq org-download-screenshot-method
;;    "xclip -selection clipboard -t image/png -o > %s")
;;
;;
;;  ;; Drag-and-drop to `dired`
;;  (add-hook 'dired-mode-hook 'org-download-enable)




;;;   .oooooo.                          .o88o.  o8o
;;;  d8P'  `Y8b                         888 `"  `"'
;;; 888           .ooooo.  ooo. .oo.   o888oo  oooo   .oooooooo
;;; 888          d88' `88b `888P"Y88b   888    `888  888' `88b
;;; 888          888   888  888   888   888     888  888   888
;;; `88b    ooo  888   888  888   888   888     888  `88bod8P'
;;;  `Y8bood8P'  `Y8bod8P' o888o o888o o888o   o888o `8oooooo.
;;;                                                  d"     YD
;;;                                                  "Y88888P'


;;
;;'(global-display-line-numbers-mode t)

(autoload 'zap-up-to-char "misc"
  "Kill up to, but not including ARGth occurrence of CHAR.
            \(fn arg char)"
  'interactive)
(global-set-key "\M-Z" 'zap-up-to-char)


;;;; Beacon  -- MVZ 12-29-2022 replaced with hl-line+ flash
;;(use-package beacon)
;;(beacon-mode 1)

;; make cursor the width of the character it is under
;; i.e. full width of a TAB
(setq x-stretch-cursor t)


;; Multiple cursors 3-22-2022
(use-package multiple-cursors
  :ensure   t
  :bind ( ("H-SPC" . set-rectangular-region-anchor)
         ("C-M-SPC" . set-rectangular-region-anchor)
        ;;; (" C->" . mc/mark-next-like-this)
        ;;; (" C-<" . mc/mark-previous-like-this)
         (" C-c C->" . mc/mark-all-like-this)
         (" C-S-c C-S-c" . mc/edit-lines)
         ))

;; Eyebrowse Mode 3-19-2022
;; http://pragmaticemacs.com/page/2/
(use-package eyebrowse
  :ensure t
  ;;:diminish eyebrowse-mode
  :config (progn
            (define-key eyebrowse-mode-map (kbd "M-1") 'eyebrowse-switch-to-window-config-1)
            (define-key eyebrowse-mode-map (kbd "M-2") 'eyebrowse-switch-to-window-config-2)
            (define-key eyebrowse-mode-map (kbd "M-3") 'eyebrowse-switch-to-window-config-3)
            (define-key eyebrowse-mode-map (kbd "M-4") 'eyebrowse-switch-to-window-config-4)
            (eyebrowse-mode t)
            (setq eyebrowse-new-workspace t)))



;;;; ;;Scrollkeeper 3-16-2022
;;;; (use-package scrollkeeper
;;;;   :ensure t)
;;;; (global-set-key [remap scroll-up-command] 'scrollkeeper-contents-up)
;;;; (global-set-key [remap scroll-down-command] 'scrollkeeper-contents-down)
;;
;;;; Golden ratio mode 3-16-2022
;;;; (use-package golden-ratio
;;;; 	:ensure t)
;;;; (golden-ratio-mode 1)
;;


;; Zoom mode - replacement for golden-ratio mode 3-16-2022
(use-package zoom
  :ensure t)
'(zoom-ignored-buffer-name-regexps '("^*calc"))
'(zoom-ignored-buffer-names '("zoom.el"))
'(zoom-ignored-major-modes '(dired-mode markdown-mode))
'(zoom-mode t nil (zoom))
'(zoom-size '(0.618 . 0.618))
(global-set-key (kbd "C-x +") 'zoom)


;;;; Scroll enhancements 3-16-2022
;;;; Per https://two-wrongs.com/centered-cursor-mode-in-vanilla-emacs
;;;; (setq
;;;;      scroll-preserve-screen-position t ;; Disabled 5-15-2022 Org Mode jumping issues
;;;;      scroll-conservatively 0
;;;;      maximum-scroll-margin 0.5
;;;;      scroll-margin 99999)
;;
;; Highlight Indent Guides 3-16-2022
(use-package highlight-indent-guides
  :ensure t)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
;;
;;
;;


;;;hl-line+  3-16-2022
;; (use-package hl-line+
;; 	:load-path "~/.emacs.d/packages/")
;; (toggle-hl-line-when-idle 2)

(use-package hl-line+
  :load-path "~/.emacs.d/packages/"
  :hook
  (window-scroll-functions . hl-line-flash)
  (focus-in . hl-line-flash)
  (post-command . hl-line-flash)

  :custom
  (global-hl-line-mode nil)
	;;(toggle-hl-line-when-idle 1)
	(hl-line-flash-show-period 0.5)
	(hl-line-inhibit-highlighting-for-modes '(dired-mode))
  (hl-line-overlay-priority -100) ;; sadly, seems not observed by diredfl
  )


;;; MVZ 12-27-2022 Centering mode with recenter at end of file
(use-package centered-cursor-mode
  :ensure t
  :init
  (global-centered-cursor-mode 1)
  )
(setq scroll-margin 28) ;; full screen = 57 lines
(setq-default indicate-empty-lines t)
(setq ccm-recenter-at-end-of-file t)


;;;; 2-28-2022 Additions
;;(use-package simple
;;  :ensure nil
;;  :config (column-number-mode +1))
;;


(require 'rainbow-delimiters)
(add-hook 'web-mode-hook #'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)


;;(use-package ediff
;;  :ensure nil
;;  :config
;;  (setq ediff-window-setup-function #'ediff-setup-windows-plain)
;;  (setq ediff-split-window-function #'split-window-horizontally))
;;


;; Diff highlighting! 3-13-2022
(use-package diff-hl
  :ensure t
  :custom
  (diff-hl-margin-mode t)
  )

(global-diff-hl-mode)


;;;; Simple modeline, deprecated in favor of doom modeline
;;;; https://github.com/dbordak/telephone-line
;;;;(require 'telephone-line)
;;;;(telephone-line-mode 1)
;;
;;
;;;; 9-18-2022 Diagnosing left margin outside gitter
;;(use-package frame
;;  :preface
;;  (defun ian/set-default-font ()
;;    (interactive)
;;    (when (member "Iosevka" (font-family-list))
;;      (set-face-attribute 'default nil :family "Iosevka"))
;;    (set-face-attribute 'default nil
;;                        :height 121
;;                        :weight 'normal))
;;  :ensure nil
;;  :config
;;  (setq initial-frame-alist '((fullscreen . maximized)))
;;  (ian/set-default-font))
;;
;;;; wsl clipboard improvements
;;;; 5-19-2022
;;;;
;;;; wsl-copy
;;(defun wsl-copy (start end)
;;  (interactive "r")
;;  (shell-command-on-region start end "clip.exe")
;;  (deactivate-mark))
;;
;;                                        ; wsl-paste
;;(defun wsl-paste ()
;;  (interactive)
;;  (let ((clipboard
;;         (shell-command-to-string "powershell.exe -command 'Get-Clipboard' 2> /dev/null")))
;;    (setq clipboard (replace-regexp-in-string "\r" "" clipboard)) ; Remove Windows ^M characters
;;    (setq clipboard (substring clipboard 0 -1)) ; Remove newline added by Powershell
;;    (insert clipboard)))



;;; MVZ 12-27-2022 Visual-Regexp
(use-package visual-regexp
	:ensure t)



;; AVY 3-5-2022
 (use-package avy
   :ensure t)
(global-set-key (kbd "C-:") 'avy-goto-char-2)
 (global-set-key (kbd "C-c '") 'avy-goto-char-2)
 (global-set-key (kbd "C-'") 'avy-goto-char)
 ;; input zero chars, jump to a line start with a tree
 (global-set-key (kbd "M-g f") 'avy-goto-line)
 ;;Input zero chars, jump to a word start with a tree.
 (global-set-key (kbd "M-g e") 'avy-goto-word-0)

;; ace-window
;; 3-7-2022
 (use-package ace-window
   :ensure t)
 (global-set-key (kbd "M-o") 'ace-window)
 ;; Allow ace-window to jump to treemacs
(setq aw-ignored-buffers (delq 'treemacs-mode aw-ignored-buffers))
 (defvar aw-dispatch-alist
   '((?x aw-delete-window "Delete Window")
     (?m aw-swap-window "Swap Windows")
     (?M aw-move-window "Move Window")
     (?c aw-copy-window "Copy Window")
     (?j aw-switch-buffer-in-window "Select Buffer")
    (?n aw-flip-window)
    (?u aw-switch-buffer-other-window "Switch Buffer Other Window")
    (?c aw-split-window-fair "Split Fair Window")
    (?v aw-split-window-vert "Split Vert Window")
    (?b aw-split-window-horz "Split Horz Window")
    (?o delete-other-windows "Delete Other Windows")
    (?? aw-show-dispatch-help))
  "List of actions for `aw-dispatch-default'.")

;; For hydra ace-window scrolling
(defun joe-scroll-other-window()
  (interactive)
  (scroll-other-window 1))
(defun joe-scroll-other-window-down ()
  (interactive)
  (scroll-other-window-down 1))

;; Ace-window multiple cursors
(use-package ace-mc
   :ensure t
  )
;;  :bind (("<C-m> h"   . ace-mc-add-multiple-cursors)
;;         ("<C-m> M-h" . ace-mc-add-single-cursor)))
(global-set-key (kbd "C-c m") 'ace-mc-add-multiple-cursors)
(global-set-key (kbd "C-c s") 'ace-mc-add-single-cursor)


(use-package transpose-frame
	:ensure t
	:defer 1)

;;
;;
;; (use-package ace-window
;;   :ensure t
;;   :defer 1
;;   :bind* ("<C-return>" . ace-window)
;;   :config
;;   (set-face-attribute
;;    'aw-leading-char-face nil
;;    :foreground "deep sky blue"
;;    :weight 'bold
;;    :height 3.0)
;;   (set-face-attribute
;;    'aw-mode-line-face nil
;;    :inherit 'mode-line-buffer-id
;;    :foreground "lawn green")
;;   (setq aw-keys '(?a ?s ?d ?f ?j ?k ?l)
;;         aw-dispatch-always t
;;         aw-dispatch-alist
;;         '((?x aw-delete-window "Ace - Delete Window")
;;           (?c aw-swap-window "Ace - Swap Window")
;;           (?n aw-flip-window)
;;           (?v aw-split-window-vert "Ace - Split Vert Window")
;;           (?h aw-split-window-horz "Ace - Split Horz Window")
;;           (?m delete-other-windows "Ace - Maximize Window")
;;           (?g delete-other-windows)
;;           (?b balance-windows)
;;           (?u (lambda ()
;;                 (progn
;;                   (winner-undo)
;;                   (setq this-command 'winner-undo))))
;;           (?r winner-redo)))
;;
;;   (when
;;       ;;(package-installed-p 'hydra)
;;       ()
;;     (defhydra hydra-window-size (:color red)
;;       "Windows size"
;;       ("h" shrink-window-horizontally "shrink horizontal")
;;       ("j" shrink-window "shrink vertical")
;;       ("k" enlarge-window "enlarge vertical")
;;       ("l" enlarge-window-horizontally "enlarge horizontal"))
;;     (defhydra hydra-window-frame (:color red)
;;       "Frame"
;;       ("f" make-frame "new frame")
;;       ("x" delete-frame "delete frame"))
;;     (defhydra hydra-window-scroll (:color red)
;;       "Scroll other window"
;;       ("n" joe-scroll-other-window "scroll")
;;       ("p" joe-scroll-other-window-down "scroll down"))
;;     (add-to-list 'aw-dispatch-alist '(?w hydra-window-size/body) t)
;;     (add-to-list 'aw-dispatch-alist '(?o hydra-window-scroll/body) t)
;;     (add-to-list 'aw-dispatch-alist '(?\; hydra-window-frame/body) t))
;;   (ace-window-display-mode t))




;; Undo-tree 3-15-2022
(use-package undo-tree
  :ensure t)
(global-undo-tree-mode)
;; End Undo-tree



;; Magit 3-13-2022
(use-package magit
  :init
  (message "Loading Magit!")
  :config
  (message "Loaded Magit!")
  :bind (("C-x g" . magit-status)
         ("C-x C-g" . magit-status)))

;; Projectile 3-13-2022
(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))


;; End Projectile



;; RecentF debugging
(require 'recentf)


;; get rid of `find-file-read-only' and replace it with something
;; more useful.
(global-set-key (kbd "C-x C-r") 'ido-recentf-open)

;; enable recent files mode.
(recentf-mode t)

;; 50 files ought to be enough.
(setq recentf-max-saved-items 50)

;; End Recentf


(use-package treemacs
  :ensure t
)
(global-set-key (kbd "M-0") #'treemacs-select-window)

;;(require 'treemacs-all-the-icons)
;;(treemacs-load-theme "all-the-icons")


;; Built-in project package
(require 'project)
(global-set-key (kbd "C-x p f") #'project-find-file)


;; Flymake go to next error
(global-set-key (kbd "C-c N") #'flymake-goto-next-error)
;; Go to previous error
(global-set-key (kbd "C-c P") #'flymake-goto-prev-error)


;;;; (defun luke/select-project ()
;;;;   (interactive)
;;;;   (let (
;;;; 	(projects (directory-files "~/Projects"))))
;;;;   (let (
;;;; 	 (pr (project-current nil (concat "~/Projects/" (ido-completing-read "Select projec;;: " project)))))
;;;; 	 (dirs (project-roots pr))
;;;;   (project-find-file-in (thing-at-point 'filename) dirs pr)))
;;
;;;; (luke/select-project)
;;
;;(defun luke/grep-in-project ()
;;  (interactive)
;;  (let* (
;;         (current-project (project-current t))
;;         (current-project-root (car (project-roots current-project)))
;;         (search-term
;;          (read-from-minibuffer "Search term: ")))
;;    (rgrep search-term "*" current-project-root)
;;    ))
;;


;;;; 3-12-2022
 ;; https://readingworldmagazine.com/emacs/2021-11-14-emacs-how-to-find-just-about-anything-on-your-computer-2/
 ;; Adding counsel,  ivy-rich, swiper

 (use-package counsel
   :ensure t
   :after ivy
   :config
                                         ; Don't start searches with ^
   (setq ivy-initial-inputs-alist nil)
   (counsel-mode)
                                         ;show org-tags in counsel searches
   (setq counsel-org-headline-display-tags t)
                                         ;show org-todos in counsel searches
   (setq counsel-org-headline-display-todo t)

   (define-key ivy-switch-buffer-map (kbd "C-d") 'mu-ivy-kill-buffer)
                                         ;ivy-todo calls org-set-tags-command, remap to counsel-org-tag
   (global-set-key [remap org-set-tags-command] #'counsel-org-tag)

   :bind (
          ([remap describe-function] . counsel-describe-function)
          ([remap describe-command] . helpful-command)
          ([remap describe-variable] . counsel-describe-variable)
          ([remap describe-key] . helpful-key)
          ("M-x" . counsel-M-x)
          ("C-x b" . counsel-switch-buffer)
          ("C-x C-b" . counsel-ibuffer)
          ("C-x C-m" . counsel-imenu) ;headers level 1
          ("C-x C-d" . counsel-bookmarked-directory)
          ;;("C-x f" .  helm-org-rifle-current-buffer)
          ;;("C-x r" .  helm-org-rifle)
          ("C-x C-a" . counsel-rg)
          ("C-x C-r" . counsel-recentf)
          ("C-x C-f" . counsel-find-file)
          ("C-h b" . counsel-descbinds)
          ("M-y" . counsel-yank-pop)
          ("M-SPC" . counsel-shell-history)
          :map minibuffer-local-map
          ("C-r" . 'counsel-minibuffer-history)
          ("C-d" . ivy-switch-buffer-kill); d for delete
          );end bind
   );end counsel

 ;;(use-package recentf
 ;;  :ensure t)
 ;;(recentf-mode 1)

 (use-package all-the-icons-ivy-rich
   :ensure t
   :init (all-the-icons-ivy-rich-mode 1))

 (use-package ivy-rich
   :after (:and ivy counsel)
                                         ;:ensure t
                                         ;:commands (counsel-mode)
   :init
   (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)
   (ivy-rich-mode)
   :config
                                         ;these are david wilsons configurations
   (setq ivy-format-function #'ivy-format-function-line)
   (setq ivy-rich-display-transformers-list
         (plist-put ivy-rich-display-transformers-list
                    'ivy-switch-buffer
                    '(:columns
                      ((ivy-rich-candidate (:width 40))
                       (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right)); return the buffer indicators
                       (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))          ; return the major mode info
                       (ivy-rich-switch-buffer-project (:width 15 :face success))             ; return project name using `projectile'
                       (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))  ; return file path relative to project root or `default-directory' if project is nil
                      :predicate
                      (lambda (cand)
                        (if-let ((buffer (get-buffer cand)))
                            ;; Don't mess with EXWM buffers
                            (with-current-buffer buffer
                              (not (derived-mode-p 'exwm-mode))))))))

                                         ;:hook
   ;;(after-init . ivy-rich-mode)
   )
                                         ;end ivy-rich
 ;;(setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)


 (use-package swiper
   :bind* (("C-s" . swiper)
                                         ;("C-r" . swiper)
           ("C-M-s" . swiper-all)
           ("M-s" . swiper-thing-at-point))
   :bind
   (:map read-expression-map
         ("C-r" . counsel-minibuffer-history))
   );end swiper

 ;; 3-5-2022
 ;; loccur
 (use-package loccur
   :ensure t)

 ;; defines shortcut for loccur of the current word
 (define-key global-map [(control o)] 'loccur-current)
 ;; defines shortcut for the interactive loccur command
 (define-key global-map [(control meta o)] 'loccur)
 ;; defines shortcut for the loccur of the previously found word
 (define-key global-map [(control shift o)] 'loccur-previous-match)

 (define-key global-map (kbd "M-s C-o") 'loccur-isearch)
 (define-key isearch-mode-map (kbd "C-o") 'loccur-isearch)

 ;; Enable vertico
 ;; https://github.com/minad/vertico
 (use-package vertico
   :ensure t
   :init
   (vertico-mode)

   ;; Different scroll margin
   ;; (setq vertico-scroll-margin 0)

   ;; Show more candidates
   (setq vertico-count 20)

   ;; Grow and shrink the Vertico minibuffer
   (setq vertico-resize t)

   ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
   (setq vertico-cycle t)
   )

 ;; Optionally use the `orderless' completion style. See
 ;; `+orderless-dispatch' in the Consult wiki for an advanced Orderless style
 ;; dispatcher. Additionally enable `partial-completion' for file path
 ;; expansion. `partial-completion' is important for wildcard support.
 ;; Multiple files can be opened at once with `find-file' if you enter a
 ;; wildcard. You may also give the `initials' completion style a try.
 (use-package orderless
   :ensure t
   :init
   ;; Configure a custom style dispatcher (see the Consult wiki)
   ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
   ;;       orderless-component-separator #'orderless-escapable-split-on-space)
   (setq completion-styles '(orderless)
         completion-category-defaults nil
         completion-category-overrides '((file (styles partial-completion)))))

 ;; Persist history over Emacs restarts. Vertico sorts by history position.
 (use-package savehist
   :init
   (savehist-mode))

 ;; A few more useful configurations...
 (use-package emacs
   :ensure t
   :init
   ;; Add prompt indicator to `completing-read-multiple'.
   ;; Alternatively try `consult-completing-read-multiple'.
   (defun crm-indicator (args)
     (cons (concat "[CRM] " (car args)) (cdr args)))
   (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

   ;; Do not allow the cursor in the minibuffer prompt
   (setq minibuffer-prompt-properties
         '(read-only t cursor-intangible t face minibuffer-prompt))
   (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

   ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
   ;; Vertico commands are hidden in normal buffers.
   ;; (setq read-extended-command-predicate
   ;;       #'command-completion-default-include-p)

   ;; Enable recursive minibuffers
   (setq enable-recursive-minibuffers t))

 ;; END vertico setup


 (use-package orderless
   :ensure t
   :custom (completion-styles '(orderless)))


 ;; Enable richer annotations using the Marginalia package
 (use-package marginalia
   :ensure t
   ;; Either bind `marginalia-cycle` globally or only in the minibuffer
   :bind (("M-A" . marginalia-cycle)
          :map minibuffer-local-map
          ("M-A" . marginalia-cycle))

   ;; The :init configuration is always executed (Not lazy!)
   :init

   ;; Must be in the :init section of use-package such that the mode gets
   ;; enabled right away. Note that this forces loading the package.
   (marginalia-mode))


;;; https://github.com/oantolin/embark
;;; Embark: Emacs Mini-Buffer Actions Rooted in Keymaps
 (use-package embark
   :ensure t

   :bind
   (("C-." . embark-act)         ;; pick some comfortable binding
    ("C-;" . embark-dwim)        ;; good alternative: M-.
    ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

   :init

   ;; Optionally replace the key help with a completing-read interface
   (setq prefix-help-command #'embark-prefix-help-command)

   :config

   ;; Hide the mode line of the Embark live/completions buffers
   (add-to-list 'display-buffer-alist
                '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                  nil
                  (window-parameters (mode-line-format . none)))))

 ;; Consult users will also want the embark-consult package.
 (use-package embark-consult
   :ensure t
   :after (embark consult)
   :demand t ; only necessary if you have the hook below
   ;; if you want to have consult previews as you move around an
   ;; auto-updating embark collect buffer
   :hook
   (embark-collect-mode . consult-preview-at-point-mode))



;;; oooooo   oooo                                 o8o
;;;  `888.   .8'                                  `"'
;;;   `888. .8'    .oooo.    .oooo.o ooo. .oo.   oooo  oo.ooooo.  oo.ooooo.
;;;    `888.8'    `P  )88b  d88(  "8 `888P"Y88b  `888   888' `88b  888' `88b
;;;     `888'      .oP"888  `"Y88b.   888   888   888   888   888  888   888
;;;      888      d8(  888  o.  )88b  888   888   888   888   888  888   888
;;;     o888o     `Y888""8o 8""888P' o888o o888o o888o  888bod8P'  888bod8P'
;;;                                                     888        888
;;;                                                    o888o      o888o

;;;               .
;;;             .o8
;;;  .ooooo.  .o888oo
;;; d88' `88b   888
;;; 888ooo888   888
;;; 888    .o   888 .
;;; `Y8bod8P'   "888"

(use-package yasnippet
  :ensure
  :bind
  (:map yas-minor-mode-map
        ("M-z". yas-expand)
        ([(tab)] . nil)
        ("TAB" . nil))
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode))

;;(define-key yas-minor-mode-map [(tab)] nil)
;;(define-key yas-minor-mode-map (kbd "TAB") nil)

(yas-global-mode 1)


;;(use-package ivy-yasnippet
;;  :ensure t)
;;
;;;;(use-package pretty-hydra
;;;;	:ensure t)
;;(use-package ivy-hydra
;;  :ensure t
;;)
;;


(use-package major-mode-hydra
  :ensure t
  :demand t
  :bind
  ("C-M-SPC" . major-mode-hydra)
  :config
  (major-mode-hydra-define org-mode
    ()
    ("Tools"
     (("l" org-lint "lint")))))


;; Hydra Posframe 3-16-2022
;; NOTE: hydra and posframe are required
;;(use-package hydra-posframe
;;  :load-path "~/.emacs.d/packages"
;;  :hook (after-init . hydra-posframe-enable))
;;
;;
;;
;;
;;
;;;; Occur customizations plus hydra 3-16-2022
;;;; https://github.com/abo-abo/hydra/wiki/Emacs
;;
;;(defun occur-dwim ()
;;  "Call `occur' with a sane default, chosen as the thing under point or selected region"
;;  (interactive)
;;  (push (if (region-active-p)
;;            (buffer-substring-no-properties
;;             (region-beginning)
;;             (region-end))
;;          (let ((sym (thing-at-point 'symbol)))
;;            (when (stringp sym)
;;              (regexp-quote sym))))
;;        regexp-history)
;;  (call-interactively 'occur))
;;
;;;; Keeps focus on *Occur* window, even when when target is visited via RETURN key.
;;;; See hydra-occur-dwim for more options.
;;(defadvice occur-mode-goto-occurrence (after occur-mode-goto-occurrence-advice activate)
;;  (other-window 1)
;;  (hydra-occur-dwim/body))
;;
;;;; Focus on *Occur* window right away.
;;(add-hook 'occur-hook (lambda () (other-window 1)))
;;
;;(defun reattach-occur ()
;;  (if (get-buffer "*Occur*")
;;      (switch-to-buffer-other-window "*Occur*")
;;    (hydra-occur-dwim/body) ))
;;
;;;; Used in conjunction with occur-mode-goto-occurrence-advice this helps keep
;;;; focus on the *Occur* window and hides upon request in case needed later.
;;(defhydra hydra-occur-dwim ()
;;  "Occur mode"
;;  ("o" occur-dwim "Start occur-dwim" :color red)
;;  ("j" occur-next "Next" :color red)
;;  ("k" occur-prev "Prev":color red)
;;  ("h" delete-window "Hide" :color blue)
;;  ("r" (reattach-occur) "Re-attach" :color red))
;;
;;(global-set-key (kbd "C-x o") 'hydra-occur-dwim/body)
;;
;;;; End occur hydra
;;


;;; oooooo   oooooo     oooo            .o8           .oooooo..o ooooooooooooo
;;;  `888.    `888.     .8'            "888          d8P'    `Y8 8'   888   `8
;;;   `888.   .8888.   .8'    .ooooo.   888oooo.     Y88bo.           888
;;;    `888  .8'`888. .8'    d88' `88b  d88' `88b     `"Y8888o.       888
;;;     `888.8'  `888.8'     888ooo888  888   888         `"Y88b      888
;;;      `888'    `888'      888    .o  888   888    oo     .d8P      888
;;;       `8'      `8'       `Y8bod8P'  `Y8bod8P'    8""88888P'      o888o
;; web-mode
(setq-default tab-width 2)
(setq indent-tabs-mode nil)
(defun luke/webmode-hook ()
 "Webmode hooks."
 (setq web-mode-enable-comment-annotation t)
 (setq web-mode-markup-indent-offset 2)
 (setq web-mode-code-indent-offset 2)
 (setq web-mode-css-indent-offset 2)
 (setq web-mode-attr-indent-offset 2)
 (setq web-mode-enable-auto-indentation t)
 (setq web-mode-enable-auto-closing t)
 (setq web-mode-enable-auto-pairing t)
 (setq web-mode-enable-css-colorization t)
 )

(add-to-list 'auto-mode-alist '("\\.svelte\\'" . web-mode))
 (setq web-mode-engines-alist
       '(("svelte" . "\\.svelte\\'")))
(add-to-list 'auto-mode-alist '("\\.njk\\'" . web-mode))

(use-package web-mode
 :ensure t
 :mode (("\\.jsx?\\'" . web-mode)
        ("\\.tsx?\\'" . web-mode)
				 ("\\.njk?\\'" . web-mode)
        ("\\.html\\'" . web-mode))

 :commands web-mode
 :mode-hydra
 ((:title "Web Commands")
  ("Mode"
   (
    ("p" php-mode "PHP Mode")
    ("w" web-mode "WEB Mode")
    ("g" html-mode "HTML Mode")
    ("3" js2-mode "Javascript Mode")
    ("e" emmet-mode "Emmet Mode" )
    ("M" emmet-cheat-sheet "Emmet Cheat Sheet")
    ("P" php-cheat-sheet "PHP Cheat Sheet")
    ("J" js-cheat-sheet "Javascript Cheat Sheet")
    ("B" bootstrap-cheat-sheet "Bootstrap Cheat Sheet")
    ("W" wordpress-cheat-u "Wordpress Cheat Sheet")
    ("4" css-grid-cheat-sheet "CSS-GRID Cheat Sheet" )
    ( "r" refresh-chrome "Refresh Chrome")
    );end mode
   "Action"
   (
    (";" comment-out-region "Comment Out Region" )
    ("." smart-comment-line "Smart Comment Line" )
    ("i" insert-yasnippet "Insert Yasnippet" )
    ("H" helm-emmet "Helm Select Emmet" )
    ("m" company-web-html "HTML Complete" )
    ("t" company-complete "Company Complete")
    ("I" highlight-indent-guides-mode  "Show Indent Guides" :toggle t )
    ("E" elnode-make-webserver "Make Elnode Server (choose 8028)")
    ("7" list-elnode-servers "List Elnode Servers")
    ("6" elnode-stop "Stop Elnode Servers")
    ("1" elnode-start "Start Elnode Server")
    ("0" visit-localhost-elnode "Elnode-8028 Local Host")
    ("8" jump-to-elnode-public "Jump ELNODE PUBLIC (in /emacs)")
    )));end action


 :hook (web-mode . luke/webmode-hook)
 ) ;; End of webmode


(use-package format-all
 :ensure t
)


;;; https://github.com/smihica/emmet-mode
(use-package emmet-mode
 :ensure t)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
;;;If you want the cursor to be positioned between first empty quotes after expanding:
(setq emmet-move-cursor-between-quotes t) ;; default nil
;;(add-to-list 'emmet-jsx-major-modes 'your-jsx-major-mode)
;;jsx-mode
;;rjsx-mode
;;js-jsx-mode
;;js2-jsx-mode
;;js-mode



;;;; company
;;(setq company-minimum-prefix-length 1
;;      company-idle-delay 0.0)
;;(use-package company
;;  :ensure t
;;  :config (global-company-mode t))



;;(use-package prettier-js
;;  :ensure t
;;  :config (setq prettier-js-args '("--bracket-same-line" t))
;;  (add-hook 'web-mode-hook #'(lambda ()
;;                               (enable-minor-mode
;;                                '("\\.jsx?\\'" . prettier-js-mode))
;;                               (enable-minor-mode
;;                                '("\\.tsx?\\'" . prettier-js-mode))))
;;
;;  (eval-after-load 'web-mode
;;    '(progn
;;       (add-hook 'web-mode-hook #'add-node-modules-path)
;;       (add-hook 'web-mode-hook #'prettier-js-mode))))
;;
;;;; (setq prettier-js-args '(
;;;;  												 "--bracket-same-line" "false"
;;;; 												 )
;;
;;
;;(use-package editorconfig
;;  :ensure t
;;  :config
;;  (editorconfig-mode 1))
;;
;;(use-package npm-mode
;;  :ensure t
;;  :config
;;  (npm-global-mode))
;;
;;;; Custom functions
;;(defun lukewh/kill-buffer ()
;;  "Kill the active buffer."
;;  (interactive)
;;  (kill-buffer (current-buffer)))
;;
;;(global-set-key (kbd "C-x K") 'lukewh/kill-buffer)
;;


;;DOOM THEMES 3-16-2022
;;https://github.com/doomemacs/themes#manually
(use-package doom-themes
 :ensure t
 :config
 ;; Global settings (defaults)
 (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
       doom-themes-enable-italic t) ; if nil, italics is universally disabled
 (load-theme 'doom-molokai t)
 ;; (load-theme 'doom-dark+ t)
 ;; (load-theme 'doom-gruvbox t)
 ;; (load-theme 'doom-peacock t)


 ;; Enable flashing mode-line on errors
 (doom-themes-visual-bell-config)
 ;; Enable custom neotree theme (all-the-icons must be installed!)
 ;;(doom-themes-neotree-config)
 ;; or for treemacs users

 (setq doom-themes-treemacs-theme "doom-colors") ; use "doom-colors" for less minimal icon theme
 (setq doom-themes-treemacs-enable-variable-pitch nil)
 ;;(setq doom-variable-pitch-font (font-spec :family "Iosevka Term" :size 11))
 (doom-themes-treemacs-config)
 ;; Corrects (and improves) org-mode's native fontification.
 (doom-themes-org-config))


;;DOOM modeline 3-16-2022
;; (use-package doom-modeline
;;  :ensure t
;;  :init (doom-modeline-mode 1))

;;; MVZ 12-27-2022 DOOM modeline new
;;; https://www.reddit.com/r/emacs/comments/dhrl56/post_your_emacsscreenshot_here/

(use-package doom-modeline
  :init (setq doom-modeline-height 0) ;; 0 fit font height
  :hook (after-init . doom-modeline-mode)
  :custom-face
  (mode-line ((t (:height 1.00)))) ;; 1.06 random sufficient scale
  (mode-line-inactive ((t (:height 1.00)))) ;; same
  :config
  (setq doom-modeline-bar-width 0)
  
  (size-indication-mode 0)
  (setq doom-modeline-buffer-file-name-style 'truncate-except-project) ;; full path
  ;; only one number for checker infomation
  (setq doom-modeline-checker-simple-format t)
  ;; exclude caching during GC
  (setq inhibit-compacting-font-caches t)
  
  (setq doom-modeline-icon t)
  ;; no color for icons (because of current theme)
  (setq doom-modeline-major-mode-color-icon nil)
  (setq doom-modeline-buffer-modification-icon t) ;; read-only icon
  (setq doom-modeline-buffer-state-icon t) ;; save icon 

  (setq doom-modeline-vcs-max-length 12)
  ;; (setq doom-modeline-)
  
  ;; whether to display indentation information.
  (setq doom-modeline-indent-info nil)
  (setq doom-modeline-enable-word-count nil)
  ;; show version of python/rust environments
  (setq doom-modeline-env-version t)
  (setq doom-modeline-env-enable-python t)
  (setq doom-modeline-env-enable-ruby t)
  (setq doom-modeline-env-enable-perl t)
  (setq doom-modeline-env-enable-go t)
  (setq doom-modeline-env-enable-elixir t)
  (setq doom-modeline-env-enable-rust t)

  ;; change the executables to use for the language version string
  (setq doom-modeline-env-python-executable "python") 
  (setq doom-modeline-env-ruby-executable "ruby")
  (setq doom-modeline-env-perl-executable "perl")
  (setq doom-modeline-env-go-executable "go")
  (setq doom-modeline-env-elixir-executable "iex")
  (setq doom-modeline-env-rust-executable "rustc")

  (setq doom-modeline-env-load-string "v.?")

  (setq doom-modeline-enable-word-count nil)
  (doom-modeline-def-modeline
    'my-doom-mode-line
    '(input-method
      media-info
      workspace-name
      window-number
      ;;bar
      buffer-info
      " "
      matches
      vcs
      remote-host
      ;;nyan-mode
      ;;parrot
      selection-info)
    '(misc-info
      input-method
      ;;buffer-encoding
      process
      major-mode
      checker
      debug
      lsp
      github
;;;      display-battery
      buffer-position
      pdf-pages
      "   "))

  (defun my-setup-custom-doom-modeline ()
    (doom-modeline-set-modeline 'my-doom-mode-line 'default))

  (add-hook 'doom-modeline-mode-hook 'my-setup-custom-doom-modeline)
)




;;When running emacsclient -c this will ensure theme loads theme
(defvar my:theme 'doom-molokai)
(defvar my:theme-window-loaded nil)
(defvar my:theme-terminal-loaded nil)

(if (daemonp)
   (add-hook 'after-make-frame-functions(lambda (frame)
                      (select-frame frame)
                      (if (window-system frame)
                          (unless my:theme-window-loaded
                            (if my:theme-terminal-loaded
                                (enable-theme my:theme)
                              (load-theme my:theme t))
                           (setq my:theme-window-loaded t))
                        (unless my:theme-terminal-loaded
                          (if my:theme-window-loaded
                              (enable-theme my:theme)
                            (load-theme my:theme t))
                         (setq my:theme-terminal-loaded t)))))

 (progn
   (load-theme my:theme t)
   (if (display-graphic-p)
       (setq my:theme-window-loaded t)
     (setq my:theme-terminal-loaded t))))



;; lsp-mode testing 12-23-2022  emacs 29.0.60
(use-package which-key
    :config
    (which-key-mode))


;; MVZ 12-23-2022
;; https://www.chadstovern.com/javascript-in-emacs-revisited/

(use-package add-node-modules-path
  :defer t
  :hook (((js2-mode rjsx-mode) . add-node-modules-path)))

(use-package prettier-js
  :defer t
  :diminish prettier-js-mode
  :hook (((js2-mode rjsx-mode) . prettier-js-mode))
  :init
  ;;(evil-leader/set-key-for-mode 'rjsx-mode
  ;;  "fp" 'prettier-js-mode)
 ) ; (f)ormat (p)rettier


(use-package company
;;  :diminish "⇥"
  :config
;;  (global-company-mode)
  (company-tng-configure-default))

(add-hook 'after-init-hook 'global-company-mode)
(setq company-idle-delay 0.0
                company-minimum-prefix-length 1
                company-show-numbers t)



 (use-package lsp-mode
  :defer t
  :diminish lsp-mode
  :hook (((js2-mode rjsx-mode) . lsp))
  :commands lsp
  :config
  (setq lsp-auto-configure t
        lsp-auto-guess-root t
        ;; don't set flymake or lsp-ui so the default linter doesn't get trampled
        lsp-diagnostic-package :none)
  ;;; keybinds after load
;;  (evil-leader/set-key
;;    "jd"  #'lsp-goto-type-definition ; (j)ump to (d)efinition
;;    "jb"  #'xref-pop-marker-stack)
); (j)ump (b)ack to marker


;;(use-package company-lsp
;; :defer t
;;  :config
;;  (setq company-lsp-cache-candidates 'auto
;;        company-lsp-async t
;;        company-lsp-enable-snippet nil
;;        company-lsp-enable-recompletion t))

;; MVZ 12-23-2022 company-lsp no longer working, use capf instead?
;;(use-package company
;;  :hook (prog-mode . company-mode)
;;  :config
;;  (setq lsp-completion-provider :capf))



(use-package lsp-ui
  :ensure t
	:after lsp-mode
  :config
  (setq lsp-ui-sideline-enable t
        ;; disable flycheck setup so default linter isn't trampled
        lsp-ui-flycheck-enable nil
				lsp-ui-sideline-show-symbol t
				lsp-ui-sideline-show-hover t
       lsp-ui-sideline-show-code-actions t
       lsp-ui-peek-enable t
       lsp-ui-imenu-enable t
       lsp-ui-doc-enable t
			 )
	:commands lsp-ui-mode
	)

;; MVZ added to this setup 12-23-2022
;;;(use-package flycheck
;;;  :ensure t
;;;  :init (global-flycheck-mode))


(use-package flycheck
  :defer t
  :diminish flycheck-mode
  :init
  (add-hook 'after-init-hook #'global-flycheck-mode)
  :config
  (setq-default flycheck-check-syntax-automatically '(mode-enabled save))
  ;; disable documentation related emacs lisp checker
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc clojure-cider-typed))
  (setq flycheck-mode-line-prefix "✔"))

;; (use-package flycheck-inline
;;   :defer t
;;   :after (flycheck)
;;   :hook ((flycheck-mode . turn-on-flycheck-inline)))

(use-package flymake
  :ensure nil
  :defer t
  :diminish flymake-mode)

(use-package rjsx-mode
 :mode ("\\.js\\'"
        "\\.jsx\\'")
 :config
 (setq js2-mode-show-parse-errors nil
       js2-mode-show-strict-warnings nil
       js2-basic-offset 2
       js-indent-level 2)
 (setq-local flycheck-disabled-checkers (cl-union flycheck-disabled-checkers
                                                  '(javascript-jshint))) ; jshint doesn't work for JSX
 (electric-pair-mode 1))
 ;; (evil-leader/set-key-for-mode 'rjsx-mode
;;   "fu"  #'lsp-find-references          ; (f)ind (u)sages
;;   "fp" 'prettier-js-mode))             ; (f)ormat (p)rettier



;; End JS setup from https://www.chadstovern.com/javascript-in-emacs-revisited/





;; lsp-mode old setup
;;(setq lsp-log-io nil) ;; Don't log everything = speed
;;(setq lsp-keymap-prefix "C-c l")
;;;;(setq lsp-restart 'auto-restart)
;;(setq lsp-ui-sideline-show-diagnostics t)
;;(setq lsp-ui-sideline-show-hover t)
;;(setq lsp-ui-sideline-show-code-actions t)
;;(setq lsp-diagnostics-provider :flymake)
;;(setq lsp-ui-doc-enable t)
;;(setq lsp-ui-doc-position 'at-point)
;;;;(global-set-key (kbd "C-.") #'lsp-ui-peek-find-definitions)
;;
;;(use-package lsp-mode
;;  :ensure t
;;  :hook (
;;         (web-mode . lsp-deferred)
;;         (lsp-mode . lsp-enable-which-key-integration)
;;         )
;;  :commands lsp-deferred)
;;
;;
;;(use-package lsp-ui
;;  :ensure t
;;  :commands lsp-ui-mode)
;;
;;(use-package lsp-python-ms
;;  :ensure t
;;  :init (setq lsp-python-ms-auto-install-server t)
;;  :hook (python-mode . (lambda ()
;;                         (require 'lsp-python-ms)
;;                         (lsp))))  ; or lsp-deferred
;;
;;
;;(defun enable-minor-mode (my-pair)
;;  "Enable minor mode if filename match the regexp.  MY-PAIR is a cons cell (regexp . minor-mode)."
;;  (if (buffer-file-name)
;;      (if (string-match (car my-pair) buffer-file-name)
;;          (funcall (cdr my-pair)))))
;;


;; mvz 3-29-2019
    ;; Introduce key chords
    ;; KEY CHORDS!!!

    (use-package key-chord
      :ensure t
      :defer t)

    ;; Shorten delay sensitivity
    (setq key-chord-two-keys-delay .15
          key-chord-one-key-delay .15)

    ;; https://emacsredux.com/blog/2013/04/28/switch-to-previous-buffer/
    (defun er-switch-to-previous-buffer ()
      "Switch to previously open buffer.
    Repeated invocations toggle between the two most recently open buffers."
      (interactive)
      (switch-to-buffer (other-buffer (current-buffer) 1)))

    (key-chord-define-global "JJ" #'er-switch-to-previous-buffer)
    (key-chord-define-global ";'" #'smex)
    (key-chord-define-global "fj" #'ace-jump-mode)
    (key-chord-define-global "gk" #'ace-jump-mode-pop-mark)
    (key-chord-define-global "zx" #'ace-window)



    ;; https://www.reddit.com/r/emacs/comments/22hzx7/what_are_your_keychord_abbreviations/
    ;; Opening Files
    (key-chord-define-global "o0" 'helm-find-files)
    (key-chord-define-global "o=" 'dired-jump)
    (key-chord-define-global "o-" 'counsel-recentf)
    (key-chord-define-global "o[" 'find-file-at-point)

    ;; One for projectile:
    (key-chord-define-global "p-" 'projectile-find-file)

    ;; Bind replace-string to something useful:
    (key-chord-define-global "r4" 'replace-string)
    (key-chord-define-global "r3" 'vr/query-replace)
    (key-chord-define-global "r5" 'helm-ag)


    ;; Expand/contract region
    (key-chord-define-global "e3" 'er/expand-region)
    (key-chord-define-global "e2" 'er/contract-region)

    ;; Quick access to useful functions:
    (key-chord-define-global "t5" 'untabify)
    (key-chord-define-global "p[" 'fill-paragraph)
    (key-chord-define-global "p]" 'unfill-paragraph)
    (key-chord-define-global " k" 'delete-trailing-whitespace)
    (key-chord-define-global "m," 'my-previous-like-this)
    (key-chord-define-global "m." 'my-more-like-this)
    (key-chord-define-global "s1" 'ispell-region)
    (key-chord-define-global "[]" 'deft)
    (key-chord-define-global ";u" 'undo-tree-visualize)
 ;; window management:
  (key-chord-define-global ";2" 'double-window)
  (key-chord-define-global ";3" 'triple-window)
  (key-chord-define-global ";8" 'eighty-columns)
  (key-chord-define-global ";w" 'one-hundred-thirty-two-columns)
  (key-chord-define-global ";s" 'rotate-windows)  ;; "s" for switch

    (key-chord-define-global "e5" 'sp-change-enclosing)

    (key-chord-mode +1)


  ;; ace-jump-mode
  ;; mvz 3-29-2019

  ;;
  ;; ace jump mode major function
  ;;
  ;; (use-package ace-jump-mode

  ;;   :defer t)
  ;; (autoload
  ;;   'ace-jump-mode
  ;;   "ace-jump-mode"
  ;;   "Emacs quick move minor mode"
  ;;   t)
  ;; ;; you can select the key you prefer to
  ;; (define-key global-map (kbd "C-c SPC") 'ace-jump-mode)



  ;; ;;
  ;; ;; enable a more powerful jump back function from ace jump mode
  ;; ;;
  ;; (autoload
  ;;   'ace-jump-mode-pop-mark
  ;;   "ace-jump-mode"
  ;;   "Ace jump back:-)"
  ;;   t)
  ;; (eval-after-load "ace-jump-mode"
  ;;   '(ace-jump-mode-enable-mark-sync))
  ;; (define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)


;;;; CTRLF
;;;; https://github.com/raxod502/ctrlf
;;
;;(straight-use-package
;; '(ctrlf :host github :repo "raxod502/ctrlf"))
;;
;;;; (use-package ctrlf
;;;;   :defer 3
;;;;   :straight (ctrlf :host github :repo "raxod502/ctrlf")
;;;;   :config
;;;;   (ctrlf-mode))
;;
;;(bind-key "C-f" 'ctrlf-forward-fuzzy)


;;;; https://github.com/alphapapa/bufler.el
;;;; 3-11-2020
;;(straight-use-package
;;  '(bufler :host github :repo "alphapapa/bufler.el"))
;;
;;(bind-key "C-x C-b" 'bufler)
;;
;;'(package-selected-packages
;;  '(minions borg yaml-mode figlet ivy-yasnippet multiple-cursors eyebrowse prettier emacsql-sqlite3 f3 wgrep ivy-posframe hydra-posframe move-text doom-modeline highlight-indent-guides doom-themes focus golden-ratio scrollkeeper -t undo-tree counsel-projectile treemacs-magit diff-hl lsp-treemacs ivy-hydra helpful octicons all-the-icons-ivy-rich ivy-rich counsel swiper beacon emmet-mode loccur treemacs-projectile treemacs-all-the-icons treemacs yasnippet-snippets js-react-redux-yasnippets yasnippet embark-consult embark marginalia orderless vertico rainbow-delimiters all-the-icons telephone-line editorconfig add-node-modules-path flymake-cursor lsp-python-ms modus-themes modus-vivendi-theme npm-mode mini-frame prettier-js lsp-ui lsp-mode modus-operandi-theme magit company web-mode json-mode expand-region which-key exec-path-from-shell use-package))
;;(custom-set-faces
;; ;; custom-set-faces was added by Custom.
;; ;; If you edit it by hand, you could mess it up, so be careful.
;; ;; Your init file should contain only one such instance.
;; ;; If there is more than one, they won't work right.
;; '(default ((t (:family "Iosevka Term" :foundry "UKWN" :slant normal :weight regular :height 120 :width normal))))
;; '(avy-lead-face ((t (:inherit (bold modus-themes-reset-soft) :background "color-57" :weight bold))))
;; '(avy-lead-face-0 ((t (:inherit avy-lead-face :background "color-57"))))
;; '(fixed-pitch-face ((t (:family "Iosevka Nerd Font" :slant normal :weight normal :height 1.2 :width normal))))
;; '(font-lock-comment-face ((t (:foreground "#AA77BB" :slant italic))))
;; '(help-key-binding ((t (:background "red"))))
;; '(hl-line ((t (:background "#444444"))))
;; '(org-agenda-date ((t (:inherit outline-3 (fixed-pitch-face)))))
;; '(org-agenda-date-today ((t (:inherit (outline-1) :foreground "#999999" :height 1.3))))
;; '(org-agenda-structure ((t (:inherit outline-1 :foreground "#999999" :weight bold))))
;; '(org-block ((t (:inherit fixed-pitch-face))))
;; '(org-code ((t (:inherit (fixed-pitch-face)))))
;; '(org-document-info ((t (:foreground "dark orange"))))
;; '(org-document-info-keyword ((t (:inherit (fixed-pitch-face)))))
;; '(org-document-title ((t (:inherit outline-1 :foreground "#999999" :weight light :height 1.7 :family "ETBembo"))))
;; '(org-headline-done ((t (:inherit height :foreground "#888888" :weight light :slant italic :family "ETBembo"))))
;; '(org-indent ((t (:inherit (org-hide fixed-pitch-face)))))
;; '(org-level-1 ((t (:inherit outline-1 :foreground "#999999" :weight bold :height 1.6 :family "ETBembo"))))
;; '(org-level-2 ((t (:inherit outline-2 :foreground "#999999" :weight light :slant italic :height 1.3 :family "ETBembo"))))
;; '(org-level-3 ((t (:inherit outline-3 :foreground "#999999" :weight light :slant italic :height 1.1 :family "ETBembo"))))
;; '(org-level-4 ((t (:inherit outline-4 :foreground "#999999" :weight light :slant italic :height 1.0 :family "ETBembo"))))
;; '(org-link ((t (:foreground "royal blue" :underline t :family "ETBembo"))))
;; '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch-face) :background "#fbf8ef"))))
;; '(org-property-value ((t (:inherit fixed-pitch-face))) t)
;; '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch-face) :foreground "#990000" :background "#fbf8ef"))))
;; '(org-super-agenda-header ((t (:inherit outline-3) :family ETBembo :height 1.2)))
;; '(org-table ((t (:inherit (fixed-pitch-face) :foreground "#83a598"))))
;; '(org-tag ((t (:inherit (fixed-pitch-face) :weight bold :height 0.7 :foreground "#fbf8ef" :background "#660022"))))
;; '(org-todo ((t (:inherit (fixed-pitch-face) :weight bold :foreground "#990000" :background "#fbf8ef"))))
;; '(org-verbatim ((t (:inherit (fixed-pitch-face)))))
;; '(outline-1 ((t (:family "ETBembo"))))
;; '(outline-2 ((t (:family "ETBembo"))))
;; '(outline-3 ((t (:family "ETBembo"))))
;; '(outline-4 ((t (:family "ETBembo")))))
;;(custom-set-variables
;; ;; custom-set-variables was added by Custom.
;; ;; If you edit it by hand, you could mess it up, so be careful.
;; ;; Your init file should contain only one such instance.
;; ;; If there is more than one, they won't work right.
;; '(column-number-mode t)
;; '(custom-safe-themes
;;	 '("4fda8201465755b403a33e385cf0f75eeec31ca8893199266a6aeccb4adedfa4" "e87f48ec4aebdca07bb865b90088eb28ae4b286ee8473aadb39213d361d0c45f" "0c08a5c3c2a72e3ca806a29302ef942335292a80c2934c1123e8c732bb2ddd77" "b99e334a4019a2caa71e1d6445fc346c6f074a05fcbb989800ecbe54474ae1b0" "e3daa8f18440301f3e54f2093fe15f4fe951986a8628e98dcd781efbec7a46f2" "046e442b73846ae114d575a51be9edb081a1ef29c05ae5e237d5769ecfd70c2e" default))
;; '(global-display-line-numbers-mode t)
;; '(tool-bar-mode nil))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
	 '("be84a2e5c70f991051d4aaf0f049fa11c172e5d784727e0b525565bb1533ec78" "443e2c3c4dd44510f0ea8247b438e834188dc1c6fb80785d83ad3628eadf9294" "2dc03dfb67fbcb7d9c487522c29b7582da20766c9998aaad5e5b63b5c27eec3f" "0cd00c17f9c1f408343ac77237efca1e4e335b84406e05221126a6ee7da28971" "cffc64e7e3f0639cfeee833856beeb879e8f03e47901b24ca6ddd67d9a761df5" "8d5f22f7dfd3b2e4fc2f2da46ee71065a9474d0ac726b98f647bc3c7e39f2819" "7e377879cbd60c66b88e51fad480b3ab18d60847f31c435f15f5df18bdb18184" "6945dadc749ac5cbd47012cad836f92aea9ebec9f504d32fe89a956260773ca4" "e3daa8f18440301f3e54f2093fe15f4fe951986a8628e98dcd781efbec7a46f2" "b54376ec363568656d54578d28b95382854f62b74c32077821fdfd604268616a" "8d8207a39e18e2cc95ebddf62f841442d36fcba01a2a9451773d4ed30b632443" "251ed7ecd97af314cd77b07359a09da12dcd97be35e3ab761d4a92d8d8cf9a71" "4fda8201465755b403a33e385cf0f75eeec31ca8893199266a6aeccb4adedfa4" "b99e334a4019a2caa71e1d6445fc346c6f074a05fcbb989800ecbe54474ae1b0" default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hl-line ((t (:extend t :background "brightblack")))))
