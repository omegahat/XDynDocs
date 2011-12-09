
(defun x-r-eval-string ()
 "experimental code that is no longer used"
 (interactive)
 (let* ((proc (get-ess-process ess-current-process-name))
        (cmd (get-node-content-value))
        (start (marker-position (process-mark proc)))
        old-filter value ( ctr 0))

 (unwind-protect
   (progn 
      (setq oldfilter (process-filter proc))
      (set-process-filter proc '(lambda (proc output) 
                                    (setq value (concat value output))
(message "%d %s %s" ctr output value)
                                    (ordinary-insertion-filter proc output)))
(setq ess-synchronize-evals t)
      (ess-eval-linewise cmd nil t t))
   (set-process-filter proc old-filter))
(save-excursion
  (set-buffer (get-buffer "routput"))
  (insert value) (insert "--------\n") )
 value
))



(defun get-output (start)
 (interactive)
 (let* ((proc (get-ess-process ess-current-process-name)))
     (save-excursion
        (set-buffer (process-buffer sprocess))
        (buffer-substring start (point-max) ))
))


; (send-command "mean(1:10)\nSys.time()\n")

(defun send-command (cmd)
  (interactive)
  (let ((proc (get-ess-process ess-current-process-name))
        (out-buffer (generate-new-buffer "*routput*"))
        ans) 

   (setq ess-synchronize-evals t)
(setq cmd (concat cmd "\ncat('<r-done>\n')\n"))
   (comint-redirect-send-command-to-process cmd out-buffer proc t)
(sleep-for 2)
   (setq ans (save-excursion 
               (set-buffer out-buffer)
;               (while (progn (save-excursion (goto-char 0) (not (search-forward "<r-done>" nil t))))
;                   ()) ; (sleep-for .1))
               (concat (buffer-name) " " (format "%d" (point-max)) " " (buffer-string))))
;   (kill-buffer out-buffer)
(message "%s" ans)
   ans)
)

;     (process-send-string ess-current-process-name (concat cmd "\n"))
;    (save-excursion
;       (set-buffer (process-buffer sprocess))
;       (buffer-substring start (point-max) )); (marker-position (process-mark proc))))
