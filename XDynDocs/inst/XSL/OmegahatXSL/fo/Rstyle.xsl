<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:r="http://www.r-project.org"
		xmlns:s="http://cm.bell-labs.com/stat/S4"
		xmlns:gtk="http://www.gtk.org"
		xmlns:statdocs="http://www.statdocs.org"
                xmlns:python="http://www.python.org"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:omg="http://www.omegahat.org"
                exclude-result-prefixes="r fo python s gtk statdocs omg"
                version="1.0" >

<!-- Use 'chunk.xsl' in line below to chunk files. -->
<xsl:import href="http://docbook.sourceforge.net/release/xsl/current/fo/docbook.xsl"/>
<!--<xsl:import href="../html/defs.xsl"/>-->			       <!-- XXX Need to separate this. -->

<xsl:param name="html.stylesheet" select="'S.css'" type='string'/> <!--doc:type -->
<!-- Turn this off for now. Need it for book -->
<!-- <xsl:param name="generate.toc" select="0" type='int'/>  -->

<xsl:template match="directory">
 <xsl:apply-templates/>/
</xsl:template>


<!-- We should not have to specify the [not(show)].  It works for the HTML. But
     there may be something about the fact this is defined within the top-level XSL file and not imported, 
     or somehow this is overriding our more specific version in common/RCommonDocbook.xsl 
     Yep. Moving it to Rstyle.xsl works just fine.-->

<xsl:template match="r:init|r:code|r:function|r:frag|r:test|r:commands|s:code|s:function" name="makeVerbatimCode">

 <xsl:param name="color">#f0ffff</xsl:param>
 <xsl:param name="format" select="1"/>
 <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>

 <xsl:element name="fo:block">
  <xsl:attribute name="background-color"><xsl:value-of select="$color"/></xsl:attribute>
  <xsl:attribute name="space-before">5pt</xsl:attribute>
  <xsl:attribute name="space-after">2pt</xsl:attribute>

<!--
  Why do we want this label to appear?
    Put this on the same line as the  links to code nodes that use this, but have this on the left and those on the right.
         e.g. use a blank leader 
  <xsl:if test="@id">
   <fo:block><fo:inline color="#008800"><xsl:value-of select="@id"></xsl:value-of></fo:inline></fo:block>
  </xsl:if>
-->
 
  <!-- Put links to the containers of any r:code block with a @ref to this code block etc.  -->
  <xsl:if test="@id and count(//r:code[@ref=$id])"> 
<xsl:message><xsl:value-of select="$id"/> used in other <xsl:value-of select="count(//r:code[@ref=$id])"/> r:code blocks</xsl:message>
              <!-- Put a box around this but have it just big enough to contain the links. -->
    <fo:block text-align="right">
      <fo:inline>
	<xsl:for-each select="//r:code[@ref=$id]">
	  <fo:basic-link color="green"><xsl:attribute name="internal-destination"><xsl:value-of select="../@id"/></xsl:attribute>
	  <xsl:value-of select="../@id"/>
	  </fo:basic-link><xsl:if test="position() != last()">, </xsl:if><!--<xsl:text> </xsl:text>-->
	</xsl:for-each>
      </fo:inline>
    </fo:block>
  </xsl:if>

 
  <!--  Now get on with displaying the code.  -->
  <!-- Put a label describing the language. -->
<!-- <fo:block text-align="right">R</fo:block> -->
 <fo:block hyphenate="false" font-family="monospace" text-align="start" 
           wrap-option="no-wrap" linefeed-treatment="preserve" white-space-treatment="preserve" 
           white-space-collapse="false"> 

  <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
   <xsl:choose>
     <!-- XXX add the not(*=text()) back -->
     <xsl:when test="@notrim or count(./r:code[@ref]) > 0"><!-- or not(*=text())  Check if there are sub nodes that aren't text, e.g r:output -->
       <xsl:apply-templates /> 
     </xsl:when>
     <xsl:otherwise>
       <xsl:choose>
         <xsl:when test="$format and function-available('r:call')">
          <xsl:call-template name="formatRCode"/><xsl:text>&#10;</xsl:text>
	 </xsl:when>
         <xsl:otherwise>
	   <xsl:call-template name="trim-left"><xsl:with-param name="contents" select="."/></xsl:call-template>
	 </xsl:otherwise>
       </xsl:choose>
     </xsl:otherwise>
   </xsl:choose>
