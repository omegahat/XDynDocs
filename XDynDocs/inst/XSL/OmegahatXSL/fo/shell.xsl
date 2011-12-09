<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:r="http://www.r-project.org"
		xmlns:s="http://cm.bell-labs.com/stat/S4"
		xmlns:c="http://www.C.org"
                xmlns:python="http://www.python.org"
                xmlns:perl="http://www.perl.org"
		xmlns:vb="http://www.visualbasic.com"
		xmlns:omegahat="http://www.omegahat.org"
                xmlns:bioc="http://www.bioconductor.org"
                xmlns:java="http://www.java.com"
		xmlns:statdocs="http://www.statdocs.org"
		xmlns:gtk="http://www.gtk.org"
		xmlns:com="http://www.microsoft.com"
		xmlns:sh="http://www.shell.org"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">


<!--
<xsl:template match="sh:command">
</xsl:template>


<xsl:template match="sh:output">
 <xsl:call-template name="inline.monoseq"/>/
 <xsl:apply-templates />
</xsl:template>

<xsl:template match="sh:script">
  <xsl:call-template name="inline.monoseq"/>/
</xsl:template>

<xsl:template match="sh:env">
$<xsl:apply-templates />
</xsl:template>

<xsl:template match="dir">
</xsl:template>

<xsl:template match="executable">
</xsl:template>


<xsl:template match="sh:arg">
</xsl:template>
-->


<xsl:template match="sh:code">
 <xsl:call-template name="makeVerbatimCode">
  <xsl:with-param name="color">#DCDCDC</xsl:with-param>
  <xsl:with-param name="format" select="0" />
 </xsl:call-template>
</xsl:template>

<xsl:template match="sh:env|sh:var">
  <!-- XXX change color  -->
 <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="sh:output">
  <xsl:call-template name="inline.monoseq"/>/
</xsl:template>

<xsl:template match="sh:cmd|sh:expr">
 <xsl:call-template name="expression">
   <xsl:with-param name="color">#B8860B</xsl:with-param>
 </xsl:call-template>
</xsl:template>

<xsl:template match="sh:exec|sh:executable|executable|sh:func">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="sh:dir">
 <fo:inline font-style="bold"><xsl:call-template name="inline.monoseq"/>/</fo:inline>
</xsl:template>

</xsl:stylesheet>
