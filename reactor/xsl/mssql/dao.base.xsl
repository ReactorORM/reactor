<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />
	
	<xsl:template match="/">
	
&lt;cfcomponent hint="I am the base DAO object for the <xsl:value-of select="table/@name"/> table.  I am generated.  DO NOT EDIT ME."
	extends="<xsl:choose>
		<xsl:when test="table/@name = table/@baseTable">reactor.core.abstractDao</xsl:when>
		<xsl:when test="table/@name != table/@baseTable"><xsl:value-of select="table/@customDaoBase" /></xsl:when>
	</xsl:choose>" &gt;
	
	&lt;cfset variables.signature = "<xsl:value-of select="table/@signature" />" /&gt;
	
	&lt;cffunction name="create" access="public" hint="I create a record in the <xsl:value-of select="table/@name" /> table." output="false" returntype="void"&gt;
		&lt;cfargument name="to" hint="I am the transfer object for <xsl:value-of select="table/@name" />" required="yes" type="<xsl:value-of select="table/@toBase" />" /&gt;
		&lt;cfset var qCreate = 0 /&gt;
		<xsl:if test="table/@name != table/@baseTable">
		&lt;cfset super.create(arguments.to) /&gt;
		</xsl:if>		
		&lt;cftransaction&gt;	
			&lt;cfquery name="qCreate" datasource="#getDsn()#"&gt;
				INSERT INTO [<xsl:value-of select="table/@name" />]
				(
					<xsl:for-each select="table/columns/column">
						<xsl:if test="@identity != 'true'">"<xsl:value-of select="@name" />"<xsl:if test="position() != last()">, 
					</xsl:if>
						</xsl:if>
					</xsl:for-each>
				) VALUES (<xsl:for-each select="table/columns/column"><xsl:if test="@identity != 'true'">
					&lt;cfqueryparam<xsl:choose>
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
						</xsl:choose> value="#arguments.to.<xsl:value-of select="@name" />#"<xsl:if test="@nullable = 'true'"> null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@name" />), DE(true), DE(false))#" </xsl:if> /&gt;<xsl:if test="position() != last()">
					<xsl:text>,</xsl:text>
					</xsl:if>
					</xsl:if></xsl:for-each>
				)<xsl:if test="table/columns/column[@identity = 'true']">
				
				SELECT SCOPE_IDENTITY() as Id</xsl:if>
			&lt;/cfquery&gt;
		&lt;/cftransaction&gt;<xsl:if test="table/columns/column[@identity = 'true']">
		
		&lt;cfif qCreate.recordCount&gt;
			&lt;cfset arguments.to.<xsl:value-of select="table/columns/column[@identity = 'true']/@name" /> = qCreate.id /&gt;
		&lt;/cfif&gt;</xsl:if>
	&lt;/cffunction&gt;
		
	&lt;cffunction name="read" access="public" hint="I read a record from the <xsl:value-of select="table/@name" /> table." output="false" returntype="void"&gt;
		&lt;cfargument name="to" hint="I am the transfer object for <xsl:value-of select="table/@name" /> which will be populated." required="yes" type="<xsl:value-of select="table/@toBase" />" /&gt;
		&lt;cfset var qRead = 0 /&gt;
		<xsl:if test="table/@name != table/@baseTable">
		&lt;cfset super.read(arguments.to) /&gt;
		</xsl:if>
		&lt;cfquery name="qRead" datasource="#getDsn()#"&gt;
			SELECT 
				<xsl:for-each select="table/columns/column">"<xsl:value-of select="@name" />"<xsl:if test="position() != last()">, 
				</xsl:if>
				</xsl:for-each>
			FROM [<xsl:value-of select="table/@name" />]
			WHERE
				<xsl:for-each select="table/columns/column[@primaryKey = 'true']">"<xsl:value-of select="@name" />" = &lt;cfqueryparam<xsl:choose>
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
				</xsl:choose> value="#arguments.to.<xsl:value-of select="@name" />#"<xsl:if test="@nullable = 'true'"> null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@name" />), DE(true), DE(false))#" </xsl:if> /&gt;<xsl:if test="position() != last()"> AND 
				</xsl:if>
				</xsl:for-each>
		&lt;/cfquery&gt;
		
		&lt;cfif qRead.recordCount&gt;<xsl:for-each select="table/columns/column">
			&lt;cfset arguments.to.<xsl:value-of select="@name" /> = qRead.<xsl:value-of select="@name" /> /&gt;</xsl:for-each>
		&lt;/cfif&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="update" access="public" hint="I update a record in the <xsl:value-of select="table/@name" /> table." output="false" returntype="void"&gt;
		&lt;cfargument name="to" hint="I am the transfer object for <xsl:value-of select="table/@name" /> which will be used to update a record in the table." required="yes" type="<xsl:value-of select="table/@toBase" />" /&gt;
		&lt;cfset var qUpdate = 0 /&gt;
		<xsl:if test="table/@name != table/@baseTable">
		&lt;cfset super.update(arguments.to) /&gt;
		</xsl:if>
		&lt;cfquery name="qUpdate" datasource="#getDsn()#"&gt;
			UPDATE [<xsl:value-of select="table/@name" />]
			SET <xsl:for-each select="table/columns/column[@primaryKey = 'false']">
				"<xsl:value-of select="@name" />" = &lt;cfqueryparam<xsl:choose>
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
					</xsl:choose> value="#arguments.to.<xsl:value-of select="@name" />#"<xsl:if test="@nullable = 'true'"> null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@name" />), DE(true), DE(false))#" </xsl:if> /&gt;<xsl:if test="position() != last()">
				<xsl:text>,</xsl:text>
				</xsl:if></xsl:for-each>
			WHERE <xsl:for-each select="table/columns/column[@primaryKey = 'true']">"<xsl:value-of select="@name" />" = &lt;cfqueryparam<xsl:choose>
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
				</xsl:choose> value="#arguments.to.<xsl:value-of select="@name" />#"<xsl:if test="@nullable = 'true'"> null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@name" />), DE(true), DE(false))#" </xsl:if> /&gt;<xsl:if test="position() != last()"> AND 
				</xsl:if>
				</xsl:for-each>
		&lt;/cfquery&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="delete" access="public" hint="I delete a record in the <xsl:value-of select="table/@name" /> table." output="false" returntype="void"&gt;
		&lt;cfargument name="to" hint="I am the transfer object for <xsl:value-of select="table/@name" /> which will be used to delete from the table." required="yes" type="<xsl:value-of select="table/@toBase" />" /&gt;
		&lt;cfset var qDelete = 0 /&gt;
		
		&lt;cfquery name="qDelete" datasource="#getDsn()#"&gt;
			DELETE FROM [<xsl:value-of select="table/@name" />]
			WHERE <xsl:for-each select="table/columns/column[@primaryKey = 'true']">"<xsl:value-of select="@name" />" = &lt;cfqueryparam<xsl:choose>
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
				</xsl:choose> value="#arguments.to.<xsl:value-of select="@name" />#"<xsl:if test="@nullable = 'true'"> null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@name" />), DE(true), DE(false))#" </xsl:if> /&gt;<xsl:if test="position() != last()"> AND 
				</xsl:if>
				</xsl:for-each>
		&lt;/cfquery&gt;<xsl:if test="table/@name != table/@baseTable">
			
		&lt;cfset super.delete(arguments.to) /&gt;</xsl:if>
	&lt;/cffunction&gt;
	
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>