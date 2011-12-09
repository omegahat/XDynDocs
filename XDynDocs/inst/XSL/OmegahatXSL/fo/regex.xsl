<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:rx="http://www.regex.org"
                version="1.0">


<xsl:template match="rx:pattern|rx:expr">
  <fo:inline font-weight="italic"><xsl:call-template name="inline.monoseq"/></fo:inline>
</xsl:template>



</xsl:stylesheet>
