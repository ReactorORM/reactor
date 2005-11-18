<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">
&lt;cfcomponent hint="I am the base TO object for the <xsl:value-of select="object/@name"/><xsl:text> </xsl:text><xsl:value-of select="object/@type"/>.  I am generated.  DO NOT EDIT ME."
	extends="<xsl:choose>
		<xsl:when test="count(object/super)"><xsl:value-of select="object/@mapping"/>.To.<xsl:value-of select="object/@dbms"/>.<xsl:value-of select="object/super/@name"/>To</xsl:when>
		<xsl:otherwise>reactor.base.abstractTo</xsl:otherwise>
	</xsl:choose>" &gt;
	
	&lt;cfset variables.signature = "<xsl:value-of select="object/@signature" />" /&gt;
	<xsl:for-each select="object/fields/field">
		&lt;cfset this.<xsl:value-of select="@name" /> = "<xsl:value-of select="@default" />" /&gt;
	</xsl:for-each>
	
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>