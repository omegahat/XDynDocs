(load "~/Emacs/Contrib/nxml-mode-20041004/rng-auto.el")

(setq   auto-mode-alist (append (list 
                                 '("\\.Rdb$" . nxml-mode))))

(add-hook 'nxml-mode-hook
	  '(lambda ()
	     (set (make-local-variable 'ispell-skip-region-alist)
               (cons '("<r:code\\>" . "</r:code\\>")
         	      ispell-skip-region-alist))))
