<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:s="http://cm.bell-labs.com/stat/S4"
        xmlns:r="http://www.r-project.org"
	xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
	xmlns:omg="http://www.omegahat.org"
	xmlns:bioc="http://www.bioconductor.org"
	exclude-result-prefixes="doc" version='1.0'
    >

<xsl:import href="dblatex.xsl"/>

<xsl:import href="latex.xsl"/>
<xsl:import href="js.xsl"/>
<xsl:import href="svg.xsl"/>
<xsl:import href="xpath.xsl"/>


<xsl:output method="text" omit-xml-declaration="yes"/>
<xsl:strip-space elements="*"/>


<xsl:param name="bibliog.file" />

<xsl:template match="/article">
\documentclass[article]{jss}
\usepackage[authoryear,round]{natbib}  % [authoryear]
<xsl:apply-templates select="./articleinfo/authorgroup|./articleinfo/author"/>
<xsl:apply-templates select="./articleinfo//abstract|./abstract"/>
<xsl:apply-templates select="./articleinfo//title|./title"/>
<xsl:apply-templates select="./articleinfo//keywordset"/>
\input{latexMacros}

\begin{document}

<xsl:apply-templates select="./section|./ackno|./bibliography|./appendix"/>

\end{document}
</xsl:template>

<xsl:template match="authorgroup">
\author{<xsl:for-each select="./author"><xsl:apply-templates select="."/>
<xsl:if test="not(position() = last())"><xsl:text> \And 
</xsl:text></xsl:if></xsl:for-each>}

\Plainauthor{<xsl:for-each select="./author"><xsl:apply-templates select="."/>
<xsl:if test="not(position() = last())"><xsl:text>, </xsl:text></xsl:if></xsl:for-each>}
</xsl:template>

<xsl:template match="abstract">
\Abstract{<xsl:apply-templates/>}
</xsl:template>

<xsl:template match="keywordset">
\Keywords{<xsl:for-each select="./keyword"><xsl:apply-templates/><xsl:if test="not(position() = last())"><xsl:text>, </xsl:text></xsl:if></xsl:for-each>}
</xsl:template>

<xsl:template match="articleinfo/title">
\title{<xsl:apply-templates/>}
</xsl:template>

<xsl:template match="author/affiliation">
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="author">
<xsl:apply-templates select="firstname"/><xsl:text> </xsl:text><xsl:apply-templates select="surname"/> \\
  <xsl:apply-templates select="affiliation"/>
</xsl:template>

<xsl:template match="r:makePlot">
\includegraphics{<xsl:value-of select="graphic/@fileref"/>}
</xsl:template>

<xsl:template match="caption">
\caption{<xsl:apply-templates/>}
</xsl:template>

<xsl:template match="dyngraphic"/>



<xsl:template match="omg:pkg">\OmgPackage{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="r:slot">\Rslot{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="js">\proglang{JavaScript}</xsl:template>
<xsl:template match="xpath">\proglang{XPath}</xsl:template>
<xsl:template match="xml">\proglang{XML}</xsl:template>
<xsl:template match="C">\proglang{C}</xsl:template>

<xsl:template match="proglang">\proglang{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="mklang">\MarkupLang{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="svg">\MarkupLang{SVG}</xsl:template>

<xsl:template match="bioc:pkg">\BioCPackage{<xsl:apply-templates/>}</xsl:template>


<xsl:template match="bibliography">
<xsl:choose>
<xsl:when test="$bibliog.file = ''">
<xsl:message>bibliography file not set (bibliog.file)</xsl:message>
</xsl:when>
<xsl:otherwise>
\bibliography{<xsl:value-of select="$bibliog.file"/>} 
</xsl:otherwise>
</xsl:choose>

</xsl:template>


<xsl:template match="biblioref">\citep{<xsl:value-of select="@linkend"/>}</xsl:template>


<xsl:template match="quote">``<xsl:apply-templates/>''</xsl:template>

</xsl:stylesheet>
