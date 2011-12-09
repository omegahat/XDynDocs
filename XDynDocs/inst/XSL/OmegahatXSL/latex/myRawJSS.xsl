<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:s="http://cm.bell-labs.com/stat/S4"
        xmlns:r="http://www.r-project.org"
	xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
	xmlns:omg="http://www.omegahat.org"
	xmlns:bioc="http://www.bioconductor.org"
	xmlns:xml="http://www.w3.org/XML/1998/namespace"
	xmlns:svg="http://www.w3.org/2000/svg" 
	xmlns:js="http://www.ecma-international.org/publications/standards/Ecma-262.htm"
        xmlns:str="http://exslt.org/strings"
	xmlns:ltx="http://www.latex.org"
	exclude-result-prefixes="doc str" version='1.0'
    >

<xsl:include href="basicLatex.xsl"/>

<xsl:output method="text" omit-xml-declaration="yes"/>

<xsl:param name="doc.class">[article]{jss}</xsl:param>


<xsl:template match="articleinfo/title">
\title{<xsl:apply-templates/>}
\Plaintitle{<xsl:value-of select="normalize-space(.)"/>}
</xsl:template>

<xsl:template match="articleinfo/titleabbrev">
\Shorttitle{<xsl:value-of select="."/>}
</xsl:template>

<xsl:template match="authorgroup">
\author{<xsl:for-each select="./author"><xsl:apply-templates select="."/>
<xsl:if test="not(position() = last())"><xsl:text> \And 
</xsl:text></xsl:if></xsl:for-each>}

\Plainauthor{<xsl:for-each select="./author"><xsl:call-template name="author"/>
<xsl:if test="not(position() = last())"><xsl:text>, \\
</xsl:text></xsl:if></xsl:for-each>}
</xsl:template>

<xsl:template match="abstract">
\Abstract{<xsl:apply-templates/>}
</xsl:template>

<xsl:template match="keywordset|keywords">
\Keywords{<xsl:for-each select="./keyword"><xsl:apply-templates/><xsl:if test="not(position() = last())"><xsl:text>, </xsl:text></xsl:if></xsl:for-each>}
\Plainkeywords{<xsl:for-each select="./keyword"><xsl:apply-templates mode="plain"/><xsl:if test="not(position() = last())"><xsl:text>, </xsl:text></xsl:if></xsl:for-each>}
</xsl:template>

<xsl:template match="keyword" mode="plain">
<xsl:message>plain keyword  <xsl:value-of select="string(.)"/></xsl:message>
<xsl:apply-templates select=".//text()"/>
</xsl:template>

<!-- Like to be able to do this more generically -->
<xsl:template match="js" mode="plain">JavaScript</xsl:template>


<xsl:template match="author/affiliation">
<xsl:apply-templates/>
</xsl:template>

<xsl:template name="author">
<xsl:apply-templates select="firstname"/><xsl:text> </xsl:text><xsl:apply-templates select="surname"/> 
</xsl:template>

<xsl:template match="author">
<xsl:call-template name="author"/> \\
  <xsl:apply-templates select="affiliation"/>
</xsl:template>



<xsl:template match="author/address">
  <xsl:apply-templates select="../firstname"/><xsl:text> </xsl:text><xsl:apply-templates select="../surname"/> \\
  <xsl:apply-templates select="../affiliation"/> \\
  <xsl:for-each select="street">
     <xsl:apply-templates /> \\
  </xsl:for-each>
  <xsl:apply-templates select="city"/><xsl:text> </xsl:text><xsl:apply-templates select="state"/><xsl:text> </xsl:text><xsl:apply-templates select="postcode"/>  <xsl:if test="../url or ../email"> \\<xsl:text> 
  </xsl:text></xsl:if>
  <xsl:apply-templates select="../email"/> <xsl:if test="../url"> \\<xsl:text>
  </xsl:text></xsl:if>
  <xsl:apply-templates select="../url"/> 
  <!-- Determine if we are the last author/address -->
<xsl:if test="not(position() = last())"><xsl:text>&#10;&#10;</xsl:text></xsl:if>
</xsl:template>




<!-- Not certain why match="citation/biblioref" doesn't work -->
<xsl:template match="citation[biblioref]">\citep{<xsl:value-of select="biblioref/@linkend"/>}</xsl:template>
<xsl:template match="citation[biblioref and @ltx:cmd]">\<xsl:value-of select="@ltx:cmd"/>{<xsl:value-of select="biblioref/@linkend"/>}</xsl:template>

<xsl:template match="html">\proglang{HTML}</xsl:template>


<!-- [Done see preProc.xsl] 
     This is very specific to the RKML paper and we will pull it out
     and create a new top-level XSL file.  This replaces the Google API key
     in the example HTML files when we embed Google Earth in a Web page. -->

<xsl:param name="GoogleAPIKey">jaspi$key</xsl:param>


<!-- Now moved to preProc.xsl for the KMLpaper, but I have left it here as 
     as an example.  It is better to do it when expanding HTML elements to 
     their docbook equivalents. -->
<xsl:template match="showHTML">
<xsl:param name="str" select="string(programlisting)"/>
\begin{CodeChunk}
\begin{CodeInput}
<xsl:value-of select="substring-before($str, 'jsapi?key')"/>jsapi?key=Google API Key<xsl:value-of select="substring-after($str,$GoogleAPIKey)"/>
\end{CodeInput}
\end{CodeChunk}
</xsl:template>

</xsl:stylesheet>
