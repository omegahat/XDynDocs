DB2LATEX_XSL=$(HOME)/db2latex-xsl-0.8pre1/xsl/docbook.xsl
#book-article.mod.xsl

XSL_PARAMS=--stringparam latex.documentclass.article "english,11pt,fancyvrb" --stringparam latex.babel.language "none" --stringparam latex.pagestyle "plain" --stringparam latex.document.font "times" --stringparam ulink.show 1

DB2LATEX_XSL=foo.xsl

outline.tex: outline.xml $(DB2LATEX_XSL) GNUmakefile
outline.pdf: outline.tex

%.tex: %.xml
#	xsltproc foo.xsl  $<  > $@
	xsltproc --xinclude $(XSL_PARAMS) $(DB2LATEX_XSL)  $<  > $@

%.pdf: %.tex
	pdflatex $*
	pdflatex $*

# For use with passing to FOP specifically
FO_PARAMS=--stringparam title.margin.left "0pt" --stringparam body.start.indent "0pt" --stringparam start.indent "0pt" \
      --stringparam draft.mode "'yes'" --stringparam body.font.master "11"
%.fo: %.xml fo.xsl GNUmakefile
	xsltproc $(FO_PARAMS) --xinclude fo.xsl $< > $@

FOP=$(HOME)/fop-0.93/fop

%.fpdf: %.fo
	$(FOP) $< $@




clean:
	rm outline.pdf outline.tex outline.aux


configure: configure.in
	   autoconf

#	tar Hjcf $@ -s /^/OmegahatXSL\\// --exclude=.svn configure configure.in XSL CSS Icons JavaScript nxml-mode Make
#	tar Hjcf $@ -C .. -s /^inst/OmegahatXSL/ --exclude=.svn inst/configure inst/configure.in inst/XSL inst/CSS inst/Icons inst/JavaScript inst/nxml-mode inst/Make
TERMS=configure configure.in XSL CSS Icons JavaScript nxml-mode Make
OmegahatXSL.tar.bz2: configure GNUmakefile
	tar HLjcf $@ -C .. -s /^inst/OmegahatXSL/ --exclude=.svn --exclude='*~' $(TERMS:%=inst/%)

