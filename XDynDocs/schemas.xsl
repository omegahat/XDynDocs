<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:param name="newDir"><xsl:message terminate="yes">You must set newDir</xsl:message></xsl:param>

<xsl:template match="node()"><xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy></xsl:template>

<xsl:template match="@*">
<xsl:copy/>
</xsl:template>

<xsl:template match="@*[contains(., '/Users/duncan')]">
<xsl:attribute name="{name()}"><xsl:value-of select="substring-before(., '/Users/duncan')"/><xsl:value-of select="$newDir"/><xsl:value-of select="substring-after(., '/Users/duncan')"/></xsl:attribute>
</xsl:template>

</xsl:stylesheet>