<?xml version="1.0"?>

<!-- Copyright the Omegahat Project for Statistical Computing, 2000 -->
<!-- Author: Duncan Temple Lang -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:ltx="http://www.latex.org"
                xmlns:xp="http://www.w3.org/TR/xpath" 
                extension-element-prefixes="xp"
                exclude-result-prefixes="xp"
                version="1.0">

<xsl:template match="xp:code">
\begin{verbatim}
<xsl:apply-templates />
\end{verbatim}
</xsl:template>

<xsl:template match="xp:func">\XP<xsl:value-of select="local-name()"/>{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="xp:expr">\verb+<xsl:apply-templates/>+</xsl:template>

</xsl:stylesheet>