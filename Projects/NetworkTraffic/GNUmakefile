TOP=../..

ifdef USE_XMLTO
index.html:
	xmlto html-nochunks -m spam.xsl outline.xml

outline.pdf: 
	xmlto pdf --extensions -m spam.xsl outline.xml
else

include $(TOP)/GNUmakefile.conf

endif

schema.html: schema.xml schema.xsl
	xsltproc schema.xsl schema.xml > $@

LINKS=$(shell xsltproc links.xsl setup.xml | sed -e 's/,//' | sort | uniq | egrep -v '^(http|ftp)')

FILES=schema.html setup.html hw3.pdf index.html

WEB_SITE=winnie.ucdavis.edu:/var/www/html/stat141/Winter04

tmp:
	@echo "$(LINKS)"

ship: $(FILES) $(LINKS)
	(export RSYNC_RSH=ssh; rsync $(FILES) $(LINKS) $(WEB_SITE)/Homework/DBMS)

shipLinks:  $(LINKS)
	(export RSYNC_RSH=ssh; rsync $(LINKS) $(WEB_SITE)/Homework/DBMS)






