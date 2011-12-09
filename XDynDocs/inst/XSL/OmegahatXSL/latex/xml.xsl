<?xml version="1.0"?>

<!-- Copyright the Omegahat Project for Statistical Computing, 2000 -->
<!-- Author: Duncan Temple Lang -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xml="http://www.w3.org/XML/1998/namespace"
                xmlns:ltx="http://www.latex.org"
		xmlns:kml="http://earth.google.com/kml/2.1"
                version="1.0">

<!-- \verb+&lt;+\textit{}\verb+&gt;+ -->
<xsl:template match="xml:tag|xml:node|xml:element">\XMLTag{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="xml:attr">\XMLAttr{<xsl:apply-templates/>}</xsl:template>

  <!--  Want to capitalize the First letter. -->
<xsl:template match="xml:*">\XML<xsl:value-of select="local-name()"/>{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="xml:code">\begin{verbatim}<xsl:apply-templates/>\end{verbatim}</xsl:template>


<xsl:template match="xml:code//text()"><xsl:value-of select="."/></xsl:template>

<xsl:template match="kml:style">\verb+<xsl:apply-templates/>+</xsl:template>
<xsl:template match="kml:style">\verb+<xsl:copy-of select="text()"/>+</xsl:template>


<xsl:template match="quote[@ltx:verb = 'true' ]">\verb+<xsl:apply-templates/>+</xsl:template>

<xsl:template match="xsl:param">\XSLparam{<xsl:value-of select="."/>}</xsl:template>


</xsl:stylesheet>


