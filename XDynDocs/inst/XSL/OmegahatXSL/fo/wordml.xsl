<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:wml='http://schemas.openxmlformats.org/wordprocessingml/2006/main'
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version='1.0'>

<xsl:param name="wml.style.color">brown</xsl:param>
<xsl:template match="wml:style">
  <xsl:call-template name="jsInline">
    <xsl:with-param name="color"><xsl:value-of select="$wml.style.color"/></xsl:with-param>
  </xsl:call-template>
</xsl:template>
</xsl:stylesheet>