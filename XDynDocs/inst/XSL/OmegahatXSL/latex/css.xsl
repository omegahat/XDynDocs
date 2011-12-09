<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:css="http://www.w3.org/Style/CSS/"
		version="1.0">

<xsl:template match="css:selector">\CSSselector{<xsl:apply-templates/>}
</xsl:template>


</xsl:stylesheet>

