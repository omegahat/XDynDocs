<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc"
                version='1.0'>

<xsl:include href="/usr/share/sgml/docbook/xsl-stylesheets/html/docbook.xsl" />
<xsl:include href="/home/duncan/Projects/org/omegahat/Docs/XSL/defs.xsl" />
<xsl:include href="/home/duncan/Projects/org/omegahat/Docs/XSL/SLanguage.xsl" />
<xsl:include href="/home/duncan/Projects/org/omegahat/Docs/XSL/Rstyle.xsl" />
<xsl:include href="/home/duncan/Projects/org/omegahat/Docs/XSL/perl.xsl" />


<xsl:template match="exercise">
 <xsl:apply-templates select="question"/>
</xsl:template>
</xsl:stylesheet>
