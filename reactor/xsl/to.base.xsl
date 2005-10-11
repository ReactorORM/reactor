<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">
&lt;cfcomponent hint="I am the base TO object for the <xsl:value-of select="table/@name"/> table.  I am generated.  DO NOT EDIT ME."
	extends="<xsl:value-of select="table/@baseToSuper" />" &gt;
	
	&lt;cfset variables.signature = "<xsl:value-of select="table/@signature" />" /&gt;
	<xsl:for-each select="table/columns/column">&lt;cfset this.<xsl:value-of select="@name" /> = <xsl:value-of select="@default" /> /&gt;
	</xsl:for-each>
	&lt;cffunction name="getSignature"&gt;
		&lt;cfreturn variables.signature /&gt;
	&lt;/cffunction&gt;
	
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>