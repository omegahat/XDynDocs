<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:r="http://www.r-project.org"
	xmlns:omg="http://www.omegahat.org"
	xmlns:bioc="http://www.bioconductor.org"
        version="1.0">


<xsl:template match="r:package|r:pkg|rpkg">\Rpackage{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="r:package|r:pkg|rpkg">\pkg{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="omg:pkg|bioc:pkg">\pkg{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="r">\proglang{R}</xsl:template>
<xsl:template match="latex[string(.) = '']">
\LaTeX{}
</xsl:template>

<xsl:template match="html">\proglang{HTML}</xsl:template>

<xsl:template match="js">\proglang{JavaScript}</xsl:template>
<xsl:template match="xpath">\proglang{XPath}</xsl:template>
<xsl:template match="xml">\proglang{XML}</xsl:template>
<xsl:template match="C">\proglang{C}</xsl:template>

<xsl:template match="proglang">\proglang{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="mklang">\MarkupLang{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="svg">\MarkupLang{SVG}</xsl:template>
<xsl:template match="kml">\MarkupLang{KML}</xsl:template>


</xsl:stylesheet>