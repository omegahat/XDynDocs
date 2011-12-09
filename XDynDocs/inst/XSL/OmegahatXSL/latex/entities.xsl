<!-- Not used (yet). Replacements done with sed outside of XSL -->
<!-- Taken from http://www2.informatik.hu-berlin.de/~obecker/XSLT/xmlverbatim/xmlverbatim.xsl.html -->
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version='1.0'>

<xsl:template name="html-replace-entities">
      <xsl:param name="text" />
      <xsl:param name="attrs" />
      <xsl:variable name="tmp">
         <xsl:call-template name="replace-substring">
            <xsl:with-param name="from" select="'&gt;'" />
            <xsl:with-param name="to" select="'&amp;gt;'" />
            <xsl:with-param name="value">
               <xsl:call-template name="replace-substring">
                  <xsl:with-param name="from" select="'&lt;'" />
                  <xsl:with-param name="to" select="'&amp;lt;'" />
                  <xsl:with-param name="value">
                     <xsl:call-template name="replace-substring">
                        <xsl:with-param name="from" select="'&amp;'" />
                        <xsl:with-param name="to" select="'&amp;amp;'" />
                        <xsl:with-param name="value" select="$text" />
		     </xsl:call-template>
		  </xsl:with-param>
	       </xsl:call-template>
	    </xsl:with-param>
	 </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
         <!-- $text is an attribute value -->
         <xsl:when test="$attrs">
            <xsl:call-template name="replace-substring">
               <xsl:with-param name="from" select="' '" />
               <xsl:with-param name="to" select="'&amp;#xA;'" />
               <xsl:with-param name="value">
                  <xsl:call-template name="replace-substring">
                     <xsl:with-param name="from" select="'&quot;'" />
                     <xsl:with-param name="to" select="'&amp;quot;'" />
                     <xsl:with-param name="value" select="$tmp" />
		  </xsl:call-template>
	       </xsl:with-param>
	    </xsl:call-template>
	 </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$tmp" />
	 </xsl:otherwise>
      </xsl:choose>
</xsl:template>

   <!-- replace in $value substring $from with $to -->
   <xsl:template name="replace-substring">
      <xsl:param name="value" />
      <xsl:param name="from" />
      <xsl:param name="to" />
      <xsl:choose>
         <xsl:when test="contains($value,$from)">
            <xsl:value-of select="substring-before($value,$from)" />
            <xsl:value-of select="$to" />
            <xsl:call-template name="replace-substring">
               <xsl:with-param name="value" select="substring-after($value,$from)" />
               <xsl:with-param name="from" select="$from" />
               <xsl:with-param name="to" select="$to" />
	    </xsl:call-template>
	 </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$value" />
	 </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

</xsl:stylesheet>
