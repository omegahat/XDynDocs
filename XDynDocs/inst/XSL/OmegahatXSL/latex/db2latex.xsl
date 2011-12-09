<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:s="http://cm.bell-labs.com/stat/S4"
        xmlns:r="http://www.r-project.org"
	xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
	xmlns:xi="http://www.w3.org/2003/XInclude"
	exclude-result-prefixes="doc" version='1.0'>

<xsl:param name="latex.documentclass.article">11pt</xsl:param>


<doc:param name="document.xml.language">
 <doc:description>This specifies the language to use for the document.
  We have changed the default to be English.
 </doc:description>
</doc:param>
<!--Could also set <xsl:param name="latex.language.option">en</xsl:param> 
    but the default value for that uses document.xml.language (or latex.babel.language).-->
<xsl:param name="document.xml.language">en</xsl:param>


<doc:param name="admon.graphics.path">
 <doc:description>If we specify this as an empty string, the LaTeX admonition
 environment does not use images and so does not complain about not finding them.
 </doc:description>
</doc:param>
<xsl:param name="admon.graphics.path"></xsl:param>


<doc:param name="latex.article.preamble.post" xmlns="">
<doc:description>The contents of this variable are
inserted at the end of the preamble and where we can
define macros and change the way the LaTeX is processed.
</doc:description>
</doc:param>
<xsl:param name="latex.article.preamble.post">
<xi:include href="latexMacros.tex" parse="text"/>
</xsl:param>

 <xsl:include href="http://db2latex.sourceforge.net/current/xsl/docbook.xsl"/>
 <xsl:include href="latex.xsl"/>
 <xsl:include href="xml.xsl"/>
 <xsl:include href="shell.xsl"/>

<xsl:template match="r:makePlot"></xsl:template>

</xsl:stylesheet>
