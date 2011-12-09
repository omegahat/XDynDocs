<?xml version='1.0'?>
<!-- 
 This is used for converting our XML file into HTML
 and doing the R computations on the fly while this is being
 processed.
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

<!--<xsl:import href="http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl"/> -->
<xsl:import href="http://www.omegahat.org/XSL/html/Rhtml.xsl"/>
<xsl:import href="http://www.omegahat.org/XSL/html/Rsource.xsl"/>
<!--<xsl:import href="http://www.omegahat.org/XSL/html/Rstyle.xsl"/>-->
<xsl:import href="http://www.omegahat.org/XSL/html/c.xsl"/>
<xsl:import href="http://www.omegahat.org/XSL/html/html.xsl"/>
<xsl:import href="http://www.omegahat.org/XSL/html/shell.xsl"/>
<xsl:import href="http://www.omegahat.org/XSL/html/xml.xsl"/>

<!-- Order is important as the <apply-imports /> call in r:code, etc. needs to find the template in dynamic.xsl -->
<xsl:import href="dynamic.xsl"/>
<xsl:import href="dynParams.xsl"/>

<xsl:param name="html.stylesheet" select="'http://www.omegahat.org/OmegaTech.css'"/>
<xsl:param name="graphicsFormat">JPEG</xsl:param>
<xsl:param name="targetFormat">HTML</xsl:param>

<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" />


<xsl:template match="r:code|r:function|r:test|r:init">

<xsl:if test="string-length(normalize-space(text())) != 0">
 <xsl:choose>
  <xsl:when test="($showCode or @showCode='true') and (not(@showCode = 'false'))">
    <xsl:call-template name="makeVerbatimCode"/>
    <xsl:apply-imports/>  
  </xsl:when>
  <xsl:otherwise>
   <div><xsl:attribute name='title'><xsl:call-template name="formatRCode"/></xsl:attribute>
     <!-- Run the code via dynamic.xsl templates. 
          Note that R creates the PRE or whatever for the entire HTML formatting. -->
     <xsl:apply-imports/>  
   </div>
  </xsl:otherwise>
 </xsl:choose>
</xsl:if>

</xsl:template>

<xsl:template name="user.footer.content">
  <xsl:call-template name="postamble"/>
</xsl:template>

<!--
 We shouldn't define this here. Inherit the imported one from the static XSL in
  OmegahatXSL/html/Rsource.xsl
<xsl:template name="makeVerbatimCode">
 <xsl:param name="class">rcode</xsl:param>
 <xsl:if test="@id">
   <a><xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute></a>
 </xsl:if>
 <xsl:element name="pre">
    <xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute> 
     <xsl:apply-templates />
 </xsl:element>
</xsl:template>
-->


<!-- Show the code only if showExpressionCode is 1 or we have an explicit @showCode="true".
     Add the code string as a tooltip on the result. -->
<xsl:template match="r:expr">
  <xsl:if test="($showExpressionCode or @showCode = 'true') and not(@showCode = 'false')">
    (<code class="rexpr"><xsl:apply-templates /></code>)
  </xsl:if>
  <code>
    <xsl:attribute name="title"><xsl:value-of select="string(.)"/></xsl:attribute>
    <xsl:apply-imports />
  </code>
</xsl:template>

<xsl:template match="r:data|r:value|r:object">
  <xsl:apply-imports />
</xsl:template>


<!-- Show the R code but don't evaluate it. -->
<xsl:template match="programlisting[@lang='r' or @lang='R']">
    <xsl:call-template name="makeVerbatimCode"/>
</xsl:template>


<xsl:template match="r:commands">
 <div class="r-commands"><pre class="r-commands">
  <xsl:apply-imports />
 </pre></div>
</xsl:template>




<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

<xsl:template match="r:plot">
 <xsl:if test="($showCode or @showCode='true') and (not(@showCode='false'))">
    <xsl:call-template name="makeVerbatimCode"/>
 </xsl:if>

 <xsl:if test= "not($runCode)">
           <!--  Potentially a broken image, but that's okay! ??? -->
    <img>
      <xsl:attribute name="src"><xsl:choose><xsl:when test="@originalFile"><xsl:value-of select="@originalFile"/></xsl:when>
                                           <xsl:otherwise><xsl:value-of select="@file"/></xsl:otherwise>
                                </xsl:choose></xsl:attribute>
      <xsl:attribute name="alt"><xsl:value-of select="."/></xsl:attribute>
    </img>
 </xsl:if>

 <xsl:if test="$runCode and $runPlots and function-available('r:library') and function-available('r:graphicsEval') and not(@eval='no' or @eval='false')"> 
