<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="text" omit-xml-declaration="yes"/> 

<xsl:template match="/article">
 <xsl:apply-templates select="//graphic[@fileref]"/>
</xsl:template>

<xsl:template match="graphic[@fileref]">
 <xsl:value-of select="@fileref"/><xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="*"/>

</xsl:stylesheet>