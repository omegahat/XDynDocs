TOP=../..

ifdef USE_XMLTO
index.html:
	xmlto html-nochunks -m spam.xsl outline.xml

outline.pdf: 
	xmlto pdf --extensions -m spam.xsl outline.xml
else

include $(TOP)/GNUmakefile.conf

endif
