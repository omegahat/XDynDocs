<?xml version='1.0'?>
<!--############################################################################# 
|	$Id: fo.xsl,v 1.7 2007/05/29 02:43:34 duncan Exp $
|- #############################################################################
|	$Author: duncan $												
|														
+ ############################################################################## -->
<!-- 
 This is used for converting our XML file into FO. From there
 we use an FO formatting application, e.g. Apache's FOP, to create the
 PDF/RTF/...
 -->
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
		xmlns:xi="http://www.w3.org/2003/XInclude"
		xmlns:mml="http://www.w3.org/1998/Math/MathML"
		xmlns:ltx="http://www.latex.org"
                extension-element-prefixes="r"
		exclude-result-prefixes="r s c sh cpp omg rwx make xi fo mml"
                version='1.0'>

<xsl:import href="http://docbook.sourceforge.net/release/xsl/current/fo/docbook.xsl"/>

<xsl:import href="http://www.omegahat.org/XDynDocs/XSL/dynamic.xsl"/>


<xsl:import href="Rstyle.xsl"/>
<xsl:import href="c.xsl"/>				       <!--If this goes before Rstyle.xsl, the templates for c:... aren't found-->
<xsl:import href="omg.xsl"/>
<xsl:import href="Rtemplates.xsl"/>


<xsl:import href="docbook.xsl"/>
<xsl:import href="xml.xsl"/>
<xsl:import href="xsl.xsl"/>
<xsl:import href="lisp.xsl"/>
        <!-- order is very important here. We lose the fixme and friends! -->
<xsl:import href="../common/RCommonDocbook.xsl"/>
<xsl:import href="shell.xsl"/>
<xsl:import href="make.xsl"/>



<xsl:import href="css.xsl"/>
<xsl:import href="html.xsl"/>

<xsl:import href="perl.xsl"/>
<xsl:import href="js.xsl"/>
<xsl:import href="wordml.xsl"/>
<xsl:import href="curl.xsl"/>
<xsl:import href="flash.xsl"/>

<xsl:import href="emacsLisp.xsl"/>
<xsl:import href="rest.xsl"/>


<xsl:import href="../common/no-latex.xsl" />
<xsl:import href="../common/no-html.xsl" />

<xsl:template match="query"/>

<xsl:template match="r">R</xsl:template>

<xsl:template match="chapter/summary">
 <fo:block border-style="solid" font-style="italic" 
     start-indent="3em" end-indent="3em">
  <fo:block text-align="center">
   <fo:inline font-size="20pt" font-family="Helvetica">Summary</fo:inline>
  </fo:block>
     <fo:block start-indent="3.5em" end-indent="3.5em">
      <xsl:apply-templates />
    </fo:block>
  </fo:block>
</xsl:template>

<xsl:template match="todo|reminder|wrong">
  <xsl:call-template name="nongraphical.admonition"/>
</xsl:template>

<xsl:template match="summary">
 <fo:block start-indent="20pt" end-indent="20pt" border="solid" padding-before="6pt" padding-after="60pt">
 <fo:block font-weight="bold" font-size="14pt">Summary</fo:block>  <xsl:text>&#160;</xsl:text>
   <xsl:apply-templates />
 </fo:block>
</xsl:template>

<!--
<xsl:template match="*">
<xsl:message> Caught <xsl:value-of select="name()"/>  <xsl:copy-of select="@*"/></xsl:message>
</xsl:template>
-->
<xsl:attribute-set name="formal.object.properties">
  <xsl:attribute name="keep-together.within-column">auto</xsl:attribute>
</xsl:attribute-set>

<xsl:template match="xi:include">
  <!-- Make the link local if it is local. Not http://randomWalk.svg -->
 (XInclude) <fo:basic-link external-destination="{@href}"><xsl:value-of select="@href"/><xsl:if test="@xpointer"><xsl:value-of select="@xpointer"/></xsl:if></fo:basic-link>
</xsl:template>



<xsl:template match="proglisting">
 <xsl:call-template name="makeVerbatimCode">
   <xsl:with-param name="color"><xsl:value-of select="$program.code.color"/></xsl:with-param>
 </xsl:call-template>
</xsl:template>

<xsl:param name="targetFormat">HTML</xsl:param>
<xsl:param name="runCode" select="0" />
<xsl:param name="showCode" select="1"/>
<!--
<xsl:param name="imageDir">Foo</xsl:param>
-->

<xsl:param name="title.margin.left">0pt</xsl:param>
<xsl:param name="body.start.indent">0pt</xsl:param>
<xsl:param name="start.indent">0pt</xsl:param>
<xsl:param name="body.font.master">11</xsl:param>


