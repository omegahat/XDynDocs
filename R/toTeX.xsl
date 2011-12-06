<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:r="http://www.r-project.org"
                xmlns:c="http://www.c.org"
		xmlns:s="http://cm.bell-labs.com/stat/S4"
                xmlns:omg="http://www.omegahat.org"
                xmlns:rwx="http://www.omegahat.org/RwxWidgets"
                xmlns:make="http://www.make.org"
                xmlns:sh="http://www.shell.org"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version='1.0'>

<xsl:import href="/Users/duncan/db2latex-xsl-0.8pre1/xsl/docbook.xsl"/>

<xsl:template match="s:*">
 \<xsl:value-of select="local-name(.)"/>{<xsl:apply-templates/>}
</xsl:template>

<xsl:template match="r:package">
\Rpackage{<xsl:apply-templates/>}
</xsl:template>

<xsl:template match="exercise">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="c:code">
\begin{Verbatim}
<xsl:apply-templates/>
\end{Verbatim}
</xsl:template>

</xsl:stylesheet>

