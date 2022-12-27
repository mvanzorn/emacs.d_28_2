;; Prerequisites:
;; Install Node
;; https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-20-04
;; Install nvm
;; npm i -g typescript-language-server; npm i -g typescript
;; npm i -g prettier

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

;; TRAMP DEBUGGIN / OPTIMIZATION
(setq vc-handled-backends '(Git))
(setq tramp-verbose 1)
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


;; ORG-MODE
;;(use-package org-contrib)

(use-package org)
	     

;; END ORG-MODE





;; Beacon
(use-package beacon)
(beacon-mode 1)

;; Minimap
(use-package minimap)
(setq minimap-window-location 'right)




;; make cursor the width of the character it is under
;; i.e. full width of a TAB
(setq x-stretch-cursor t)

;; Multiple cursors 3-22-2022
(use-package multiple-cursors
  :ensure   t
  :bind ( ;;("H-SPC" . set-rectangular-region-anchor)
         ;;("C-M-SPC" . set-rectangular-region-anchor)
         (" C->" . mc/mark-next-like-this)
         (" C-<" . mc/mark-previous-like-this)
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



;; ;;Scrollkeeper 3-16-2022
;; (use-package scrollkeeper
;;   :ensure t)
;; (global-set-key [remap scroll-up-command] 'scrollkeeper-contents-up)
;; (global-set-key [remap scroll-down-command] 'scrollkeeper-contents-down)

;; Golden ratio mode 3-16-2022
;; (use-package golden-ratio
;; 	:ensure t)
;; (golden-ratio-mode 1)

;; Zoom mode - replacement for golden-ratio mode 3-16-2022
(use-package zoom
	:ensure t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-display-line-numbers-mode t)
 '(minimap-mode t)
 '(minimap-width-fraction 0.1)
 '(org-file-apps
	 '((auto-mode . emacs)
		 (directory . emacs)
		 ("\\.mm\\'" . default)
		 ("\\.x?html?\\'" . system)
		 ("\\.pdf\\'" . system)))
 '(package-archives
	 '(("gnu" . "https://elpa.gnu.org/packages/")
		 ("melpa" . "https://melpa.org/packages/")
		 ("nongnu" . "https://elpa.nongnu.org/nongnu/")
		 ("org" . "https://orgmode.org/elpa/")))
 '(package-selected-packages
	 '(minions minimap borg yaml-mode figlet ivy-yasnippet multiple-cursors eyebrowse prettier emacsql-sqlite3 f3 wgrep ivy-posframe hydra-posframe move-text doom-modeline highlight-indent-guides doom-themes focus golden-ratio scrollkeeper -t undo-tree counsel-projectile treemacs-magit diff-hl lsp-treemacs ivy-hydra helpful octicons all-the-icons-ivy-rich ivy-rich counsel swiper beacon emmet-mode loccur treemacs-projectile treemacs-all-the-icons treemacs yasnippet-snippets js-react-redux-yasnippets yasnippet embark-consult embark marginalia orderless vertico rainbow-delimiters all-the-icons telephone-line editorconfig add-node-modules-path flymake-cursor lsp-python-ms modus-themes modus-vivendi-theme npm-mode mini-frame prettier-js lsp-ui lsp-mode modus-operandi-theme magit company web-mode json-mode expand-region which-key exec-path-from-shell use-package))
 '(tramp-ssh-controlmaster-options
	 "-o ControlPath=/tmp/ssh-ControlPath-%%r@%%h:%%p -o ControlMaster=auto -o ControlPersist=yes" t)
 '(tramp-use-ssh-controlmaster-options nil)
 '(zoom-ignored-buffer-name-regexps '("^*calc"))
 '(zoom-ignored-buffer-names '("zoom.el"))
 '(zoom-ignored-major-modes '(dired-mode markdown-mode))
 '(zoom-mode t nil (zoom))
 '(zoom-size '(0.618 . 0.618)))

;; Override balance windows 
(global-set-key (kbd "C-x +") 'zoom)

;; '(zoom-ignore-predicates '((lambda () (> (count-lines (point-min) (point-max)) 20)))))

;; Scroll enhancements 3-16-2022
;; Per https://two-wrongs.com/centered-cursor-mode-in-vanilla-emacs
(setq scroll-preserve-screen-position t
      scroll-conservatively 0
      maximum-scroll-margin 0.5
      scroll-margin 99999)

