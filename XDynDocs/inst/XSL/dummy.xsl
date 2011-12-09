<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


<xsl:import href="http://www.omegahat.org/XSL/html/Rhtml.xsl"/>

<xsl:template match="exercise"/>
<xsl:template match="data">
<pre class="data">
  <xsl:apply-templates/>
</pre>
</xsl:template>

</xsl:stylesheet>

