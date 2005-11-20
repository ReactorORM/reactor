<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">
&lt;cfcomponent hint="I am the custom Record object for the <xsl:value-of select="table/@name"/> table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="<xsl:value-of select="object/@mapping"/>.Record.<xsl:value-of select="object/@dbms"/>.base.<xsl:value-of select="object/@name"/>Record" &gt;
	&lt;!--- Place custom code here, it will not be overwritten ---&gt;
	
	&lt;cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection"&gt;
		&lt;cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" /&gt;
		&lt;cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) /&gt;
		&lt;cfset super.validate(arguments.ValidationErrorCollection) /&gt;
		
		&lt;!--- Add custom validation logic here, it will not be overwritten ---&gt;
		
		&lt;cfreturn arguments.ValidationErrorCollection /&gt;
	&lt;/cffunction&gt;
	
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>