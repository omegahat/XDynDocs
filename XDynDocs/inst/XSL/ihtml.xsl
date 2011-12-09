<?xml version='1.0'?>
<!-- 
 This is used for converting our XML file into  HTML
 with interactive components that we can process with, e.g., wxWidgets
 to render the document interactively so that users can alter the 
 "inputs" and redo the computations.

  Plots are live/dynamic graphics devices.
  Code is (currently) run and the output displayed
  in a widget (if HTML then in an embedded widget
  and if just text in a text widget.)
  and the actual code is displayed in a secondary a widget.
  Depending on how this is rendered, these two displays
  might be in a draggable paned window or in a notebook
  with two tabs.
  displayed
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:r="http://www.r-project.org"
                xmlns:c="http://www.C.org"
                xmlns:s="http://cm.bell-labs.com/stat/S4"
                xmlns:omg="http://www.omegahat.org"
                xmlns:rwx="http://www.omegahat.org/RwxWidgets"
                xmlns:make="http://www.make.org"
                xmlns:sh="http://www.shell.org"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:i="http://www.statdocs.org/interactive"
		xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:html='http://www.w3.org/TR/REC-html40'
                exclude-result-prefixes="r i xlink"
                version='1.0'>




  <!-- Should we include the regular html.xsl and just override the rules we want.  -->
<xsl:import href="html.xsl"/>
<xsl:output method="html" omit-xml-declaration="yes" indent="yes" />

<!-- This is called by docbook's template for handling the overall document
      and is called within the body of the HTML document.  -->

<!--  No real need to do this as we are using the XML package in R and could  fetch the nodes
      directly, but for now we are still using this. But we ignore the interactive
      variables -->

<xsl:template name="user.header.content">
<r:codeDictionary>
  <!-- Get all the code nodes of interest which are the ones we want to evaluate.
       So exclude the ones inside an ignore node and also the ones with eval='false'.
       Here  we tell the processor how many nodes there are to allow for allocation of the 
       data structure of the right length ahead of time.   -->
 <xsl:attribute name="count">
     <xsl:value-of select="count((//r:code|//r:function|//r:plot|//r:dynOptions|//r:expr)[not(@eval = 'false') and not(ancestor::ignore)])"/> 
 </xsl:attribute>

 <!--  could discard nodes inside ignore or with eval='false', but not necessary
       as we can recognize eval='false' in R. But the ignore nodes do need to be processed. 
    can use xsl:apply-templates  select="//r:code|...." mode="" and have a rule for those.
    This will allow us to get the ids on also. If we just use copy-of on these, then the
    elements that don't have an id supplied by the author will be bare and we won't be able
    to match.  Note that when we apply-templates with mode="dictionary", the ids are still
    calculated relative to the positions in the entire document and not just in the subset and so 
    match the ids calculated in the regular mode.
   -->
<xsl:text>
</xsl:text>
   <xsl:apply-templates select="(//r:code|//r:function|//r:plot|//r:dynOptions|//r:expr)[not(@eval = 'false') and not(ancestor::ignore)]" mode="dictionary"/> 
   </r:codeDictionary>

   <!-- Give a list of the interactive components (that are not within an ignore node) -->
<xsl:text>
</xsl:text>
<i:interactiveVariables>
  <xsl:apply-templates select="//i:*[not(ancestor::ignore)]" mode="table"/>
<xsl:text>
</xsl:text>
</i:interactiveVariables>
<xsl:text>
</xsl:text>
</xsl:template>     <!-- user.header.content -->

<!-- Perhaps we just need the node name, var and the optional ref but for now, we copy the entire thing.  -->
<xsl:template match="//i:*" mode="table">
<xsl:text>
</xsl:text>
 <xsl:copy-of select="."/>
</xsl:template>						    


<!-- Process the r:* nodes with code for the codeDictionary which means to copy each and add an id 
     attribute if needed. -->
<xsl:template match="//r:code|//r:function|//r:plot|//r:dynOptions|//r:expr" mode="dictionary">
  <xsl:copy>
   <xsl:copy-of select="@*"/>
      <!-- caclulate and add an id attribute if the node doesn't already have one. -->
   <xsl:if test="not(@id)">
           <xsl:attribute name="id"><xsl:value-of select="name()"/>_<xsl:number level="any" />
           </xsl:attribute>
   </xsl:if>
   <xsl:apply-templates />
  </xsl:copy>
  <xsl:if test="not(@eval='false' or ancestor::ignore)">
  </xsl:if>
<xsl:text>
</xsl:text>
</xsl:template>


<xsl:param name="targetFormat">InteractiveHTML</xsl:param>


<xsl:template match="r:expr">
<xsl:call-template name="makeObject"/>
<!--
 <OBJECT type="app/x-R-expr">
     <xsl:copy-of select="."/>
 </OBJECT>
-->
</xsl:template>

<!-- Deal with the nodes that don't need to be eval'ed -->
<xsl:template match="r:function[@eval='false']">
<xsl:element name="PRE">
 <xsl:attribute name="class">rcode</xsl:attribute>
 <xsl:apply-templates/>
</xsl:element>
</xsl:template>

<xsl:template match="r:code[@eval='false']|r:test[@eval='false']|r:init[@eval='false']">
<xsl:element name="PRE">
 <xsl:attribute name="class">rcode</xsl:attribute>
 <xsl:apply-templates/>
</xsl:element>
</xsl:template>

