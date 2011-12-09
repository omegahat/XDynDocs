<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                version="1.0">

<xsl:output method="xml" encoding="UTF-8"
 doctype-public="-//OASIS//DTD Entity Resolution XML Catalog V1.0//EN"
 doctype-system="http://www.oasis-open.org/committees/entity/release/1.0/catalog.dtd"/>

<xsl:param name="OMEGA_XSL" select="''"/>

<xsl:template match="catalog">
 <catalog>
 <xsl:apply-templates />
 <rewriteURI uriStartString="http://www.omegahat.org/XSL" rewritePrefix="file:///{$OMEGA_XSL}/XSL"/>

 </catalog>
</xsl:template>

<xsl:template match="/">
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="*">
 <xsl:element name="{name(.)}">
  <xsl:for-each select="@*">
   <xsl:copy />
  </xsl:for-each>
   <xsl:apply-templates />
 </xsl:element>
</xsl:template>


</xsl:stylesheet>

