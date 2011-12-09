<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:s="http://cm.bell-labs.com/stat/S4"
        xmlns:r="http://www.r-project.org"
	xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
	xmlns:omg="http://www.omegahat.org"
	xmlns:bioc="http://www.bioconductor.org"
	xmlns:xi="http://www.w3.org/2003/XInclude"
	exclude-result-prefixes="doc" version='1.0'
  >

<xsl:import href="db2latex.xsl"/>
<xsl:import href="latex.xsl"/>
<xsl:import href="js.xsl"/>
<xsl:import href="svg.xsl"/>
<xsl:import href="xpath.xsl"/>

<xsl:template name="generate.latex.article.preamble">
\documentclass[article]{jss}
</xsl:template>

<xsl:param name="latex.mapping.xml" select="document('db2latex.bindings.xml')"/>
<xsl:param name="latex.use.hyperref" select="0"/>

<xsl:param name="latex.documentclass">jss</xsl:param>
<xsl:param name="document.xml.language">en</xsl:param>

<xsl:param name="latex.pdf.preamble">
		<xsl:text>\usepackage{ifthen}&#10;</xsl:text>
		<xsl:text>% --------------------------------------------&#10;</xsl:text>
		<xsl:text>% Check for PDFLaTeX/LaTeX &#10;</xsl:text>
		<xsl:text>% --------------------------------------------&#10;</xsl:text>
		<xsl:text>\newif\ifpdf&#10;</xsl:text>
		<xsl:text>\ifx\pdfoutput\undefined&#10;</xsl:text>
		<xsl:text>\pdffalse % we are not running PDFLaTeX&#10;</xsl:text>
		<xsl:text>\else&#10;</xsl:text>
		<xsl:text>\pdfoutput=1 % we are running PDFLaTeX&#10;</xsl:text>
		<xsl:text>\pdftrue&#10;</xsl:text>
		<xsl:text>\fi&#10;</xsl:text>
</xsl:param>


<xsl:template match="graphic[@format='SVG']">
<xsl:variable name="str"><xsl:value-of select="string(@fileref)"/></xsl:variable>
<xsl:message>Processing SVG figure <xsl:value-of select="@fileref"/> to <xsl:value-of select="concat(substring($str, 0, string-length($str) - 2), 'pdf')"/></xsl:message>
%\includegraphics{<xsl:value-of select="concat(substring($str, 0, string-length($str) - 2), 'pdf')"/>}
\includegraphics{SVGTree.png}
</xsl:template>


<xsl:template name="before.document.begins">
 <xsl:apply-templates select="//articleinfo/keywordset" mode="pre.document"/>
 <xsl:apply-templates select="//abstract" mode="pre.document"/>
</xsl:template>

<!-- what about latex.override -->


<xsl:template match="abstract" mode="pre.document">
<xsl:message>Processing abstract</xsl:message>
\Abstract{
 <xsl:apply-templates/>
}
</xsl:template>

<!--
<xsl:template name="map.begin">
 <xsl:if test="local-name(.) = 'article'">
   <xsl:apply-templates select="//articleinfo/keywordset" mode="pre.document"/>
 </xsl:if>

 <xsl:call-template name="latex.mapping">
   <xsl:with-param name="keyword" select="local-name(.)"/>
   <xsl:with-param name="role">begin</xsl:with-param>
   <xsl:with-param name="string" select="$string"/>
 </xsl:call-template>
</xsl:template>
-->

<xsl:template match="keywordset" />
<xsl:template match="keywordset" mode="pre.document">
<xsl:message>My keywordset</xsl:message>
\Keywords{<xsl:apply-templates/>}
\Plainkeywords{<xsl:apply-templates/>}			       <!-- Need to have , separated values -->
</xsl:template>

<!--
<xsl:template match="author">
<xsl:apply-templates select="firstname"/><xsl:text> </xsl:text><xsl:apply-templates select="surname"/>
</xsl:template>

<xsl:template match="authorgroup">
\author{
 <xsl:apply-templates select="author"/>
}
</xsl:template>
-->

<!-- <xsl:include href="http://db2latex.sourceforge.net/current/xsl/docbook.xsl"/> -->


<!-- This should probably go in db2latex.xsl, but put it here for now -->

<xsl:template match="biblioref">
<xsl:message>Bibliography reference: <xsl:value-of select="@linkend"/> </xsl:message>
\cite{<xsl:value-of select="@linkend"/>}
</xsl:template>




<xsl:template match="omg:pkg">\OmgPackage{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="bioc:pkg">\BioCPackage{<xsl:apply-templates/>}</xsl:template>

</xsl:stylesheet>