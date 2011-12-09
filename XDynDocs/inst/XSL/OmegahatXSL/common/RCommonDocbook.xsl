<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:r="http://www.r-project.org"
                xmlns:s="http://cm.bell-labs.com/stat/S4"
                xmlns:omg="http://www.omegahat.org"
                xmlns:rwx="http://www.omegahat.org/RwxWidgets"
                xmlns:make="http://www.make.org"
                xmlns:sh="http://www.shell.org"
		xmlns:c="http://www.C.org"
		xmlns:cpp="http://www.cplusplus.org"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:ltx="http://www.latex.org"
		xmlns:html="http://www.w3.org/TR/html401"
                extension-element-prefixes="r"
                version='1.0'>

<!-- <xsl:import href="level.xsl"/> -->


<xsl:param name="r-inline-code-refs" select="0"/>

<!--??? Do we want these for HTML? We should use CSS. -->
<xsl:param name="r.error.color">#54ff9f</xsl:param>

<xsl:param name="r.code.background.color">#C0C0C0</xsl:param>
<xsl:param name="r.code.color">#FFF8DC</xsl:param>	       <!--7000FF-->

<xsl:param name="r.var.background.color">#ffffffff</xsl:param>
<xsl:param name="r.var.color">#888888</xsl:param>

<xsl:param name="r.arg.background.color">#ffffffff</xsl:param>
<xsl:param name="r.arg.color">#ff0000</xsl:param>

<xsl:param name="r.pkg.background.color">#ffffffff</xsl:param>
<xsl:param name="r.pkg.color">#888888</xsl:param>

<xsl:param name="r.func.background.color">#ffffffff</xsl:param>
<xsl:param name="r.func.color">#0000ff</xsl:param>

<xsl:param name="program.code.color">#e0e0e0</xsl:param>
<xsl:param name="r.output.code.color">#54ff9f</xsl:param>
<xsl:param name="r.warning.color">#54ff9f</xsl:param>
<xsl:param name="shell.code.color">#54ff9f</xsl:param>
<xsl:param name="omg.package.color">blue</xsl:param>
<xsl:param name="fo.code.color">red</xsl:param>


<!-- This is a boolean value that controls whether the show elements within r:code, etc. elements
are displayed (the default) or the actual code that is run but not originally intended to be displayed
itself.-->
<xsl:param name="r-show-do-code" select="0"/>

<xsl:template match="garbage" />

<xsl:template match="keywords"/>

<xsl:template match="fixed"/>

<xsl:template match="implement"/>


<xsl:template match="docbook">DocBook</xsl:template>
<xsl:template match="perl"><proglang>PERL</proglang></xsl:template>
<xsl:template match="json"><proglang>JSON</proglang></xsl:template>
<xsl:template match="word">Microsoft Word</xsl:template>

<xsl:template match="comment">
<xsl:if test="$show.comments">
  <xsl:apply-imports />
</xsl:if>
</xsl:template>



<!-- Move to FO and HTML and make "verbatim" -->
<xsl:template match="r:globalAssign">&lt;&lt;-</xsl:template>

<!-- Perhaps make this dependent on draft? -->
<xsl:template match="verify|db:fixme" />

<xsl:template match="fixme">
  <xsl:apply-templates select="./*[name() != 'solved']" />
</xsl:template>

<!-- <xsl:template match="fixme/solved" /> -->

  <!-- don't display r:code, r:plot, etc. that have an @show = 'false'  -->
<xsl:template match="r:code[@show='false']|r:plot[@show='false']|r:init[@show='false']|r:frag[@show='false']" /> 

<xsl:template match="invisible|ignore" />

<xsl:template match="note[@status='done']" />

<xsl:template match="ltx:literal|html:literal|fo:literal|db:literal"/>


  <!-- XXX Need to handle recursive <r:code @ref=''>  Done? -->
<xsl:template match="r:code[@ref]|r:plot[@ref]" mode="reference">
 <xsl:variable name="ref" select="@ref"/>
 <xsl:apply-templates select="//*[@id=$ref]" mode="reference"/>
</xsl:template>


<xsl:template match="r:code[./do]|r:init[./do]|r:test[./do]|r:plot[./do]|r:command[./do]">
  <!--  either the <do> or the <show> nodes -->
  <xsl:if test="$r-show-do-code">
    <xsl:apply-templates select="do"/>
  </xsl:if>
  <xsl:if test="not($r-show-do-code)">
    <xsl:apply-templates select="show"/>
  </xsl:if>

 <xsl:apply-templates select="r:output"/>
</xsl:template>

  <!--  -->
<xsl:template match="r:code/show|r:init/show|r:test/show|r:plot/show|r:commands/show|r:command/show">
 <xsl:call-template name="makeVerbatimCode"/>
</xsl:template>


<xsl:template match="r:code/do|r:init/do|r:test/do|r:plot/do">
 <xsl:call-template name="makeVerbatimCode"/>
</xsl:template>

<xsl:template match="r:remove|r:rm"/>

<xsl:template match="r:noeval">
<xsl:apply-templates/>
</xsl:template>


<xsl:template name="formatRCode">
 <xsl:choose>
 <xsl:when test="function-available('r:call')">
   <xsl:choose>
     <xsl:when test="function-available('r:formatCode')">
       <xsl:value-of select="r:formatCode(.)"/>
     </xsl:when>
     <xsl:otherwise>
       <xsl:value-of select="r:call('formatCode', .)"/>
     </xsl:otherwise>
   </xsl:choose>
 </xsl:when>
 <xsl:otherwise>
   <xsl:apply-templates select="text()"/>
 </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="acronymDef"><xsl:apply-templates/></xsl:template>


<xsl:template match="section/topics"/>


<xsl:template match="sed">sed</xsl:template>
<xsl:template match="awk">awk</xsl:template>

<xsl:template match="dtl"/>

</xsl:stylesheet>
