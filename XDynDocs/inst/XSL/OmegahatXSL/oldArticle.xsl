<?xml version="1.0"?>

<!-- Copyright the Omegahat Project for Statistical Computing, 2000 -->
<!-- Author: Duncan Temple Lang -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:bib="http://www.bibliography.org"
                xmlns:c="http://www.C.org"
                xmlns:rs="http://www.omegahat.org/RS"
                xmlns:r="http://www.r-project.org"
                xmlns:s="http://cm.bell-labs.com/stat/S4"
                xmlns:splus="http://www.insightful.com/S-Plus"
                exclude-result-prefixes="bib rs s c"
                version="1.0">


<xsl:output method="html" />

<xsl:param name="doIncludes" select="'true'" />

<xsl:include href="http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl"/>
<!-- <xsl:include href="/Users/duncan/docbook-xsl-1.71.1/html/docbook.xsl" /> -->

 <xsl:include href="table.xsl" />
 <xsl:include href="elements.xsl" />

 <xsl:include href="java.xsl" />
 <xsl:include href="c.xsl" />
 <xsl:include href="SLanguage.xsl" />
 <xsl:include href="html.xsl" />
 <xsl:include href="xml.xsl" /> 
 <xsl:include href="env.xsl" /> 
 <xsl:include href="latex.xsl" /> 
 <xsl:include href="omg.xsl" />


 <xsl:include href="defs.xsl" />


 <xsl:include href="curl.xsl" /> 

<xsl:param name="cssURL" select="'OmegaTech.css'" />
<xsl:param name="outputFile" select="''" />
<xsl:param name="inputXSL" select="''" />
<xsl:param name="inputFile" select="''" />
<xsl:param name="showCreation" select="''" />
<xsl:param name="footnoteImage" select="'back.png'" />


 <!-- don't use import! -->
<xsl:include href="bibliography.xsl" />


<xsl:template match="title" mode="toc">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="title" />
<xsl:template match="comment" />

<xsl:template match="section"  mode="toc">
  <li>
   <xsl:element name="a">
    <xsl:attribute name="href">#section-<xsl:number level="single" count="section" format="1" /></xsl:attribute>
      <xsl:apply-templates select="title" mode="toc" />
   </xsl:element>
     <!-- Want to conditionally add the ol. -->
     <ol type="A">
       <xsl:apply-templates select="subsection" mode="toc" />
     </ol>
  </li>
</xsl:template>

<xsl:template match="subsection" mode="toc">
 <li><xsl:element name="a">
    <xsl:attribute name="href">#subsection-<xsl:number level="any" count="section" format="1" />-<xsl:number level="single" count="subsection" format="A" /></xsl:attribute>
      <xsl:apply-templates select="title" mode="toc" />
     <ol>
       <xsl:apply-templates select="subsubsection" mode="toc" />
     </ol>
   </xsl:element>
 </li>
</xsl:template>

<xsl:template match="subsubsection" mode="toc">
  <li> <xsl:element name="a">
    <xsl:attribute name="href">#subsubsection-<xsl:number level="any" count="subsubsection" format="1" /></xsl:attribute>
      <xsl:apply-templates select="title" mode="toc" />
   </xsl:element>
   </li>
</xsl:template>

<xsl:template match="subsubsection">
  <h3><xsl:element name="a"> 
   <xsl:attribute name="name">#subsubsection-<xsl:number level="any" count="subsubsection" format="1" /></xsl:attribute>
      <xsl:value-of select="title" />
  </xsl:element>
 </h3>
      <xsl:apply-templates />
</xsl:template>


<xsl:template match="appendix" mode="toc">
 <li><xsl:element name="a">
    <xsl:attribute name="href">#appendix-<xsl:number level="single" count="appendix" format="A" /></xsl:attribute>
      <xsl:apply-templates select="title" mode="toc" />
   </xsl:element>
 </li>
</xsl:template>


<!-- We want to put this somewhere else in the document,
   perhaps at the end of the logical unit such as a section or the entire
   document.
-->
<xsl:template match="footnote">
 <small><sup class="footnote">
