<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:make="http://www.make.org"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version='1.0'>


<xsl:param name="cpp.code.color">#f0f0f0</xsl:param>
<xsl:template match="make:code">
 <xsl:call-template name="makeVerbatimCode">
   <xsl:with-param name="color"><xsl:value-of select="$cpp.code.color"/></xsl:with-param>
 </xsl:call-template>
</xsl:template>


</xsl:stylesheet>
