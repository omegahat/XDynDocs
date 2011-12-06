NaiveBayesSolutions.pdf: NaiveBayesSolutions.tex

CODE=cv.R cvSample.R getMessageWords.R isHTML.R LingSpam.R logodds.R NaiveBayes.R plot.R SpamAssassin.R tauVar.R 

CODE_SRC=$(CODE:%=../../Code/Spam/R/%)

WEB_DIR=winnie.ucdavis.edu:/var/www/html/stat141/Winter04/Homework/NaieveBayes/Solutions/

%.pdf: %.tex
	@echo "Doing pdflatex now"
	(TEXINPUTS=.:$(OMEGA_HOME)/Docs::; export TEXINPUTS ; pdflatex $< )
	(TEXINPUTS=.:$(OMEGA_HOME)/Docs::; export TEXINPUTS ; pdflatex $< )

NaiveBayesSolutions.tar.gz tar: NaiveBayesSolutions.pdf $(CODE_SRC)
	tar zcf NaiveBayesSolutions.tar.gz $^

ship: NaiveBayesSolutions.pdf $(CODE_SRC) NaiveBayesSolutions.tar.gz
	rsync $^ $(WEB_DIR)