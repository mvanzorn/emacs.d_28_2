;;; transpose-mark-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "transpose-mark" "transpose-mark.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from transpose-mark.el

(autoload 'transpose-mark "transpose-mark" "\
If region is active use 'transpose-mark-region', otherwise use 'transpose-mark-line'." t nil)

(autoload 'transpose-mark-line "transpose-mark" "\
Transpose the current line with the line which the current mark is pointing to." t nil)

(autoload 'transpose-mark-region "transpose-mark" "\
Transpose the current region with the previously marked region.
Once you've transposed one the region is reset." t nil)

(autoload 'transpose-mark-region-abort "transpose-mark" "\
Remove the transpose-mark-region-overlay if set." t nil)

(autoload 'transpose-mark-region-start-func "transpose-mark" "\
Run a function at the start of the overlay and expand the overlay selection to
the new point after the function as been ran.

\(fn FUNC)" t nil)

(autoload 'transpose-mark-region-end-func "transpose-mark" "\
Run a function at the end of the overlay and expand the overlay selection to
the new point after the function as been ran.

\(fn FUNC)" t nil)

(autoload 'tmr-start--forward-word "transpose-mark" "\
Run transpose-mark-region-start-func with forward-word." t nil)

(autoload 'tmr-start--backward-word "transpose-mark" "\
Run transpose-mark-region-start-func with backward-word." t nil)

(autoload 'tmr-start--forward-char "transpose-mark" "\
Run transpose-mark-region-start-func with forward-char." t nil)

(autoload 'tmr-start--backward-char "transpose-mark" "\
Run transpose-mark-region-start-func with backward-char." t nil)

(autoload 'tmr-end--forward-word "transpose-mark" "\
Run transpose-mark-region-end-func with forward-word." t nil)

(autoload 'tmr-end--backward-word "transpose-mark" "\
Run transpose-mark-region-end-func with backward-word." t nil)

(autoload 'tmr-end--forward-char "transpose-mark" "\
Run transpose-mark-region-end-func with forward-char." t nil)

(autoload 'tmr-end--backward-char "transpose-mark" "\
Run transpose-mark-region-end-func with backward-char." t nil)

(register-definition-prefixes "transpose-mark" '("transpose-mark-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; transpose-mark-autoloads.el ends here
