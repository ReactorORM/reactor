<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">
&lt;cfcomponent hint="I am the base TO object for the <xsl:value-of select="table/@name"/> table.  I am generated.  DO NOT EDIT ME."
	extends="<xsl:choose>
		<xsl:when test="table/@name = table/@baseTable">reactor.core.abstractTo</xsl:when>
		<xsl:when test="table/@name != table/@baseTable"><xsl:value-of select="table/@customToBase" /></xsl:when>
	</xsl:choose>" &gt;
	
	&lt;cfset variables.signature = "<xsl:value-of select="table/@signature" />" /&gt;
	&lt;cfset variables.existsInDb = false />
	<xsl:for-each select="table/columns/column">&lt;cfset this.<xsl:value-of select="@name" /> = <xsl:choose>
		<xsl:when test="@type = 'int'">0</xsl:when>
		<xsl:when test="@type = 'bigint'">0</xsl:when>
		<xsl:when test="@type = 'bit'">0</xsl:when>
		<xsl:when test="@type = 'decimal'">0</xsl:when>
		<xsl:when test="@type = 'float'">0</xsl:when>
		<xsl:when test="@type = 'money'">0</xsl:when>
		<xsl:when test="@type = 'numeric'">0</xsl:when>
		<xsl:when test="@type = 'real'">0</xsl:when>
		<xsl:when test="@type = 'smallint'">0</xsl:when>
		<xsl:when test="@type = 'smallmoney'">0</xsl:when>
		<xsl:when test="@type = 'timestamp'">0</xsl:when>
		<xsl:when test="@type = 'tinyint'">0</xsl:when>
		<xsl:otherwise>""</xsl:otherwise>
	</xsl:choose> /&gt;
	</xsl:for-each>
	&lt;cffunction name="getSignature"&gt;
		&lt;cfreturn variables.signature /&gt;
	&lt;/cffunction&gt;
	
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>