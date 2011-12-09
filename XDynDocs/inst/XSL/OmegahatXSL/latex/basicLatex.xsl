<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:s="http://cm.bell-labs.com/stat/S4"
        xmlns:r="http://www.r-project.org"
	xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
	xmlns:omg="http://www.omegahat.org"
	xmlns:bioc="http://www.bioconductor.org"
	xmlns:xml="http://www.w3.org/XML/1998/namespace"
	xmlns:svg="http://www.w3.org/2000/svg" 
	xmlns:js="http://www.ecma-international.org/publications/standards/Ecma-262.htm"
        xmlns:str="http://exslt.org/strings"
	exclude-result-prefixes="doc str" version='1.0'
    >

<xsl:import href="dblatex.xsl"/>

<xsl:import href="js.xsl"/>
<xsl:import href="xpath.xsl"/>


<xsl:include href="latex.xsl"/>
<xsl:include href="entities.xsl"/>

<xsl:include href="../common/fileRefs.xsl"/>
<xsl:include href="svg.xsl"/>
<xsl:include href="xml.xsl"/>

<xsl:include href="table.xsl"/>

<xsl:include href="sh.xsl"/>
<xsl:include href="xsl.xsl"/>

<xsl:include href="languages.xsl"/>


<xsl:output method="text" omit-xml-declaration="yes"/>

<xsl:param name="latex.macro.file">latexMacros</xsl:param>
<xsl:param name="load.cprotect" select="1"/>

<!-- <xsl:strip-space elements="*"/>  -->
<xsl:preserve-space elements="*"/>
<xsl:strip-space elements="
abstract affiliation anchor answer appendix area areaset areaspec
artheader article audiodata audioobject author authorblurb authorgroup
beginpage bibliodiv biblioentry bibliography biblioset blockquote book
bookbiblio bookinfo callout calloutlist caption caution chapter
citerefentry cmdsynopsis co collab colophon colspec confgroup
copyright dedication docinfo editor entry entrytbl epigraph equation
example figure footnote footnoteref formalpara funcprototype
funcsynopsis glossary glossdef glossdiv glossentry glosslist graphicco
group highlights imagedata imageobject imageobjectco important index
indexdiv indexentry indexterm informalequation informalexample
informalfigure informaltable inlineequation inlinemediaobject
itemizedlist itermset keycombo keywordset legalnotice listitem lot
mediaobject mediaobjectco menuchoice msg msgentry msgexplan msginfo
msgmain msgrel msgset msgsub msgtext note objectinfo
orderedlist othercredit part partintro preface printhistory procedure
programlistingco publisher qandadiv qandaentry qandaset question
refentry reference refmeta refnamediv refsect1 refsect1info refsect2
refsect2info refsect3 refsect3info refsynopsisdiv refsynopsisdivinfo
revhistory revision row sbr screenco screenshot sect1 sect1info sect2
sect2info sect3 sect3info sect4 sect4info sect5 sect5info section
sectioninfo seglistitem segmentedlist seriesinfo set setindex setinfo
shortcut sidebar simplelist simplesect spanspec step subject
subjectset substeps synopfragment table tbody textobject tfoot tgroup
thead tip toc tocchap toclevel1 toclevel2 toclevel3 toclevel4
toclevel5 tocpart varargs variablelist varlistentry videodata
videoobject void warning subjectset

classsynopsis
constructorsynopsis
destructorsynopsis
fieldsynopsis
methodparam
methodsynopsis
ooclass
ooexception
oointerface
simplemsgentry
"/>

<!-- 
   <xsl:preserve-space elements="text()"/>
-->

<xsl:template match="comment()">%</xsl:template>
<xsl:template match="comment()"/>
<xsl:template match="comment()[following-sibling::figure]">%<xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="caption//comment()">%</xsl:template>


<xsl:template match="text()[not(ancestor::r:code) and not(ancestor::r:output) and not(ancestor::xml:code) and not(ancestor::js:code) and not(ancestor::svg:code)]"><xsl:value-of select="str:replace(str:replace(str:replace(string(.), '&amp;', '\&amp;'), '_', '\_'), '#', '\#')"/></xsl:template>

<xsl:template name="replace-leading-newlines">
<xsl:param name="string"/>
<xsl:message>string = '<xsl:value-of select="$string"/>'</xsl:message>
<xsl:choose><xsl:when test="substring($string, 1, 1) = '&#10;'">
  <xsl:call-template name="replace-leading-newlines">
   <xsl:with-param name="string" select="substring($string, 2)"/>
  </xsl:call-template>
</xsl:when>
<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="xpara/text()"><xsl:value-of select="translate(string(.), '&#10;', ' ')"/></xsl:template>


<!-- Remove any new line at the end -->
<!--
<xsl:template match="para/text()[local-name(following-sibling::*[1]) = 'code' and
substring(., string-length(.) -1, string-length(.)) = '&#10;']"><xsl:message>trailing para/text() '<xsl:value-of select="translate(., '&#10;', 'X')"/>'</xsl:message><xsl:value-of select="substring(., 1, string-length(.)-2)"/></xsl:template>

