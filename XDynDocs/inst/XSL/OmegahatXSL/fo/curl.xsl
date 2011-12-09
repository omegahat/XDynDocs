<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:curl="http://curl.haxx.se"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">


<xsl:param name="curl.option.color">#885488</xsl:param>
<xsl:template match="curl:opt">
  <fo:inline color="{$curl.option.color}" font-weight="italic">  
    <xsl:apply-templates />  
  </fo:inline>
</xsl:template>

</xsl:stylesheet>
