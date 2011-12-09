
(defvar r-nxml-buffer nil
   "variable that stores the buffer that contains R running in a shell")

(defun* r-run-node-code-in-r (&optional get-output (delay 2))
  ""
  (interactive)
  (save-excursion 
     (run-node-code-in-r (get-node-content-value) get-output delay))
)

(defun* run-node-code-in-r (text &optional get-output (delay 2))
  ""
  (interactive)
  (if r-nxml-buffer
    (let ((cur))
    (save-excursion
      (switch-to-buffer r-nxml-buffer)
      (end-of-buffer)
      (setq cur (point))
      (insert (concat text ""))
      (comint-send-input)
      (if get-output
         (progn 
            (sleep-for delay)
            (buffer-substring-no-properties cur (point)))
         t))))
)

(defun r-nxml-set-buffer (name)
    ""
  (interactive "sEnter buffer name: ")
  (if (stringp name) (setq name (get-buffer name)))
  (setq r-nxml-buffer name)
)