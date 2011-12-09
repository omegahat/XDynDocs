<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                version="1.0">

<xsl:output method="text" omit-xml-declaration="yes"/>
<xsl:template match="text()" />

<xsl:template match="rewriteURI">
 <xsl:if test="@uriStartString='http://docbook.sourceforge.net/release/xsl/current'"><xsl:value-of select="@rewritePrefix"/></xsl:if>
</xsl:template>

<xsl:template match="/"><xsl:apply-templates/></xsl:template>

</xsl:stylesheet>

