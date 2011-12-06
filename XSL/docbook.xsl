<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc"
                version='1.0'>


<xsl:include href="http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl" />
<xsl:include href="http://www.omegahat.org/XSL/defs.xsl" />
<xsl:include href="http://www.omegahat.org/XSL/SLanguage.xsl" />
<xsl:include href="http://www.omegahat.org/XSL/Rstyle.xsl" />
<xsl:include href="http://www.omegahat.org/XSL/perl.xsl" />
<xsl:include href="http://www.omegahat.org/XSL/regex.xsl" />
<xsl:include href="http://www.omegahat.org/XSL/shell.xsl" />



<xsl:template match="exercise">
 <xsl:apply-templates select="question"/>
</xsl:template>
</xsl:stylesheet>