<xsl:output indent="yes" encoding='utf-8' />

<xsl:template match="r:question"/>

<xsl:template match="question">
 <fo:inline background-color="gray">
  <xsl:apply-templates/>
 </fo:inline>
</xsl:template>

<xsl:template match="invisible/r:code|invisible/r:function">
  <xsl:if test="r:eval(.)"/>
</xsl:template>

<xsl:template match="r:null|s:null">
<fo:inline font-family="monospace" font-weight="bold">NULL</fo:inline>
</xsl:template>

<xsl:template match="xml:node|xml:tag">
<fo:inline font-family="monospace" font-weight="bold">&lt;<xsl:apply-templates />&gt;</fo:inline>
</xsl:template>

<xsl:template match="xml:attr">
  <fo:inline font-family="monospace" font-weight="italic"><xsl:apply-templates /></fo:inline>
</xsl:template>


<xsl:template match="r:example">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="faq"/>



<xsl:template match="datalisting|data">
   <xsl:call-template name="makeVerbatimCode">
     <xsl:with-param name="color"></xsl:with-param>
   </xsl:call-template>
</xsl:template>


<xsl:template match="r:value|r:object|r:data" />

<xsl:template match="ignore" />
<xsl:template match="invisible">
  <!-- XXX evaluate the code -->
</xsl:template>

<xsl:template match="verify">
<xsl:text>&#0191;</xsl:text><xsl:apply-templates/>?
</xsl:template>

<xsl:template match="r:code/r:output|r:test/r:output">
 <xsl:if test="not($runCode)">
  <xsl:call-template name="r-output"/>
 </xsl:if>
</xsl:template>


<xsl:template match="r:output" name="r-output">
  <xsl:call-template name="makeVerbatimCode">
    <xsl:with-param name="color"><xsl:value-of select="$r.output.code.color"/></xsl:with-param>	       <!--sea green -->
    <xsl:with-param name="format" select="false"/>
  </xsl:call-template>
</xsl:template>


<xsl:template match="r:code/r:code[@ref]|r:plot/r:code[@ref]|r:init/r:code[@ref]|r:function/r:code[@ref]"><xsl:text/>
<xsl:choose>
 <xsl:when test="$r-inline-code-refs">
  <xsl:apply-templates select="//r:code[@id = $ref]" mode="reference"/>
 </xsl:when>
 <xsl:otherwise>
  &lt;&lt;<fo:basic-link color="green"><xsl:attribute name="internal-destination"><xsl:value-of select="@ref"/></xsl:attribute><xsl:value-of select="@ref"/></fo:basic-link>&gt;&gt;
 </xsl:otherwise>
</xsl:choose>
<xsl:text/></xsl:template>

<xsl:template match="r:string[starts-with(., '&quot;')]">
  <fo:inline><xsl:apply-templates/></fo:inline>
</xsl:template>

<xsl:template match="r:string[not(starts-with(., '&quot;'))]">
  <fo:inline>"<xsl:apply-templates/>"</fo:inline>
</xsl:template>

<xsl:template match="r:literal[@type='string']">
  <fo:inline>"<xsl:apply-templates/>"</fo:inline>
</xsl:template>

<xsl:template match="r:literal">
  <fo:inline>"<xsl:apply-templates/>"</fo:inline>
</xsl:template>



<xsl:template match="r:warning">
 <xsl:call-template name="makeVerbatimCode">
  <xsl:with-param name="color"><xsl:value-of select="$r.warning.color"/></xsl:with-param>
 </xsl:call-template>
</xsl:template>


<xsl:template match="r:error">
 <xsl:call-template name="makeVerbatimCode">
  <xsl:with-param name="color"><xsl:value-of select="$r.error.color"/></xsl:with-param>
 </xsl:call-template>
</xsl:template>



<xsl:template match="s:output">
    <xsl:call-template name="makeVerbatimCode">  
        <xsl:with-param name="color">#54ff9f</xsl:with-param>
    </xsl:call-template>
</xsl:template>


<xsl:template match="r:plot">
<xsl:message>Hi from r:plot <xsl:value-of select="$showCode"/></xsl:message>
 <xsl:if test="$showCode">
    <xsl:call-template name="makeVerbatimCode"><xsl:with-param name="color" select="$r.code.color"/></xsl:call-template><xsl:text>&#010;</xsl:text>
 </xsl:if>
 <xsl:choose>
   <xsl:when test="$runCode and function-available('r:graphicsEval')">
     <xsl:copy-of select="r:graphicsEval(.)"/>
   </xsl:when>
   <xsl:otherwise>
     <xsl:if test="@file">
       <fo:block>
	 <xsl:element name="fo:external-graphic">
	   <xsl:attribute name="src"><xsl:value-of select="$imageDir"/>/<xsl:value-of select="@file"/>.jpg</xsl:attribute>
