<!-- 
  Common material shared by dblatex.xsl and db2latex.xsl and are available to 
  have other customizations of dblatex/db2latex.
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
                exclude-result-prefixes="r s rwx fo sh omg make xsl"
                version='1.0'>

<!-- <xsl:import href="http://www.omegahat.org/XSL/c.xsl"/> -->

<!-- <xsl:variable name="latex.language.option">en</xsl:variable> -->

<xsl:param name="targetFormat">LaTeX</xsl:param>
<xsl:param name="runCode" select="1"/>
<xsl:param name="imageDir">/tmp</xsl:param>
<xsl:param name="showCode" select="1" type="boolean"></xsl:param>

<xsl:output indent="yes" format="text"/>


<xsl:template match="tex">
 <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="docbook">
% \url{http://docbook.sourceforge.net}{DocBook}
\htmladdnormallink{DocBook}{http://docbook.sourceforge.net}
</xsl:template>

<xsl:template name="makeVerbatimCode">
 <xsl:param name="class">rcode</xsl:param>
 <!-- trim ?  -->
\begin{<xsl:value-of select="$class"/>}<xsl:value-of select="text()" />\end{<xsl:value-of select="$class"/>} 
<!--\begin{verbatim}<xsl:apply-templates />\end{verbatim}-->
</xsl:template>

<xsl:template match="current-date">
 <xsl:value-of select="r:call('date')"/>
</xsl:template>


<xsl:template match="r:expr">
  <!-- <xsl:call-template name="inline.monoseq"/> -->
  <xsl:if test="@showCode and @showCode='true'">
    (\Sexpr{<xsl:apply-templates />})
  </xsl:if>
  <xsl:apply-imports />
</xsl:template>

<xsl:template match="r:code|r:function|r:test|r:init">
  <xsl:if test="($showCode or @showCode='true') and (@showCode and not(@showCode='false'))">
    <xsl:call-template name="makeVerbatimCode"/>
  </xsl:if>
\begin{Routput}
<xsl:apply-imports/>
\end{Routput}
</xsl:template>

<xsl:template match="r:code/r:output">
 \begin{Routput}
     <xsl:apply-templates/>  
 \end{Routput}
</xsl:template>


<xsl:template match="r:plot">
 <xsl:if test="($showCode or @showCode='true') and (@showCode and not(@showCode='false'))">
    <xsl:call-template name="makeVerbatimCode"/>
 </xsl:if>

\begin{center}
 <xsl:if test="not($runCode)">
  \includegraphics{<xsl:value-of select="@originalFile"/>}
 </xsl:if>

 <xsl:if test="$runCode and not(@eval='no' or @eval='false')">
   <xsl:choose>
     <xsl:when test="not($runPlots)">plot goes here</xsl:when>
     <xsl:when test="function-available('r:library') or function-available('eval')">
       <xsl:variable name="ans" select="r:graphicsEval(., string($imageDir))"/>
       <xsl:if test="not(exslt:object-type($ans) = 'node-set' and count($ans) = 0) and not(exslt:object-type($ans) = 'string' and $ans = '')">
        \includegraphics{<xsl:copy-of select="$ans"/>}
       </xsl:if>
     </xsl:when>
   </xsl:choose>
 </xsl:if>
\end{center}
</xsl:template>

<xsl:template match="s:var|r:var">
  \Svar{<xsl:apply-templates />}
</xsl:template>

<xsl:template match="r:func|s:func">
 \Sfunc{<xsl:apply-templates />}
</xsl:template>

<xsl:template match="r:package">
 \Spackage{<xsl:apply-templates />}
</xsl:template>



<!--<fo:inline font-family="Courier" font-style="oblique"><xsl:apply-templates/></fo:inline>-->
<!--  <fo:inline font-type="italic" font-family="monospace"><xsl:apply-templates/></fo:inline> -->

<xsl:template match="dots">$\ldots$</xsl:template>

<xsl:template match="sh:code">
 <xsl:if test="($showCode or @showCode='true') and (@showCode and not(@showCode='false'))"> 
   <xsl:call-template name="makeVerbatimCode">
     <xsl:with-param name="class">shell</xsl:with-param>
   </xsl:call-template>
 </xsl:if>
 <xsl:if test="$runCode">
  <programlisting class="shoutput">
    <xsl:copy-of select="r:call('system', string(.), boolean(1))"/>
  </programlisting>
 </xsl:if>
</xsl:template>

<xsl:template match="make:code">
 <xsl:call-template name="makeVerbatimCode">
  <xsl:with-param name="color">#f0e68c</xsl:with-param>
 </xsl:call-template>
</xsl:template>


<xsl:template match="latex">\LaTeX</xsl:template>

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
 \Sclass{<xsl:apply-templates/>}
</xsl:template>

<!-- catch all for the r: nodes.-->
<xsl:template match="r:*">\<xsl:value-of select="name(.)"/>{<xsl:apply-templates />}</xsl:template>


<!--
<xsl:template match="articleinfo|code">
  <xsl:copy-of select = "." />
</xsl:template>

<xsl:template match="para|listitem|section|title|itemizedlist|figure|xref|article|section">
<xsl:element name="{name(.)}">
  <xsl:apply-templates/>
</xsl:element>
<xsl:apply-imports/>
</xsl:template>
-->

<xsl:template match="r:run">
\begin{Rinvocation}
 <xsl:choose>
    <xsl:when test="$invocation=''"> 
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$invocation"/>
    </xsl:otherwise>
 </xsl:choose>
\end{Rinvocation}

</xsl:template>
</xsl:stylesheet>
