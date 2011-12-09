<?xml version="1.0"?>

<!-- Copyright the Omegahat Project for Statistical Computing, 2000 -->
<!-- Author: Duncan Temple Lang -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sh="http://www.shell.org"
                version="1.0">

<xsl:template match="sh:exec">
\textsl{<xsl:apply-templates/>}
</xsl:template>

</xsl:stylesheet>