<xsl:template match="para/text()[local-name(preceding-sibling::*[1]) = 'code' and substring(., 1, 1) = '&#10;']"><xsl:message>preceding para/text() '<xsl:value-of select="."/>'</xsl:message><xsl:call-template name="replace-leading-newlines"><xsl:with-param name="string" select="substring(., 2, string-length(.))"/></xsl:call-template></xsl:template>
-->


<!--
<xsl:template match="text()[normalize-space()]">
<xsl:value-of select="normalize-space()"/>
</xsl:template>

<xsl:template match="text()[not(normalize-space())]" />
-->
<xsl:param name="bibliog.file" />

<xsl:param name="doc.class">{article}</xsl:param>

<xsl:template match="/article">
\documentclass<xsl:value-of select="$doc.class"/>
\usepackage[authoryear,round]{natbib}
\usepackage{hyperref}
\usepackage{graphicx}
\usepackage{caption}
\usepackage{listings}
\usepackage{enumerate}

%\usepackage{times}
%\usepackage{fullpage}
\usepackage{supertabular}

<xsl:if test="(//caption//r:expr | //caption//r:formula) or $load.cprotect > 0">
\usepackage{cprotect}
</xsl:if>


% From http://stackoverflow.com/questions/741985/latex-source-code-listing-like-in-professional-books
%\usepackage{beramono}  % This messes up the regular verbatim mode.
\lstset {                 % A rudimentary config that shows off some features.
    basicstyle=\ttfamily, % Without beramono, we'd get cmtt, the teletype font.
    commentstyle=\textit, % cmtt doesn't do italics. It might do slanted text though.
    tabsize=4            % Or whatever you use in your editor, I suppose.
}

% These and \author and \PlainAuthor interact with each other.
%\usepackage{colortbl}
%\usepackage{dbk_table}

\usepackage{appendix}
\usepackage{fancyvrb}
\usepackage{float}
\usepackage{tabularx}

\def\hyperlabel#1{}

