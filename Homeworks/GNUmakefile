hw1.pdf:

TOP=..

#XSL_PARAMS=--param "toc.section.depth" "4"
XSL_FOP_PARAMS=$(XSL_PARAMS)
XSL_PARAMS=--xinclude
# --verbose

LATEX_SLIDE_DIR=$(HOME)/Ross/inputs

include $(TOP)/GNUmakefile.conf


lec1.html: lec1.slx spam.slx  weblogs.slx networkIntrusion.slx yield.slx email.slx

foo.html: lec2.html
	xsltproc  --xinclude /usr/share/sgml/slides-3.3.0/xsl/html/vslides.xsl lec2.slx

lec%.pdf: lec%.tex
	(echo "Ok"; TEXINPUTS=$(LATEX_SLIDE_DIR):${TEXINPUTS}; export TEXINPUTS ; pdflatex lec$*)


shipIndex:
	scp index.html winnie:/var/www/html/stat141/Winter04/Homework/homework.html
