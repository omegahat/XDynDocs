<xsl:stylesheet  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		 xmlns:xml="http://www.w3.org/XML/1998/namespace"
		 xmlns:xp="http://www.w3.org/TR/xpath"		       
		 xmlns:fo="http://www.w3.org/1999/XSL/Format"
		 xmlns:kml="http://earth.google.com/kml/2.1"
		 version="1.0">


<xsl:template match="xml:tag|xml:element|xml:node|xml:tagName|xml:el">
  &lt;<xsl:apply-templates/>&gt;
</xsl:template>

<xsl:template match="xp:func">
 <fo:inline font-weight="italic"><xsl:apply-templates />()</fo:inline>
</xsl:template>

<xsl:template match="xp:expr|xp:path">
 <fo:inline font-weight="italic"><xsl:apply-templates /></fo:inline>
</xsl:template>

<xsl:template match="xp:true">
<fo:inline font-weight="bold">true</fo:inline>
</xsl:template>


<xsl:param name="xpath.code.color">#FFCCFF</xsl:param>

<xsl:template match="xp:code">
 <fo:block hyphenate="false" font-family="monospace" text-align="start"
             wrap-option="no-wrap"  white-space-treatment="preserve"
             linefeed-treatment='preserve'
             white-space-collapse = "false">
          <xsl:attribute name="background-color"><xsl:value-of select="$xpath.code.color"/></xsl:attribute><xsl:apply-templates/></fo:block>
</xsl:template>


<xsl:template match="xp:call">
 <fo:inline font-weight="bold"><xsl:apply-templates /></fo:inline>
</xsl:template>

<xsl:template match="xp:attr">
 <fo:inline font-weight="italic"><xsl:apply-templates /></fo:inline>
</xsl:template>

<xsl:template match="xml:namespace|xml:namespaceprefix">
 <fo:inline font-weight="italic"><xsl:apply-templates /></fo:inline>
</xsl:template>

<xsl:template match="xp:ns">
 <fo:inline font-weight="bold"><xsl:apply-templates /></fo:inline>
</xsl:template>


<!--  -->

<xsl:template match="xsl:call">
 <fo:inline font-weight="bold"><xsl:apply-templates /></fo:inline>
</xsl:template>

<xsl:template match="xsl:func">
 <fo:inline font-weight="bold"><xsl:apply-templates /></fo:inline>
</xsl:template>

<xsl:template match="xsl:param">
 <fo:inline font-weight="italic"><xsl:apply-templates /></fo:inline>
</xsl:template>


<xsl:template match="xml:xmlns">
 <fo:inline font-weight="italic"><xsl:apply-templates /></fo:inline>
</xsl:template>

<xsl:template match="ns:uri" xmlns:ns="http://www.w3.org/TR/REC-xml-names">
 <fo:inline font-weight="bold"><xsl:apply-templates /></fo:inline>
</xsl:template>

<xsl:template match="xml:attribute">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="xml:expr">
 <fo:inline font-weight="italic"><xsl:apply-templates /></fo:inline>
</xsl:template>


<xsl:template match="xml:inline-code|xml:code">
 <fo:block hyphenate="false" font-family="monospace" text-align="start"
             wrap-option="no-wrap"  white-space-treatment="preserve"
             linefeed-treatment='preserve'
             white-space-collapse = "false"
             background-color = '#f0ffff'> <xsl:apply-templates/></fo:block>
</xsl:template>

<xsl:template match="xml">
<fo:inline font-weight="bold">XML</fo:inline>
</xsl:template>

<xsl:template match="js">
<fo:inline font-weight="bold">JavaScript</fo:inline>
</xsl:template>

<xsl:template match="svg">
<fo:inline font-weight="bold">SVG</fo:inline>
</xsl:template>

<xsl:template match="kml:style">
 <fo:inline font-weight="italic"><xsl:apply-templates /></fo:inline>
</xsl:template>


</xsl:stylesheet>