<?xml version="1.0"?>

<!-- See tangle.xsl -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:r="http://www.r-project.org"
                version="1.0">

<xsl:output method="text"/>

<xsl:template match="/">
   <xsl:apply-templates select="//r:code[not(@eval='false') and not(@used='0')]"/>
</xsl:template>

<xsl:template match="r:output"/>

<xsl:template match="r:code[@ref]">
 <xsl:apply-templates select="//r:code[@id='@ref']"/>
</xsl:template>

</xsl:stylesheet>