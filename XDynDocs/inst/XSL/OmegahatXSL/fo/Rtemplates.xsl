<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:r="http://www.r-project.org"
                xmlns:s="http://cm.bell-labs.com/stat/S4"
		version="1.0">

<xsl:template match="r:null">
 <fo:inline font-family="bold">NULL</fo:inline>
</xsl:template>

<xsl:template match="r:arg">
 <fo:inline font-weight="italic"><xsl:apply-templates/></fo:inline>
</xsl:template>

<xsl:param name="r.s3class.color">#00FF00</xsl:param>
<xsl:template match="r:s3class|s3class">
 <fo:inline color="{$r.s3class.color}" font-weight="italic"><xsl:apply-templates/></fo:inline>
</xsl:template>

<xsl:param name="r.class.color">#BB149A</xsl:param>

<xsl:template match="r:class">
 <fo:inline font-style="oblique" color="{$r.class.color}"><xsl:call-template name="inline.monoseq"/></fo:inline>
</xsl:template>

<xsl:param name="r.slot.color">red</xsl:param>
<xsl:template match="r:slot">
 <fo:inline color="{$r.slot.color}" font-weight="bold"><xsl:call-template name="inline.monoseq"/></fo:inline>
</xsl:template>

<xsl:param name="r.field.color">#88FF00</xsl:param>
<xsl:template match="r:field">
 <fo:inline color="{$r.field.color}" font-weight="italic"><xsl:call-template name="inline.monoseq"/></fo:inline>
</xsl:template>


<xsl:template match="r:true|s:true|r:TRUE">
  <fo:inline font-family="monospace" font-weight="bold">TRUE</fo:inline>
</xsl:template>

<xsl:template match="r:false|s:false|r:FALSE">
  <fo:inline font-family="monospace" font-weight="bold">FALSE</fo:inline>
</xsl:template>


<xsl:template match="r:na|r:NA|s:na|s:NA">
  <fo:inline font-family="monospace" font-weight="bold">NA</fo:inline>
</xsl:template>

<xsl:template match="r:nan">
  <fo:inline font-family="monospace" font-weight="bold">NaN</fo:inline>
</xsl:template>

<xsl:template match="r:inf">
  <fo:inline font-family="monospace" font-weight="bold">Inf</fo:inline>
</xsl:template>


<xsl:template match="r:value" />


<xsl:template match="r:op|r:operator|s:operator"> 
   <xsl:call-template name="inline.italicmonoseq"/>()
</xsl:template>


</xsl:stylesheet>
