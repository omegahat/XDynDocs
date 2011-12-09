<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:r="http://www.r-project.org"
                xmlns:s="http://cm.bell-labs.com/stat/S4"
                xmlns:omg="http://www.omegahat.org"
                xmlns:rwx="http://www.omegahat.org/RwxWidgets"
                xmlns:make="http://www.make.org"
                xmlns:sh="http://www.shell.org"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                extension-element-prefixes="r"
                exclude-result-prefixes="r s rwx fo sh omg make xsl"
                version='1.0'>


<xsl:param name="level" select="'1'" />

<xsl:template match="//*[@level]">
 <xsl:if test="@level &lt; $level">
  <xsl:copy select="name(.)">
   <xsl:apply-templates select="@*"/>
   <xsl:apply-templates />
  </xsl:copy>  
 </xsl:if>
</xsl:template>

<xsl:template match="*">
 <xsl:copy select="name(.)">
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates />   
 </xsl:copy>
</xsl:template>

<xsl:template match="@*">
 <xsl:copy-of select="."/>
</xsl:template>

</xsl:stylesheet>
