<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:r="http://www.r-project.org"
                version='1.0'>

<xsl:output method="text"/>

<xsl:template match="article">
  <xsl:for-each select="//r:code">
    <xsl:value-of select="." />
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
