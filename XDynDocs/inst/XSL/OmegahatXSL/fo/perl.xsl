<?xml version="1.0" ?>
<xsl:stylesheet 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:perl="http://www.perl.org"
        xmlns:fo="http://www.w3.org/1999/XSL/Format"
        version="1.0">

<xsl:template match="perl:class">
 <fo:inline color="green" font-style="italic">
  <xsl:apply-templates />
 </fo:inline>
</xsl:template>



<xsl:param name="perl.code.color">#C0C0C0</xsl:param>
<xsl:template match="perl:code">
 <xsl:call-template name="makeVerbatimCode">
   <xsl:with-param name="color"><xsl:value-of select="$perl.code.color"/></xsl:with-param>
 </xsl:call-template>
</xsl:template>

<!--
<xsl:template match="perl:sub">
<font class="perlSub"><xsl:apply-templates/>()</font>
</xsl:template>

<xsl:template match="perl:cmd">
<code class="per"><xsl:apply-templates/></code>
</xsl:template>

<xsl:template match="perl:variable">
 <b class="perlVariable"><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="perl:module">
 <b class="perlModule"><xsl:apply-templates/></b>
</xsl:template>
-->

</xsl:stylesheet>