<!--   <xsl:variable name="bob"><xsl:copy-of select="r:graphicsEval(., string($imageDir), string($targetFormat))"/></xsl:variable> -->
   <xsl:variable name="bob" select="r:graphicsEval(., string($imageDir), string($targetFormat))"/>

   <xsl:variable name="format">
     <xsl:choose><xsl:when test="@r:format"><xsl:value-of select="translate(@r:format,$lcletters, $ucletters)"/></xsl:when>
                 <xsl:otherwise><xsl:value-of select="translate($graphicsFormat, $lcletters, $ucletters)"/></xsl:otherwise>
     </xsl:choose>
   </xsl:variable>

  <xsl:choose>
   <xsl:when test="exslt:object-type($bob) = 'string'">
    <xsl:choose>
      <xsl:when test="$bob=''">
      </xsl:when>
      <xsl:when test="$format='PDF'">
	<xsl:element name="a">
	  <xsl:attribute name="href"><xsl:value-of select="$bob"/></xsl:attribute>
	  <xsl:value-of select="$bob"/>
	</xsl:element>
      </xsl:when>
      <xsl:when test="$format='SVG'">
<xsl:message>SVG doc: <xsl:value-of select="$bob"/></xsl:message>
        <iframe frameborder="0">

    	       <!-- Read the width and height of the image and add them as attributes -->
<!--    Needs the normalized path for the image files to be passed to this from the call to graphicsEval(). -->
	  <xsl:attribute name="src"><xsl:value-of select="$bob"/></xsl:attribute>
	  <xsl:attribute name="width"><xsl:value-of select="number(translate(string(document($bob)/*/@width), 'pt','')) * 1.34"/></xsl:attribute>
	  <xsl:attribute name="height"><xsl:value-of select="number(translate(string(document($bob)/*/@height), 'pt','')) * 1.34"/></xsl:attribute>

	  <xsl:copy-of select="@*"/>
	</iframe>

<xsl:message>SVG doc width <xsl:value-of select="number(translate(string(document($bob)/*/@width), 'pt','')) * 1.34"/></xsl:message>

      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="img">
	  <xsl:attribute name="src"><xsl:value-of select="$bob"/></xsl:attribute>
	  <xsl:copy-of select="@*"/>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
   </xsl:when>
   <xsl:otherwise><xsl:copy-of select="$bob"/></xsl:otherwise>
  </xsl:choose>
 </xsl:if>
</xsl:template>

<xsl:template match="s:var|r:var">
  <code class="rvar"><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="r:func|s:func">
 <xsl:call-template name="inline.italicmonoseq"><xsl:with-param name="content"><xsl:apply-templates/>()</xsl:with-param></xsl:call-template>
</xsl:template>

<xsl:template match="r:package">
<xsl:call-template name="inline.italicmonoseq"/>
</xsl:template>

<xsl:template name="getSVGDim">

</xsl:template>


<!--<fo:inline font-family="Courier" font-style="oblique"><xsl:apply-templates/></fo:inline>-->
<!--  <fo:inline font-type="italic" font-family="monospace"><xsl:apply-templates/></fo:inline> -->

<xsl:template match="dots">...</xsl:template>

<xsl:template match="sh:code">
 <xsl:if test="($showCode or @showCode='true') and (not(@showCode='false'))"> 
   <xsl:call-template name="makeVerbatimCode">
     <xsl:with-param name="class">shell</xsl:with-param>
   </xsl:call-template>
 </xsl:if>
 <xsl:if test="$runCode">
  <pre class="shoutput">
<!--    <xsl:copy-of select="r:call('system', string(.), boolean(1))"/> -->
     <xsl:copy-of select="r:call('evalShell', .)"/>
  </pre>
 </xsl:if>
</xsl:template>

<xsl:template match="make:code">
 <xsl:call-template name="makeVerbatimCode">
  <xsl:with-param name="color">#f0e68c</xsl:with-param>
 </xsl:call-template>
</xsl:template>


<xsl:template match="latex">LaTeX</xsl:template>

<xsl:template match="ignore"/>

<xsl:template match="invisible">
<xsl:comment>
 <xsl:apply-templates />
</xsl:comment>
</xsl:template>

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

<xsl:template match="interactive" />

<xsl:template match="r:run">
 <xsl:if test="$invocation=''">
<pre class="run">
<xsl:apply-templates/>
</pre>
 </xsl:if>
</xsl:template>

<xsl:template match="r:formatCode">
 <PRE class="rcode">
  <xsl:call-template name="formatRCode"/>
 </PRE>
</xsl:template>

<xsl:template name="sessionInfo">
 <hr width="50%"/>
 <div class="rsessionInfo">
   <p>
     <xsl:copy-of select="r:parseEval('sessionInfo()')"/>
   </p>
 </div>
</xsl:template>

</xsl:stylesheet>