<!--
       <xsl:attribute name="width">4.5in</xsl:attribute>
       <xsl:attribute name="height">3in</xsl:attribute>
-->
	 </xsl:element>
       </fo:block>
     </xsl:if>
   </xsl:otherwise>
 </xsl:choose>
</xsl:template>


<xsl:template match="r:expr" name="r-expression">
  <fo:inline background-color="{$r.code.background.color}" color="{$r.code.color}"><xsl:call-template name="inline.monoseq"/></fo:inline>
</xsl:template>


<xsl:template match="r:formula">
  <call-template name="r-expression"/>
</xsl:template>


<xsl:template match="r:arg|s:arg|r:param">
 <fo:inline background-color="{$r.arg.background.color}" color="{$r.arg.color}"><xsl:call-template name="inline.italicmonoseq"/></fo:inline>
</xsl:template>

<xsl:template match="s:var|r:var" name="r-var">
 <fo:inline background-color="{$r.var.background.color}" color="{$r.var.color}"><xsl:call-template name="inline.boldmonoseq"/></fo:inline>
</xsl:template>


<xsl:template match="sub">
<xsl:call-template name="inline.subscriptseq"/>
</xsl:template>


<xsl:template match="r:func|s:func|rfunc|r:s3method">
 <fo:inline background-color="{$r.func.background.color}" color="{$r.func.color}"><xsl:call-template name="inline.italicmonoseq"><xsl:with-param name="contents"><xsl:apply-templates/></xsl:with-param></xsl:call-template>()</fo:inline></xsl:template>

<xsl:template match="r:package|r:pkg|rpkg">   <!--XXX use rpkg to get around using r:pkg in an entity without the namespace being defined at that point. -->
  <fo:basic-link>
   <xsl:attribute name="external-destination">http://cran.r-project.org/web/packages/<xsl:value-of select="."/>/index.html</xsl:attribute>
    <fo:inline background-color="{$r.pkg.background.color}" color="{$r.pkg.color}"><xsl:call-template name="inline.italicmonoseq"/></fo:inline>
  </fo:basic-link>
</xsl:template>


<xsl:template match="dots">...</xsl:template>


<!--<fo:inline font-family="Courier" font-style="oblique"><xsl:apply-templates/></fo:inline>-->
<!--  <fo:inline font-type="italic" font-family="monospace"><xsl:apply-templates/></fo:inline> -->




<xsl:template match="sh:output">
 <xsl:call-template name="makeVerbatimCode">
  <xsl:with-param name="color"><xsl:value-of select="$shell.code.color"/></xsl:with-param>
 </xsl:call-template>
</xsl:template>


<xsl:template match="latex">LaTeX</xsl:template>
<xsl:template match="tex">TeX</xsl:template>
<xsl:template match="html">HTML</xsl:template>



<xsl:template match="ignore"/>

<!-- If we want to put a hyperlink to a particular Web site URL, we can do this with
    -->

<xsl:template match="omg:func[@pkg]" name="omg:func">
   <xsl:call-template name="ulink"><xsl:with-param name="url">http://www.omegahat.org/<xsl:value-of select="string(@pkg)"/>/<xsl:value-of select="string(.)"/>.html</xsl:with-param></xsl:call-template>()
</xsl:template>

<xsl:template match="omg:func[@url]">
<xsl:call-template name="ulink" ><xsl:with-param name="url">http://www.omegahat.org/<xsl:value-of select="string(@url)"/>/<xsl:value-of select="string(.)"/>.html</xsl:with-param></xsl:call-template>()
</xsl:template>



<xsl:template match="omg:package|omg:pkg">
<fo:inline color="{$omg.package.color}"><xsl:call-template name="ulink"><xsl:with-param name="url">http://www.omegahat.org/<xsl:value-of select="string(.)"/></xsl:with-param></xsl:call-template></fo:inline>
</xsl:template>

<xsl:template match="omg:pkg[text()='XML']">
<fo:inline color="{$omg.package.color}"><xsl:call-template name="ulink"><xsl:with-param name="url">http://www.omegahat.org/RSXML</xsl:with-param></xsl:call-template></fo:inline>
</xsl:template>



<xsl:template match="omg:package[@url]">
<fo:inline color="{$omg.package.color}"><xsl:call-template name="ulink" ><xsl:with-param name="url">http://www.omegahat.org/<xsl:value-of select="string(@url)"/></xsl:with-param></xsl:call-template></fo:inline>
</xsl:template>

