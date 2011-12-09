<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version='1.0'>

<xsl:template match="makeGlossary">
<xsl:choose>
 <xsl:when test="not(ancestor::glossary)">
 <section><title>Glossary</title>
  <xsl:call-template name="makeGlossaryTable"/>
 </section>
 </xsl:when>
 <xsl:otherwise>
  <xsl:call-template name="makeGlossaryTable"/>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="makeGlossaryTable">
<table>
<tgroup cols='2' align='left' colsep='1' rowsep='1'>
<thead>
<colspec colname="acronym"/>
<colspec colname="def"/>
</thead>
<tbody>
<xsl:apply-templates select="//acronymDef | //acronym[@def]" mode="glossary"/>
</tbody>
</tgroup>
</table>
</xsl:template>

<xsl:template match="acronymDef" mode="glossary">
<row>
  <entry><xsl:value-of select="@value"/></entry>
  <entry><xsl:apply-templates/></entry>
</row>
</xsl:template>

<xsl:template match="acronym[@def]" mode="glossary">
 <row>
  <entry><xsl:apply-templates /></entry>
  <entry><xsl:value-of select="@def"/></entry>
 </row>
</xsl:template>

</xsl:stylesheet>

