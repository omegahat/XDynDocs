<?xml version="1.0"?>
<!-- 
  This ensures that the resulting document has the
  xml-stylesheet type="text/xsl" href=$XSL_FILE
  processing instruction at the top.
  This makes the document browsable by Firefox.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:dcom="http://www.microsoft.com"
                version="1.0">

<xsl:param name="XSL_FILE">http://www.omegahat.org/XSL/Rstyle.xsl</xsl:param>

<xsl:template match="processing-instruction('xml-stylesheet')"></xsl:template>

<xsl:template match="*">
 <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="/">
 <xsl:processing-instruction name="xml-stylesheet">  href="<xsl:value-of select='string($XSL_FILE)'/>" type="text/xsl"</xsl:processing-instruction>
 <xsl:apply-templates />
</xsl:template>

</xsl:stylesheet>