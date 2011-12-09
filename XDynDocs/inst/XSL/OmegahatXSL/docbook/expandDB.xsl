<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version='1.0'
	 xmlns:xi="http://www.w3.org/2003/XInclude">

<xsl:template match="docbook">DocBook</xsl:template>
<xsl:template match="perl"><proglang>PERL</proglang></xsl:template>
<xsl:template match="json"><proglang>JSON</proglang></xsl:template>
<xsl:template match="r|R"><proglang>R</proglang></xsl:template>


<xsl:include href="shorthand.xsl"/>
<xsl:include href="glossaryTable.xsl"/>
<xsl:include href="linkTable.xsl"/>
<xsl:include href="../common/xml-to-string.xsl"/>

<xsl:output method="xml"
            cdata-section-elements=""/>

<!-- copy everything through by default. -->
<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>


<xsl:template match="img">
<graphic format="PNG"><xsl:attribute name="fileref"><xsl:value-of select="@src"/></xsl:attribute></graphic>
</xsl:template>

<!-- Allow for a verbatim XML/HTML that is protected by putting  -->
<xsl:template match="verbXML">
<programlisting>
<xsl:text>&#10;</xsl:text>
<xsl:call-template name="xml-to-string">
<xsl:with-param name="node-set" select="./*[1]"/>
</xsl:call-template>
<xsl:text>&#10;</xsl:text>
</programlisting>
</xsl:template>


</xsl:stylesheet>


