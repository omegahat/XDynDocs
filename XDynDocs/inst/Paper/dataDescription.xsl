<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:r="http://www.r-project.org" 
                version="1.0">

<!-- <xsl:import href="http://www.omegahat.org/XSL/html/Rhtml.xsl"/> -->

<xsl:include href="http://www.omegahat.org/XSL/docbook/expandDB.xsl"/>

<xsl:preserve-space elements="*"/>

<xsl:template match="*|attribute::*">
 <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
 </xsl:copy>
</xsl:template>


<xsl:template match="dataDescription">
<table>
<title><xsl:apply-templates select="title"/></title>
<tgroup cols='4'>
<thead>
<row>
<entry>Name</entry><xsl:text>&#10;</xsl:text>
<entry>Type</entry><xsl:text>&#10;</xsl:text>
<entry>Unit</entry><xsl:text>&#10;</xsl:text>
<entry>Description</entry><xsl:text>&#10;</xsl:text>
</row>
</thead>
<tbody>
<xsl:apply-templates select="variables/variable"/>
</tbody>
</tgroup>
</table>
</xsl:template>

<xsl:template match="dataDescription/variables/variable">
<row><xsl:text>&#10;</xsl:text>
<entry><xsl:value-of select="@name"/></entry><xsl:text>&#10;</xsl:text>
<entry><xsl:value-of select="@type"/></entry><xsl:text>&#10;</xsl:text>
<entry><xsl:apply-templates select="unit"/></entry><xsl:text>&#10;</xsl:text>
<entry><xsl:apply-templates select="description"/></entry><xsl:text>&#10;</xsl:text>
</row><xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="unit|title|description">
<xsl:apply-templates/>
</xsl:template>



</xsl:stylesheet>
