<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">
&lt;cfcomponent hint="I am the base Gateway object for the <xsl:value-of select="object/@name"/> table.  I am generated.  DO NOT EDIT ME (but feel free to delete me)."
	extends="reactor.base.abstractGateway" &gt;
	
	&lt;cfset variables.signature = "<xsl:value-of select="object/@signature" />" /&gt;

	&lt;cffunction name="getAll" access="public" hint="I return all rows from the <xsl:value-of select="object/@name" /> table." output="false" returntype="query"&gt;
		&lt;cfreturn getByFields() /&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="getByFields" access="public" hint="I return all matching rows from the <xsl:value-of select="object/@name" /> table." output="false" returntype="query"&gt;
		<xsl:for-each select="//field[@overridden = 'false']">
			&lt;cfargument name="<xsl:value-of select="@name" />" hint="If provided, I match the provided value to the <xsl:value-of select="@name" /> field in the <xsl:value-of select="/object/@name" /> table." required="no" type="string" /&gt;
		</xsl:for-each>
		&lt;cfset var Query = createQuery() /&gt;
		&lt;cfset var Where = Query.getWhere() /&gt;
		
		<xsl:for-each select="//field[@overridden = 'false']">
			&lt;cfif IsDefined('arguments.<xsl:value-of select="@name" />')&gt;
				&lt;cfset Where.isEqual(
					<xsl:choose>
						<xsl:when test="string-length(../../../@alias) &gt; 0">
							"<xsl:value-of select="../../../@alias" />"
						</xsl:when>
						<xsl:otherwise>
							"<xsl:value-of select="../../@name" />"
						</xsl:otherwise>
					</xsl:choose>
				, "<xsl:value-of select="@name" />", arguments.<xsl:value-of select="@name" />) /&gt;
			&lt;/cfif&gt;
		</xsl:for-each>
		
		&lt;cfreturn getByQuery(Query) /&gt;
	&lt;/cffunction&gt;
	
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>