;; Highlight Indent Guides 3-16-2022
(use-package highlight-indent-guides
	:ensure t)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)



;; hl-line+  3-16-2022 
;; (use-package hl-line+
;; 	:load-path "~/.emacs.d/packages/")
;; (toggle-hl-line-when-idle 1)

(use-package hl-line+
	:load-path "~/.emacs.d/packages/"
  :hook
  (window-scroll-functions . hl-line-flash)
  (focus-in . hl-line-flash)
  (post-command . hl-line-flash)

  :custom
  (global-hl-line-mode nil)
  (hl-line-flash-show-period 0.5)
  (hl-line-inhibit-highlighting-for-modes '(dired-mode))
  (hl-line-overlay-priority -100) ;; sadly, seems not observed by diredfl
  )


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

; 50 files ought to be enough.
(setq recentf-max-saved-items 50)

;; End Recentf
 

;; 3-12-2022
;; https://readingworldmagazine.com/emacs/2021-11-14-emacs-how-to-find-just-about-anything-on-your-computer-2/
;; Adding counsel,  ivy-rich, swiper

(use-package counsel
;:ensure t
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
("C-x f" .  helm-org-rifle-current-buffer)
("C-x r" .  helm-org-rifle)
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



;; ;;Scrollkeeper 3-16-2022
;; (use-package scrollkeeper
;;   :ensure t)
;; (global-set-key [remap scroll-up-command] 'scrollkeeper-contents-up)
;; (global-set-key [remap scroll-down-command] 'scrollkeeper-contents-down)

;; Golden ratio mode 3-16-2022
;; (use-package golden-ratio
;; 	:ensure t)
;; (golden-ratio-mode 1)

;; Zoom mode - replacement for golden-ratio mode 3-16-2022
(use-package zoom
	:ensure t)


;; Override balance windows 
(global-set-key (kbd "C-x +") 'zoom)

;; '(zoom-ignore-predicates '((lambda () (> (count-lines (point-min) (point-max)) 20)))))

;; Scroll enhancements 3-16-2022
;; Per https://two-wrongs.com/centered-cursor-mode-in-vanilla-emacs
(setq scroll-preserve-screen-position t
      scroll-conservatively 0
      maximum-scroll-margin 0.5
      scroll-margin 99999)

;; Highlight Indent Guides 3-16-2022
(use-package highlight-indent-guides
	:ensure t)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)



;; hl-line+  3-16-2022 
;; (use-package hl-line+
;; 	:load-path "~/.emacs.d/packages/")
;; (toggle-hl-line-when-idle 1)

(use-package hl-line+
	:load-path "~/.emacs.d/packages/"
  :hook
  (window-scroll-functions . hl-line-flash)
  (focus-in . hl-line-flash)
  (post-command . hl-line-flash)

  :custom
  (global-hl-line-mode nil)
  (hl-line-flash-show-period 0.5)
  (hl-line-inhibit-highlighting-for-modes '(dired-mode))
  (hl-line-overlay-priority -100) ;; sadly, seems not observed by diredfl
  )


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

; 50 files ought to be enough.
(setq recentf-max-saved-items 50)

;; End Recentf
 

;; 3-12-2022
;; https://readingworldmagazine.com/emacs/2021-11-14-emacs-how-to-find-just-about-anything-on-your-computer-2/
;; Adding counsel,  ivy-rich, swiper

(use-package counsel
;:ensure t
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
("C-x f" .  helm-org-rifle-current-buffer)
("C-x r" .  helm-org-rifle)
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

(use-package ivy-yasnippet
	:ensure t)


(autoload 'zap-up-to-char "misc"
    "Kill up to, but not including ARGth occurrence of CHAR.
  
  \(fn arg char)"
    'interactive)
(global-set-key "\M-Z" 'zap-up-to-char)



;; https://github.com/smihica/emmet-mode
(use-package emmet-mode
	:ensure t)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
;; If you want the cursor to be positioned between first empty quotes after expanding:
(setq emmet-move-cursor-between-quotes t) ;; default nil
;; (add-to-list 'emmet-jsx-major-modes 'your-jsx-major-mode)
;; jsx-mode
;; rjsx-mode
;; js-jsx-mode
;; js2-jsx-mode
;; js-mode



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



;; AVY 3-5-2022
(use-package avy
	:ensure t)
(global-set-key (kbd "C-:") 'avy-goto-char)
(global-set-key (kbd "C-'") 'avy-goto-char-2)
;; input zero chars, jump to a line start with a tree
(global-set-key (kbd "M-g f") 'avy-goto-line)
;;Input zero chars, jump to a word start with a tree.
(global-set-key (kbd "M-g e") 'avy-goto-word-0)

;; ace-window
;; 3-7-2022
(use-package ace-window
	:ensure t)
(global-set-key (kbd "M-o") 'ace-window)
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




;; IDO
;; (setq ido-everywhere            t
;;       ido-enable-prefix         nil
;;       ido-enable-flex-matching  t
;;       ido-auto-merge-work-directories-length nil
;;       ;;ido-use-filename-at-point t
;;       ido-max-prospects         10
;;       ido-create-new-buffer     'always
;;       ;; ido-use-virtual-buffers   t
;;       ;; ido-handle-duplicate-virtual-buffers 2
;;       ido-default-buffer-method 'selected-window
;;       ido-default-file-method   'selected-window)

;; (setq ido-decorations (quote ("\n" "" "\n" "\n ..." "[" "]" "
;;   [No match]" " [Matched]" " [Not readable]" " [Too big]" "
;;   [Confirm]")))
;; (defun ido-disable-line-truncation () (set (make-local-variable 'truncate-lines) nil))
;; (add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-truncation)

;; (defun ido-my-keys ()
;;   (define-key ido-completion-map (kbd "<up>")   'ido-prev-match)
;;   (define-key ido-completion-map (kbd "<down>") 'ido-next-match))

;; (add-hook 'ido-setup-hook 'ido-my-keys)
;; (ido-mode 1)

;; Icomplete
;; (setq icomplete-show-matches-on-no-input t)
;; (setq icomplete-in-buffer t)
;; (icomplete-mode 1)

;; FIDO
;;(fido-mode 1)


(use-package treemacs)



;; Enable vertico
;; https://github.com/minad/vertico
(use-package vertico
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
  ;; Either bind `marginalia-cycle` globally or only in the minibuffer
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init configuration is always executed (Not lazy!)
  :init

  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. Note that this forces loading the package.
  (marginalia-mode))


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





;; ;; Enable icomplete-vertical (Global Emacs minor mode to display icomplete candidates vertically)
;; ;; See https://github.com/oantolin/icomplete-vertical#installation-and-usage
;; (use-package icomplete-vertical
;;   :ensure t  
;;   :config
;;   :hook (icomplete-minibuffer-setup . icomplete-vertical-mode))



;; Built-in project package
(require 'project)
(global-set-key (kbd "C-x p f") #'project-find-file)

;; I need the hash on uk keyboard
;;(global-set-key (kbd "M-3") (lambda () (interactive) (insert "#")))

;; Go to next error
(global-set-key (kbd "C-c N") #'flymake-goto-next-error)
;; Go to previous error
(global-set-key (kbd "C-c P") #'flymake-goto-prev-error)

;; (defun luke/select-project ()
;;   (interactive)
;;   (let (
;; 	(projects (directory-files "~/Projects"))))
;;   (let (
;; 	 (pr (project-current nil (concat "~/Projects/" (ido-completing-read "Select projec;;: " project)))))
;; 	 (dirs (project-roots pr))
;;   (project-find-file-in (thing-at-point 'filename) dirs pr)))

;; (luke/select-project)

(defun luke/grep-in-project ()
  (interactive)
  (let* (
	(current-project (project-current t))
	(current-project-root (car (project-roots current-project)))
	(search-term
	 (read-from-minibuffer "Search term: ")))
    (rgrep search-term "*" current-project-root)
    ))


;; Particles
;; https://github.com/elizagamedev/power-mode.el
;; (setq power-mode-shake-strength nil)
;; (setq power-mode-streak-shake-threshold nil)
;; (use-package power-mode
;;   :load-path "packages"
;;   :init
;;   (add-hook 'after-init-hook #'power-mode))


;; Preferred font
;; Load pragmatapro-lig.el
;;(add-to-list 'load-path "/home/luke/emacs/custom-packages/emacs-pragmatapro-ligatures")
;;(require 'pragmatapro-lig)
;;(add-to-list 'default-frame-alist '(font . "PragmataPro Mono Liga-10"))
;; Enable pragmatapro-lig-mode for specific modes
;;(add-hook 'text-mode-hook 'pragmatapro-lig-mode)
;;(add-hook 'prog-mode-hook 'pragmatapro-lig-mode)
;; or globally
;;(pragmatapro-lig-global-mode)
;;(setq line-spacing 0)

;; General settings
(delete-selection-mode t)
(tool-bar-mode -1)
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq create-lockfiles nil)
(global-display-line-numbers-mode)
(global-prettify-symbols-mode 1)
;;(global-hl-line-mode 1)

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
;;(setq which-key-idle-delay 10000)
(setq which-key-idle-delay 0)
;;(setq which-key-idle-secondary-delay 0.05)
;;(setq which-key-popup-type 'side-window)
(setq which-key-side-window-location 'bottom)
;; Prerequisites:
;; Install Node
;; https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-20-04
;; Install nvm
;; npm i -g typescript-language-server; npm i -g typescript
;; npm i -g prettier

;; make cursor the width of the character it is under
;; i.e. full width of a TAB
(setq x-stretch-cursor t)

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



;; ;;Scrollkeeper 3-16-2022
;; (use-package scrollkeeper
;;   :ensure t)
;; (global-set-key [remap scroll-up-command] 'scrollkeeper-contents-up)
;; (global-set-key [remap scroll-down-command] 'scrollkeeper-contents-down)

;; Golden ratio mode 3-16-2022
;; (use-package golden-ratio
;; 	:ensure t)
;; (golden-ratio-mode 1)

;; Zoom mode - replacement for golden-ratio mode 3-16-2022
(use-package zoom
	:ensure t)


;; Override balance windows 
(global-set-key (kbd "C-x +") 'zoom)

;; '(zoom-ignore-predicates '((lambda () (> (count-lines (point-min) (point-max)) 20)))))

;; Scroll enhancements 3-16-2022
;; Per https://two-wrongs.com/centered-cursor-mode-in-vanilla-emacs
(setq scroll-preserve-screen-position t
      scroll-conservatively 0
      maximum-scroll-margin 0.5
      scroll-margin 99999)

;; Highlight Indent Guides 3-16-2022
(use-package highlight-indent-guides
	:ensure t)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)



;; hl-line+  3-16-2022 
;; (use-package hl-line+
;; 	:load-path "~/.emacs.d/packages/")
;; (toggle-hl-line-when-idle 1)

(use-package hl-line+
	:load-path "~/.emacs.d/packages/"
  :hook
  (window-scroll-functions . hl-line-flash)
  (focus-in . hl-line-flash)
  (post-command . hl-line-flash)

  :custom
  (global-hl-line-mode nil)
  (hl-line-flash-show-period 0.5)
  (hl-line-inhibit-highlighting-for-modes '(dired-mode))
  (hl-line-overlay-priority -100) ;; sadly, seems not observed by diredfl
  )


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

; 50 files ought to be enough.
(setq recentf-max-saved-items 50)

;; End Recentf
 

;; 3-12-2022
;; https://readingworldmagazine.com/emacs/2021-11-14-emacs-how-to-find-just-about-anything-on-your-computer-2/
;; Adding counsel,  ivy-rich, swiper

(use-package counsel
;:ensure t
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
("C-x f" .  helm-org-rifle-current-buffer)
("C-x r" .  helm-org-rifle)
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


;; https://github.com/smihica/emmet-mode
(use-package emmet-mode
	:ensure t)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
;; If you want the cursor to be positioned between first empty quotes after expanding:
(setq emmet-move-cursor-between-quotes t) ;; default nil
;; (add-to-list 'emmet-jsx-major-modes 'your-jsx-major-mode)
;; jsx-mode
;; rjsx-mode
;; js-jsx-mode
;; js2-jsx-mode
;; js-mode



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




;; IDO
;; (setq ido-everywhere            t
;;       ido-enable-prefix         nil
;;       ido-enable-flex-matching  t
;;       ido-auto-merge-work-directories-length nil
;;       ;;ido-use-filename-at-point t
;;       ido-max-prospects         10
;;       ido-create-new-buffer     'always
;;       ;; ido-use-virtual-buffers   t
;;       ;; ido-handle-duplicate-virtual-buffers 2
;;       ido-default-buffer-method 'selected-window
;;       ido-default-file-method   'selected-window)

;; (setq ido-decorations (quote ("\n" "" "\n" "\n ..." "[" "]" "
;;   [No match]" " [Matched]" " [Not readable]" " [Too big]" "
;;   [Confirm]")))
;; (defun ido-disable-line-truncation () (set (make-local-variable 'truncate-lines) nil))
;; (add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-truncation)

;; (defun ido-my-keys ()
;;   (define-key ido-completion-map (kbd "<up>")   'ido-prev-match)
;;   (define-key ido-completion-map (kbd "<down>") 'ido-next-match))

;; (add-hook 'ido-setup-hook 'ido-my-keys)
;; (ido-mode 1)

;; Icomplete
;; (setq icomplete-show-matches-on-no-input t)
;; (setq icomplete-in-buffer t)
;; (icomplete-mode 1)

;; FIDO
;;(fido-mode 1)


(use-package treemacs)



;; Enable vertico
;; https://github.com/minad/vertico
(use-package vertico
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
  ;; Either bind `marginalia-cycle` globally or only in the minibuffer
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init configuration is always executed (Not lazy!)
  :init

  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. Note that this forces loading the package.
  (marginalia-mode))


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





;; ;; Enable icomplete-vertical (Global Emacs minor mode to display icomplete candidates vertically)
;; ;; See https://github.com/oantolin/icomplete-vertical#installation-and-usage
;; (use-package icomplete-vertical
;;   :ensure t  
;;   :config
;;   :hook (icomplete-minibuffer-setup . icomplete-vertical-mode))



;; Built-in project package
(require 'project)
(global-set-key (kbd "C-x p f") #'project-find-file)

;; I need the hash on uk keyboard
;;(global-set-key (kbd "M-3") (lambda () (interactive) (insert "#")))

;; Go to next error
(global-set-key (kbd "C-c N") #'flymake-goto-next-error)
;; Go to previous error
(global-set-key (kbd "C-c P") #'flymake-goto-prev-error)

;; (defun luke/select-project ()
;;   (interactive)
;;   (let (
;; 	(projects (directory-files "~/Projects"))))
;;   (let (
;; 	 (pr (project-current nil (concat "~/Projects/" (ido-completing-read "Select projec;;: " project)))))
;; 	 (dirs (project-roots pr))
;;   (project-find-file-in (thing-at-point 'filename) dirs pr)))

;; (luke/select-project)

(defun luke/grep-in-project ()
  (interactive)
  (let* (
	(current-project (project-current t))
	(current-project-root (car (project-roots current-project)))
	(search-term
	 (read-from-minibuffer "Search term: ")))
    (rgrep search-term "*" current-project-root)
    ))


;; Particles
;; https://github.com/elizagamedev/power-mode.el
;; (setq power-mode-shake-strength nil)
;; (setq power-mode-streak-shake-threshold nil)
;; (use-package power-mode
;;   :load-path "packages"
;;   :init
;;   (add-hook 'after-init-hook #'power-mode))


;; Preferred font
;; Load pragmatapro-lig.el
;;(add-to-list 'load-path "/home/luke/emacs/custom-packages/emacs-pragmatapro-ligatures")
;;(require 'pragmatapro-lig)
;;(add-to-list 'default-frame-alist '(font . "PragmataPro Mono Liga-10"))
;; Enable pragmatapro-lig-mode for specific modes
;;(add-hook 'text-mode-hook 'pragmatapro-lig-mode)
;;(add-hook 'prog-mode-hook 'pragmatapro-lig-mode)
;; or globally
;;(pragmatapro-lig-global-mode)
;;(setq line-spacing 0)

;; General settings
(delete-selection-mode t)
(tool-bar-mode -1)
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq create-lockfiles nil)
(global-display-line-numbers-mode)
(global-prettify-symbols-mode 1)
;;(global-hl-line-mode 1)

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
;;(setq which-key-idle-delay 10000)
(setq which-key-idle-delay 0.01)
;;(setq which-key-idle-secondary-delay 0.05)
;;(setq which-key-popup-type 'side-window)
;;(setq which-key-side-window-location 'bottom)
(which-key-setup-side-window-bottom)
(which-key-setup-minibuffer)
;;(setq which-key-side-window-max-height 0.33)


(use-package expand-region
  :ensure t
  :bind (("C-=" . er/expand-region)
	 ("C--" . er/contract-region)))


;; json-mode
(use-package json-mode
  :ensure t)

;; move-text
(use-package move-text
	:ensure t)
(move-text-default-bindings)


;;(use-package pretty-hydra
;;	:ensure t)
(use-package ivy-hydra)

(use-package major-mode-hydra
    :bind
    ("C-M-SPC" . major-mode-hydra)
    :config
    (major-mode-hydra-define org-mode
      ()
      ("Tools"
       (("l" org-lint "lint")))))


;; Hydra Posframe 3-16-2022
;; NOTE: hydra and posframe are required
(use-package hydra-posframe
	:load-path "~/.emacs.d/packages"
  :hook (after-init . hydra-posframe-enable))





;; Occur customizations plus hydra 3-16-2022
;; https://github.com/abo-abo/hydra/wiki/Emacs

(defun occur-dwim ()
  "Call `occur' with a sane default, chosen as the thing under point or selected region"
  (interactive)
  (push (if (region-active-p)
            (buffer-substring-no-properties
             (region-beginning)
             (region-end))
          (let ((sym (thing-at-point 'symbol)))
            (when (stringp sym)
              (regexp-quote sym))))
        regexp-history)
  (call-interactively 'occur))

;; Keeps focus on *Occur* window, even when when target is visited via RETURN key.
;; See hydra-occur-dwim for more options.
(defadvice occur-mode-goto-occurrence (after occur-mode-goto-occurrence-advice activate)
  (other-window 1)
  (hydra-occur-dwim/body))

;; Focus on *Occur* window right away.
(add-hook 'occur-hook (lambda () (other-window 1)))

(defun reattach-occur ()
  (if (get-buffer "*Occur*")
    (switch-to-buffer-other-window "*Occur*")
    (hydra-occur-dwim/body) ))

;; Used in conjunction with occur-mode-goto-occurrence-advice this helps keep
;; focus on the *Occur* window and hides upon request in case needed later.
(defhydra hydra-occur-dwim ()
  "Occur mode"
  ("o" occur-dwim "Start occur-dwim" :color red)
  ("j" occur-next "Next" :color red)
  ("k" occur-prev "Prev":color red)
  ("h" delete-window "Hide" :color blue)
  ("r" (reattach-occur) "Re-attach" :color red))

(global-set-key (kbd "C-x o") 'hydra-occur-dwim/body)

;; End occur hydra

;; ORG-ROAM 3-16-2022
;; https://github.com/org-roam/org-roam

(setq org-directory (concat (getenv "HOME") "/Documents/notes/"))
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "/path/to/org-files/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))




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


(use-package web-mode
  :ensure t
  :mode (("\\.jsx?\\'" . web-mode)
	 ("\\.tsx?\\'" . web-mode)
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
)


;; company
(setq company-minimum-prefix-length 1
      company-idle-delay 0.0)
(use-package company
  :ensure t
  :config (global-company-mode t))


;; magit
(use-package magit
  :ensure t
  :bind (
	 ("C-x g" . magit-status)))


;; theme
;; (use-package modus-themes
;;   :ensure t
;;   :init
;;     (setq modus-themes-syntax '(green-strings yellow-comments)
;; 	modus-themes-mode-line '(accented borderless)
;; 	modus-themes-hl-line '(accented))
    
;;   (modus-themes-load-themes)
;;   :config
;;     (load-theme 'modus-vivendi t))


;; DOOM THEMES 3-16-2022
;; https://github.com/doomemacs/themes#manually
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; (load-theme 'doom-molokai t)	
	;; (load-theme 'doom-dark+ t)
	;; (load-theme 'doom-gruvbox t)
	(load-theme 'doom-peacock t)
	

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


;; DOOM modeline 3-16-2022
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))


;; When running emacsclient -c this will ensure theme loads
;; theme
;;(defvar my:theme 'modus-vivendi)
;;(defvar my:theme-window-loaded nil)
;;(defvar my:theme-terminal-loaded nil)

;;(if (daemonp)
;;    (add-hook 'after-make-frame-functions(lambda (frame)
;;                       (select-frame frame)
;;                       (if (window-system frame)
;;                           (unless my:theme-window-loaded
;;                             (if my:theme-terminal-loaded
;;                                 (enable-theme my:theme)
;;                               (load-theme my:theme t))
;;                            (setq my:theme-window-loaded t))
;;                         (unless my:theme-terminal-loaded
;;                           (if my:theme-window-loaded
;;                               (enable-theme my:theme)
;;                             (load-theme my:theme t))
;;                          (setq my:theme-terminal-loaded t)))))

;;  (progn
;;    (load-theme my:theme t)
;;    (if (display-graphic-p)
;;        (setq my:theme-window-loaded t)
;;      (setq my:theme-terminal-loaded t))))


;; lsp-mode
(setq lsp-log-io nil) ;; Don't log everything = speed
(setq lsp-keymap-prefix "C-c l")
;;(setq lsp-restart 'auto-restart)
(setq lsp-ui-sideline-show-diagnostics t)
(setq lsp-ui-sideline-show-hover t)
(setq lsp-ui-sideline-show-code-actions t)
(setq lsp-diagnostics-provider :flymake)
(setq lsp-ui-doc-enable t)
(setq lsp-ui-doc-position 'at-point)
(global-set-key (kbd "C-.") #'lsp-ui-peek-find-definitions)

(use-package lsp-mode
  :ensure t
  :hook (
	 (web-mode . lsp-deferred)
	 (lsp-mode . lsp-enable-which-key-integration)
	 )
  :commands lsp-deferred)


(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package lsp-python-ms
  :ensure t
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                         (require 'lsp-python-ms)
                         (lsp))))  ; or lsp-deferred


(defun enable-minor-mode (my-pair)
  "Enable minor mode if filename match the regexp.  MY-PAIR is a cons cell (regexp . minor-mode)."
  (if (buffer-file-name)
      (if (string-match (car my-pair) buffer-file-name)
	  (funcall (cdr my-pair)))))


;; Trying prettier.el instead of prettier-js 3-19-2022
;; (use-package prettier
;; 	:ensure t)
;; (add-hook 'after-init-hook #'global-prettier-mode)



(use-package prettier-js
  :ensure t
	:config (setq prettier-js-args '("--bracket-same-line" t))	
	(add-hook 'web-mode-hook #'(lambda ()
															 (enable-minor-mode
																'("\\.jsx?\\'" . prettier-js-mode))
  	  												 (enable-minor-mode
																'("\\.tsx?\\'" . prettier-js-mode))))

	(eval-after-load 'web-mode
		'(progn
			 (add-hook 'web-mode-hook #'add-node-modules-path)
			 (add-hook 'web-mode-hook #'prettier-js-mode))))

;; (setq prettier-js-args '(
;;  												 "--bracket-same-line" "false"
;; 												 )
			

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package npm-mode
  :ensure t
  :config
  (npm-global-mode))

;; Custom functions
(defun lukewh/kill-buffer ()
  "Kill the active buffer."
  (interactive)
  (kill-buffer (current-buffer)))

(global-set-key (kbd "C-x K") 'lukewh/kill-buffer)



;; 2-28-2022 Additions
(use-package simple
  :ensure nil
  :config (column-number-mode +1))

(require 'rainbow-delimiters)
;;(add-hook 'web-mode-hook #'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

(use-package ediff
  :ensure nil
  :config
  (setq ediff-window-setup-function #'ediff-setup-windows-plain)
  (setq ediff-split-window-function #'split-window-horizontally))

;; Diff highlighting! 3-13-2022
;;(use-package diff-hl
;;  :ensure t)

;;(global-diff-hl-mode)


;; Simple modeline, deprecated in favor of doom modeline 
;; https://github.com/dbordak/telephone-line
;;(require 'telephone-line)
;;(telephone-line-mode 1)

(use-package frame
  :preface
  (defun ian/set-default-font ()
    (interactive)
    (when (member "Iosevka" (font-family-list))
      (set-face-attribute 'default nil :family "Iosevka"))
    (set-face-attribute 'default nil
                        :height 130
                        :weight 'normal))
  :ensure nil
  :config
  (setq initial-frame-alist '((fullscreen . maximized)))
  (ian/set-default-font))



(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Iosevka Term" :foundry "UKWN" :slant normal :weight normal :height 121 :width normal)))))
