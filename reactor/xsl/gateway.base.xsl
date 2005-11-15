<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">
&lt;cfcomponent hint="I am the base Gateway object for the <xsl:value-of select="object/@name"/> table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractGateway" &gt;
	
	&lt;cfset variables.signature = "<xsl:value-of select="object/@signature" />" /&gt;
	&lt;cfset variables.dbUniqueIdentifierType = "uniqueidentifier" &gt;
	
	&lt;cffunction name="createCriteria" access="public" hint="I return a critera object which can be used to compose and execute complex queries on this gateway." output="false" return="reactor.query.criteria"&gt;
		&lt;cfset var criteria = CreateObject("Component", "reactor.query.criteria").init(getObjectFactory().create("<xsl:value-of select="object/@name" />", "Metadata")) /&gt;
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
		
		
		&lt;!--- cfquery name="qGet" datasource="#getConfig().getDsn()#"&gt;
			SELECT 
				<xsl:for-each select="object/columns/column">
					<xsl:choose>
						<xsl:when test="@dbDataType = 'uniqueidentifier'">
							Stuff(Convert(varchar(36), [<xsl:value-of select="../../@name" />].[<xsl:value-of select="@name" />]), 24, 1, '') as [<xsl:value-of select="@name" />]
						</xsl:when>
						<xsl:otherwise>
							[<xsl:value-of select="../../@name" />].[<xsl:value-of select="@name" />]
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="position() != last()">,</xsl:if>				
				</xsl:for-each>
			FROM [<xsl:value-of select="object/@database" />].[<xsl:value-of select="object/@owner" />].[<xsl:value-of select="object/@name" />] 
			WHERE 1=1
				<xsl:for-each select="object/columns/column">
					&lt;cfif IsDefined('arguments.<xsl:value-of select="@name" />')&gt;
						AND [<xsl:value-of select="../../@name" />].[<xsl:value-of select="@name" />] = &lt;cfqueryparam cfsqltype="<xsl:value-of select="@cfSqlType" />"<xsl:if test="@length > 0"> scale="<xsl:value-of select="@length" />"</xsl:if> value="<xsl:choose>
							<xsl:when test="@dbDataType = 'uniqueidentifier'">#Left(arguments.<xsl:value-of select="@name" />, 23)#-#Right(arguments.<xsl:value-of select="@name" />, 12)#</xsl:when>
							<xsl:otherwise>#arguments.<xsl:value-of select="@name" />#</xsl:otherwise>
						</xsl:choose>"<xsl:if test="@nullable = 'true'"> null="#Iif(NOT Len(arguments.<xsl:value-of select="@name" />), DE(true), DE(false))#"</xsl:if> /&gt;
					&lt;/cfif&gt;
				</xsl:for-each>
		&lt;/cfquery&gt;
		
		&lt;cfreturn qGet / ---&gt;
	&lt;/cffunction&gt;
	
	&lt;!--- cffunction name="getByCriteria" access="public" hint="I return all matching rows from the <xsl:value-of select="object/@name" /> table." output="false" returntype="query"&gt;
		&lt;cfargument name="Criteria" hint="I am optional criteria to apply to this query." required="no" default="#CreateObject("Component", "reactor.core.criteria")#" /&gt;
		&lt;cfset var sqlStart = "" /&gt;
		&lt;cfset var sqlEnd = "" /&gt;
		
		&lt;cfsavecontent variable="sqlStart"&gt;
			SELECT 
				&lt;cfif arguments.Criteria.getDistinct()&gt;DISTINCT&lt;/cfif&gt;	
				<xsl:for-each select="object/columns/column">
					<xsl:choose>
						<xsl:when test="@dbDataType = 'uniqueidentifier'">
							Stuff(Convert(varchar(36), [<xsl:value-of select="../../@name" />].[<xsl:value-of select="@name" />]), 24, 1, '') as [<xsl:value-of select="@name" />]
						</xsl:when>
						<xsl:otherwise>
							[<xsl:value-of select="../../@name" />].[<xsl:value-of select="@name" />]
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="position() != last()">,</xsl:if>				
				</xsl:for-each>
			FROM [<xsl:value-of select="object/@database" />].[<xsl:value-of select="object/@owner" />].[<xsl:value-of select="object/@name" />] 
		&lt;/cfsavecontent&gt;
		
		&lt;cfreturn super.getByCriteria(arguments.Criteria, sqlStart, sqlEnd) /&gt;
	&lt;/cffunction ---&gt;
	
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>