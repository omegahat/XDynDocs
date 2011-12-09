<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                version="1.0">

<xsl:output method="xml"
   doctype-public="-//OASIS//DTD Entity Resolution XML Catalog V1.0//EN"
   doctype-system="http://www.oasis-open.org/committees/entity/release/1.0/catalog.dtd"/>

<xsl:param name="OMEGA_XSL" select="''"/>

<xsl:template match="*">
 <xsl:element name="{name(.)}">
  <xsl:for-each select="@*">
   <xsl:copy />
  </xsl:for-each>
   <xsl:apply-templates />
 </xsl:element>
</xsl:template>

<xsl:template match="catalog">
<!-- 
 <xsl:element name="catalog">
  <xsl:attribute name="xmlns">urn:oasis:names:tc:entity:xmlns:xml:catalog</xsl:attribute>
  <xsl:for-each select="@*">
   <xsl:copy />
  </xsl:for-each>
 </xsl:element>
 -->
 <catalog>
  <xsl:apply-templates />
  <rewriteURI uriStartString="http://www.omegahat.org/XSL" rewritePrefix="file://{$OMEGA_XSL}/XSL"/>

  <xsl:if test="$DOCBOOK_XSL!=''">
   <rewriteURI uriStartString="http://docbook.sourceforge.net/release/xsl/current" rewritePrefix="file://{$DOCBOOK_XSL}"/>
  </xsl:if>
 </catalog>
</xsl:template>

<xsl:template match="/"><xsl:apply-templates/></xsl:template>




</xsl:stylesheet>

