<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:rest="http://www.rest.org"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

<xsl:template match="rest:method">
  <fo:inline color="#e6ffff" 
             xsl:use-attribute-sets="monospace.verbatim.properties">
    <xsl:apply-templates />
 </fo:inline>
</xsl:template>

<xsl:template match="rest:param">
  <fo:inline color="#ffffe6" 
             xsl:use-attribute-sets="monospace.verbatim.properties">
    <xsl:apply-templates />
 </fo:inline>
</xsl:template>


</xsl:stylesheet>