<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:omg="http://www.omegahat.org"
		xmlns:bioc="http://www.bioconductor.org"
		xmlns:rwx="http://www.omegahat.org/RwxWidgets"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                exclude-result-prefixes="fo rwx bioc omg"
                version="1.0">

<xsl:template match="omg:func[@pkg]">
<xsl:call-template name="ulink"><xsl:with-param name="url">http://www.omegahat.org/<xsl:value-of select="string(@pkg)"/>/<xsl:value-of select="string(.)"/>.html</xsl:with-param></xsl:call-template> 
</xsl:template>


<xsl:template match="omg:pkg">
  <fo:basic-link>
   <xsl:attribute name="external-destination">http://www.omegahat.org/<xsl:value-of select="."/></xsl:attribute>
    <xsl:apply-templates/>
  </fo:basic-link>
<!--<xsl:call-template name="ulink"><xsl:with-param name="url">http://www.omegahat.org/<xsl:value-of select="."/></xsl:with-param></xsl:call-template> -->
</xsl:template>



<xsl:template match="bioc:pkg">
  <fo:basic-link>
   <xsl:attribute name="external-destination">http://www.bioconductor.org/<xsl:value-of select="."/></xsl:attribute>
    <xsl:apply-templates/>
  </fo:basic-link>
<!--<xsl:call-template name="ulink"><xsl:with-param name="url">http://www.omegahat.org/<xsl:value-of select="."/></xsl:with-param></xsl:call-template> -->
</xsl:template>

</xsl:stylesheet>