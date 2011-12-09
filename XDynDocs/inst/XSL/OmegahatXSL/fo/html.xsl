<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:html="http://www.w3.org/TR/html401"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">


<xsl:template match="html:tag">
  <fo:inline color="#FF88FF">&lt;<xsl:call-template name="inline.monoseq"/>&gt;</fo:inline> 
</xsl:template>

<xsl:template match="html:attr|html:attribute">
  <fo:inline color="#FF8822"><xsl:call-template name="inline.monoseq"/></fo:inline> 
</xsl:template>

<xsl:template match="html:val">
 <fo:inline font-weight="bold"><xsl:call-template name="inline.monoseq"/></fo:inline>
</xsl:template>

<xsl:template match="html:param">
  <fo:inline color="#FF88FF"><xsl:call-template name="inline.monoseq"/></fo:inline> 
</xsl:template>


<xsl:param name="html.code.color">orange</xsl:param>

<xsl:template match="html:code">
  <xsl:call-template name="makeVerbatimCode">
   <xsl:with-param name="color"><xsl:value-of select="$html.code.color"/></xsl:with-param>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>