<xsl:if test="//example">
\newcounter{example}
\newenvironment{example}[1][]{\refstepcounter{example}\par\medskip\noindent%
   \textbf{Example~\theexample. #1} \rmfamily}{\medskip}
</xsl:if>

<xsl:apply-templates select="./articleinfo/authorgroup|./articleinfo/author"/>
<xsl:apply-templates select="./articleinfo//abstract|./abstract"/>
<xsl:apply-templates select="./articleinfo//title|./title"/>
<xsl:apply-templates select="./articleinfo//titleabbrev|./titleabbrev"/>
<xsl:apply-templates select="./articleinfo//keywordset | ./articleinfo//keywords"/>

\Address{
<xsl:apply-templates select="./articleinfo//author/address"/>
}

\input{<xsl:value-of select="$latex.macro.file"/>}

\begin{document}

<xsl:apply-templates select="./chapter | ./section | ./ackno | ./bibliography | ./appendix"/>

\end{document}
</xsl:template>


<xsl:template match="authorgroup">
\author{<xsl:for-each select="./author"><xsl:apply-templates select="."/>
<xsl:if test="not(position() = last())"><xsl:text> \And 
</xsl:text></xsl:if></xsl:for-each>}
</xsl:template>


<xsl:template match="keywordset|keywords">

</xsl:template>

<xsl:template match="keyword" mode="plain">
<xsl:message>plain keyword  <xsl:value-of select="string(.)"/></xsl:message>
<xsl:apply-templates select=".//text()"/>
</xsl:template>

<!-- Like to be able to do this more generically -->
<xsl:template match="js" mode="plain">JavaScript</xsl:template>


<xsl:template match="articleinfo/title">
\title{<xsl:apply-templates/>}
</xsl:template>

<xsl:template match="author/affiliation">
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="author">
\author{
<xsl:apply-templates select="firstname"/><xsl:text> </xsl:text><xsl:apply-templates select="surname"/> \\
  <xsl:apply-templates select="affiliation"/>
}
</xsl:template>

<!-- 
<xsl:template match="figure">
\begin{figure}[H]
\begin{center}
<xsl:apply-templates/>
\end{center}
\label{<xsl:value-of select="@id"/>}
\end{figure}
</xsl:template>
 -->

<xsl:template match="r:makePlot">
\includegraphics{<xsl:call-template name="makeFileRef"><xsl:with-param name="path"><xsl:value-of select="graphic/@fileref"/></xsl:with-param></xsl:call-template>}
</xsl:template>

<xsl:template match="r:makePlot[contains(graphic/@fileref, '.svg')]">
<xsl:apply-templates select="graphic"/>
</xsl:template>

<xsl:template match="caption">
<xsl:if test="//r:expr|//r:formula">\cprotect</xsl:if>\caption{<xsl:apply-templates/>}
\label{<xsl:value-of select="ancestor::figure/@id"/>}
</xsl:template>

<xsl:template match="dyngraphic"/>
<xsl:template match="comment"/>

<xsl:template match="omg:pkg">\OmgPackage{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="bioc:pkg">\BioCPackage{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="r:slot">\Rslot{<xsl:apply-templates/>}</xsl:template>


<xsl:template match="bibliography">
<xsl:choose>
<xsl:when test="$bibliog.file = ''">
<xsl:message>bibliography file not set (bibliog.file)</xsl:message>
</xsl:when>
<xsl:otherwise>
\clearpage

\bibliography{<xsl:value-of select="$bibliog.file"/>} 
</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="biblioref">\citep{<xsl:value-of select="@linkend"/>}</xsl:template>


<xsl:template match="quote">``<xsl:apply-templates/>''</xsl:template>
<xsl:template match="para"><xsl:apply-templates/>
</xsl:template>

<xsl:template match="figure/title[following-sibling::caption]"/>

<xsl:template match="caption[.//listitem] | caption[count(.//para) > 1]">
\captionsetup{singlelinecheck=off}
\caption[list=off]{<xsl:apply-templates/>}
\label{<xsl:value-of select="ancestor::figure/@id"/>}
</xsl:template>

<xsl:template match="example">
\begin{example}{<xsl:apply-templates select="./title" mode="eg"/>}\label{<xsl:value-of select="@id"/>}
<xsl:apply-templates />  <!-- select="*[not(name() = 'title')] | text()"/>	 -->
\end{example}
</xsl:template>

<xsl:template match="example/title"/>
<xsl:template match="example/title" mode="eg"><xsl:apply-templates/></xsl:template>


<xsl:template match="section[./title/*]">
\section[<xsl:apply-templates select="./title/text()"/>]{<xsl:apply-templates select="./title/*|./title/text()"/>}\label{<xsl:value-of select="@id"/>}<xsl:apply-templates />					
</xsl:template>

<xsl:template match="appendix[./title/*]">
  <xsl:if test="not (preceding-sibling::appendix)">
    <xsl:text>% ---------------------&#10;</xsl:text>
    <xsl:text>% Appendixes start here&#10;</xsl:text>
    <xsl:text>% ---------------------&#10;</xsl:text>
    <xsl:text>\begin{appendices}&#10;</xsl:text> 
    <xsl:text>\appendix&#10;</xsl:text>
  </xsl:if>
\section[<xsl:apply-templates select="./title/text()"/>]{<xsl:apply-templates select="./title/*|./title/text()"/>}\label{<xsl:value-of select="@id"/>}<xsl:apply-templates />					

  <xsl:if test="not (following-sibling::appendix)">
    <xsl:text>&#10;\end{appendices}&#10;</xsl:text>
  </xsl:if>
</xsl:template>


<xsl:template match="graphic">
\includegraphics{<xsl:call-template name="makeFileRef"><xsl:with-param name="path"><xsl:value-of select="@fileref"/></xsl:with-param></xsl:call-template>}
</xsl:template>


<xsl:template match="graphic[contains(@fileref, '.svg')]">
\includegraphics{<xsl:call-template name="makeFileRef"><xsl:with-param name="path"><xsl:value-of select="substring-before(@fileref, '.svg')"/>.png</xsl:with-param></xsl:call-template>}
</xsl:template>


<xsl:template match="graphic[contains(@fileref, '.jpg')]">
\includegraphics{<xsl:call-template name="makeFileRef"><xsl:with-param name="path"><xsl:value-of select="@fileref"/></xsl:with-param></xsl:call-template>}
</xsl:template>


<!--
<xsl:template match="text()[ancestor::caption]">
<xsl:value-of select="normalize-space(.)"/>
</xsl:template>
-->



<xsl:template match="programlisting">\begin{verbatim}
<xsl:apply-templates /> 
\end{verbatim}</xsl:template>



<xsl:template match="orderedlist">
\begin{enumerate}<xsl:call-template name="orderedListFormat"/>
<xsl:apply-templates />
\end{enumerate}
</xsl:template>

<xsl:template name="orderedListFormat">
<xsl:if test="@numeration">
[<xsl:if test="@numeration = 'lowerroman'">i</xsl:if>]
</xsl:if>
</xsl:template>


<xsl:template match="note">
\begin{quote}
 Note: <xsl:apply-templates/>
\end{quote}
</xsl:template>


<!-- Not certain why match="citation/biblioref" doesn't work -->
<xsl:template match="citation[biblioref]">\citep{<xsl:value-of select="biblioref/@linkend"/>}</xsl:template>


<xsl:template match="fix|check"/>

<xsl:template match="sup">$^{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="sub">$_{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="title/subtitle">\\<xsl:text>&#10;</xsl:text><xsl:apply-templates/></xsl:template>

<xsl:template match="dso">\DSO{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="proj">\Project{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="r:na">\texttt{NA}</xsl:template>

<xsl:template match="directory|dir">\texttt{<xsl:apply-templates/>/}</xsl:template>

</xsl:stylesheet>
