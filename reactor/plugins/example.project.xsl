<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">
&lt;cfcomponent hint="I am the object for the <xsl:value-of select="object/@alias"/> object.  I am generated.  DO NOT EDIT ME (but feel free to delete me)." &gt;
	&lt;cfset variables.signature = "<xsl:value-of select="object/@signature" />" /&gt;

	&lt;cffunction name="_configure" access="public" hint="I configure and return this object." output="false" returntype="any"  &gt;
		&lt;cfreturn this /&gt;
	&lt;/cffunction &gt;
	&lt;cffunction name="example" access="public" hint="I am an example method." output="false" returntype="any" _returntype="string"&gt;
		&lt;cfreturn "I am the result of the example method." /&gt;
	&lt;/cffunction&gt;

&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>