<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template name="string-replace-all">
  <xsl:param name="txt"/>
  <xsl:param name="replace"/>
  <xsl:param name="by"/>
  <xsl:choose>
    <xsl:when test="contains($txt,$replace)">
      <xsl:value-of select="substring-before($txt,$replace)"/>
      <xsl:value-of select="$by"/>
      <xsl:call-template name="string-replace-all">
        <xsl:with-param name="txt" select="substring-after($txt,$replace)"/>
        <xsl:with-param name="replace" select="$replace"/>
        <xsl:with-param name="by" select="$by"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$txt"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="string-replace-uscore">
 <xsl:call-template name="string-replace-all"> 
  <xsl:with-param name="text" select="string(.)"/>
  <xsl:with-param name="replace" select="_"/>
  <xsl:with-param name="by">\_</xsl:with-param>
 </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
