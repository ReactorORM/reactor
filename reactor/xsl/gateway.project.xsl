<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">
&lt;cfcomponent hint="I am the base Gateway object for the <xsl:value-of select="object/@alias"/> object.  I am generated.  DO NOT EDIT ME (but feel free to delete me)."
	extends="reactor.base.abstractGateway" &gt;
	
	&lt;cfset variables.signature = "<xsl:value-of select="object/@signature" />" /&gt;

	&lt;cffunction name="getAll" access="public" hint="I return all rows from the <xsl:value-of select="object/@name" /> table." output="false" returntype="query"&gt;
		&lt;cfargument name="sortByFieldList" hint="I am a comma sepeared list of fields to sort this query by." required="no" type="string" default="" /&gt;
		&lt;cfreturn getByFields(sortByFieldList=arguments.sortByFieldList) /&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="getByFields" access="public" hint="I return all matching rows from the <xsl:value-of select="object/@name" /> table." output="false" returntype="query"&gt;
		<xsl:for-each select="//field">
			&lt;cfargument name="<xsl:value-of select="@alias" />" hint="If provided, I match the provided value to the <xsl:value-of select="@alias" /> field in the <xsl:value-of select="/object/@alias" /> object." required="no" type="string" /&gt;
		</xsl:for-each>
		&lt;cfargument name="sortByFieldList" hint="I am a comma sepeared list of fields to sort this query by." required="no" type="string" default="" /&gt;
		&lt;cfset var Query = createQuery() /&gt;
		&lt;cfset var Where = Query.getWhere() /&gt;
		&lt;cfset var x = 0 /&gt;
		
		<xsl:for-each select="//field">
			&lt;cfif IsDefined('arguments.<xsl:value-of select="@alias" />')&gt;
				&lt;cfset Where.isEqual(
					<xsl:choose>
						<xsl:when test="string-length(/object/@alias) &gt; 0">
							"<xsl:value-of select="/object/@alias" />"
						</xsl:when>
						<xsl:otherwise>
							"<xsl:value-of select="/object/@name" />"
						</xsl:otherwise>
					</xsl:choose>
				, "<xsl:value-of select="@alias" />", arguments.<xsl:value-of select="@alias" />) /&gt;
			&lt;/cfif&gt;
		</xsl:for-each>
		
		&lt;cfloop list="#arguments.sortByFieldList#" index="x"&gt;
			&lt;cfset Query.getOrder().setAsc("<xsl:value-of select="object/@alias" />", trim(x)) /&gt;
		&lt;/cfloop&gt;
		
		&lt;cfreturn getByQuery(Query,true) /&gt;
	&lt;/cffunction&gt;
	
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>