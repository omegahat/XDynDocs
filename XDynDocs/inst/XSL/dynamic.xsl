<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:r="http://www.r-project.org"
                xmlns:omg="http://www.omegahat.org"
                xmlns:rwx="http://www.omegahat.org/RwxWidgets"
                xmlns:make="http://www.make.org"
                xmlns:sh="http://www.shell.org"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:s="http://www.cm.bell-labs.com/stat/S4"
                version='1.0'>

<xsl:param name="r:verbose" select="1" />
<xsl:param name="targetFormat" select="HTML" />
<xsl:param name="runCode" select="1"/>
<xsl:param name="imageDir" select="."/>
<xsl:param name="showCode" select="0"/>
<xsl:param name="runPlots" select="1"/>
<xsl:param name="add.r.session.info" select="1"/>

<xsl:param name="r:prompt" select="'R>'"/>

<!-- Whether to use embedded data within  -->
<xsl:param name="use.existing.data" select="1" />

<xsl:template match="/article">
 <xsl:apply-imports/>
 <xsl:if test="add.r.session.info">
    <xsl:call-template name="sessionInfo"/>
 </xsl:if>
</xsl:template>


<xsl:template name="startR">
 <xsl:if test="function-available('r:init')">
  <xsl:if test="r:init()">
   <xsl:if test="r:library('StatDocs')"/>
  </xsl:if>
 </xsl:if>
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="r:invisible">
  <xsl:if test="$runCode and r:voidEval(.)"/>			       <!-- get just the text pieces. -->
</xsl:template>


<!-- We can have a generic eval() function in R that will figure out what to do
     based on the node type. But then we lose some control. But it doesn't hurt to 
     provide it and allow people to call it or by-pass it.
 -->

<!-- function, code, plot and expr -->

  <!-- Evaluate the r:code blocks in R and put the results back 
       into the target document. -->
<xsl:template match="r:code|r:test" name="r-code">
 <xsl:if test="$runCode and not(@eval='false') and function-available('r:evalNode') and not(ancestor::r:noeval)">
   <xsl:variable name="value"><xsl:copy-of select="r:evalNode(., string($targetFormat))"/></xsl:variable>
   <xsl:if test="not(@showOutput) or @showOutput != 'false'">
     <xsl:copy-of select="$value"/>  
   </xsl:if>
 </xsl:if>
</xsl:template>


<!-- r:code with an r:value attribute which refers to another node somewhere in the document. -->
<xsl:template match="r:code[@r:value and not(@eval = 'false') and not(ancestor::r:noeval)]">
 <xsl:choose>
  <xsl:when test="$use.existing.data">  
  <xsl:variable name="name" select="@r:value"/>
   <xsl:if test="$runCode and r:dynamicData(//r:value[@r:id=$name], string($targetFormat))" /> 
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="r-code"/>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<!-- r:code node with an r:value node within it. -->
<xsl:template match="r:code[./r:value and not(@eval = 'false')]">
 <xsl:choose>
  <xsl:when test="$use.existing.data">  
   <xsl:if test="$runCode and r:dynamicData(./r:value)" />   <!-- XX Can't do a r:call('dynamicData', ....) as that doesn't get the context! -->
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="r-code"/>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>



<xsl:template match="r:function">
  <xsl:if test="function-available('r:voidEval') and r:voidEval(.)"/>       <!--ignore the result -->
</xsl:template>

<xsl:template match="r:expr">
 <xsl:if test="$runCode and not(@eval='false') and function-available('r:envEval')">
   <xsl:value-of select="r:envEval(., string($targetFormat))"/>  
 </xsl:if>
</xsl:template>


<xsl:template match="r:init">
 <!-- <xsl:message>r:init  <xsl:if test="not(function-available('r:voidEval'))">voidEval not available</xsl:if></xsl:message> -->
 <xsl:if test="$runCode and function-available('r:voidEval')">
   <xsl:if test="r:voidEval(.)"/>  
 </xsl:if>
</xsl:template>

<!-- This probably won't be used as the return value is important
     and  needs to be inserted into the resulting text in a context-specific 
     manner. -->
<xsl:template match="r:plot">
 <xsl:if test="$runCode and $runPlots and not(@eval='false') and function-available('r:graphicsEval')">
   <xsl:value-of select="r:graphicsEval(., $imageDir, $targetFormat)"/>  
 </xsl:if>
</xsl:template>


<xsl:template match="r:dynOptions">
  <xsl:if test="$runCode and r:setOptions(., string($targetFormat))"/>
   <xsl:apply-templates />
  <xsl:if test="$runCode and r:popOptions()"/>
</xsl:template>


<xsl:template match="r:commands">
     <!--  called via xsl:apply-imports from html.xsl and dynRFO.xsl -->
  <xsl:if test="$runCode and r:evalExpressions(., string($targetFormat))"/>
</xsl:template>

<xsl:template match="r:sessionInfo">
 <xsl:value-of select="r:eval('sessionInfo()')" />
</xsl:template>


<xsl:param name="foo" select="xyz"/>

<xsl:template match="r:rm|r:remove">
 <xsl:if test="$runCode and function-available('r:removeVariables') and r:removeVariables(.)"/>
<!-- testing  <xsl:if test="count(.) > 0 and number($foo) = 1"><xsl:message>Okay</xsl:message></xsl:if> -->
 <xsl:apply-imports/>
</xsl:template>

<!-- Not reached since . See above.  -->
<!--
<xsl:template match="r:data|r:object|r:value" name="dynamicData">
<xsl:message> Dealing with dynamicData</xsl:message>
 <xsl:if test="$use-existing-data">  
   <xsl:if test="r:dynamicData(.)" />
 </xsl:if>
</xsl:template>
-->

</xsl:stylesheet>
