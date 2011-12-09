<?xml version='1.0'?>
<!-- 
 This is used for converting our XML file into FO
 and doing the R computations on the fly while this is being
 processed.

 What about Rfo.xsl in org/omegahat/Docs/XSL/fo ?

 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:r="http://www.r-project.org"
                xmlns:s="http://cm.bell-labs.com/stat/S4"
                xmlns:omg="http://www.omegahat.org"
                xmlns:rwx="http://www.omegahat.org/RwxWidgets"
                xmlns:make="http://www.make.org"
                xmlns:sh="http://www.shell.org"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:exslt="http://exslt.org/common" 
                extension-element-prefixes="r"
                exclude-result-prefixes="r s rwx fo sh omg make xsl exslt"
                version='1.0'>

<xsl:import href="http://docbook.sourceforge.net/release/xsl/current/fo/docbook.xsl"/>

<xsl:import href="http://www.omegahat.org/XSL/fo/c.xsl"/>
<xsl:import href="http://www.omegahat.org/XSL/fo/shell.xsl"/>
<xsl:import href="http://www.omegahat.org/XSL/fo/Rtemplates.xsl" /> 
<!-- <xsl:import href="http://www.omegahat.org/XSL/fo/Rstyle.xsl" /> -->
<xsl:import href="http://www.omegahat.org/XSL/fo/xml.xsl" />

<xsl:import href="http://www.omegahat.org/XSL/fo/Rfo.xsl" />

<xsl:import href="dynamic.xsl"/>
<xsl:import href="noInteractive.xsl"/>

<xsl:import href="dynParams.xsl"/>
<xsl:param name="targetFormat">FO</xsl:param>

<xsl:output indent="yes"/>


<!-- Use the one from the import.-->
<xsl:template name="unused.makeVerbatimCode">
 <xsl:param name="color">#f0ffff</xsl:param>
 <xsl:element name="fo:block">
  <xsl:attribute name="background-color"><xsl:value-of select="$color"/></xsl:attribute>
  <xsl:attribute name="space-before">5pt</xsl:attribute>
  <xsl:attribute name="space-after">2pt</xsl:attribute>

  <xsl:if test="@size">
    <xsl:attribute name="font-size"><xsl:value-of select="@size" /></xsl:attribute>
  </xsl:if>

 <fo:block hyphenate="false" font-family="monospace" text-align="start" 
         wrap-option="no-wrap" linefeed-treatment="preserve" white-space-treatment="preserve" 
          white-space-collapse="false">  
   <xsl:choose>
     <xsl:when test="@notrim">
        <xsl:apply-templates />
     </xsl:when>
     <xsl:otherwise>
        <xsl:call-template name="trim-left"><xsl:with-param name="contents" select="./text()"/></xsl:call-template>
     </xsl:otherwise>
   </xsl:choose>
<!--
   <xsl:if test="$runCode">
      <xsl:apply-imports/> 
   </xsl:if>
-->
 </fo:block>
 </xsl:element>
</xsl:template>

<xsl:template match="r:value" />

<!-- Display R code that is not mean for evaluation.  -->
<xsl:template match="programlisting[@lang='r' or @lang='R']">
   <xsl:call-template name="makeVerbatimCode">
      <xsl:with-param name="color">#f0ffee</xsl:with-param>
   </xsl:call-template>
</xsl:template>

<xsl:template match="r:commands">
 <fo:block hyphenate="false" font-family="monospace" text-align="start" 
         wrap-option="no-wrap" linefeed-treatment="preserve" white-space-treatment="preserve" 
          white-space-collapse="false" background-color="#f0ffee">  
     <xsl:apply-imports/>  
 </fo:block>
</xsl:template>

<xsl:template match="r:code|r:function|r:test|r:init">
  <xsl:if test="($showCode or @showCode='true') and not(@showCode = 'false')">
    <xsl:call-template name="makeVerbatimCode">
      <xsl:with-param name="color">#f0ffee</xsl:with-param>
    </xsl:call-template>
  </xsl:if>
<!--  <xsl:if test="runCode"></xsl:if> -->
<!-- 
 <fo:block hyphenate="false" font-family="monospace" text-align="start" 
         wrap-option="no-wrap" linefeed-treatment="preserve" white-space-treatment="preserve" 
          white-space-collapse="false">  

 </fo:block>
-->
     <xsl:apply-imports/>  
</xsl:template>

<xsl:template match="invisible">
<xsl:comment>
 <xsl:apply-templates />
</xsl:comment>
</xsl:template>


<xsl:template match="r:plot">
 <xsl:if test="($showCode or @showCode='true') and not(@showCode='false')">
    <xsl:call-template name="makeVerbatimCode">
      <xsl:with-param name="color"><xsl:value-of select="$r.code.color"/></xsl:with-param>
    </xsl:call-template>
 </xsl:if>

 <xsl:if test="not($runCode)">
           <!--  Potentially a broken image, but that's okay! ??? -->
    <fo:external-graphic>
      <xsl:attribute name="src">url(<xsl:choose><xsl:when test="@originalFile"><xsl:value-of select="@originalFile"/></xsl:when>
                                           <xsl:otherwise><xsl:value-of select="@file"/></xsl:otherwise>
                                </xsl:choose>)</xsl:attribute>
    </fo:external-graphic>
 </xsl:if>

 <xsl:if test="$runCode and $runPlots and not(@eval='no' or @eval='false')">
     <xsl:if test="function-available('r:graphicsEval')">
<xsl:message>XXX</xsl:message>
       <xsl:variable name="ans" select="r:graphicsEval(., string($imageDir), string($targetFormat))"/>
