<?xml version="1.0"?>

<!-- Copyright the Omegahat Project for Statistical Computing, 2000 -->
<!-- Author: Duncan Temple Lang -->

<xsl:stylesheet id="article:SVGArticle"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:ltx="http://www.latex.org"
                xmlns:svg="http://www.w3.org/2000/svg" 
		xmlns:s="http://cm.bell-labs.com/stat/S4"
                extension-element-prefixes="svg"
                exclude-result-prefixes="svg"
                version="1.0">

<xsl:template match="svg:code">
\begin{verbatim}
<xsl:apply-templates />
\end{verbatim}
</xsl:template>

<xsl:template match="svg:code//text()"><xsl:value-of select="."/></xsl:template>

</xsl:stylesheet>