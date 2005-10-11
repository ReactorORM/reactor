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
	
	&lt;!--- cffunction name="getByFields" access="public" hint="I return all matching rows from the <xsl:value-of select="table/@name" /> table." output="false" returntype="query"&gt;
		<xsl:for-each select="table/baseTableColumns/baseTableColumn[@overridden = 'false']">&lt;cfargument name="<xsl:value-of select="@name" />" hint="If provided, I match the provided value to the <xsl:value-of select="@name" /> column in the <xsl:value-of select="/table/@baseTable" /> table." required="no" type="string" /&gt;
		</xsl:for-each>
		<xsl:for-each select="table/columns/column">&lt;cfargument name="<xsl:value-of select="@name" />" hint="If provided, I match the provided value to the <xsl:value-of select="@name" /> column in the <xsl:value-of select="/table/@name" /> table." required="no" type="string" /&gt;
		</xsl:for-each>&lt;cfset var qGet = 0 /&gt;
		<xsl:variable name="foreignTable" select="table/@baseTable" />
		&lt;cfquery name="qGet" datasource="#getDsn()#"&gt;
			SELECT 
				<xsl:for-each select="table/baseTableColumns/baseTableColumn[@overridden = 'false']">[<xsl:value-of select="/table/@baseTable" />].[<xsl:value-of select="@name" />],
				</xsl:for-each>
				<xsl:for-each select="table/columns/column">[<xsl:value-of select="/table/@name" />].[<xsl:value-of select="@name" />]<xsl:if test="position() != last()">, 
				</xsl:if>
				</xsl:for-each>
			FROM [<xsl:value-of select="table/@name" />] <xsl:if test="count(table/baseTableColumns/baseTableColumn) > 0">JOIN [<xsl:value-of select="table/@baseTable" />]
				ON<xsl:for-each select="table/foreignKeys/foreignKey[@table = $foreignTable]"> [<xsl:value-of select="/table/@name" />].[<xsl:value-of select="column/@name" />] = [<xsl:value-of select="$foreignTable" />].[<xsl:value-of select="column/@name" />]<xsl:if test="position() != last()"> AND</xsl:if></xsl:for-each>
			</xsl:if>
			WHERE 1=1
				<xsl:for-each select="table/baseTableColumns/baseTableColumn[@overridden = 'false']">&lt;cfif IsDefined('arguments.<xsl:value-of select="@name" />')&gt;
					AND [<xsl:value-of select="/table/@baseTable" />].[<xsl:value-of select="@name" />] = &lt;cfqueryparam<xsl:choose>
						<xsl:when test="@type = 'int'"> cfsqltype="cf_sql_integer"</xsl:when>
						<xsl:when test="@type = 'bigint'"> cfsqltype="cf_sql_bigint"</xsl:when>
						<xsl:when test="@type = 'bit'"> cfsqltype="cf_sql_bit"</xsl:when>
						<xsl:when test="@type = 'char'"> cfsqltype="cf_sql_char"</xsl:when>
						<xsl:when test="@type = 'datetime'"> cfsqltype="cf_sql_date"</xsl:when>
						<xsl:when test="@type = 'decimal'"> cfsqltype="cf_sql_decimal"</xsl:when>
						<xsl:when test="@type = 'float'"> cfsqltype="cf_sql_float"</xsl:when>
						<xsl:when test="@type = 'money'"> cfsqltype="cf_sql_money"</xsl:when>
						<xsl:when test="@type = 'nchar'"> cfsqltype="cf_sql_char"</xsl:when>
						<xsl:when test="@type = 'numeric'"> cfsqltype="cf_sql_numeric"</xsl:when>
						<xsl:when test="@type = 'nvarchar'"> cfsqltype="cf_sql_varchar"</xsl:when>
						<xsl:when test="@type = 'real'"> cfsqltype="cf_sql_real"</xsl:when>
						<xsl:when test="@type = 'smalldatetime'"> cfsqltype="cf_sql_date"</xsl:when>
						<xsl:when test="@type = 'smallint'"> cfsqltype="cf_sql_smallint"</xsl:when>
						<xsl:when test="@type = 'smallmoney'"> cfsqltype="cf_sql_money"</xsl:when>
						<xsl:when test="@type = 'timestamp'"> cfsqltype="cf_sql_timestamp"</xsl:when>
						<xsl:when test="@type = 'tinyint'"> cfsqltype="cf_sql_tinyint"</xsl:when>
						<xsl:when test="@type = 'varchar'"> cfsqltype="cf_sql_varchar"</xsl:when>
					</xsl:choose><xsl:choose>
						<xsl:when test="@type = 'char'"> scale="<xsl:value-of select="@length" />"</xsl:when>
						<xsl:when test="@type = 'nchar'"> scale="<xsl:value-of select="@length" />"</xsl:when>
						<xsl:when test="@type = 'nvarchar'"> scale="<xsl:value-of select="@length" />"</xsl:when>
						<xsl:when test="@type = 'varchar'"> scale="<xsl:value-of select="@length" />"</xsl:when>
					</xsl:choose> value="#arguments.<xsl:value-of select="@name" />#"<xsl:if test="@nullable = 'true'"> null="#Iif(NOT Len(arguments.<xsl:value-of select="@name" />), DE(true), DE(false))#" </xsl:if> /&gt;
				&lt;/cfif&gt;
				</xsl:for-each>
				<xsl:for-each select="table/columns/column">&lt;cfif IsDefined('arguments.<xsl:value-of select="@name" />')&gt;
					AND [<xsl:value-of select="/table/@name" />].[<xsl:value-of select="@name" />] = &lt;cfqueryparam<xsl:choose>
						<xsl:when test="@type = 'int'"> cfsqltype="cf_sql_integer"</xsl:when>
						<xsl:when test="@type = 'bigint'"> cfsqltype="cf_sql_bigint"</xsl:when>
						<xsl:when test="@type = 'bit'"> cfsqltype="cf_sql_bit"</xsl:when>
						<xsl:when test="@type = 'char'"> cfsqltype="cf_sql_char"</xsl:when>
						<xsl:when test="@type = 'datetime'"> cfsqltype="cf_sql_date"</xsl:when>
						<xsl:when test="@type = 'decimal'"> cfsqltype="cf_sql_decimal"</xsl:when>
						<xsl:when test="@type = 'float'"> cfsqltype="cf_sql_float"</xsl:when>
						<xsl:when test="@type = 'money'"> cfsqltype="cf_sql_money"</xsl:when>
						<xsl:when test="@type = 'nchar'"> cfsqltype="cf_sql_char"</xsl:when>
						<xsl:when test="@type = 'numeric'"> cfsqltype="cf_sql_numeric"</xsl:when>
						<xsl:when test="@type = 'nvarchar'"> cfsqltype="cf_sql_varchar"</xsl:when>
						<xsl:when test="@type = 'real'"> cfsqltype="cf_sql_real"</xsl:when>
						<xsl:when test="@type = 'smalldatetime'"> cfsqltype="cf_sql_date"</xsl:when>
						<xsl:when test="@type = 'smallint'"> cfsqltype="cf_sql_smallint"</xsl:when>
						<xsl:when test="@type = 'smallmoney'"> cfsqltype="cf_sql_money"</xsl:when>
						<xsl:when test="@type = 'timestamp'"> cfsqltype="cf_sql_timestamp"</xsl:when>
						<xsl:when test="@type = 'tinyint'"> cfsqltype="cf_sql_tinyint"</xsl:when>
						<xsl:when test="@type = 'varchar'"> cfsqltype="cf_sql_varchar"</xsl:when>
					</xsl:choose><xsl:choose>
						<xsl:when test="@type = 'char'"> scale="<xsl:value-of select="@length" />"</xsl:when>
						<xsl:when test="@type = 'nchar'"> scale="<xsl:value-of select="@length" />"</xsl:when>
						<xsl:when test="@type = 'nvarchar'"> scale="<xsl:value-of select="@length" />"</xsl:when>
						<xsl:when test="@type = 'varchar'"> scale="<xsl:value-of select="@length" />"</xsl:when>
					</xsl:choose> value="#arguments.<xsl:value-of select="@name" />#"<xsl:if test="@nullable = 'true'"> null="#Iif(NOT Len(arguments.<xsl:value-of select="@name" />), DE(true), DE(false))#" </xsl:if> /&gt;
				&lt;/cfif&gt;
				</xsl:for-each>
		&lt;/cfquery&gt;
		
		&lt;cfreturn qGet /&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="getByCriteria" access="public" hint="I return all matching rows from the <xsl:value-of select="table/@name" /> table." output="false" returntype="query"&gt;
		&lt;cfargument name="Criteria" hint="I am optional criteria to apply to this query." required="no" default="#CreateObject("Component", "reactor.core.criteria")#" /&gt;
		&lt;cfset var qGet = 0 /&gt;
		<xsl:variable name="foreignTable" select="table/@baseTable" />
		&lt;cfquery name="qGet" datasource="#getDsn()#" maxrows="#arguments.Criteria.getMaxRows()#" cachedwithin="#arguments.Criteria.getCachedWithin()#" &gt;
			SELECT 
				&lt;cfif arguments.Criteria.getDistinct()&gt;DISTINCT&lt;/cfif&gt;				
				&lt;cfif Len(arguments.Criteria.getFieldList())&gt;
					#arguments.Criteria.getFieldList()#
				&lt;cfelse&gt;
					<xsl:for-each select="table/baseTableColumns/baseTableColumn[@overridden = 'false']">[<xsl:value-of select="/table/@baseTable" />].[<xsl:value-of select="@name" />],
					</xsl:for-each>
					<xsl:for-each select="table/columns/column">[<xsl:value-of select="/table/@name" />].[<xsl:value-of select="@name" />]<xsl:if test="position() != last()">, 
					</xsl:if>
					</xsl:for-each>
				&lt;/cfif&gt;
			FROM [<xsl:value-of select="table/@name" />] <xsl:if test="count(table/baseTableColumns/baseTableColumn) > 0">JOIN [<xsl:value-of select="table/@baseTable" />]
				ON<xsl:for-each select="table/foreignKeys/foreignKey[@table = $foreignTable]"> [<xsl:value-of select="/table/@name" />].[<xsl:value-of select="column/@name" />] = [<xsl:value-of select="$foreignTable" />].[<xsl:value-of select="column/@name" />]<xsl:if test="position() != last()"> AND</xsl:if></xsl:for-each>
			</xsl:if>
			&lt;cfif Len(arguments.Criteria.getExpression().asString())&gt;
				WHERE #arguments.Criteria.getExpression().asString()#
			&lt;/cfif&gt;
			&lt;cfif Len(arguments.Criteria.getOrder().asString())&gt;
				ORDER BY #arguments.Criteria.getOrder().asString()#
			&lt;/cfif&gt;
		&lt;/cfquery&gt;
		
		&lt;cfreturn qGet /&gt;
	&lt;/cffunction ---&gt;
	
	
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>