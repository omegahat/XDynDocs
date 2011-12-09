<?xml version="1.0"?>
<!-- Customization layer -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:dcom="http://www.microsoft.com"
                version="1.0">


<xsl:template match="dcom:method">
 <xsl:call-template name="func">
   <xsl:with-param name="class">COM</xsl:with-param>
 </xsl:call-template>
</xsl:template>

<xsl:template match="dcom:name">
  <b><xsl:apply-templates/></b>
</xsl:template>


<xsl:template match="dcom:var">
  <xsl:call-template name="var">
    <xsl:with-param name="class">COM</xsl:with-param>
  </xsl:call-template>
</xsl:template>


<xsl:template match="dcom:class">
    <code class="COM"><xsl:apply-templates/></code>
</xsl:template>

<xsl:template match="dcom:property">
  <xsl:call-template name="var">
    <xsl:with-param name="class">COM</xsl:with-param>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>


