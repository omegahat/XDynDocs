<xsl:stylesheet  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		 xmlns:xml="http://www.w3.org/XML/1998/namespace"
		 xmlns:xp="http://www.w3.org/TR/xpath"		       
		 xmlns:fo="http://www.w3.org/1999/XSL/Format"
		 version="1.0">

<xsl:template match="xsl:var">
  <fo:inline font-weight="bold"><xsl:apply-templates /></fo:inline>
</xsl:template>


<xsl:param name="xsl.code.color">#f0ff88</xsl:param>
<xsl:template match="xsl:code">
  <xsl:call-template name="makeVerbatimCode">
    <xsl:with-param name="color"><xsl:value-of select="$xsl.code.color"/></xsl:with-param>
  </xsl:call-template>
</xsl:template>


</xsl:stylesheet>