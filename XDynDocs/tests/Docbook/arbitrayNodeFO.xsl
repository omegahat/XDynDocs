<?xml version='1.0'?>
<!-- 
 This is used for converting our XML file into HTML
 and doing the R computations on the fly while this is being
 processed.
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:r="http://www.r-project.org"
                xmlns:s="http://cm.bell-labs.com/stat/S4"
                xmlns:omg="http://www.omegahat.org"
                xmlns:rwx="http://www.omegahat.org/RwxWidgets"
                xmlns:make="http://www.make.org"
                xmlns:sh="http://www.shell.org"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                extension-element-prefixes="r"
                exclude-result-prefixes="r s rwx fo sh omg make xsl"
                version='1.0'>

<xsl:import href="http://www.omegahat.org/IDynDocs/XSL/dynRFO.xsl"/>

<xsl:template match="/">
 <xsl:apply-templates />
</xsl:template>
</xsl:stylesheet>
