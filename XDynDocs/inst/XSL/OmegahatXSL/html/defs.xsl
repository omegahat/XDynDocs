<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:r="http://www.r-project.org"
		xmlns:s="http://cm.bell-labs.com/stat/S4"
                xmlns:py="http://www.python.org"
                xmlns:perl="http://www.perl.org"
                xmlns:c="http://www.C.org"
		xmlns:vb="http://www.visualbasic.com"
		xmlns:omegahat="http://www.omegahat.org"
		xmlns:bioc="http://www.bioconductor.org"
                xmlns:java="http://www.java.com"
		xmlns:sql="http://www.sql.org"
                version="1.0">


<xsl:template match="ignore" />

<xsl:template match="squote">
'<xsl:apply-templates/>'
</xsl:template>

<xsl:template match="LaTeX|latex">
 <i>LaTeX</i>
</xsl:template>

<xsl:template match="splus|SPLUS">
 <i>S-Plus</i>
</xsl:template>

<xsl:template match="py:code">
  <xsl:call-template name="code">
    <xsl:with-param name="class">python</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="perl:code|perl:script">
  <xsl:call-template name="code">
    <xsl:with-param name="class">perl</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="java:code">
  <xsl:call-template name="code">
    <xsl:with-param name="class">java</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="vb:code">
  <xsl:call-template name="code">
    <xsl:with-param name="class">VB</xsl:with-param>
  </xsl:call-template>
</xsl:template>


<xsl:template match="sql:code|sql:cmd">
  <xsl:call-template name="code">
    <xsl:with-param name="class">SQL</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="sql:func">
  <xsl:element name="code">
    <xsl:attribute name="class">SQL</xsl:attribute><xsl:value-of select="." />
  </xsl:element>
</xsl:template>

<xsl:template match="invisible"/>


<xsl:template match="VB">
 <i>Visual Basic</i>
</xsl:template>

<xsl:template match="Perl">
 <i>Perl</i>
</xsl:template>

<xsl:template match="Java">
 <i>Java</i>
</xsl:template>

<xsl:template match="Python">
 <i>Python</i>
</xsl:template>

<!--
 If this is here, Rstyle.xsl causes problems in Firefox when coming
 from omegahat.org in the 
       xsl:include href="defs.xsl"
  We have to use xsl:import
  But omitting this allows us to use xsl:include
-->

<xsl:template match="s:code|s:init">			       <!--|r:code|r:script|r:init|s:init -->
  <xsl:call-template name="code">
    <xsl:with-param name="class">S</xsl:with-param>
  </xsl:call-template>
</xsl:template>


<xsl:template match="c:code">
  <xsl:call-template name="code">
    <xsl:with-param name="class">C</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="env">
  <xsl:call-template name="var">
    <xsl:with-param name="class">env</xsl:with-param>
  </xsl:call-template>
</xsl:template>


<xsl:template match="vb:var">
  <xsl:call-template name="var">
    <xsl:with-param name="class">VisualBasic</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="vb:type">
  <xsl:call-template name="type">
    <xsl:with-param name="class">VisualBasic</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="c:type">
  <xsl:call-template name="type">
    <xsl:with-param name="class">C</xsl:with-param>
  </xsl:call-template>
</xsl:template>


<xsl:template match="c:keyword">
  <xsl:call-template name="keyword">
    <xsl:with-param name="class">c</xsl:with-param>
  </xsl:call-template>
</xsl:template>


<xsl:template match="NA|s:NA|s:na">
 <b>NA</b>
</xsl:template>

<xsl:template match="r:na|r:NA">
 <b><a href="library/base/html/NA.html">NA</a></b>
</xsl:template>

<xsl:template match="NaN">
 <b>NaN</b>
</xsl:template>


<xsl:template match="acknowledgments">
 <h2>Acknowledgements</h2>
 <xsl:apply-templates />
</xsl:template>


</xsl:stylesheet>
