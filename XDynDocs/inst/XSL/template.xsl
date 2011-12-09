<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!-- Style we are overriding/extending -->
<xsl:import href="http://www.omegahat.org/XSL/html/Rhtml.xsl"/>

  <!--  template to kill off nodes we don't want shown -->
<xsl:template match="thingsToSuppress"/>

  <!-- template that we can fill in to handle new nodes or override imported templates -->
<xsl:template match="node">
</xsl:template>

</xsl:stylesheet>

