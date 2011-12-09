<?xml version="1.0"?>

<!-- Copyright the Omegahat Project for Statistical Computing, 2000 -->
<!-- Author: Duncan Temple Lang -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:bib="http://www.bibliography.org"
                xmlns:c="http://www.C.org"
                xmlns:rs="http://www.omegahat.org/RS"
                xmlns:s="http://cm.bell-labs.com/stat/S4"
                xmlns:r="http://www.r-project.org"
                xmlns:omegahat="http://www.omegahat.org"
		xmlns:el="http://www.gnu.org/software/emacs/manual/elisp.html"
		exclude-result-prefixes="r s rs c bib el omegahat"
                omit-result-prefixes="yes"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">


<xsl:param name="emacslisp.key.color">#54ff9f</xsl:param>
<xsl:param name="emacslisp.var.color">#00ff9f</xsl:param>
<xsl:param name="emacslisp.func.color">#54009f</xsl:param>

<xsl:template match="el:key">
  <fo:inline color="{$emacslisp.key.color}" font-weight="italic"><xsl:apply-templates /></fo:inline>
</xsl:template>

<xsl:template match="el:var">
  <fo:inline color="{$emacslisp.var.color}" font-weight="italic"><xsl:apply-templates /></fo:inline>
</xsl:template>

<xsl:template match="el:func">
  <fo:inline color="{$emacslisp.func.color}" font-weight="italic"><xsl:apply-templates /></fo:inline>
</xsl:template>

</xsl:stylesheet>