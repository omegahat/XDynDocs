<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
		xmlns:r="http://www.r-project.org"
                extension-element-prefixes="r">


<xsl:param name="invocation"/>				       <!-- HTML equivalent in OmegahatXSL/html/Rsource.xsl for some reason -->

<xsl:param name="runCode" select="1"/>
<xsl:param name="imageDir" select="/tmp"/>
<xsl:param name="showCode" select="1" type="boolean" as="xs:boolean"></xsl:param>
<xsl:param name="showExpressionCode" select="0" type="boolean"></xsl:param>
<!-- -->


<!-- Common material - i.e. common to FO, HTML, Docbook output -->


<!-- Entry template that loads any data and then processes the article using the regular
     top-level templates.  -->
<xsl:template match="/">

  <xsl:choose>
    <xsl:when test="count(//r:data[@ref]) = 0">
       <xsl:apply-templates select="//r:dataArchive" mode="autoload"/>
    </xsl:when>
    <xsl:otherwise>
       <!-- <xsl:message>processing r:data[@autoload]  <xsl:value-of select="count(//r:data[@autoload='true'])"/></xsl:message> -->
      <xsl:apply-templates select="//r:data[@autoload='true']" mode="autoload"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-imports/>

</xsl:template>


<!-- Process a r:data[@ref='id'] to load the entry into R. -->
<xsl:template match="r:data[@ref]">
 <xsl:param name="id" select="@ref"/>
<!-- <xsl:message>processing r:data[@ref] <xsl:value-of select="$id"/></xsl:message> -->
 <xsl:if test="r:dynamicData(//r:data[@r:id = $id])"/>
</xsl:template>

<xsl:template match="r:data" mode="autoload">
<xsl:message>processing r:data <xsl:value-of select="@r:id"/></xsl:message>
   <!-- If we call r:call('dynamicData', .) we get the context passed in because we have explicitly made that
        function an XSLTContextFunction. -->
   <xsl:if test="r:dynamicData(.)"/> 
</xsl:template>

<xsl:template match="r:dataArchive" mode="autoload">	       <!--If we don't put an autload mode here, we process it twice.-->
 <xsl:apply-templates mode="autoload"/>
</xsl:template>



</xsl:stylesheet>

