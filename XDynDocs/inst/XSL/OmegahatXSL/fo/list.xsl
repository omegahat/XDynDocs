<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template match="li">
  <xsl:call-template name="itemizedlist.listitem"/>
</xsl:template>

<xsl:template match="ul">
  <xsl:call-template name="itemizedlist"/>
</xsl:template>


</xsl:stylesheet>

