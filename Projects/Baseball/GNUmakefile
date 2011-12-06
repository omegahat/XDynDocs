FILES=$(wildcard *.pdf *.png *.jpg ) gallery.html examples.html

examples.html: examples.xml questions.xsl
	xsltproc questions.xsl examples.xml > $@

ship: $(FILES)
	scp $(FILES)  winnie.ucdavis.edu:/var/www/html/stat141/Winter04/Homework/Baseball


InstallData.html: InstallData.xml 
	xsltproc ../../XSL/docbook.xsl InstallData.xml > $@
