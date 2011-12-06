<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:r="http://www.r-project.org"
                version="1.0">

<xsl:import href="http://www.omegahat.org/XSL/html/Rhtml.xsl"/>


<xsl:param name="showAnswers" select="1" />

<xsl:template match="/">
<html>
<head>
<link rel="stylesheet">
 <xsl:attribute name="href"><xsl:value-of select="$html.stylesheet"/></xsl:attribute>
</link>
<link rel="stylesheet" href="foo.css"/>
<title>Questions</title>
</head>
<body>
<ol>
 <xsl:apply-templates select="/questions/q" />
</ol>
</body>
</html>
</xsl:template>



<xsl:template match="q">
  <li>
   <div>
     <xsl:apply-templates select="./*[name() != 'answer']"/>
   </div>
    <xsl:if test="$showAnswers">
     <div class="answer">
      <xsl:apply-templates select="answer"/>
     </div>
    </xsl:if>
  </li>
</xsl:template>

</xsl:stylesheet>

