<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version='1.0'>

<xsl:template match="linkTable">
<xsl:choose>
 <xsl:when test="not(ancestor::section)">
 <section><title>Table of Links</title>
  <xsl:call-template name="makeLinkTable"/>
 </section>
 </xsl:when>
 <xsl:otherwise>
  <xsl:call-template name="makeLinkTable"/>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="makeLinkTable">
<orderedlist>
<xsl:apply-templates select="//ulink" mode="linkTable"/>
</orderedlist>
</xsl:template>

<xsl:template match="ulink" mode="linkTable">
<listitem>
  <xsl:apply-templates/>
</listitem>
</xsl:template>

<!-- If there is no text in the ulink, add it by copying the @url.  -->
<xsl:template match="ulink[not(text())]" mode="linkTable">
<listitem>
  <ulink><xsl:attribute name="url"><xsl:value-of select="@url"/></xsl:attribute><xsl:value-of select="@url"/></ulink>
</listitem>
</xsl:template>

</xsl:stylesheet>

