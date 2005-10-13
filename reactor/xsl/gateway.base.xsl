<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">
&lt;cfcomponent hint="I am the base Gateway object for the <xsl:value-of select="table/@name"/> table.  I am generated.  DO NOT EDIT ME."
	extends="<xsl:value-of select="table/@baseGatewaySuper" />" &gt;
	
	&lt;cfset variables.signature = "<xsl:value-of select="table/@signature" />" /&gt;
		
	&lt;cffunction name="getAll" access="public" hint="I return all rows from the <xsl:value-of select="table/@name" /> table." output="false" returntype="query"&gt;
		&lt;cfreturn getByFields() /&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="getByFields" access="public" hint="I return all matching rows from the <xsl:value-of select="table/@name" /> table." output="false" returntype="query"&gt;
		<xsl:for-each select="table/superTables[@sort = 'backward']//columns/column[@overridden = 'false']">&lt;cfargument name="<xsl:value-of select="@name" />" hint="If provided, I match the provided value to the <xsl:value-of select="@name" /> column in the <xsl:value-of select="../../@toTable" /> table." required="no" type="string" /&gt;
		</xsl:for-each>
		<xsl:for-each select="table/columns/column">&lt;cfargument name="<xsl:value-of select="@name" />" hint="If provided, I match the provided value to the <xsl:value-of select="@name" /> column in the <xsl:value-of select="/table/@name" /> table." required="no" type="string" /&gt;
		</xsl:for-each>&lt;cfset var qGet = 0 /&gt;
		
		&lt;cfquery name="qGet" datasource="#getConfig().getDsn()#"&gt;
			SELECT 
				<xsl:for-each select="table/superTables[@sort = 'backward']//columns/column">[<xsl:value-of select="../../@toTable" />].[<xsl:value-of select="@name" />],
				</xsl:for-each>
				<xsl:for-each select="table/columns/column">[<xsl:value-of select="../../@name" />].[<xsl:value-of select="@name" />]<xsl:if test="position() != last()">, 
				</xsl:if>
				</xsl:for-each>
			FROM [<xsl:value-of select="table/@name" />] <xsl:for-each select="table/superTables[@sort = 'backward']/superTable/relationship/column">JOIN [<xsl:value-of select="../../@toTable" />]
				ON [<xsl:value-of select="../../@fromTable" />].[<xsl:value-of select="@name" />] = [<xsl:value-of select="../../@toTable" />].[<xsl:value-of select="@referencedColumn" />]
			</xsl:for-each>WHERE 1=1
				<xsl:for-each select="table/superTables[@sort = 'backward']//columns/column">&lt;cfif IsDefined('arguments.<xsl:value-of select="@name" />')&gt;
					AND [<xsl:value-of select="../../@toTable" />].[<xsl:value-of select="@name" />] = &lt;cfqueryparam cfsqltype="<xsl:value-of select="@cfSqlType" />"<xsl:if test="@length > 0"> scale="<xsl:value-of select="@length" />"</xsl:if> value="#arguments.<xsl:value-of select="@name" />#"<xsl:if test="@nullable = 'true'"> null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@name" />), DE(true), DE(false))#"</xsl:if> /&gt;
				&lt;/cfif&gt;
				</xsl:for-each>
				<xsl:for-each select="table/columns/column">&lt;cfif IsDefined('arguments.<xsl:value-of select="@name" />')&gt;
					AND [<xsl:value-of select="../../@name" />].[<xsl:value-of select="@name" />] = &lt;cfqueryparam cfsqltype="<xsl:value-of select="@cfSqlType" />"<xsl:if test="@length > 0"> scale="<xsl:value-of select="@length" />"</xsl:if> value="#arguments.<xsl:value-of select="@name" />#"<xsl:if test="@nullable = 'true'"> null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@name" />), DE(true), DE(false))#"</xsl:if> /&gt;
				&lt;/cfif&gt;
				</xsl:for-each>
		&lt;/cfquery&gt;
		
		&lt;cfreturn qGet /&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="getByCriteria" access="public" hint="I return all matching rows from the <xsl:value-of select="table/@name" /> table." output="false" returntype="query"&gt;
		&lt;cfargument name="Criteria" hint="I am optional criteria to apply to this query." required="no" default="#CreateObject("Component", "reactor.core.criteria")#" /&gt;
		&lt;cfset var qGet = 0 /&gt;

		&lt;cfquery name="qGet" datasource="#getConfig().getDsn()#" maxrows="#arguments.Criteria.getMaxRows()#" cachedwithin="#arguments.Criteria.getCachedWithin()#" &gt;
			SELECT 
				&lt;cfif arguments.Criteria.getDistinct()&gt;DISTINCT&lt;/cfif&gt;				
				&lt;cfif Len(arguments.Criteria.getFieldList())&gt;
					#arguments.Criteria.getFieldList()#
				&lt;cfelse&gt;
					<xsl:for-each select="table/superTables[@sort = 'backward']//columns/column">[<xsl:value-of select="../../@toTable" />].[<xsl:value-of select="@name" />],
					</xsl:for-each>
					<xsl:for-each select="table/columns/column">[<xsl:value-of select="../../@name" />].[<xsl:value-of select="@name" />]<xsl:if test="position() != last()">, 
					</xsl:if>
					</xsl:for-each>
				&lt;/cfif&gt;
			FROM [<xsl:value-of select="table/@name" />] <xsl:for-each select="table/superTables[@sort = 'backward']/superTable/relationship/column">JOIN [<xsl:value-of select="../../@toTable" />]
				ON [<xsl:value-of select="../../@fromTable" />].[<xsl:value-of select="@name" />] = [<xsl:value-of select="../../@toTable" />].[<xsl:value-of select="@referencedColumn" />]
			</xsl:for-each>
			&lt;cfif Len(arguments.Criteria.getExpression().asString())&gt;
				WHERE #arguments.Criteria.getExpression().asString()#
			&lt;/cfif&gt;
			&lt;cfif Len(arguments.Criteria.getOrder().asString())&gt;
				ORDER BY #arguments.Criteria.getOrder().asString()#
			&lt;/cfif&gt;
		&lt;/cfquery&gt;
		
		&lt;cfreturn qGet /&gt;
	&lt;/cffunction&gt;
	
	
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>