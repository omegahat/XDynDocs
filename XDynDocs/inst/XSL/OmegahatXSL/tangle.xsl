<?xml version="1.0"?>
<!-- An alternative to getCode.xsl but more imperative/procedural than
     the template/rule based approach. 
  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:r="http://www.r-project.org"
                version="1.0">

<xsl:output method="text"/>

<xsl:param name="forPackage" select="0" />

<xsl:template match="/">
 <xsl:if test="$forPackage">
    <xsl:apply-templates select="//r:function[not(@eval='false')]|//r:classDef[not(@eval='false')]"/>
 </xsl:if>
 <xsl:if test="not($forPackage)">
    <xsl:apply-templates select="//r:function[not(@eval='false')]|//r:code[not(@eval='false') and not(@used='0')]|//r:plot[not(@eval='false') and not(@used='0')]|//r:expr[not(@eval='false') and not(@used='0')]"/>
 </xsl:if>
</xsl:template>

<xsl:template match="//r:code|//r:expr|//r:plot|r:function">
    ####   <xsl:value-of select="@id"/>
     <xsl:apply-templates />
</xsl:template>


<xsl:template match="//r:*[@file]">
    ####   <xsl:value-of select="@id"/>
     <xsl:apply-templates />
</xsl:template>

<xsl:template match="r:output" />

</xsl:stylesheet>
