<?xml version="1.0"?>

<!-- Copyright the Omegahat Project for Statistical Computing, 2000 -->
<!-- Author: Duncan Temple Lang -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:bib="http://www.bibliography.org"
                xmlns:c="http://www.C.org"
                xmlns:sh="http://www.shell.org"
                xmlns:rs="http://www.omegahat.org/RS"
                xmlns:s="http://cm.bell-labs.com/stat/S4"
                xmlns:r="http://www.r-project.org"
                xmlns:omegahat="http://www.omegahat.org"
		exclude-result-prefixes="s"
                omit-result-prefixes="yes"
                version="1.0">


<xsl:import href="http://www.sourceforge.net/projects/db2latex/release/xsl/docbook.xsl" />

<xsl:param name="latex.documentclass.article">11pt,twoside</xsl:param>

<!-- Insert our defines, includes, etc. -->
<xsl:param name="latex.article.preamble.post">
<xsl:text>
\usepackage{times}
\usepackage{natbib}
\usepackage{fullpage}
\usepackage{amsmath}
\usepackage{graphics}

\usepackage{moreverb}

\bibliographystyle{plain} % prsty, unsrt
%\usepackage[gather]{chapterbib}
\usepackage{bibunits}

\usepackage{hyperref}
\input{WebMacros}
\input{Smacros}
\input{Cmacros}
\input{XMLMacros}
\input{HTMLMacros}

\def\url#1{\textbf{#1}}
\def\red{}

\def\SASName#1{\textit{#1}}
\def\remind#1{\textsl{#1}}
</xsl:text>
</xsl:param>


<xsl:variable name="l10n.gentext.default.language">en</xsl:variable>
<xsl:variable name="latex.documentclass.common"></xsl:variable>
<xsl:variable name="latex.babel.language"></xsl:variable>

<xsl:template match="invisible" />

<xsl:template match="s:code|r:code">
  <xsl:call-template name="verbatim.apply.templates"/>  
</xsl:template>
<!-- verbatim.apply.templates -->

<xsl:template match="c:code">
  <xsl:call-template name="verbatim.apply.templates"/>
</xsl:template>

<xsl:template match="s:output">
  <xsl:call-template name="verbatim.apply.templates"/>
</xsl:template>

<xsl:template match="s:function|s:functionRef|r:func|s:func">
  <xsl:text>\SFunction{</xsl:text><xsl:apply-templates mode="latex.verbatim"/><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="s:variable|r:var|s:var">
  <xsl:text>{\SVariable{</xsl:text><xsl:apply-templates mode="latex.verbatim"/><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="s:package|r:package">
  <xsl:text>{\RPackage{</xsl:text><xsl:apply-templates mode="latex.verbatim"/><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="s:arg|r:arg">
  <xsl:text>\SArg{</xsl:text><xsl:apply-templates mode="latex.verbatim"/><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="s:operator|r:operator">
  <xsl:text>\SOperator{</xsl:text><xsl:apply-templates mode="latex.verbatim"/><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="s:keyword">
  <xsl:text>\SKeyword{</xsl:text><xsl:apply-templates mode="latex.verbatim"/><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="r:class">
  <xsl:text>\SClass{</xsl:text><xsl:apply-templates mode="latex.verbatim"/><xsl:text>}</xsl:text>
</xsl:template>


<xsl:template match="c:routine">
  <xsl:text>\Croutine{</xsl:text><xsl:apply-templates mode="latex.verbatim"/><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="s:expression|r:expr">
  <xsl:text>\verb|</xsl:text><xsl:apply-templates mode="latex.verbatim"/><xsl:text>|</xsl:text>
</xsl:template>



<xsl:template match="s:NA|s:na">\textit{NA}</xsl:template>
<xsl:template match="s:null">\textsl{NULL}</xsl:template>
<xsl:template match="s:true">\textsl{TRUE}</xsl:template>
<xsl:template match="s:false">\textsl{FALSE}</xsl:template>

<xsl:template match="s:dots">$\ldots$</xsl:template>

<xsl:template match="dll">
  <xsl:text>\DLL{</xsl:text><xsl:apply-templates mode="latex.verbatim"/><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="c:type">
  <xsl:text>\Ctype{</xsl:text><xsl:apply-templates mode="latex.verbatim"/><xsl:text>}</xsl:text>
</xsl:template>


</xsl:stylesheet>