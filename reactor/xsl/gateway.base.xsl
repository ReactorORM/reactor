<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">
&lt;cfcomponent hint="I am the base Gateway object for the <xsl:value-of select="object/@name"/> table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractGateway" &gt;
	
	&lt;cfset variables.signature = "<xsl:value-of select="object/@signature" />" /&gt;
	&lt;cfset variables.dbUniqueIdentifierType = "uniqueidentifier" &gt;
	
	&lt;cffunction name="createCriteria" access="public" hint="I return a critera object which can be used to compose and execute complex queries on this gateway." output="false" return="reactor.query.criteria"&gt;
		&lt;cfset var criteria = CreateObject("Component", "reactor.query.criteria").init(_getObjectFactory().create("<xsl:value-of select="object/@name" />", "Metadata")) /&gt;
		&lt;cfreturn criteria /&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="getAll" access="public" hint="I return all rows from the <xsl:value-of select="object/@name" /> table." output="false" returntype="query"&gt;
		&lt;cfreturn getByFields() /&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="getByFields" access="public" hint="I return all matching rows from the <xsl:value-of select="object/@name" /> table." output="false" returntype="query"&gt;
		<xsl:for-each select="//column[@overridden = 'false']">
			&lt;cfargument name="<xsl:value-of select="@name" />" hint="If provided, I match the provided value to the <xsl:value-of select="@name" /> column in the <xsl:value-of select="/object/@name" /> table." required="no" type="string" /&gt;
		</xsl:for-each>
		&lt;cfset var Criteria = createCriteria() /&gt;
		&lt;cfset var Expression = criteria.getExpression() /&gt;
		
		<xsl:for-each select="//column[@overridden = 'false']">
			&lt;cfif IsDefined('arguments.<xsl:value-of select="@name" />')&gt;
				&lt;cfset expression.isEqual("<xsl:value-of select="@name" />", arguments.<xsl:value-of select="@name" />) /&gt;
			&lt;/cfif&gt;
		</xsl:for-each>
		
		&lt;cfreturn getByCriteria(Criteria) /&gt;
	&lt;/cffunction&gt;
	
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>