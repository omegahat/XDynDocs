<?xml version="1.0" ?>
<xsl:stylesheet 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xml="http://www.w3.org/XML/1998/namespace"
	xmlns:xp="http://www.w3.org/TR/xpath"
        xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:json="http://www.json.org"
        xmlns:ecma="http://www.ecma-international.org/publications/standards/Ecma-262.htm"
        xmlns:js="http://www.ecma-international.org/publications/standards/Ecma-262.htm"
        version="1.0">

<xsl:param name="js.code.color">lightgray</xsl:param>

<xsl:template match="js:code">
  <xsl:call-template name="makeVerbatimCode">
   <xsl:with-param name="color"><xsl:value-of select="$js.code.color"/></xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:param name="js.func.color">brown</xsl:param>
<xsl:template match="js:func|js:function">
  <xsl:call-template name="jsInline">
    <xsl:with-param name="color"><xsl:value-of select="$js.func.color"/></xsl:with-param>
  </xsl:call-template>()
</xsl:template>

<xsl:param name="js.expr.color">brown</xsl:param>
<xsl:template match="js:expr | js:value">
  <xsl:call-template name="jsInline">
    <xsl:with-param name="color"><xsl:value-of select="$js.expr.color"/></xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="js:null|json:null">
  <fo:inline >
    <xsl:attribute name="color"><xsl:value-of select="$js.expr.color"/></xsl:attribute>null
  </fo:inline>
</xsl:template>



<xsl:template match="json:false">
  <fo:inline >
    <xsl:attribute name="color"><xsl:value-of select="$js.expr.color"/></xsl:attribute>false
  </fo:inline>
</xsl:template>
<xsl:template match="json:true">
  <fo:inline >
    <xsl:attribute name="color"><xsl:value-of select="$js.expr.color"/></xsl:attribute>true
  </fo:inline>
</xsl:template>




<xsl:param name="js.param.color">brown</xsl:param>
<xsl:template match="js:param">
  <xsl:call-template name="jsInline">
    <xsl:with-param name="color"><xsl:value-of select="$js.param.color"/></xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:param name="js.var.color">brown</xsl:param>

<xsl:template match="js:var">
  <xsl:call-template name="jsInline">
    <xsl:with-param name="color"><xsl:value-of select="$js.var.color"/></xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="jsInline">
  <xsl:param name="color">black</xsl:param>
  <xsl:param name="isFunc" select="0"/>
  <fo:inline >
    <xsl:attribute name="color"><xsl:value-of select="$color"/></xsl:attribute>
    <xsl:apply-templates/><xsl:if test="$isFunc">()</xsl:if>
  </fo:inline>
</xsl:template>


<xsl:template match="js:keyword">
  <xsl:call-template name="jsInline">
    <xsl:with-param name="color"><xsl:value-of select="$js.var.color"/></xsl:with-param>
  </xsl:call-template>
</xsl:template>



<xsl:param name="js.field.color">black</xsl:param>
<xsl:template match="js:field">
  <xsl:call-template name="jsInline">
    <xsl:with-param name="color"><xsl:value-of select="$js.field.color"/></xsl:with-param>
  </xsl:call-template>
</xsl:template>


<xsl:template match="js:method">
  <xsl:call-template name="jsInline">
    <xsl:with-param name="color"><xsl:value-of select="$js.var.color"/></xsl:with-param>
    <xsl:with-param name="isFunc">1</xsl:with-param>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>

