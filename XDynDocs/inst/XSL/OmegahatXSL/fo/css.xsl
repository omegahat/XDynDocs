<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:css="http://www.w3.org/Style/CSS"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">


<xsl:template match="css:class">
  <fo:inline color="#FF88FF"><xsl:call-template name="inline.monoseq"/></fo:inline> 
</xsl:template>

</xsl:stylesheet>