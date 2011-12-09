<?xml version="1.0" ?>

<!-- Copyright the Omegahat Project for Statistical Computing, 2000 -->
<!-- Author: Duncan Temple Lang -->

<xsl:stylesheet
            xmlns:bib="http://www.bibliography.org"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
            exclude-result-prefixes="bib"
            version="1.0"
         >

<!-- The alan XSLT does not emit the terminating li in this template,
     but it does require it here. One can try using xsl:element name="li"
     to force the terminating li tag, but it still won't happen. Change
     the name of the tag and all is well. So Alan is watching for li tags!
  -->
<xsl:template match="bibitem">
  <li>
     <xsl:apply-templates /> 
  </li>
</xsl:template>

<xsl:template match="bib:book">
  <li>
     <xsl:apply-templates select="bib:title" />, 
     <xsl:apply-templates select="bib:authors" />,
     <xsl:apply-templates select="bib:year" />  
  </li>
</xsl:template>

<xsl:template match="bib:urlItem">
  <li>
     <xsl:apply-templates select="bib:title" />, 
     <xsl:apply-templates select="url" />
     Valid on: <xsl:apply-templates select="date" />  
  </li>
</xsl:template>



<xsl:template match="bib:title">
 <i><xsl:apply-templates /></i>
</xsl:template>

<!-- Need to put comma separators in here.  -->
<xsl:template match="bib:authors">
 <xsl:apply-templates select="author" mode="bib" />
 <xsl:if test = "not(position()=last())" > 
        <xsl:text >, </xsl:text> 
    </xsl:if> 
</xsl:template>

<xsl:template match="author" mode="bib" >
 <xsl:apply-templates />
</xsl:template>

</xsl:stylesheet>



