<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:r="http://www.r-project.org"
                xmlns:s="http://cm.bell-labs.com/stat/S4"
                xmlns:omg="http://www.omegahat.org"
                xmlns:rwx="http://www.omegahat.org/RwxWidgets"
                xmlns:make="http://www.make.org"
                xmlns:sh="http://www.shell.org"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                extension-element-prefixes="r"
                exclude-result-prefixes="r s rwx fo sh omg make xsl"
                version='1.0'>

<xsl:import href="http://db2latex.sourceforge.net/current/xsl/docbook.xsl"/>
<xsl:import href="dynamic.xsl"/>
<xsl:import href="latex.xsl"/>

<!-- Use English. -->
<xsl:variable name="l10n.gentext.default.language">en</xsl:variable>
<xsl:variable name="latex.documentclass.common"></xsl:variable>
<xsl:variable name="latex.babel.language"></xsl:variable>

<xsl:param name="latex.documentclass.article">11pt,times</xsl:param>
<!--<xsl:param name="latex.use.ltxtable">1</xsl:param> -->
<xsl:param name="latex.use.tablularx">1</xsl:param>

<xsl:param name="latex.article.preamble.post">
 \usepackage{Rdocbook}
</xsl:param>


<xsl:template match="/bob">
\documentclass[times,11pt]{article}
\usepackage{Rdocbook}
\begin{document}
 <xsl:apply-templates />
\end{document}
</xsl:template>

<xsl:template name="scape">
<xsl:param name="string"/>
  <xsl:value-of select="$string"/>
</xsl:template>

<xsl:template match="ignore"/>

<xsl:template match="interactive"/>

<xsl:template match="xml:tag">
\xmlTag{<xsl:apply-templates/>}
</xsl:template>

<xsl:template match="xml:attr">
\xmlAttr{<xsl:apply-templates/>}
</xsl:template>

<xsl:template match="xml:node|xml:element">
\xmlNode{<xsl:apply-templates/>}
</xsl:template>

</xsl:stylesheet>