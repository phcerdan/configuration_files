(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)
;; For TAB to work in org-mode evil-mode:
(setq evil-want-C-i-jump nil)
(require 'evil-org)
(require 'evil-leader)
(evil-leader/set-leader "<SPC>")
(global-evil-leader-mode)
(require 'company)
;; Color-scheme
; (add-hook 'after-init-hook
;  (lambda () (load-theme 'cyberpunk t)))
;; Move between window with C-c hjkl, note that in vim/tmux is C-hjkl. Not sure if good.
(global-set-key (kbd "C-c C-h")  'windmove-left)
(global-set-key (kbd "C-c C-l")  'windmove-right)
(global-set-key (kbd "C-c C-k")  'windmove-up)
(global-set-key (kbd "C-c C-j")  'windmove-down)
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "WAITING" "|" "DONE" "CANCELED")))
(setq org-log-done 'time)
(setq org-agenda-files (list "~/Dropbox/org-mode/agenda.org"
			     "~/Dropbox/org-mode/organizer.org"))
(setq org-directory '("~/Dropbox/org-mode"))
; org - minimum for agenda
(add-hook 'org-agenda-mode-hook
  (lambda ()
    (define-key org-agenda-mode-map "\C-n" 'evil-next-buffer)
    (define-key org-agenda-mode-map "\C-p" 'evil-prev-buffer)
    (define-key org-agenda-mode-map "b" 'evil-backward-word-begin)
    (define-key org-agenda-mode-map "h" 'evil-backward-char)
    (define-key org-agenda-mode-map "j" 'evil-next-line)
    (define-key org-agenda-mode-map "k" 'evil-previous-line)
    (define-key org-agenda-mode-map "l" 'evil-forward-char)
    (define-key org-agenda-mode-map "n" 'evil-forward-word-begin)
    (define-key org-agenda-mode-map "p" 'evil-forward-word-begin)
    (define-key org-agenda-mode-map "w" 'evil-forward-word-begin)))
;; To copy to clipboard in emacs terminal mode -nw. Require XSEL
(load "~/.emacs.d/copy_paste_emacs_terminal.el")
;;;;;;;;;;;;;;;; END of PHC ;;;;;;;;;;;
;; from \url: http://lukeswart.net/2015/04/lightning-intro-to-emacs-using-evil-mode-and-org-mode/
;; Include this in your Emacs config file (ie ~/.emacs.d/init.el or ~/.emacs)
(require 'evil)
;; Enable Evil mode as defuault
(evil-mode 1)
;; Treat wrapped line scrolling as single lines
; (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
; (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
  ;;; esc quits pretty much anything (like pending prompts in the minibuffer)
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
;; Enable smash escape (ie 'jk' and 'kj' quickly to exit insert mode)
(define-key evil-insert-state-map "k" #'cofi/maybe-exit-kj)
(evil-define-command cofi/maybe-exit-kj ()
  :repeat change
  (interactive)
  (let ((modified (buffer-modified-p)))
    (insert "k")
    (let ((evt (read-event (format "Insert %c to exit insert state" ?j)
                           nil 0.5)))
      (cond
       ((null evt) (message ""))
       ((and (integerp evt) (char-equal evt ?j))
        (delete-char -1)
        (set-buffer-modified-p modified)
        (push 'escape unread-command-events))
       (t (setq unread-command-events (append unread-command-events
                                              (list evt))))))))
(define-key evil-insert-state-map "j" #'cofi/maybe-exit-jk)
(evil-define-command cofi/maybe-exit-jk ()
  :repeat change
  (interactive)
  (let ((modified (buffer-modified-p)))
    (insert "j")
    (let ((evt (read-event (format "Insert %c to exit insert state" ?k)
                           nil 0.5)))
      (cond
       ((null evt) (message ""))
       ((and (integerp evt) (char-equal evt ?k))
        (delete-char -1)
        (set-buffer-modified-p modified)
        (push 'escape unread-command-events))
       (t (setq unread-command-events (append unread-command-events
                                              (list evt))))))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/Dropbox/org-mode/organizer.org")))
 '(package-selected-packages (quote (helm evil-org cyberpunk-theme company))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
