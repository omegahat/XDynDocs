<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sh="http://www.shell.org"
        version="1.0">

<xsl:template match="sh:code">\begin{verbatim}<xsl:apply-templates/>
\end{verbatim}</xsl:template>

<xsl:template match="sh:var">\ShellVar{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="sh:cmd">\ShellCmd{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="sh:exec">
\textsl{<xsl:apply-templates/>}
</xsl:template>

</xsl:stylesheet>
