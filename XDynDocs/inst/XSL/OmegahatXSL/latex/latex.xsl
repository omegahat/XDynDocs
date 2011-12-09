<?xml version="1.0"?>

<!-- Copyright the Omegahat Project for Statistical Computing, 2000 -->
<!-- Author: Duncan Temple Lang -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:ltx="http://www.latex.org"
		xmlns:s="http://cm.bell-labs.com/stat/S4"
		xmlns:r="http://www.r-project.org"
		xmlns:str="http://exslt.org/strings"
		xmlns:mml="http://www.w3.org/1998/Math/MathML"
                extension-element-prefixes="r"
                exclude-result-prefixes="r s ltx str mml"
                version="1.0"
	xmlns:mk="http://www.make.org">

<xsl:include href="../common/RCommonDocbook.xsl"/>
<xsl:include href="../common/no-html.xsl"/>
<xsl:include href="../common/no-fo.xsl"/>

<xsl:include href="utils.xsl"/>

<xsl:include href="css.xsl"/>
<xsl:include href="languages.xsl"/>


<xsl:template match="latex">\LaTeX</xsl:template>

<xsl:template match="s:expression|r:expression|r:expr">\R<xsl:value-of select="local-name(.)"/>{<!--<xsl:apply-templates/>--><xsl:call-template name="scape"><xsl:with-param name="string" select="text()"/></xsl:call-template>}</xsl:template>


<xsl:template match="s:expression|r:expression|r:expr">\verb|<xsl:apply-templates/>|</xsl:template>


<xsl:template match="r:formula">\verb!<xsl:apply-templates/>!</xsl:template>


<!-- <xsl:template match="text()"><xsl:value-of select="str:replace(str:replace(string(.), '_', '\_'), '&amp;', '\&amp;')"/>}</xsl:template>-->

<!-- Was <xsl:apply-templates/>  rather than value-of select=replace() -->
<!-- <xsl:call-template name="string-replace-uscore"/> -->
<xsl:template match="r:var|s:variable|r:func">\R<xsl:value-of select="local-name(.)"/>{<xsl:value-of select="str:replace(string(.), '_', '\_')"/>}</xsl:template>

<xsl:template match="s:func|s:functionRef">\Sfunc{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="s:arg|r:arg">\Sarg{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="r:class">\Rclass{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="s:param|r:param">\Sparam{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="r:output">\begin{verbatim}&#10;<xsl:apply-templates/>&#10;\end{verbatim}&#10;</xsl:template>

<xsl:template match="r:dots|dots">\ldots</xsl:template>


<xsl:template match="s:null|r:null">\Snull<xsl:call-template name="addBraces"/></xsl:template>
<xsl:template match="s:NA|r:NA">\SNA<xsl:call-template name="addBraces"/></xsl:template>
<xsl:template match="s:false|r:false|r:FALSE">\SFALSE<xsl:call-template name="addBraces"/></xsl:template>
<xsl:template match="s:true|r:true|r:TRUE">\STRUE<xsl:call-template name="addBraces"/></xsl:template>

<!-- Check to see if we need to add {} after a macro.Really want to check if the next element is text().  -->
<xsl:template name="addBraces"><xsl:if test="starts-with(string(following-sibling::text()[1]), ' ')">{}</xsl:if></xsl:template>

<xsl:template match="r:code/r:output"><xsl:apply-templates/></xsl:template>

<xsl:template match="r:output//text() | r:code//text()"><xsl:value-of select="."/></xsl:template>

<xsl:template match="r:function|r:code|s:code|s:plot|r:plot|r:test">\begin{CodeChunk}
\begin{CodeInput}<xsl:apply-templates/>\end{CodeInput}
\end{CodeChunk}</xsl:template>


<xsl:template match="current-date">
 <xsl:value-of select="r:call('date')"/>
</xsl:template>

<xsl:template match="ltx:*|tex|latex[string(.) != '']|ltx:literal">
 <xsl:copy-of select="."/><xsl:text>&#010;</xsl:text>
</xsl:template>

<xsl:template match="ltx:eqn"><xsl:apply-templates/></xsl:template>

<xsl:template match="mml:eqn"><xsl:message>ignoring MathML</xsl:message></xsl:template>


<xsl:template match="acronymDef"><xsl:apply-templates/></xsl:template>

<xsl:template match="var">\var{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="mk:code">\begin{verbatim}<xsl:apply-templates/>
\end{verbatim}</xsl:template>


<xsl:template match="makeGlossary">
<xsl:if test="not(ancestor::glossary)">
\section{Glossary}\label{sec:glossary}
</xsl:if>
\begin{tabularx}{lp{4in}}
Acronym &amp; Definition \\
<xsl:apply-templates select="//acronymDef | //acronym[@def]" mode="glossary"/>
\end{tabularx}
</xsl:template>

<xsl:template match="acronymDef" mode="glossary">
<xsl:value-of select="@value"/>  &amp;  <xsl:apply-templates/> \\
</xsl:template>

<xsl:template match="acronym[@def]" mode="glossary">
<xsl:apply-templates /> &amp; <xsl:value-of select="@def"/> \\
</xsl:template>

<xsl:template match="r:help">?\texttt{<xsl:apply-templates/>}</xsl:template>


<xsl:template match="author">
\author{<xsl:apply-templates/>}
</xsl:template>


<xsl:template match="r:op">\Rop{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="r:keyword">\Rkeyword{<xsl:apply-templates/>}</xsl:template>


</xsl:stylesheet>
