<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">
&lt;cfcomponent hint="I am the base Metadata object for the <xsl:value-of select="object/@name"/><xsl:text> </xsl:text><xsl:value-of select="object/@type"/>.  I am generated.  DO NOT EDIT ME."
	extends="<xsl:choose>
		<xsl:when test="count(object/super)"><xsl:value-of select="object/@mapping"/>.Metadata.<xsl:value-of select="object/@dbms"/>.base.<xsl:value-of select="object/super/@name"/>Metadata</xsl:when>
		<xsl:otherwise>reactor.base.abstractMetadata</xsl:otherwise>
	</xsl:choose>" &gt;
	
	&lt;cfset variables.signature = "<xsl:value-of select="object/@signature" />" &gt;
	
	&lt;cfsavecontent variable="variables.metadataXml"&gt;
		&lt;object name="<xsl:value-of select="object/@name" />"
			owner="<xsl:value-of select="object/@owner" />"
			type="<xsl:value-of select="object/@type" />"
			database="<xsl:value-of select="object/@database" />"
			dbms="<xsl:value-of select="object/@dbms" />"&gt;
			
			<xsl:for-each select="object/super">
				&lt;super name="<xsl:value-of select="@name" />"&gt;
					<xsl:for-each select="relate">
						&lt;relate from="<xsl:value-of select="@from" />" to="<xsl:value-of select="@to" />" /&gt;
					</xsl:for-each>
				&lt;/super&gt;
			</xsl:for-each>
			
			<xsl:for-each select="object/hasOne">
				&lt;hasOne name="<xsl:value-of select="@name" />"&gt;
					<xsl:for-each select="relate">
						&lt;relate from="<xsl:value-of select="@from" />" to="<xsl:value-of select="@to" />" /&gt;
					</xsl:for-each>
				&lt;/hasOne&gt;
			</xsl:for-each>
			
			<xsl:for-each select="object/hasMany">
				&lt;hasMany name="<xsl:value-of select="@name" />"&gt;
					<xsl:for-each select="relate">
						&lt;relate from="<xsl:value-of select="@from" />" to="<xsl:value-of select="@to" />" /&gt;
					</xsl:for-each>
					<xsl:if test="count(link)">
						&lt;link name="<xsl:value-of select="link/@name" />" /&gt;
					</xsl:if>
				&lt;/hasMany&gt;
			</xsl:for-each>

			&lt;columns&gt;
				<xsl:for-each select="object/columns/column">
					&lt;column name="<xsl:value-of select="@name" />"
						primaryKey="<xsl:value-of select="@primaryKey" />"
						identity="<xsl:value-of select="@identity" />"
						nullable="<xsl:value-of select="@nullable" />"
						dbDataType="<xsl:value-of select="@dbDataType" />"
						cfDataType="<xsl:value-of select="@cfDataType" />"
						cfSqlType="<xsl:value-of select="@cfSqlType" />"
						length="<xsl:value-of select="@length" />"
						default="<xsl:value-of select="@default" />" 
						overridden="<xsl:value-of select="@overridden" />" /&gt;
				</xsl:for-each>
			&lt;/columns&gt;		
		&lt;/object&gt;
	&lt;/cfsavecontent&gt;
	&lt;cfset setMetadataXml(variables.metadataXml) /&gt;
	
	&lt;cffunction name="getQuerySafeTableAlias" access="public" hint="I return a table alias formatted for the database." output="false" returntype="string"&gt;
		<xsl:choose>
			<xsl:when test="object[@dbms = 'mssql']">
				&lt;cfreturn "[#getName()#]" /&gt;
			</xsl:when>
			<xsl:when test="object[@dbms = 'mysql']">
				.... MYSQL CODE WILL GO HERE ...
			</xsl:when>
		</xsl:choose>
	&lt;/cffunction&gt;
	
	&lt;cffunction name="getQuerySafeTableName" access="public" hint="I return a table expression formatted for the database." output="false" returntype="string"&gt;
		<xsl:choose>
			<xsl:when test="object[@dbms = 'mssql']">
				&lt;cfreturn "[#getDatabase()#].[#getOwner()#].[#getName()#]" /&gt;
			</xsl:when>
			<xsl:when test="object[@dbms = 'mysql']">
				.... MYSQL CODE WILL GO HERE ...
			</xsl:when>
		</xsl:choose>
	&lt;/cffunction&gt;
	
	&lt;cffunction name="getQuerySafeColumn" access="public" hint="I return a column expression formatted for the database." output="false" returntype="string"&gt;
		&lt;cfargument name="name" hint="I am the name of the column to get" required="yes" type="string" /&gt;
		&lt;cfset var column = getColumn(arguments.name) /&gt;
		
		<xsl:choose>
			<xsl:when test="object[@dbms = 'mssql']">
				&lt;cfreturn "[#column.table#].[#column.name#]" /&gt;
			</xsl:when>
			<xsl:when test="object[@dbms = 'mysql']">
				.... MYSQL CODE WILL GO HERE ...
			</xsl:when>
		</xsl:choose>
	&lt;/cffunction&gt;
	
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>