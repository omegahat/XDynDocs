<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:r="http://www.r-project.org"
                xmlns:omg="http://www.omegahat.org"
                xmlns:rwx="http://www.omegahat.org/RwxWidgets"
                xmlns:make="http://www.make.org"
                xmlns:sh="http://www.shell.org"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:s="http://www.cm.bell-labs.com/stat/S4"
                extension-element-prefixes="r"		
                version='1.0'>

<!-- Basically, we want to copy the entire document but process the r:code, r:plot, r:expr nodes -->

<xsl:import href="dynParams.xsl" />
<xsl:import href="dynamic.xsl" />


<xsl:template match="/">
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="@*|node()|text()">
 <xsl:copy>
   <xsl:apply-templates/>
 </xsl:copy>
</xsl:template>

<xsl:template match="r:function">
 <xsl:if test="$showCode and not(@showCode = 'false')"><xsl:copy-of select="."/></xsl:if>
 <xsl:apply-imports />
</xsl:template>

<xsl:template match="r:code">
 <xsl:if test="$showCode and not(@showCode = 'false')"><xsl:copy-of select="."/></xsl:if>
 <xsl:apply-imports />
</xsl:template>

<xsl:template match="r:plot">
 <xsl:if test="$showCode and not(@showCode = 'false')"><xsl:copy-of select="."/></xsl:if>
 <xsl:apply-imports />
</xsl:template>


<xsl:template match="r:expr">
  <xsl:apply-imports />
</xsl:template>

</xsl:stylesheet>
