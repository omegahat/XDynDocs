<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc"
                version='1.0'>

<xsl:include href="http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl" />

<xsl:template match="answer">
</xsl:template>

<xsl:template match="question">
 <li> <xsl:apply-templates /> </li>
</xsl:template>

<xsl:template match="questions">
 <ol>
  <xsl:apply-templates />
 </ol>
</xsl:template>

</xsl:stylesheet>
