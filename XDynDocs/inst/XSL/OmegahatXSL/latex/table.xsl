<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:s="http://cm.bell-labs.com/stat/S4"
        xmlns:r="http://www.r-project.org"
	xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
	xmlns:omg="http://www.omegahat.org"
	xmlns:bioc="http://www.bioconductor.org"
        xmlns:exsl="http://exslt.org/common"
	xmlns:ltx="http://www.latex.org"
	exclude-result-prefixes="doc" version='1.0'
    >

<xsl:param name="thead.bold" select="1" />

<xsl:template match="table[title]">
\begin{center}
\begin{table}
\begin{tabularx}{\linewidth}{<xsl:call-template name="table-format-string"/>}
<xsl:apply-templates select="tgroup/thead/row"/>
<xsl:apply-templates select="tgroup/tbody/row"/>
<xsl:apply-templates select="tgroup/tfoot"/>
\end{tabularx}
<xsl:apply-templates select="title"/>
\end{table}
\end{center}
</xsl:template>

<!-- was \tablecaption  -->
<xsl:template match="table[@ltx:multipage]/title">
\bottomcaption{<xsl:apply-templates/>}
</xsl:template>

<xsl:template match="table[title and @ltx:multipage]">
<xsl:apply-templates select="title"/><xsl:call-template name="label.id"/>\begin{supertabular}{<xsl:call-template name="table-format-string"/>}
<xsl:apply-templates select="tgroup/thead/row"/>
<xsl:apply-templates select="tgroup/tbody/row"/>
<xsl:apply-templates select="tgroup/tfoot"/>
\end{supertabular}
</xsl:template>



<xsl:template name="table-format-string">
<xsl:choose>
 <xsl:when test="@ltx:format">
    <xsl:value-of select="@ltx:format"/>
 </xsl:when>
 <xsl:otherwise>
   <xsl:for-each select="./tgroup/colspec">X</xsl:for-each>
 </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="row"><xsl:for-each select="entry"><xsl:apply-templates select="."/><xsl:if test="following-sibling::*"><xsl:text> &amp; </xsl:text></xsl:if><xsl:if test="not(following-sibling::*)"><xsl:text> \\
</xsl:text></xsl:if></xsl:for-each>
</xsl:template>


<xsl:template match="row/entry"><xsl:apply-templates/></xsl:template>
<xsl:template match="row/entry[@fmt]"><xsl:message>row/entry[@fmt]</xsl:message><xsl:apply-templates/></xsl:template>
<xsl:template match="thead/row/entry"><xsl:choose><xsl:when test="$thead.bold">\textbf{<xsl:apply-templates/>}</xsl:when><xsl:otherwise><xsl:apply-imports/></xsl:otherwise></xsl:choose></xsl:template>



<xsl:template match="row/entry[@spanname]">
<xsl:param name="id"><xsl:value-of select="@spanname"/></xsl:param>
<xsl:param name="tgroup" select="ancestor::tgroup"/>
<xsl:param name="span" select="ancestor::tgroup/spanspec[@spanname = $id]"/>
<xsl:param name="start" select="count(exsl:node-set($tgroup)/colspec[@colname = exsl:node-set($span)/@namest]/preceding-sibling::colspec) + 1"/>
<xsl:param name="end" select="count(exsl:node-set($tgroup)/colspec[@colname = exsl:node-set($span)/@nameend]/preceding-sibling::colspec) + 1"/>
<!--<xsl:message>spanname = '<xsl:value-of select="$id"/>' :  <xsl:value-of select="exsl:node-set($span)/@namest"/> from = <xsl:value-of select="$start"/>, to = <xsl:value-of select="$end"/>  span = <xsl:value-of select="$end - $start + 1"/></xsl:message>-->
\multicolumn{<xsl:value-of select="$end - $start + 1"/>}{<xsl:choose><xsl:when test="@ltx:format"><xsl:value-of select="@ltx:format"/></xsl:when><xsl:otherwise>l</xsl:otherwise></xsl:choose>}{<xsl:apply-templates/>}
</xsl:template>



<xsl:template match="tfoot"><xsl:apply-templates/></xsl:template>


<xsl:template name="tex-format">
  <xsl:param name="string"/>
  <xsl:call-template name="special-replace">
    <xsl:with-param name="i">1</xsl:with-param>
    <xsl:with-param name="mapfile" select="document('omg_texmap.xml')"/>
    <xsl:with-param name="string" select="$string"/>
  </xsl:call-template>
</xsl:template>

<!--
<xsl:template match="programlisting">\begin{verbatim}
<xsl:call-template name="special-replace">
 <xsl:with-param name="i">1</xsl:with-param>
 <xsl:with-param name="mapfile" select="document('texmap.xml')"/>
 <xsl:with-param name="string" select="string(.)"/>
</xsl:call-template>
\end{verbatim}
</xsl:template>
-->

</xsl:stylesheet>