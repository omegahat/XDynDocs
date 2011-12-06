dll:


ifneq ($(XML_CATALOG_FILES), )
  CTANGLE_XSL=$(shell xmlcatalog $(XML_CATALOG_FILES) http://www.omegahat.org/XSL/ctangle.xsl | tail -n 1)
  TANGLE_XSL= $(shell xmlcatalog $(XML_CATALOG_FILES) http://www.omegahat.org/XSL/tangle.xsl | tail -n 1)
else
  CTANGLE_XSL=${OMEGA_HOME}/Docs/XSL/ctangle.xsl
  TANGLE_XSL=${OMEGA_HOME}/Docs/XSL/ctangle.xsl
endif

ttmp:
	@echo "$(CTANGLE_XSL)"

AllBML.c: BML.xml
	xsltproc $(CTANGLE_XSL) $< > $@

cCode: BML.c RBML.c BML.h

BML.c: BML.xml
	xsltproc --stringparam file BML.c $(CTANGLE_XSL) $< > $@

RBML.c: BML.xml
	xsltproc --stringparam file RBML.c $(CTANGLE_XSL) $< > $@

BML.h: BML.xml
	xsltproc --stringparam file BML.h $(CTANGLE_XSL) $< > $@

BML.R: BML.xml
	xsltproc --param forPackage 1 $(TANGLE_XSL) $< > $@

dll BML.so: BML.c BML.h RBML.c
	R CMD SHLIB BML.c RBML.c

clean: 
	-rm BML.so BML.o BML.c


include $(DYN_DOCS)/inst/Make/Makefile

