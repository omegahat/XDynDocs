<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version='1.0'>

<xsl:template match="figure">
    <!-- start-indent="12pt" end-indent="12pt" -->
<fo:block border-style="solid" space-before="2em" space-after="2em" 
          padding="12pt">
 <xsl:apply-imports/>
</fo:block>
</xsl:template>

<xsl:template match="caption">
  <!-- font-style="italic" -->
  <!-- Compute the font-size as a percentage of the top-leve font size. -->
 <fo:block  padding="5pt" font-size="9pt" font-family="Helvetica">
   <xsl:apply-templates/>
 </fo:block>
</xsl:template>



<!-- Taken from http://www.sagehill.net/docbookxsl/CustomXrefs.html -->
<xsl:param name="local.l10n.xml" select="document('')"/>
<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
  <l:l10n language="en">
    <l:context name="xref">
      <l:template name="page.citation" text=" (page %p)"/>
    </l:context>
  </l:l10n>
</l:i18n>


<xsl:template match="xframe">
<fo:block keep-together.within-line="always">
 <fo:leader leader-pattern="rule" rule-style="solid" leader-length="5%"/><fo:inline space-after="2em"/><fo:inline><xsl:value-of select="@label"/></fo:inline> 
  <fo:leader leader-pattern="rule" rule-style="solid" leader-length="85%"/> 
</fo:block>
<fo:block border-style="solid">
 <xsl:call-template name="makeVerbatimCode"/>
</fo:block>
</xsl:template>


</xsl:stylesheet>