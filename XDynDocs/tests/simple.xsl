<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		version="1.0">

<xsl:template match="/">
<fo:block>
<fo:inline>Top-level node: <xsl:value-of select="local-name()"/></fo:inline>
<xsl:apply-templates />
</fo:block>
</xsl:template>
</xsl:stylesheet>