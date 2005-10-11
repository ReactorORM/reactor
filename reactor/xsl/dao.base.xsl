<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />
	<xsl:template match="/">
	
&lt;cfcomponent hint="I am the base DAO object for the <xsl:value-of select="table/@name"/> table.  I am generated.  DO NOT EDIT ME."
	extends="<xsl:value-of select="table/@baseDaoSuper" />" &gt;
	
	&lt;cfset variables.signature = "<xsl:value-of select="table/@signature" />" /&gt;

	&lt;cffunction name="create" access="public" hint="I create a record in the <xsl:value-of select="table/@name" /> table." output="false" returntype="void"&gt;
		&lt;cfargument name="to" hint="I am the transfer object for <xsl:value-of select="table/@name" />" required="yes" type="<xsl:value-of select="table/@customToSuper" />" /&gt;
		&lt;cfset var qCreate = 0 /&gt;
		<xsl:if test="table/@superTable != ''">
		&lt;cfset super.create(arguments.to) /&gt;
		<xsl:variable name="superRelationshipName" select="table/@superRelationshipName" />
		<xsl:for-each select="table/foreignKeys/foreignKey[@name = $superRelationshipName]/column"><xsl:if test="@name != @referencedColumn">&lt;cfset arguments.to.<xsl:value-of select="@name" /> = arguments.to.<xsl:value-of select="@referencedColumn" /> /&gt;
		</xsl:if>
		</xsl:for-each>
		</xsl:if>		
		<xsl:choose>
		<xsl:when test="table[@dbType = 'mssql']">
		&lt;cftransaction&gt;	
			&lt;cfquery name="qCreate" datasource="#getConfig().getDsn()#"&gt;
				INSERT INTO [<xsl:value-of select="table/@name" />]
				(
					<xsl:for-each select="table/columns/column">
						<xsl:if test="@identity != 'true'">[<xsl:value-of select="@name" />]<xsl:if test="position() != last()">, 
					</xsl:if>
						</xsl:if>
					</xsl:for-each>
				) VALUES (<xsl:for-each select="table/columns/column"><xsl:if test="@identity != 'true'">
					&lt;cfqueryparam cfsqltype="<xsl:value-of select="@cfSqlType" />"<xsl:if test="@length > 0"> scale="<xsl:value-of select="@length" />"</xsl:if> value="#arguments.to.<xsl:value-of select="@name" />#"<xsl:if test="@nullable = 'true'"> null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@name" />), DE(true), DE(false))#"</xsl:if> /&gt;<xsl:if test="position() != last()">
					<xsl:text>,</xsl:text>
					</xsl:if>
					</xsl:if></xsl:for-each>
				)<xsl:if test="table/columns/column[@identity = 'true']">
				
				SELECT SCOPE_IDENTITY() as Id</xsl:if>
			&lt;/cfquery&gt;
		&lt;/cftransaction&gt;
		</xsl:when>
		<xsl:when test="table[@dbType = 'mysql']">
			.... MYSQL CODE WILL GO HERE ...
		</xsl:when>
		</xsl:choose>
			
		<xsl:if test="table/columns/column[@identity = 'true']">
		&lt;cfif qCreate.recordCount&gt;
			&lt;cfset arguments.to.<xsl:value-of select="table/columns/column[@identity = 'true']/@name" /> = qCreate.id /&gt;
		&lt;/cfif&gt;
		</xsl:if>
	&lt;/cffunction&gt;
		
	&lt;cffunction name="read" access="public" hint="I read a record from the <xsl:value-of select="table/@name" /> table." output="false" returntype="void"&gt;
		&lt;cfargument name="to" hint="I am the transfer object for <xsl:value-of select="table/@name" /> which will be populated." required="yes" type="<xsl:value-of select="table/@customToSuper" />" /&gt;
		&lt;cfset var qRead = 0 /&gt;
		<xsl:if test="table/@superTable != ''">
		&lt;cfset super.read(arguments.to) /&gt;
		<xsl:variable name="superRelationshipName" select="table/@superRelationshipName" />
		<xsl:for-each select="table/foreignKeys/foreignKey[@name = $superRelationshipName]/column"><xsl:if test="@name != @referencedColumn">&lt;cfset arguments.to.<xsl:value-of select="@referencedColumn" /> = arguments.to.<xsl:value-of select="@name" /> /&gt;
		</xsl:if>
		</xsl:for-each>
		</xsl:if>
		<xsl:choose>
		<xsl:when test="table[@dbType = 'mssql']">
		&lt;cfquery name="qRead" datasource="#getConfig().getDsn()#"&gt;
			SELECT 
				<xsl:for-each select="table/columns/column">[<xsl:value-of select="@name" />]<xsl:if test="position() != last()">, 
				</xsl:if>
				</xsl:for-each>
			FROM [<xsl:value-of select="table/@name" />]<xsl:if test="table/columns/column[@primaryKey = 'true']">
			WHERE
				<xsl:for-each select="table/columns/column[@primaryKey = 'true']">[<xsl:value-of select="@name" />] = &lt;cfqueryparam cfsqltype="<xsl:value-of select="@cfSqlType" />"<xsl:if test="@length > 0"> scale="<xsl:value-of select="@length" />"</xsl:if> value="#arguments.to.<xsl:value-of select="@name" />#"<xsl:if test="@nullable = 'true'"> null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@name" />), DE(true), DE(false))#"</xsl:if> /&gt;<xsl:if test="position() != last()"> AND 
				</xsl:if>
				</xsl:for-each>
				</xsl:if>
		&lt;/cfquery&gt;
		</xsl:when>
		<xsl:when test="table[@dbType = 'mysql']">
			.... MYSQL CODE WILL GO HERE ...
		</xsl:when>
		</xsl:choose>
		&lt;cfif qRead.recordCount&gt;<xsl:for-each select="table/columns/column">
			&lt;cfset arguments.to.<xsl:value-of select="@name" /> = qRead.<xsl:value-of select="@name" /> /&gt;</xsl:for-each>
		&lt;/cfif&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="update" access="public" hint="I update a record in the <xsl:value-of select="table/@name" /> table." output="false" returntype="void"&gt;
		&lt;cfargument name="to" hint="I am the transfer object for <xsl:value-of select="table/@name" /> which will be used to update a record in the table." required="yes" type="<xsl:value-of select="table/@customToSuper" />" /&gt;
		&lt;cfset var qUpdate = 0 /&gt;
		<xsl:if test="table/@superTable != ''">
		&lt;cfset super.read(arguments.to) /&gt;
		<xsl:variable name="superRelationshipName" select="table/@superRelationshipName" />
		<xsl:for-each select="table/foreignKeys/foreignKey[@name = $superRelationshipName]/column"><xsl:if test="@name != @referencedColumn">&lt;cfset arguments.to.<xsl:value-of select="@referencedColumn" /> = arguments.to.<xsl:value-of select="@name" /> /&gt;
		</xsl:if>
		</xsl:for-each>
		</xsl:if>
		<xsl:choose>
		<xsl:when test="table[@dbType = 'mssql']">
		&lt;cfquery name="qUpdate" datasource="#getConfig().getDsn()#"&gt;
			UPDATE [<xsl:value-of select="table/@name" />]
			SET <xsl:for-each select="table/columns/column[@primaryKey = 'false']">
				"<xsl:value-of select="@name" />" = &lt;cfqueryparam cfsqltype="<xsl:value-of select="@cfSqlType" />"<xsl:if test="@length > 0"> scale="<xsl:value-of select="@length" />"</xsl:if> value="#arguments.to.<xsl:value-of select="@name" />#"<xsl:if test="@nullable = 'true'"> null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@name" />), DE(true), DE(false))#"</xsl:if> /&gt;<xsl:if test="position() != last()">
				<xsl:text>,</xsl:text>
				</xsl:if></xsl:for-each>
			WHERE <xsl:for-each select="table/columns/column[@primaryKey = 'true']">"<xsl:value-of select="@name" />" = &lt;cfqueryparam cfsqltype="<xsl:value-of select="@cfSqlType" />"<xsl:if test="@length > 0"> scale="<xsl:value-of select="@length" />"</xsl:if> value="#arguments.to.<xsl:value-of select="@name" />#"<xsl:if test="@nullable = 'true'"> null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@name" />), DE(true), DE(false))#"</xsl:if> /&gt;<xsl:if test="position() != last()"> AND 
				</xsl:if>
				</xsl:for-each>
		&lt;/cfquery&gt;
		</xsl:when>
		<xsl:when test="table[@dbType = 'mysql']">
			.... MYSQL CODE WILL GO HERE ...
		</xsl:when>
		</xsl:choose>
	&lt;/cffunction&gt;
	
	&lt;cffunction name="delete" access="public" hint="I delete a record in the <xsl:value-of select="table/@name" /> table." output="false" returntype="void"&gt;
		&lt;cfargument name="to" hint="I am the transfer object for <xsl:value-of select="table/@name" /> which will be used to delete from the table." required="yes" type="<xsl:value-of select="table/@customToSuper" />" /&gt;
		&lt;cfset var qDelete = 0 /&gt;
		<xsl:if test="table/@superTable != ''">
		<xsl:variable name="superRelationshipName" select="table/@superRelationshipName" />
		<xsl:for-each select="table/foreignKeys/foreignKey[@name = $superRelationshipName]/column"><xsl:if test="@name != @referencedColumn">&lt;cfset arguments.to.<xsl:value-of select="@name" /> = arguments.to.<xsl:value-of select="@referencedColumn" /> /&gt;
		</xsl:if>
		</xsl:for-each>
		</xsl:if>
		<xsl:choose>
		<xsl:when test="table[@dbType = 'mssql']">
		&lt;cfquery name="qDelete" datasource="#getConfig().getDsn()#"&gt;
			DELETE FROM [<xsl:value-of select="table/@name" />]
			WHERE <xsl:for-each select="table/columns/column[@primaryKey = 'true']">"<xsl:value-of select="@name" />" = &lt;cfqueryparam cfsqltype="<xsl:value-of select="@cfSqlType" />"<xsl:if test="@length > 0"> scale="<xsl:value-of select="@length" />"</xsl:if> value="#arguments.to.<xsl:value-of select="@name" />#"<xsl:if test="@nullable = 'true'"> null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@name" />), DE(true), DE(false))#"</xsl:if> /&gt;<xsl:if test="position() != last()"> AND 
				</xsl:if>
				</xsl:for-each>
		&lt;/cfquery&gt;
		</xsl:when>
		<xsl:when test="table[@dbType = 'mysql']">
			.... MYSQL CODE WILL GO HERE ...
		</xsl:when>
		</xsl:choose>
		<xsl:if test="table/@superTable != ''">
		&lt;cfset super.delete(arguments.to) /&gt;</xsl:if>
	&lt;/cffunction&gt;
	
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>