<xsl:template name="makeObject">
          <!-- Potentially need to deal with chunks here. -->

 <xsl:param name="type"><xsl:value-of select="local-name(.)"/></xsl:param>

 <xsl:element name="OBJECT">
   <xsl:attribute name="type">app/x-R-<xsl:value-of select="$type"/></xsl:attribute>
     <!-- want to get rid of namespace : -->

   <xsl:attribute name="id"><xsl:if test="@id"><xsl:value-of select="@id"/></xsl:if>
                            <xsl:if test="not(@id)"><xsl:value-of select="name()"/>_<xsl:number level="any" /></xsl:if>
   </xsl:attribute>
   <xsl:apply-templates select="@*"/>

 </xsl:element>

<xsl:text>
</xsl:text>

<!-- Emit the i:* nodes  -->
<xsl:if test="count(./i:*) > 0">
 <xsl:element name="OBJECT">
    <xsl:attribute name="type">app/x-R-interactive</xsl:attribute>
       <!-- Connect to the R code. -->
    <xsl:attribute name="ref"><xsl:value-of select="name()"/>_<xsl:number level="any" /></xsl:attribute>
<!--   Rather than just copy the i:* elements, we loop over them and put each on its own line
      This is not important, just easier to read.  If we could kill off the xmlns:i, r, xlink, things would 
      be better.
       <xsl:copy-of select="./i:*"/> -->

       <xsl:text>
       </xsl:text>

    <xsl:for-each select="./i:*">
      <xsl:copy-of select="."/><xsl:text>
      </xsl:text>
    </xsl:for-each>

  </xsl:element>
</xsl:if>

</xsl:template>

<xsl:template match="r:function">
 <xsl:call-template name="makeObject">
   <xsl:with-param name="type">function</xsl:with-param>
 </xsl:call-template>
</xsl:template>

<xsl:template match="r:code|r:test|r:init">
 <xsl:call-template name="makeObject">
   <xsl:with-param name="type">code</xsl:with-param>
 </xsl:call-template>
</xsl:template>

<xsl:template match="r:plot">
 <xsl:call-template name="makeObject">
   <xsl:with-param name="type">plot</xsl:with-param>
 </xsl:call-template>
</xsl:template>

<xsl:template match="sh:code">
 <OBJECT type="app/x-R-shell-code">
     <xsl:copy-of select="."/>
 </OBJECT>
</xsl:template>

<xsl:template match="invisible|r:invisible">
  <xsl:copy-of select = "."/>
</xsl:template>

<!--  Kill off all the interactive specifications.  
<xsl:template match="i:*" />
-->

<xsl:template match="i:*" mode="strip-i" />

<xsl:template match="r:run" />

<!-- for <interactive, we might want to copy everything through but add a ref attribute to 
    each of the <i:*> nodes.  How can we do this easily.
   Otherwise, just leave the interactive go through as is and we will add an HTML tag handler
   that will fetch the ref value.


<xsl:template match="interactive">
 <xsl:copy-of select = "."/>
</xsl:template>
 -->


<!-- Work on the interactive node by putting in a count of the
     i:* nodes contained within it. (Note the .//i:*, not ./i:*
     since the i:* nodes are not direct children of interactive
 -->

<xsl:template match="interactive[@ref]">
  <xsl:copy>
    <xsl:attribute name="iCount"><xsl:value-of select="count(.//i:*)"/></xsl:attribute>
    <xsl:apply-templates select="@*" />
    <xsl:apply-templates select="node()"/>  
  </xsl:copy>
</xsl:template>

<xsl:template match="@*">
  <xsl:copy/>
</xsl:template>

<!-- For i: elements that do not have a ref="..." attribute, grab the one
     from the enclosing interactive node. 

     For wxHtml, we need to have the i:* elements as OBJECT tags to get them
     to be laid out properly within the HTML display.  Otherwise, they appear in
     strange places without the width and height allocated for them.
     So we change, e.g. from i:slider to OBJECT type="app/x-i-slider.
-->
<xsl:template match="i:*[not(@ref)]">
 <xsl:element name="object">
     <xsl:apply-templates select="@*"/>
     <xsl:attribute name="type">app/x-i-<xsl:value-of select="local-name(.)"/></xsl:attribute>
     <xsl:attribute name="ref"><xsl:value-of select="string(ancestor::interactive[@ref]/@ref)"/></xsl:attribute>
     <xsl:apply-templates/>
 </xsl:element>
</xsl:template>


<xsl:template match="r:output">
  <!-- Copy this. -->
</xsl:template>

<!--  Copy <a> elements. Need more. 
   Author should use <ulink url="">
   but is doing this inside an <interactive>
   node and so is using HTML.  So instead,
   we "encourage" them to declare the HTML
   namespace as xmlns='http://www.w3.org/TR/REC-html40'
   in the first HTML element or to use
    xmlns:html='http://www.w3.org/TR/REC-html40'
    <html:table><html:tr>...</html:tr></html:table>
-->
<xsl:template match="html:*">
     <!-- vitally important that this is copy and not copy-of so that the i:* tags, etc. get processed via the apply-templates  -->
  <xsl:copy select=".">
   <xsl:apply-templates />
  </xsl:copy>
</xsl:template>


       <!-- Kill off any r:code i:display='false' nodes. -->
<xsl:template match="r:code[@i:display='false']" />

</xsl:stylesheet>
