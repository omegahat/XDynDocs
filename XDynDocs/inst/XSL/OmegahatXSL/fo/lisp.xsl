<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:lisp="http://www.lisp.org"
		xmlns:t="http://www.tlisp.org"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version='1.0'>

<xsl:template match="lisp">
LISP
</xsl:template>

<xsl:template match="lisp:code">
 <xsl:call-template name="makeVerbatimCode">
   <xsl:with-param name="color">silver</xsl:with-param>
 </xsl:call-template>
</xsl:template>

<xsl:template match="t:code">
 <xsl:call-template name="makeVerbatimCode">
   <xsl:with-param name="color">lightgray</xsl:with-param>
 </xsl:call-template>
</xsl:template>

<xsl:template match="lisp:func">
 <xsl:call-template name="inline.italicmonoseq"/>
</xsl:template>

<xsl:template match="lisp:arg">
 <fo:inline color="orange"><xsl:call-template name="inline.italicseq"/></fo:inline>
</xsl:template>

<xsl:template match="t:expr|lisp:expr">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="t:var|lisp:var">
  <fo:inline color="red"><xsl:call-template name="inline.monoseq"/></fo:inline>
</xsl:template>

<xsl:template match="lisp:macro">
  <fo:inline color="gray"><xsl:call-template name="inline.monoseq"/></fo:inline>
</xsl:template>

<xsl:template match="lisp:package|lisp:pkg">
  <fo:inline color="salmon"><xsl:call-template name="inline.monoseq"/></fo:inline>
</xsl:template>

<xsl:template match="lisp:kw|lisp:keyword">
  <fo:inline color="green"><xsl:call-template name="inline.monoseq"/></fo:inline>
</xsl:template>



</xsl:stylesheet>