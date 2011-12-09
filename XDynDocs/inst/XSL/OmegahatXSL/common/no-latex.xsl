<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	 xmlns:r="http://www.r-project.org"
      version="1.0">

<xsl:template match="r:pkgVersion">
<xsl:call-template name="R.ref"/> package, version <xsl:apply-templates/>.
</xsl:template>
</xsl:stylesheet>


