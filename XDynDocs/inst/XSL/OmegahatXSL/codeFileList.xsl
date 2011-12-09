<?xml version="1.0"?>

<!-- Copyright the Omegahat Project for Statistical Computing, 2000 -->
<!-- Author: Duncan Temple Lang -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
                xmlns:r="http://www.r-project.org"
                xmlns:rs="http://www.omegahat.org/RS"
                xmlns:c="http://www.C.org"
                xmlns:pl="http://www.perl.org"
                xmlns:py="http://www.python.org"
                version="1.0">


<!-- 
   This walks through all the code tags that match the language
   of interest and have a file attribute. It then writes this filename
   to standard output.
  -->

<xsl:param name="language" select="'C'"/>
<xsl:output method="text" omit-xml-declaration="yes" />

<xsl:template match="/">
 <xsl:apply-templates select="//c:code|//r:code|//r:plot|//r:expr|//pl:code|//py:code" />
</xsl:template>

<xsl:template match="*[@lang]">
 <xsl:if test="translate($language, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = @lang">
   <xsl:value-of select="@file" /><xsl:text>
</xsl:text>
 </xsl:if>
</xsl:template>

<xsl:template match="*[not(@lang)]">
<xsl:variable name="ns"> <xsl:value-of select="substring-before(name(.), ':')"/></xsl:variable>
 <xsl:if test="$ns = translate($language, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')">
  <xsl:value-of select="@file" /><xsl:text>
</xsl:text>
 </xsl:if>
</xsl:template>

</xsl:stylesheet>
