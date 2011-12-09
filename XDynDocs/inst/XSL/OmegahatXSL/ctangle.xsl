<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:r="http://www.r-project.org"
                xmlns:c="http://www.C.org"
                version="1.0">

<xsl:output method="text"/>

<xsl:param name="file" select="''"/>

<xsl:template match="/">
<xsl:choose>
 <xsl:when test="string($file)=''">
  <xsl:apply-templates select="//c:header" />
  <xsl:apply-templates select="//c:code" />
 </xsl:when>
 <xsl:otherwise>
  <xsl:apply-templates select="//c:header[@file = $file]" />
  <xsl:apply-templates select="//c:code[@file = $file]" />
 </xsl:otherwise>
 </xsl:choose>
</xsl:template>

</xsl:stylesheet>
