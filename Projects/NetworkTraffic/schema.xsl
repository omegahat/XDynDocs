<?xml version="1.0" ?>

<!-- Copyright the Omegahat Project for Statistical Computing, 2000 -->
<!-- Author: Duncan Temple Lang -->

<xsl:stylesheet
            xmlns:bib="http://www.bibliography.org"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
            version="1.0"
>

<xsl:template match="/">

<HTML>
<head>
<title>Field Descriptions for TCP connections  Attributes</title>
</head>
<body>
<h1>Field Descriptions for TCP connections  Attributes</h1>
<table>
<tr>
<th>Field name</th><th>Description</th>
</tr>
<xsl:apply-templates />
</table>
</body>
</HTML>

</xsl:template>

<xsl:template match="row">
 <tr>
     <td><xsl:value-of select="Field" /></td>
     <td><xsl:value-of select="Extra" /></td>
 </tr>
</xsl:template>

</xsl:stylesheet>
