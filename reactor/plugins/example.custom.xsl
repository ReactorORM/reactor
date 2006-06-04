<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">
&lt;cfcomponent hint="I am the <xsl:value-of select="object/@dbms"/> custom Example object for the <xsl:value-of select="object/@alias"/> object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="<xsl:value-of select="object/@alias"/>Example" &gt;
	&lt;!--- Place custom code here, it will not be overwritten ---&gt;
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>