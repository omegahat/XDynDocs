<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:as="http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/"
                xmlns:mx="http://www.adobe.com/2006/mxml"
                version="1.0">


<xsl:param name="as.code.color">lightgray</xsl:param>

<xsl:template match="as:code">
  <xsl:call-template name="makeVerbatimCode">
   <xsl:with-param name="color"><xsl:value-of select="$as.code.color"/></xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="as:func">
  <fo:inline><xsl:apply-templates/>()</fo:inline>
</xsl:template>

<xsl:template match="as:field">
  <fo:inline><xsl:apply-templates/>()</fo:inline>
</xsl:template>

<xsl:template match="as:prop">
  <fo:inline><xsl:apply-templates/>()</fo:inline>
</xsl:template>

<xsl:template match="as:eventName">
  <fo:inline><xsl:apply-templates/>()</fo:inline>
</xsl:template>

<xsl:template match="as:var">
  <fo:inline><xsl:apply-templates/>()</fo:inline>
</xsl:template>

</xsl:stylesheet>