<xsl:message>plot node -> <xsl:value-of select="$ans"/>, <xsl:value-of select="exslt:object-type($ans)"/></xsl:message>
       <xsl:if test="not(exslt:object-type($ans) = 'node-set' and count($ans) = 0) and not(exslt:object-type($ans) = 'string' and $ans = '')">
<fo:block>
       <fo:external-graphic>
	 <xsl:attribute name="src">url(<xsl:value-of select="$ans"/>)</xsl:attribute>
       </fo:external-graphic>
</fo:block>
       </xsl:if>
     </xsl:if>
 </xsl:if>
</xsl:template>


<xsl:template match="r:expr">
  <xsl:if test="($showExpressionCode or @showCode='true') and not(@showCode='false')">
    (<xsl:call-template name="r-expression"/>)<xsl:text> </xsl:text>
  </xsl:if>
  <fo:inline><xsl:apply-imports /></fo:inline>
</xsl:template>



<xsl:template match="s:var|r:var">
  <xsl:call-template name="r-var"/>
</xsl:template>


<xsl:template match="r:func|s:func">
 <xsl:call-template name="inline.italicmonoseq"><xsl:with-param name="contents"><xsl:apply-templates/>()</xsl:with-param></xsl:call-template>
</xsl:template>

<xsl:template match="r:package|r:pkg">
<xsl:call-template name="inline.italicmonoseq"/>
</xsl:template>



<!--<fo:inline font-family="Courier" font-style="oblique"><xsl:apply-templates/></fo:inline>-->
<!--  <fo:inline font-type="italic" font-family="monospace"><xsl:apply-templates/></fo:inline> -->

<xsl:template match="dots">...</xsl:template>

<xsl:template match="sh:code">
 <xsl:if test="($showCode or @showCode='true') and (@showCode and not(@showCode = 'false'))">
   <xsl:call-template name="makeVerbatimCode">
     <xsl:with-param name="color">#dcdcdc</xsl:with-param>
     <xsl:with-param name="format" select="0"/>
   </xsl:call-template>
  </xsl:if>

 <xsl:if test="$runCode">
  <fo:block hyphenate="false" font-family="monospace" text-align="start" 
         wrap-option="no-wrap" linefeed-treatment="preserve" white-space-treatment="preserve"
          white-space-collapse="false"
          space-before="5pt" space-after="2pt"
          background-color="#dcdcdc"
        >
    <xsl:copy-of select="r:call('system', string(.), boolean(1))"/>
  </fo:block>
 </xsl:if>
</xsl:template>


<xsl:template match="make:code">
 <xsl:call-template name="makeVerbatimCode">
  <xsl:with-param name="color">#f0e68c</xsl:with-param>
 </xsl:call-template>
</xsl:template>


<xsl:template match="latex">LaTeX</xsl:template>

<xsl:template match="ignore"/>

<!-- If we want to put a hyperlink to a particular Web site URL, we can do this with
    -->
<xsl:template match="omg:func[@pkg]" name="omg:func">
<xsl:call-template name="ulink"><xsl:with-param name="url">http://www.omegahat.org/<xsl:value-of select="string(@pkg)"/>/<xsl:value-of select="string(.)"/>.html</xsl:with-param></xsl:call-template>
</xsl:template>

<xsl:template match="omg:func[@url]">
<xsl:call-template name="ulink" ><xsl:with-param name="url">http://www.omegahat.org/<xsl:value-of select="string(@url)"/>/<xsl:value-of select="string(.)"/>.html</xsl:with-param></xsl:call-template>
</xsl:template>

<xsl:template match="omg:package">
<xsl:call-template name="ulink" ><xsl:with-param name="url">http://www.omegahat.org/<xsl:value-of select="string(.)"/></xsl:with-param></xsl:call-template>
</xsl:template>

<xsl:template match="omg:package[@url]">
<xsl:call-template name="ulink" ><xsl:with-param name="url">http://www.omegahat.org/<xsl:value-of select="string(@url)"/></xsl:with-param></xsl:call-template>
</xsl:template>

<xsl:template match="rwx:func">
<xsl:call-template name="ulink" ><xsl:with-param name="url">http://www.omegahat.org/RwxWidgets/<xsl:value-of select="string(.)"/>.html</xsl:with-param></xsl:call-template>
</xsl:template>

<xsl:template match="r:class">
 <fo:inline color="blue"><xsl:call-template name="inline.monoseq"/></fo:inline>
</xsl:template>


<!-- catch all for the r: nodes.
<xsl:template match="r:*">\<xsl:value-of select="name(.)"/>{<xsl:apply-templates />}</xsl:template>
 -->


<xsl:template match="invocation|r:run" name="postamble">
 <fo:block background-color='lightgray' border='solid' hyphenate="false" font-family="monospace" text-align="start" 
           wrap-option="no-wrap" linefeed-treatment="preserve" white-space-treatment="preserve"
           white-space-collapse="false">
 <xsl:choose>
  <xsl:when test="not($invocation = '')">
    <xsl:copy-of select="$invocation" />
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates />
  </xsl:otherwise>
 </xsl:choose>
  </fo:block>
</xsl:template>


<xsl:template name="end.content">
  <xsl:copy-of select="r:parseEval('sessionInfo()')"/>	       <!-- should be r:call('sessionInfo') but we need to have the conversion done!-->
</xsl:template>

<xsl:template name="sessionInfo">

<fo:page-sequence hyphenate="true" master-reference="body" format="1">
 <fo:static-content flow-name="xsl-region-before-first">
  <xsl:copy-of select="r:parseEval('sessionInfo()')"/>	       <!-- should be r:call('sessionInfo') but we need to have the conversion done!-->
 </fo:static-content>
</fo:page-sequence>

</xsl:template>

</xsl:stylesheet>
