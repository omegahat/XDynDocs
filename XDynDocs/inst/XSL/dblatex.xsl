<?xml version='1.0'?>
<!-- 
 This is used for converting our XML file into LaTeX
 by going to docbook and/or LaTeX and then running
 the db2latex conversion on the resulting document.
 We do the R computations on the fly while this is being
 processed and generate content in either docbook or LaTeX.
 -->
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

<!--<xsl:import href="http://docbook.sourceforge.net/release/xsl/current"/> -->
<xsl:import href="http://dblatex.sourceforge.net/xsl/docbook.xsl"/>
<xsl:import href="dynamic.xsl"/>
<xsl:import href="latex.xsl"/>

<xsl:param name="latex.article.preamble.post"> \usepackage{Rdocbook}</xsl:param>

<!-- Stop the escaping of $, etc.  This is called from dblatex's format.xsl file in tex-format. -->
<xsl:template name="special-replace">
 <xsl:param name="string"/>
  <xsl:value-of select="$string"/>
</xsl:template>


<!-- Complete hack because dblatex leaves no hook templates that we can define
     and which are called but default to nothing. -->
<xsl:template name="verbatim.setup">
<xsl:value-of select="$latex.article.preamble.post"/>
</xsl:template>


<xsl:template match="articleinfo/revhistory"/>

</xsl:stylesheet>
