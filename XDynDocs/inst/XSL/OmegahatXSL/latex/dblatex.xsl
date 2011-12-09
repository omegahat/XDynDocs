<!DOCTYPE xsl:stylesheet [
<!ENTITY t1 "&#x370;t">
<!ENTITY t2 "&#x371;t">
<!ENTITY u1 "&#x370;u">
<!ENTITY u2 "&#x371;u">
<!ENTITY v1 "&#x370;u">
<!ENTITY v2 "&#x371;u">
]>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
        xmlns:s="http://cm.bell-labs.com/stat/S4"
        xmlns:r="http://www.r-project.org"
	exclude-result-prefixes="doc" version='1.0'>

<xsl:param name="latex.hyperparam">colorlinks,linkcolor=red,filecolor=red,urlcolor=blue</xsl:param>

<xsl:include href="http://dblatex.sourceforge.net/xsl/docbook.xsl"/>
<!--
  <xsl:include href="http://dblatex.sourceforge.net/xsl/fasttext.xsl"/> 
--> <!-- need this for scape-encode when working with links. -->

<xsl:include href="latex.xsl"/>


<!-- Taken from fasttext.xsl since if we include that we get duplicate template definitions from format.xsl,
     but we need these for links. -->
<xsl:template name="scape-encode" >
  <xsl:param name="string"/>
  <xsl:value-of select="$string"/>
</xsl:template>


<xsl:template name="special-replace-does-not-work">
  <xsl:param name="i"/>
  <xsl:param name="mapfile"/>
  <xsl:param name="string"/>
  <xsl:value-of select="$string"/>
</xsl:template>


<xsl:template match="r:code">
\begin{verbatim}
 <xsl:apply-templates />
\end{verbatim}
</xsl:template>

</xsl:stylesheet>