<xsl:template match="rwx:func">
<xsl:call-template name="ulink" ><xsl:with-param name="url">http://www.omegahat.org/RwxWidgets/<xsl:value-of select="string(.)"/>.html</xsl:with-param></xsl:call-template>
</xsl:template>


<!-- catch all for the r: nodes.
<xsl:template match="r:*">\<xsl:value-of select="name(.)"/>{<xsl:apply-templates />}</xsl:template>
 -->


<xsl:template name="expression" match="r:expression|s:expression">
 <xsl:param name="color">#e6e6fa</xsl:param>
 <fo:inline color="{string($color)}" xsl:use-attribute-sets="monospace.verbatim.properties">
  <xsl:apply-templates />
 </fo:inline>
</xsl:template>

<xsl:template match="directory|dir">
  <xsl:call-template name="inline.monoseq"/>/
</xsl:template>

<xsl:template match="file">
  <fo:inline font-family="italic"><xsl:apply-templates/></fo:inline>
</xsl:template>

<xsl:template match="s:dots|r:dots|rdots|r:rdots">
 <fo:inline font-weight="bold">...</fo:inline>
</xsl:template>

<xsl:template match="dots">...</xsl:template>

<xsl:template match="todo">[To-Do]</xsl:template>
<xsl:template match="reminder">[Reminder]</xsl:template>
<xsl:template match="wrong">[Error]</xsl:template>


<xsl:template match="figure|table|example|equation|procedure" mode="toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:if test="./ancestor::ignore">
<xsl:message>Skipping table of contents entry for <xsl:value-of select="name()"/>:  '<xsl:value-of select="normalize-space(title)"/>'</xsl:message>
  </xsl:if>
  <xsl:if test="not(./ancestor::ignore)">
    <xsl:call-template name="toc.line">
      <xsl:with-param name="toc-context" select="$toc-context"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>



<xsl:template match="fo:code">
  <xsl:call-template name="makeVerbatimCode">
    <xsl:with-param name="color"><xsl:value-of select="$fo.code.color"/></xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="biblioentry//version">
 version <xsl:apply-templates />
</xsl:template>

<xsl:template match="example">
 <xsl:apply-imports/>
 <fo:block space-after=".1in" text-align="center">
    <fo:leader leader-pattern="rule" leader-length="3in"/>
   </fo:block>
</xsl:template>

<!--
<xsl:template match="example[@id]">
<fo:block><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></fo:block>
 <xsl:apply-imports/>
 <fo:block space-after=".1in" text-align="center">
    <fo:leader leader-pattern="rule" leader-length="3in"/>
   </fo:block>
</xsl:template>
-->


<xsl:template match="codeEmphasis">
 <fo:inline color="red"><xsl:apply-templates/></fo:inline>
</xsl:template>


<xsl:template match="rdb">
<fo:basic-link><xsl:attribute name="external-destination"><xsl:value-of select="."/>.pdf</xsl:attribute><xsl:value-of select="."/></fo:basic-link>
</xsl:template>


<!-- Kill off the dyngraphic. -->
<xsl:template match="dyngraphic" />


<xsl:template match="fo:literal">
 <xsl:copy-of select="./text()|./*"/>
</xsl:template>


<xsl:template match="proglang">
<fo:inline font-weight="bold"><xsl:apply-templates/></fo:inline>
</xsl:template>

<xsl:template match="var">
<fo:inline font-weight="bold"><xsl:apply-templates/></fo:inline>
</xsl:template>

<xsl:template match="ltx:call">
<fo:inline font-weight="bold">\<xsl:apply-templates/></fo:inline>
</xsl:template>


<xsl:template match="mml:eqn" />
<xsl:template match="ltx:eqn" />


<xsl:template match="sup">
<fo:inline vertical-align="super"><xsl:apply-templates/></fo:inline>
<!--
<fo:character baseline-shift="super" font-size="8pt">
 <xsl:attribute name="character"><xsl:value-of/></fo:character>
-->
</xsl:template>
<xsl:template match="sub">
<fo:character baseline-shift="sub"><xsl:apply-templates/></fo:character>
</xsl:template>


<xsl:template match="R|r">
<fo:inline>R</fo:inline>
</xsl:template>

<xsl:template match="defn">
<fo:inline><xsl:apply-templates/></fo:inline>
</xsl:template>

<xsl:template match="proj">
<fo:inline><xsl:apply-templates/></fo:inline>
</xsl:template>

<xsl:template match="dso">
<fo:inline><xsl:apply-templates/></fo:inline>
</xsl:template>

</xsl:stylesheet>
