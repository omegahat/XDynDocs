TARGET_DIR=www.omegahat.org:OmegaWeb/RDocbook/

DOCS=../inst/nxml-mode/RdocbookEmacs.html 

indexInstall:
	scp index.html $(TARGET_DIR)

ship: $(DOCS) index.html
	scp $(DOCS) index.html $(TARGET_DIR)

../inst/nxml-mode/RdocbookEmacs.html: ../inst/nxml-mode/RdocbookEmacs.Rdb
	$(MAKE) -C $(@D) -f $(DYN_DOCS)/inst/Make/Makefile $(@F) HTML_STYLESHEET="http://www.omegahat.org/OmegaTech.css"


