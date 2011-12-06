<?xml version="1.0" ?>

<!-- Copyright the Omegahat Project for Statistical Computing, 2000 -->
<!-- Author: Duncan Temple Lang -->

<xsl:stylesheet
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
            version="1.0"
>
<xsl:output method="text" omit-xml-declaration="yes" />

<xsl:template match="/">
 <xsl:apply-templates select="//ulink" />
</xsl:template>

<xsl:template match="*">
<!-- Need new lines here. -->
 <xsl:value-of select="@url"/>,
</xsl:template>

</xsl:stylesheet>
