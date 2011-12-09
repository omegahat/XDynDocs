<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:s="http://cm.bell-labs.com/stat/S4"
        xmlns:r="http://www.r-project.org"
	xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
	xmlns:omg="http://www.omegahat.org"
	xmlns:bioc="http://www.bioconductor.org"
	xmlns:str="http://exslt.org/strings"
	exclude-result-prefixes="doc str" version='1.0'
    >

  <!-- For information on bibtex types, see http://en.wikipedia.org/wiki/BibTeX#Entry_Types  -->

<xsl:output method="text" omit-xml-declaration="yes"/>
<xsl:strip-space elements="*"/>
<xsl:preserve-space elements="title"/>

<xsl:include href="languages.xsl"/>

<xsl:template match="/">
<xsl:apply-templates select=".//biblioentry"/>
</xsl:template>

<xsl:template match="biblioentry" mode="bibType">misc</xsl:template>
<xsl:template match="biblioentry[.//r:pkg] | biblioentry[.//omg:pkg] | biblioentry[.//bioc:pkg] | biblioentry[.//r:pkgVersion]" mode="bibType">Manual</xsl:template>
<xsl:template match="biblioentry[.//@role='journal' or .//volume]" mode="bibType">article</xsl:template>
<xsl:template match="biblioentry[.//publisher]" mode="bibType">book</xsl:template>
<xsl:template match="biblioentry[.//seriesinfo]" mode="bibType">incollection</xsl:template>


<xsl:template match="text()"><xsl:value-of select="str:replace(str:replace(string(.), '_', '\_'), '&amp;', '\&amp;')"/></xsl:template>


<!--
<xsl:template name="bibType">
<xsl:choose>
<xsl:when>
 <xsl:if test=".//r:pkg">misc</xsl:if>
 <xsl:if test=".//@role='journal' or .//volume">article</xsl:if>
 <xsl:if test=".//@role='journal' or .//volume">article</xsl:if>
</xsl:when>
<xsl:otherwise>book</xsl:otherwise>
</xsl:choose>
</xsl:template>
-->

<xsl:template name="comma"><xsl:if test="not(position() = last())">,
</xsl:if></xsl:template>

<xsl:template match="biblioentry">
@<xsl:apply-templates select="." mode="bibType"/>{<xsl:value-of select="@id"/>,
<xsl:apply-templates/>
<xsl:if test="not(./year) and not(./pubdate)">,
year = 2011</xsl:if>
}
</xsl:template>

<xsl:template match="ulink">url = {<xsl:value-of select="@url"/>}<xsl:call-template name="comma"/>
</xsl:template>

<xsl:template match="subtitle"/>
<xsl:template match="subtitle" mode="ti">: <xsl:apply-templates/></xsl:template>

<xsl:template match="title">title = {<xsl:apply-templates/><xsl:apply-templates select="../subtitle" mode="ti"/>}<xsl:call-template name="comma"/>
</xsl:template>

<xsl:template match="pubdate">year = "<xsl:value-of select="."/>"<xsl:call-template name="comma"/>
</xsl:template>

<xsl:template name="makeAuthor">
<xsl:apply-templates select="surname"/><xsl:if test="firstname">, <xsl:value-of select="firstname"/></xsl:if>
</xsl:template>

<xsl:template match="surname"><xsl:choose><xsl:when test="contains(string(.), ' ')">{<xsl:apply-templates/>}</xsl:when><xsl:otherwise><xsl:apply-templates/></xsl:otherwise></xsl:choose></xsl:template>

<xsl:template match="author">author = {<xsl:call-template name="makeAuthor"/>}<xsl:call-template name="comma"/>
</xsl:template>

<xsl:template match="biblioset"><xsl:apply-templates/></xsl:template>
<xsl:template match="biblioset/title">journal = {<xsl:apply-templates />}<xsl:call-template name="comma"/>
</xsl:template>

<xsl:template match="volumenum">volume = {<xsl:apply-templates />}<xsl:call-template name="comma"/>
</xsl:template>

<xsl:template match="issuenum">num = {<xsl:apply-templates />}<xsl:call-template name="comma"/>
</xsl:template>

<xsl:template match="abbrev"/>

<xsl:template match="authorgroup">author = {<xsl:for-each select="author"><xsl:call-template name="makeAuthor"/><xsl:if test="not(position() = last())"> and </xsl:if></xsl:for-each> }<xsl:call-template name="comma"/>
</xsl:template>

<xsl:template match="editors" name="editors">editor = {<xsl:for-each select="editor"><xsl:call-template name="makeAuthor"/><xsl:if test="not(position() = last())"> and </xsl:if></xsl:for-each> }<xsl:call-template name="comma"/>
</xsl:template>



<xsl:template match="publisher">publisher = "<xsl:apply-templates select="publishername"/>"<xsl:if test="address"><xsl:call-template name="comma"/><xsl:apply-templates select="address"/></xsl:if><xsl:call-template name="comma"/>
</xsl:template>

<xsl:template match="address">address = {<xsl:apply-templates/>}<xsl:call-template name="comma"/></xsl:template>

<!--XXXX Need to inherit the processing of these elements, then put the comma in! -->
<xsl:template match="*[parent::address]"><xsl:value-of select="."/><xsl:call-template name="comma"/></xsl:template>

<!-- XXX what should the bibtex field name be for this. -->
<xsl:template match="corpauthor">institution = "<xsl:apply-templates/>"<xsl:call-template name="comma"/>
<xsl:if test="not(preceding-sibling::author) and not(following-sibling::author)">author = "{<xsl:apply-templates/>}"<xsl:call-template name="comma"/></xsl:if>
</xsl:template>

<xsl:template match="pagenums">pages = "<xsl:apply-templates/>"<xsl:call-template name="comma"/>
</xsl:template>




<xsl:template match="seriesinfo">booktitle = "{<xsl:apply-templates select="title/* | title/text()"/><xsl:apply-templates select="../subtitle" mode="ti"/>}"<xsl:call-template name="comma"/><xsl:if test="./editor"><xsl:call-template name="editors"/></xsl:if>
</xsl:template>


<xsl:template match="releaseInfo">note={<xsl:apply-templates/>}<xsl:call-template name="comma"/></xsl:template>
<xsl:template match="r:pkgVersion">note={\proglang{R}~package version~<xsl:apply-templates/>}<xsl:call-template name="comma"/></xsl:template>
</xsl:stylesheet>