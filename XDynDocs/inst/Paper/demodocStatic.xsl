<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:r="http://www.r-project.org"
                exclude-result-prefixes="r"
                version='1.0'>

<xsl:import 
    href="http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl"/>

<xsl:template match="r:func">
 <strong><xsl:value-of select="."/>()</strong>
</xsl:template>

<xsl:template match="r:code">
 <pre>
 <xsl:apply-templates/>
 </pre>
</xsl:template>

<xsl:template match="r:output">
 <xsl:value-of select="."/>
</xsl:template>

</xsl:stylesheet>
