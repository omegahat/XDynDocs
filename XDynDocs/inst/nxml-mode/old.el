  ; r:keyword
  (local-set-key "\C-qk" '(lambda () "" (interactive "*") (r-insert-node "r:keyword")))
  ; r:s3method
  (local-set-key "\C-qs" '(lambda () "" (interactive "*") (r-insert-node "r:s3method")))

  ; r:output
  (local-set-key "\C-q\C-o" '(lambda (cdata) "" (interactive "P") (r-insert-node "r:output" (not cdata) t nil)))
  (local-set-key "\C-q\C-e" '(lambda (cdata) "" (interactive "P") (r-insert-node "r:error" (not cdata) t t)))
  (local-set-key "\C-q\C-w" '(lambda (cdata) "" (interactive "P") (r-insert-node "r:warning" (not cdata) t t)))
  ; r:code
  (local-set-key "\C-q\C-c" '(lambda (cdata) "" (interactive "P") (r-insert-node "r:code" cdata t t)))
  ; r:code and r:output ????? Why would we want this?
  (local-set-key "\C-x\C-q\C-c" '(lambda () "" (interactive "*") (r-insert-node "r:function" t t t) (goto-char (nxml-token-after)) (r-insert-node "r:output" t t)))
  (local-set-key "\C-x\C-q\C-f" '(lambda () "" (interactive "*") (r-insert-node "r:function" t t t) (r-insert-node "r:output" t t)))
  ; r:function  (definition)
;  (local-set-key "\C-x\C-r\C-f" '(lambda () "" (interactive "*") (r-insert-node "r:function" t t)))
  (local-set-key "\C-q\C-f" '(lambda (cdata) "" (interactive "P") (r-insert-node "r:function" (not cdata) t t)))
  ; r:test
  (local-set-key "\C-q\C-t" '(lambda (cdata) "" (interactive "P") (r-insert-node "r:test" (not cdata) t t)))
 ; r:plot
  (local-set-key "\C-q\C-g" '(lambda (cdata) "" (interactive "P") (r-insert-node "r:plot" (not cdata) t t)))

   ; make smarter to know if we need the /ignore on a new line.
  (local-set-key "\C-q\C-i" '(lambda () "" (interactive "*") (r-insert-node "ignore" nil t t)))
; (insert "<ignore>") (nxml-forward-element) (insert "\n</ignore>")

   ; <para>\n</para>
  (local-set-key "\C-q\C-p" '(lambda () "" (interactive "*") (r-insert-node "para" nil t)))
  (local-set-key "\C-q\C-return" '(lambda () "" (interactive "*") (r-insert-node "para" nil t)))
  (local-set-key "\C-c\C-p" '(lambda () ""  
                               (interactive "*") 
                               (insert "\n") 
                               (r-insert-node "para" nil t) 
                               (save-excursion  
                                  (search-forward "</para>")
                                  (insert "\n"))))

  (local-set-key "\C-q\C-n" 'rxml-eval-node-contents)
  (local-set-key "\C-q\C-p" 'rxml-eval-node-insert-output)

;  (local-set-key "\C-c\C-l\C-l" '(lambda () ""  (interactive "*") (insert-itemized-list)))
;  (local-set-key "\C-c\C-l\C-i" '(lambda () ""  (interactive "*") (r-insert-node "li")))

  (local-set-key "\C-c\C-s\C-s" '(lambda () ""  
                                   (interactive "*") 
                                   (r-insert-node "section" nil t)
                                   (r-insert-node "title" nil nil)
                                   (nxml-up-element)
                                   (insert "\n\n")
                                   (r-insert-node "para" nil t)
                                 ))

  (local-set-key "\C-qt" '(lambda () ""  (interactive "*") (insert "<r:true/>")))
  (local-set-key "\C-u\C-qf" '(lambda () ""  (interactive "*") (insert "<r:false/>")))


; <xml:*> elements used for talking about XML.
  (local-set-key "\C-x\C-x" '(lambda () ""  (interactive "*") (r-insert-node "xml:tag")))
  (local-set-key "\C-x\C-a" '(lambda () ""  (interactive "*") (r-insert-node "xml:attr")))
  (local-set-key "\C-x\C-n" '(lambda () ""  (interactive "*") (r-insert-node "xml:ns")))
  (local-set-key "\C-x\C-e" '(lambda () ""  (interactive "*") (r-insert-node "xml:expr")))

; Put in a <programlisting> but add white space to avoid reformatting messing it up.
  (local-set-key "\C-x\C-p" '(lambda () ""  (interactive "*") (insert "\n") (r-insert-node "programlisting" t t) (save-excursion (forward-sexp) (goto-char (nxml-token-after))  (goto-char (nxml-token-after))  (insert "\n\n"))))
  (local-set-key "\C-x\C-p" '(lambda () ""  (interactive "*")  (r-insert-node "programlisting" t t t)
 ))

;  (local-set-key "\C-q\C-l" '(lambda () ""  (interactive "*")  (r-insert-node "listitem" nil nil nil) (r-insert-node "para" nil t nil)))

  (local-set-key "\C-x\C-l" '(lambda () ""  (interactive "*")  (r-insert-node "listitem" nil nil nil) (r-insert-node "para" nil t nil)))


  (local-set-key "\C-x\C-j" '(lambda () ""  (interactive "*") (r-insert-node "note") (r-insert-node "para" nil t nil)))

  (local-set-key "\C-qn" 'r-add-namespace-def)
  (local-set-key "\C-qi" 'r-insert-id)

  (local-set-key "\C-hC-e" 'rh-insert-example)

;  (local-set-key "\C-r\C-r" 'isearch-backward)
)