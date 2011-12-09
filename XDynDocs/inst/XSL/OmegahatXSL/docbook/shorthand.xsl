<?xml version="1.0"?>
<!-- This is a simple style sheet that is used to transform
  a document that uses HTML-like elements for conevenience
  instead of the more verbose Docbook terms, e.g. ul and itemizedlist
  li and listitem, p and para.
  One can use this to filter the document before it is handed to the usual
  XSL style sheets for converting to HTML or FO. 
  We can do this each time we convert the document to HTML or FO. Alternatively
  we can do this periodically and write the new file over the original one
  and so use this as a rewrite rule to expand our short version into the Docbook 
  forms and then continue editing our file. Make files allow us to do the former
  quite easily.
  To do the latter, i.e. to do a once-and-for-all rewrite, use something like
     xsltproc -o foo.xml ~/Classes/StatComputing/XDynDocs/inst/XSL/OmegahatXSL/docbookShorthand.xsl foo.xml 
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:r="http://www.r-project.org" 
                xmlns:omg="http://www.omegahat.org" 
                version="1.0">

<xsl:param name="make.r.index" select="0"/>

<xsl:template match="*|@*">
 <xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy>
</xsl:template>

<xsl:template match="li">
<listitem><para><xsl:apply-templates/></para></listitem>
</xsl:template>

<xsl:template match="ul">
<itemizedlist><xsl:apply-templates/></itemizedlist>
</xsl:template>

<xsl:template match="ol">
<orderedlist><xsl:apply-templates/></orderedlist>
</xsl:template>

<xsl:template match="p">
<para><xsl:apply-templates/></para>
</xsl:template>


<xsl:template name="indexElement">
 <xsl:param name="rtype"></xsl:param>
 <xsl:param name="type"></xsl:param>
 <xsl:if test="$make.r.index and not(ancestor::ignore)">
   <xsl:copy-of select="."/>
   <indexterm>
      <xsl:if test="not($type = '')">
        <xsl:attribute name="type"><xsl:value-of select="$type"/></xsl:attribute>
      </xsl:if>
      <primary><xsl:if test="local-name() = 'function'"><xsl:value-of select="@id"/></xsl:if>
               <xsl:if test="not(local-name() = 'function')"><xsl:value-of select="."/></xsl:if>
               <xsl:if test="not($type = '')"> (<xsl:value-of select="$rtype"/>)</xsl:if></primary>
  </indexterm>
 </xsl:if>
 <xsl:if test="not($make.r.index)">
    <xsl:copy-of select="."/>
 </xsl:if>
</xsl:template>


<xsl:template match="r:func">
 <xsl:call-template name="indexElement">
     <xsl:with-param name="type">function</xsl:with-param>
 </xsl:call-template>
</xsl:template>


<xsl:template match="r:param|r:arg">
 <xsl:call-template name="indexElement">
    <xsl:with-param name="rtype">parameter</xsl:with-param>
 </xsl:call-template>
</xsl:template>


<xsl:template match="r:option">
 <xsl:call-template name="indexElement">
    <xsl:with-param name="rtype">option</xsl:with-param>
    <xsl:with-param name="type">roption</xsl:with-param>
 </xsl:call-template>
</xsl:template>


<xsl:template match="r:pkg|omg:package">
 <xsl:call-template name="indexElement">
    <xsl:with-param name="rtype">package</xsl:with-param>
    <xsl:with-param name="type">package</xsl:with-param>
 </xsl:call-template>
</xsl:template>


<xsl:template match="r:class">
 <xsl:call-template name="indexElement">
    <xsl:with-param name="rtype">S4 class</xsl:with-param>
    <xsl:with-param name="type">class</xsl:with-param>
 </xsl:call-template>
</xsl:template>

<xsl:template match="r:s3class">
 <xsl:call-template name="indexElement">
    <xsl:with-param name="rtype">S3 class</xsl:with-param>
    <xsl:with-param name="type">class</xsl:with-param>
 </xsl:call-template>
</xsl:template>

<xsl:template match="r:globalVar">
 <xsl:call-template name="indexElement">
    <xsl:with-param name="rtype">variable</xsl:with-param>
    <xsl:with-param name="type">global variable</xsl:with-param>
 </xsl:call-template>
</xsl:template>



<xsl:template match="r:function">
 <xsl:call-template name="indexElement">
    <xsl:with-param name="rtype">definition</xsl:with-param>
 </xsl:call-template>
</xsl:template>


<xsl:template match="biblioentry[starts-with(@id, 'bib:')]">
 <xsl:copy>
   <xsl:attribute name="xreflabel"><xsl:value-of select="substring-after(@id, 'bib:')"/></xsl:attribute>
   <xsl:apply-templates select="@*|node()"/>
 </xsl:copy>
</xsl:template>


<xsl:template match="libxml">
  <ulink url="http://www.xmlsoft.org">libxml2</ulink><xsl:call-template name="indexElement"/>
</xsl:template>

<!--
<xsl:template match="no-xref">
 <xsl:copy>
   <xsl:apply-templates select="@*"/>
   <xsl:attribute name="xrefstyle">select: label page</xsl:attribute>
 </xsl:copy>
</xsl:template>
-->

</xsl:stylesheet>