<!--  Is this producing the name of the SVG file in the output in FO/PDF?
   <xsl:if test="$runCode">
      <xsl:apply-imports/> 
   </xsl:if>
-->
  </fo:block>
 
 </xsl:element>
</xsl:template>




<xsl:param name="r.option.color">#54ff9f</xsl:param>

<xsl:template match="r:option|r:opt">
  <fo:inline color="{$r.option.color}" font-weight="italic">  
    <xsl:apply-templates />  
  </fo:inline>
</xsl:template>

<xsl:template match="r:func">
  <xsl:call-template name="xref"/>
</xsl:template>

<!-- Some "constants"  -->
<xsl:template match="docbook">
<xsl:text>DocBook</xsl:text>
</xsl:template>

<xsl:template match="unix">
<xsl:text>UNIX</xsl:text>
<xsl:call-template name="inline.charseq"/><xsl:call-template name="dingbat"><xsl:with-param name="dingbat" select="'registered'"/></xsl:call-template>
</xsl:template>

<xsl:template match="omegahat">
<xsl:text>Omegahat</xsl:text>
</xsl:template>

<!-- XXXX this is HTML -->


<xsl:template match="r" name="R.ref">
<fo:basic-link>
   <xsl:attribute name="external-destination">http://www.r-project.org</xsl:attribute>
R
</fo:basic-link>
</xsl:template>


<xsl:template name="code">
<fo:block wrap-option='no-wrap'
                white-space-collapse='false'
                linefeed-treatment="preserve"
                xsl:use-attribute-sets="monospace.verbatim.properties shade.verbatim.style">
  <xsl:value-of select="."/>
</fo:block>
</xsl:template>


<xsl:template match="python:code">
 <xsl:apply-templates />
</xsl:template>

<xsl:template match="invisible"/>



<xsl:template match="omg:package">
 <fo:basic-link>
   <xsl:attribute name="external-destination">www.omegahat.org/<xsl:value-of select="."/></xsl:attribute>
    <xsl:apply-templates />
  </fo:basic-link>
</xsl:template>

<xsl:template match="statdocs:package">
 <fo:basic-link>
   <xsl:attribute name="external-destination">www.statdocs.org/<xsl:value-of select="."/></xsl:attribute>
    <xsl:apply-templates />
  </fo:basic-link>
</xsl:template>

<xsl:template match="br">
</xsl:template>

<xsl:template match="xml:element">
 <xsl:apply-templates />
</xsl:template>

<xsl:template match="xml:attribute">
 <fo:inline font-weight="bold">
   <xsl:apply-templates />
 </fo:inline>
</xsl:template>

<xsl:template match="gtk:widget">
 <fo:basic-link>
   <xsl:attribute name="external-destination">
				  <!-- Change this to lower case -->
      http://developer.gnome.org/doc/API/gtk/<xsl:value-of select="."/>.html
    </xsl:attribute>
 <fo:inline background-color="red" font-style="italic">
  <xsl:apply-templates />
 </fo:inline>
</fo:basic-link>
</xsl:template>



<xsl:template match="gtk:signal">
 <fo:inline background-color="red" font-weight="bold">
  <xsl:apply-templates />
 </fo:inline>
</xsl:template>

<xsl:template match="r:help">
<fo:inline font-weight="bold">?<xsl:apply-templates/></fo:inline>
</xsl:template>

<xsl:template match="s:func">
 <fo:inline background-color="green" font-style="italic">
  <xsl:apply-templates />()
 </fo:inline>
</xsl:template>

<xsl:template name="expression">
 <xsl:param name="color">#e6e6fa</xsl:param>
 <fo:inline color="{string($color)}" xsl:use-attribute-sets="monospace.verbatim.properties">
  <xsl:apply-templates />
 </fo:inline>
</xsl:template>

<xsl:template match="dir">
 <fo:inline font-weight="bold"><xsl:apply-templates>/</xsl:apply-templates></fo:inline>
</xsl:template>

<xsl:template match="file">
 <fo:inline font-family="italic"><xsl:apply-templates /></fo:inline>
</xsl:template>


<xsl:template match="s:keyword|r:keyword">
  <fo:inline color="#ff0000" 
             font-weight="bold"
             xsl:use-attribute-sets="monospace.verbatim.properties">
    <xsl:apply-templates />
 </fo:inline>
</xsl:template>


<xsl:template match="fo:literal">
 <xsl:copy-of select="."/>
</xsl:template>

</xsl:stylesheet>
