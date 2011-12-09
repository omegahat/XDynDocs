<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:cpp="http://www.cplusplus.org"
                xmlns:c="http://www.C.org"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

<!--
<xsl:template match="c:struct">
<xsl:template match="c:enumValue">
<xsl:template match="c:method">
-->

<xsl:template match="c:keyword">
  <fo:inline color="#e6e6fa" 
             font-weight="bold"
             xsl:use-attribute-sets="monospace.verbatim.properties">
    <xsl:apply-templates />
 </fo:inline>
</xsl:template>

<xsl:template match="c:expr|cpp:expr">
 <xsl:call-template name="expression">
   <xsl:with-param name="color">#e6e6fa</xsl:with-param>
 </xsl:call-template>
</xsl:template>


<xsl:template match="c:variable|c:var">
  <fo:inline color="#e6e6fa"><xsl:call-template name="inline.monoseq"/></fo:inline>
</xsl:template>


<xsl:template match="c:arg|c:param">
  <fo:inline color="#ffff00"><xsl:call-template name="inline.monoseq"/></fo:inline>
</xsl:template>


<xsl:template match="c:struct">
  <fo:inline color="#FF0099"><xsl:call-template name="inline.monoseq"/></fo:inline>
</xsl:template>

<xsl:template match="c:field">
  <fo:inline color="#FF00FF"><xsl:call-template name="inline.monoseq"/></fo:inline>
</xsl:template>

<xsl:template match="c:null">
  <fo:inline color="#FF00FF">NULL</fo:inline>
</xsl:template>

<xsl:template match="c:struct">
 <fo:inline color="#66000fa" font-style="italic">
  <xsl:apply-templates />
 </fo:inline>
</xsl:template>

<xsl:template match="c:routine|c:func">
 <fo:inline color="#66f00fa" font-style="italic">
  <xsl:apply-templates />
 </fo:inline>
</xsl:template>

<xsl:param name="c.code.color">#54ff9f</xsl:param>
<xsl:param name="cpp.code.color">#e6e600</xsl:param>
<xsl:template match="cpp:code">
  <xsl:call-template name="makeVerbatimCode">
    <xsl:with-param name="color"><xsl:value-of select="$cpp.code.color"/></xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="c:code">
  <xsl:call-template name="makeVerbatimCode">
    <xsl:with-param name="color"><xsl:value-of select="$c.code.color"/></xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="c:routineDef">
  <xsl:call-template name="makeVerbatimCode">
    <xsl:with-param name="color">#e6e6aa</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="c:type">
 <fo:inline color="#FF00FF" font-style="italic">
  <xsl:apply-templates />
 </fo:inline>
</xsl:template>

</xsl:stylesheet>
