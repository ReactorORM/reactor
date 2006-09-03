<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">
&lt;cfcomponent hint="I am the base TO object for the <xsl:value-of select="object/@alias"/> object.  I am generated.  DO NOT EDIT ME (but feel free to delete me)."
	extends="reactor.base.abstractTo" &gt;
	<xsl:for-each select="object/fields/field">
		&lt;cfproperty name="<xsl:value-of select="@alias" />" type="<xsl:value-of select="@cfDataType" />" /&gt;
	</xsl:for-each>
	<xsl:for-each select="object/fields/externalField">
		<!-- this defaults all external fields as strings.  I know this is wrong and it needs to be fixed -->
		&lt;cfproperty name="<xsl:value-of select="@fieldAlias" />" type="<xsl:value-of select="@cfDataType" />" /&gt;
	</xsl:for-each>
	
	&lt;cfset variables.signature = "<xsl:value-of select="object/@signature" />" /&gt;
	
	<xsl:for-each select="object/fields/field">
		&lt;cfset this.<xsl:value-of select="@alias" /> = "<xsl:value-of select="@default" />" /&gt;
	</xsl:for-each>
	<xsl:for-each select="object/fields/externalField">
		<!-- external fields aren't getting a default yet either -->
		&lt;cfset this.<xsl:value-of select="@fieldAlias" /> = "<xsl:value-of select="@default" />" /&gt;
	</xsl:for-each>
	
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>
