chapterS08.pdf:

selections.pdf:

outline.pdf:

USE_BIBUNITS=1

ifeq ($(USE_BIBUNITS),"")
 BIBFILES= RDBMS/dbms    # outline
else
 BIBFILES= selections.aux $(shell find . -name 'bu*.aux') 
endif

#RDBMS/dbms

%.pdf: %.tex
	(TEXINPUTS=.:./inputs:$(TEXINPUTS) ; export TEXINPUTS ; pdflatex $*)
#	$(MAKE) bibFiles
	bibtex $*
	(TEXINPUTS=.:./inputs:$(TEXINPUTS) ; export TEXINPUTS ; pdflatex $*)
	(TEXINPUTS=.:./inputs:$(TEXINPUTS) ; export TEXINPUTS ; pdflatex $*)

tex: outline.pdf
	(TEXINPUTS=.:./inputs:$(TEXINPUTS) ; export TEXINPUTS ; pdflatex outline)

bibFiles:
	for f in $(BIBFILES) ; do \
	    bibtex `basename $$f .aux` ; \
	done

BIBOUT=$(shell find . -name '*.aux') $(shell find . -name '*.bbl') $(shell find . -name '*.blg')

cleanBib:
	rm $(BIBOUT)


chapterS08.pdf: \
Introduction/Introduction.tex\
computerIntro/computerIntro.tex\
Rlanguage/RPrelim.tex\
DataSimple/DataSimple.tex\
Rlanguage/RProgramming.tex\
RNG/RNG.tex\
RegExpr/regexpr.tex\
Shells/shells.tex\
XML/XML.tex\
RDBMS/dbms.tex\
Graphics/Graphics.tex\
Spam/spam.tex\
electionMaps/map.tex\
Graphics/AdvancedGraphics.tex\
WritingSoftware/WritingSoftware.tex\
Efficiency/Efficiency.tex\
InterfacingToC/InterfacingToC.tex \
ExtensibleDesign/ExtensibleDesign.tex \
prefaceSciCompWData.tex