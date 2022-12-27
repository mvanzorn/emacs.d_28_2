;;; dired-fdclone-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (file-name-directory load-file-name)) (car load-path)))



;;; Generated autoloads from dired-fdclone.el

(autoload 'diredfd-enable-auto-revert "dired-fdclone" "\
Enable auto-revert settings for dired.

`dired-async' is supported.")
(autoload 'diredfd-nav-mode "dired-fdclone" "\
Toggle nav mode.

This is a minor mode.  If called interactively, toggle the
`Diredfd-Nav mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `diredfd-nav-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

(fn &optional ARG)" t)
(autoload 'diredfd-find-file "dired-fdclone" "\
Visit the current file or directory.")
(autoload 'diredfd-goto-top "dired-fdclone" "\
Go to the top line of the current file list after `..'.
If the point is already at the top file, go to the beginning of the buffer." t)
(autoload 'diredfd-goto-bottom "dired-fdclone" "\
Go to the bottom line of the current file list.
If the point is already at the bottom file, go to the end of the buffer." t)
(autoload 'diredfd-toggle-mark-here "dired-fdclone" "\
Toggle the mark on the current line." t)
(autoload 'diredfd-toggle-mark "dired-fdclone" "\
Toggle the mark on the current line and move to the next line.
Repeat ARG times if given.

If region is active, mark all the files in the region without moving the point.
If all files are already marked, unmark them instead.

(fn &optional ARG)" t)
(autoload 'diredfd-toggle-all-marks "dired-fdclone" "\
Toggle all marks.

If region is active, toggle the marks in the region and keep the point." t)
(autoload 'diredfd-unmark-all-marks "dired-fdclone" "\
Unmark all files in the Dired buffer or the active region.

(fn &optional ARG)" t)
(autoload 'diredfd-mark-or-unmark-all "dired-fdclone" "\
Unmark all files if there is any file marked, or mark all non-directory files otherwise.
If ARG is given, mark all files including directories.

(fn &optional ARG)" t)
(autoload 'diredfd-narrow-to-marked-files "dired-fdclone" "\
Kill all unmarked lines using `dired-kill-line'." t)
(autoload 'diredfd-narrow-to-files-regexp "dired-fdclone" "\
Kill all lines except those matching REGEXP using `dired-kill-line'.

(fn REGEXP)" t)
(autoload 'diredfd-goto-filename "dired-fdclone" "\
Jump to FILENAME.

(fn FILENAME)" t)
(autoload 'diredfd-do-shell-command "dired-fdclone" "\
Open an ANSI terminal and run a COMMAND in it.

In COMMAND, the % sign is a meta-character and the following
macros are available.  All path names expanded will be escaped
with `shell-quote-argument'.

%P  -- Expands to the current directory name in full path.
%C  -- Expands to the name of the file at point.
%T  -- Expands to the names of the marked files, separated by
       spaces.
%M  -- Expands to the name of each marked file, repeating the
       command once for every marked file.
%X  -- Expands to the name of the file at point without the last
       suffix. (cf. `file-name-sans-extension')
%XM -- Expands to the name of each marked file without the last
       suffix, repeating the command once for every marked file.
%XT -- Expands to the names of the marked files without their
       last suffix, separated by spaces.
%%  -- Expands to a literal %.

(fn COMMAND)" t)
(autoload 'diredfd-do-flagged-delete-or-execute "dired-fdclone" "\
Run `dired-do-flagged-delete' if any file is flagged for deletion.
If none is, run a shell command with all marked (or next ARG) files or the current file.

For a list of macros usable in a shell command line, see `diredfd-do-shell-command'.

(fn &optional ARG)" t)
(autoload 'diredfd-enter "dired-fdclone" "\
Visit the current file, or enter if it is a directory." t)
(autoload 'diredfd-enter-directory "dired-fdclone" "\
Enter DIRECTORY and jump to FILENAME.

(fn &optional DIRECTORY FILENAME)" t)
(autoload 'diredfd-enter-parent-directory "dired-fdclone" "\
Enter the parent directory." t)
(autoload 'diredfd-enter-root-directory "dired-fdclone" "\
Enter the root directory." t)
(autoload 'diredfd-follow-symlink "dired-fdclone" "\
Follow the s parent directory." t)
(autoload 'diredfd-view-file "dired-fdclone" "\
Visit the current file in view mode." t)
(autoload 'diredfd-do-pack "dired-fdclone" "\
Pack all marked (or next ARG) files, or the current file into an archive.

(fn &optional ARG)" t)
(autoload 'diredfd-pack "dired-fdclone" "\
Pack FILES into ARCHIVE, asynchronously if ASYNC is non-nil.

(fn FILES ARCHIVE &optional ASYNC)")
(autoload 'diredfd-do-unpack "dired-fdclone" "\
Unpack all marked (or next ARG) files or the current file.

(fn &optional ARG)" t)
(autoload 'diredfd-help "dired-fdclone" "\
Show the help window." t)
(autoload 'dired-fdclone "dired-fdclone" "\
Enable FDclone mimicking settings for dired.")
(register-definition-prefixes "dired-fdclone" '("diredfd-"))

;;; End of scraped data

(provide 'dired-fdclone-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; dired-fdclone-autoloads.el ends here
