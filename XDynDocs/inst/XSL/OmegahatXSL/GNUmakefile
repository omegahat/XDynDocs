INSTALL_DIR=/tmp/R

IDOCS=$(OMEGA_HOME)/R/IDocs

XSL_FILES=$(wildcard *.xsl) $(IDOCS)/inst/share/XSL/DynDocs.xsl
DTD_FILES=$(wildcard ../DTD/*.dtd)

include Install/VersionInfo

INSTALL_FILES=configure configure.in getDocbook.xsl install.xsl GNUmakefile.in  INSTALL README catalog.in

PWD=$(shell pwd)

package: Install/configure
	rm -fr $(INSTALL_DIR)/$(PKG_NAME)
	mkdir -p $(INSTALL_DIR)/$(PKG_NAME)/XSL
	mkdir -p $(INSTALL_DIR)/$(PKG_NAME)/DTD
	cp $(XSL_FILES) $(INSTALL_DIR)/$(PKG_NAME)/XSL
	mkdir $(INSTALL_DIR)/$(PKG_NAME)/XSL/fo
	cp  fo/*.xsl $(INSTALL_DIR)/$(PKG_NAME)/XSL/fo
	cp $(DTD_FILES) $(INSTALL_DIR)/$(PKG_NAME)/DTD
	cp $(INSTALL_FILES:%=Install/%) $(INSTALL_DIR)/$(PKG_NAME)
	-find . -name CVS -o -name .svn -type d -exec rm {} \; > /dev/null 2>&1

tar $(TAR_FILE): package
	(cd $(INSTALL_DIR) ; tar zcf $(PWD)/$(TAR_FILE) $(PKG_NAME))

zip $(ZIP_FILE): package
	(cd $(INSTALL_DIR) ; zip -r $(PWD)/$(ZIP_FILE) $(PKG_NAME))

Install/configure: Install/configure.in
	(cd $(@D) ; autoconf)