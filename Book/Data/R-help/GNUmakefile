include $(DYN_DOCS)/inst/Make/Makefile

questions.html: questions.xml qa-html.xsl
	xsltproc $(XSLT_FLAGS) qa-html.xsl $< > $@