[<xsl:element name="a">
  <xsl:attribute name="name">footnote-anchor<xsl:number level="any" count="footnote" format="1" /></xsl:attribute>
  <xsl:attribute name="href">#footnote-def<xsl:number level="any" count="footnote" format="1" /></xsl:attribute><xsl:number level="any" count="footnote" format="1" /></xsl:element>]
 </sup></small> 
</xsl:template>


<!-- 
  This is where we put the text of the footnote.
  It links back to where the footnote was defined via a little image
  button and then also has a name so  
 
  If there is a name attribute, we can use that as the href
  -->
<xsl:template match="footnote" mode="footnotes">
  <li>
  <xsl:element name="a">
     <xsl:attribute name="href">#footnote-anchor<xsl:number level="any" count="footnote" format="1" /></xsl:attribute>
     <xsl:attribute name="name">footnote-def<xsl:number level="any" count="footnote" format="1" /></xsl:attribute>
       <img src="{$footnoteImage}"></img>
  </xsl:element>
       <xsl:apply-templates  />
  </li>
</xsl:template>


<xsl:template match="footnote" mode="frameTitle" />


<!-- Ignore for the moment. -->
<xsl:template match="OMIT-article">
 <html>
  <head>
    <title><xsl:apply-templates select="./title" mode="frameTitle" /></title>
<!-- ../../../Docs/ -->
    <xsl:element name="link">
      <xsl:attribute name="rel">stylesheet</xsl:attribute>
      <xsl:attribute name="href"><xsl:value-of select="$cssURL" /></xsl:attribute>
    </xsl:element>
  </head>

 <body>
 <center><h1><xsl:apply-templates select="./title" mode="ok"/></h1></center>
  <xsl:apply-templates select="author" />
  <xsl:if test="count(date) > 0">
   <center><xsl:apply-templates select="date" /></center>
  </xsl:if>
<p />
 <xsl:if test="count(section) > 0">
 <h2><a name="TOC">Table of Contents</a></h2>
   <ol>
      <xsl:apply-templates select="./section" mode="toc" />
     <xsl:if test="count(bibliography) > 0">
      <li><a href="#Bibliography">Bibliography</a></li>
     </xsl:if>
     <xsl:if test="count(//footnote) > 0">
      <li><a href="#Footnotes">Footnotes</a></li>
     </xsl:if>
   </ol>
  <xsl:if test="count(appendix) > 0">
  <h3>Appendices</h3>
   <ol>
      <xsl:apply-templates select="./appendix" mode="toc" />
   </ol>
 <p />
  </xsl:if>
 </xsl:if>
 <xsl:apply-templates select="*[not(self::author|self::title|self::date)]|/article/text()" />

 <xsl:if test="count(//footnote) > 0">
 <hr width="50%"/>
 <h2><a name="Footnotes">Footnotes</a></h2>
  <ol>
    <xsl:apply-templates select="//footnote" mode="footnotes" />
  </ol>
 </xsl:if>
<p />

<xsl:if test="string-length($showCreation) > 0">
  <hr width="50%" />
 <small>
 Document generated by
 <pre>
   export LD_LIBRARY_PATH=/tmp/xml-xalan/c/lib
   /tmp/xml-xalan/c/bin/testXSLT -in <xsl:value-of select="$inputFile"/> -xsl article.xsl -out <xsl:value-of select="$outputFile" />
 </pre>
or
 <pre>
   CLASSPATH /usr/local/src/xalan-j_2_0_D01/bin/xalan.jar:/usr/local/src/xalan-j_2_0_D01/bin/xerces.jar
   java org.apache.xalan.xslt.Process -in <xsl:value-of select="$inputFile"/> -xsl article.xsl -out <xsl:value-of select="$outputFile" />
 </pre>
 </small>
</xsl:if>

   <!-- display any copyright information -->
  <hr width="50%" />
  <xsl:value-of select="copyright"/>

 </body>
 </html>
</xsl:template>

  <!-- kill the default handing of the copyright -->
<xsl:template match="copyright" />

<xsl:template match="title" mode="ok">
 <xsl:apply-templates />
</xsl:template>


<!-- Add a name=section-Number -->
<!-- 
  If there is a name attribute, we can use that as the name="" in the <a>
  -->
<xsl:template match="section">
 <h2> 
 <xsl:if test="not(@id='')">
  <xsl:element name="a">
    <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
  </xsl:element>
 </xsl:if>
  <xsl:element name="a">
    <xsl:attribute name="name">section-<xsl:number level="single" count="section" format="1" /></xsl:attribute>
   <xsl:number level="single" count="section" format="1" />. <xsl:value-of select="title" /> 
  </xsl:element>
 </h2>
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="appendix">
 <h2>
  <xsl:element name="a">
    <xsl:attribute name="name">appendix-<xsl:number level="single" count="appendix" format="A" /></xsl:attribute>
    Appendix  <xsl:number level="single" count="appendix" format="A" />. <xsl:value-of select="title" /> 
  </xsl:element>
 </h2>
  <xsl:apply-templates  />
</xsl:template>


 <!-- Like sections and appendices, we put a <a name=> element here and the name is 
      subsection-(section number)-(subsection-number).
      The visible title contains the subsection number only.
   -->
<xsl:template match="subsection">
 <xsl:element name="h3">
  <xsl:element name="a">
    <xsl:attribute name="name">subsection-<xsl:number level="any" count="section" format="A" />-<xsl:number level="single" count="subsection" format="1" /></xsl:attribute>
  </xsl:element>
   <xsl:number level="single" count="subsection" format="1" />. <xsl:value-of select="title" /> </xsl:element>
  <xsl:apply-templates  />
</xsl:template>


<xsl:template match="item">
 <li>
  <xsl:apply-templates />
 </li>
</xsl:template>


<xsl:template match="xmlAttrName">
 <b><xsl:apply-templates /></b>
</xsl:template>

<xsl:template match="ext">
 <i>.<xsl:apply-templates /></i>
</xsl:template>

<xsl:template match="itemize">
 <ul>
  <xsl:apply-templates />
 </ul>
</xsl:template>

<xsl:template match="texkywd">
 <b> \ <xsl:apply-templates /> </b>
</xsl:template>

<xsl:template match="sfunction">
 <code><b><xsl:apply-templates />() </b></code>
</xsl:template>


<xsl:template match="/article/abstract">
 <h2>Abstract</h2>
 <q><i>
   <xsl:apply-templates />
 </i></q>
<p/>
</xsl:template>




<!-- Bibliography section -->
<xsl:template match="bibliography">
 <h2><a name="Bibliography">Bibliography</a></h2>
 <ol>
  <xsl:apply-templates />
 </ol>
</xsl:template>


<!-- Expand a fragmentRef to be a hyperlink to the actual fragment,
     and make the visible text of the link be the value of the desc
     attribute if it is supplied or the id value of the target
     fragment otherwise.
  -->
<xsl:template match="fragmentRef" >
&lt;&lt;<xsl:element name="a">
  <xsl:attribute name="href">#<xsl:value-of select="@id"/></xsl:attribute> 
  <xsl:if test="@desc != ''"><xsl:value-of select="@desc"/></xsl:if>
  <xsl:if test="@desc = ''"><xsl:value-of select="@id"/></xsl:if>
</xsl:element>&gt;&gt;
</xsl:template>



<!-- General code tag and we output this as a PRE tag with a CSS class
     attribute whose value is the lang attribute of this XML code tag.
  -->
<xsl:template match="code[@lang]|fragment" name="code">
  <xsl:element name="pre">
   <xsl:attribute name="class">
      <xsl:value-of select="@lang" />
   </xsl:attribute>
     <xsl:apply-templates />
  </xsl:element>
</xsl:template>

<xsl:template match="verb" >
 <pre>
    <xsl:apply-templates />
 </pre>
</xsl:template>

<xsl:template match="fragment" >
 <xsl:element name="a"> 
  <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
   <br/>
   &lt;&lt;<xsl:value-of select="@id"/>&gt;&gt;
   <xsl:call-template name="code"/>
 </xsl:element>
</xsl:template>


<xsl:template match="file" >
 <i><xsl:apply-templates /></i>
</xsl:template>



<!-- Code for the S language. -->
<xsl:template match="code[@lang='S']|rs:function" >
  <pre class="S">
     <xsl:apply-templates />
  </pre>
</xsl:template>



<!-- Discard label elements in a description->item node -->
<xsl:template match="description/item/label" />
<xsl:template match="description/li/label" />

<xsl:template match="description/li/label|description/item/label" mode="description">
  <xsl:apply-templates />
</xsl:template>
<xsl:template match="description">
 <dl>
   <xsl:for-each select="./item|./li">
    <dt>
       <li><b><xsl:apply-templates select="label" mode="description" /></b></li>
    </dt>
    <dd>
       <xsl:apply-templates /> <!--  select="*[not(self::label)]" /> -->
    </dd>
   </xsl:for-each>
 </dl>
</xsl:template>

<xsl:template match="xmlTag">
 <b><xsl:apply-templates /></b>
</xsl:template>

<xsl:template match="xmlTag[@namespace]">
 <b><xsl:value-of select="@namespace"/>:<xsl:apply-templates /></b>
</xsl:template>

<xsl:template match="xmlAttrName">
 <font class="xmlAttr"><i><xsl:apply-templates /></i></font>
</xsl:template>



<xsl:template match="c:macro">
 <code class="cmacro"><xsl:apply-templates/></code>
</xsl:template>



<xsl:template match="i">
 <i><xsl:apply-templates/></i>
</xsl:template>


<xsl:template name="sectionRefTitle">
 <xsl:param name="id" />
 <xsl:apply-templates select="//section[@id=$id]/title" mode="ref"/>
</xsl:template>

<xsl:template match="title" mode="ref">
<xsl:apply-templates />
</xsl:template>



<xsl:template match="sectionRef">
 <xsl:element name="a">
  <xsl:attribute name="href">#<xsl:value-of select="@id"/></xsl:attribute>
<xsl:choose>
<xsl:when test="count(*) > 0">
 <xsl:apply-templates />
</xsl:when>
<xsl:when test="count(*) = 0">
section <xsl:call-template name="sectionRefTitle">
<xsl:with-param name="id"><xsl:value-of select="@id"/></xsl:with-param>
</xsl:call-template>
</xsl:when>
</xsl:choose>
 </xsl:element>

</xsl:template>

</xsl:stylesheet>

