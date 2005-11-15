<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />
	<xsl:template match="/">
	
&lt;cfcomponent hint="I am the base DAO object for the <xsl:value-of select="object/@name"/> table.  I am generated.  DO NOT EDIT ME."
	extends="<xsl:choose>
		<xsl:when test="count(object/super)"><xsl:value-of select="object/@mapping"/>.Dao.<xsl:value-of select="object/@dbms"/>.<xsl:value-of select="object/super/@name"/>Dao</xsl:when>
		<xsl:otherwise>reactor.base.abstractDao</xsl:otherwise>
	</xsl:choose>" &gt;
	
	&lt;cfset variables.signature = "<xsl:value-of select="object/@signature" />" /&gt;

	&lt;cffunction name="save" access="public" hint="I create or update a <xsl:value-of select="object/@name" /> record." output="false" returntype="void"&gt;
		&lt;cfargument name="to" hint="I am the transfer object for <xsl:value-of select="object/@name" />" required="yes" type="<xsl:value-of select="object/@mapping"/>.To.<xsl:value-of select="object/@dbms"/>.<xsl:value-of select="object/@name"/>To" /&gt;
		<xsl:choose>
			<xsl:when test="count(object/columns/column[@primaryKey = 'true']) &gt; 0 and count(object/columns/column[@identity = 'true']) &gt; 0">
		&lt;cfif <xsl:for-each select="object/columns/column[@primaryKey = 'true']">IsNumeric(arguments.to.<xsl:value-of select="@name" />) AND Val(arguments.to.<xsl:value-of select="@name" />)<xsl:if test="position() != last()"> AND </xsl:if>
			</xsl:for-each>&gt;
			&lt;cfset update(arguments.to) /&gt;
		&lt;cfelse&gt;
			&lt;cfset create(arguments.to) /&gt;
		&lt;/cfif&gt;
			</xsl:when>
			<xsl:when test="count(object/columns/column[@primaryKey = 'true']) &gt; 0 and count(object/columns/column[@identity = 'true']) = 0">
		&lt;cfif exists(arguments.to)&gt;
			&lt;cfset update(arguments.to) /&gt;
		&lt;cfelse&gt;
			&lt;cfset create(arguments.to) /&gt;
		&lt;/cfif&gt;
			</xsl:when>
			<xsl:when test="count(object/columns/column[@primaryKey = 'true']) = 0">
		&lt;cfset create(arguments.to) /&gt;
			</xsl:when>
		</xsl:choose>
	&lt;/cffunction&gt;
	
	<xsl:if test="count(object/columns/column[@primaryKey = 'true']) &gt; 0 and count(object/columns/column[@identity = 'true']) = 0">
	&lt;cffunction name="exists" access="public" hint="I check to see if the <xsl:value-of select="object/@name" /> object exists." output="false" returntype="boolean"&gt;
		&lt;cfargument name="to" hint="I am the transfer object for <xsl:value-of select="object/@name" /> which will be populated." required="yes" type="<xsl:value-of select="object/@mapping"/>.To.<xsl:value-of select="object/@dbms"/>.<xsl:value-of select="object/@name"/>To" /&gt;
		&lt;cfset var qExists = 0 /&gt;
		<xsl:if test="count(object/super) &gt; 0">
			<xsl:if test="object/super/relate/@from != object/super/relate/@to">
				&lt;cfset arguments.to.<xsl:value-of select="object/super/relate/@to" /> = arguments.to.<xsl:value-of select="object/super/relate/@from" /> /&gt;
			</xsl:if>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="object[@dbms = 'mssql']">
				&lt;cfquery name="qExists" datasource="#getConfig().getDsn()#"&gt;
					SELECT 1			
					FROM [<xsl:value-of select="object/@database" />].[<xsl:value-of select="object/@owner" />].[<xsl:value-of select="object/@name" />] as [<xsl:value-of select="object/@name" />]
					<xsl:if test="object/columns/column[@primaryKey = 'true']">
						<xsl:for-each select="object/super/relate">
							JOIN [<xsl:value-of select="/object/@database" />].[<xsl:value-of select="/object/@owner" />].[<xsl:value-of select="../@name" />] as [<xsl:value-of select="../@name" />]
							ON [<xsl:value-of select="../../@name" />].[<xsl:value-of select="@from" />] = [<xsl:value-of select="../@name" />].[<xsl:value-of select="@to" />]
						</xsl:for-each>
						WHERE
						<xsl:for-each select="object/columns/column[@primaryKey = 'true']">
							[<xsl:value-of select="../../@name" />].[<xsl:value-of select="@name" />] = &lt;cfqueryparam
								cfsqltype="<xsl:value-of select="@cfSqlType" />"
								<xsl:if test="@length > 0">
									scale="<xsl:value-of select="@length" />"
								</xsl:if>
								value="<xsl:choose>
									<xsl:when test="@dbDataType = 'uniqueidentifier'">#Left(arguments.to.<xsl:value-of select="@name" />, 23)#-#Right(arguments.to.<xsl:value-of select="@name" />, 12)#</xsl:when>
									<xsl:otherwise>#arguments.to.<xsl:value-of select="@name" />#</xsl:otherwise>
								</xsl:choose>"
								<xsl:if test="@nullable = 'true'">
									null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@name" />), DE(true), DE(false))#"</xsl:if> /&gt;
							
							<xsl:if test="position() != last()">
								AND 
							</xsl:if>
						</xsl:for-each>
						
					</xsl:if>
				&lt;/cfquery&gt;
			</xsl:when>
			<xsl:when test="object[@dbms = 'mysql']">
				.... MYSQL CODE WILL GO HERE ...
			</xsl:when>
		</xsl:choose>
				
		&lt;cfif qExists.recordCount&gt;
			&lt;cfreturn true /&gt;
		&lt;cfelse&gt;
			&lt;cfreturn false /&gt;
		&lt;/cfif&gt;
	&lt;/cffunction&gt;
	</xsl:if>
	
	&lt;cffunction name="create" access="public" hint="I create a <xsl:value-of select="object/@name" /> object." output="false" returntype="void"&gt;
		&lt;cfargument name="to" hint="I am the transfer object for <xsl:value-of select="object/@name" />" required="yes" type="<xsl:value-of select="object/@mapping"/>.To.<xsl:value-of select="object/@dbms"/>.<xsl:value-of select="object/@name"/>To" /&gt;
		&lt;cfset var qCreate = 0 /&gt;
		<xsl:if test="count(object/super) &gt; 0">
			&lt;cfset super.create(arguments.to) /&gt;
			<xsl:if test="object/super/relate/@from != object/super/relate/@to">
				&lt;cfset arguments.to.<xsl:value-of select="object/super/relate/@from" /> = arguments.to.<xsl:value-of select="object/super/relate/@to" /> /&gt;
			</xsl:if>
		</xsl:if>
			
		<xsl:choose>
			<xsl:when test="object[@dbms = 'mssql']">
				&lt;cftransaction&gt;	
					&lt;cfquery name="qCreate" datasource="#getConfig().getDsn()#"&gt;
						INSERT INTO [<xsl:value-of select="object/@name" />]
						(
							<xsl:for-each select="object/columns/column">
								<xsl:if test="@identity != 'true'">
									[<xsl:value-of select="../../@name" />].[<xsl:value-of select="@name" />]
									<xsl:if test="position() != last()">,</xsl:if>
								</xsl:if>
							</xsl:for-each>
						) VALUES (
							<xsl:for-each select="object/columns/column">
								<xsl:if test="@identity != 'true'">
									&lt;cfqueryparam cfsqltype="<xsl:value-of select="@cfSqlType" />"
									<xsl:if test="@length > 0">
										scale="<xsl:value-of select="@length" />"
									</xsl:if>
									value="<xsl:choose>
										<xsl:when test="@dbDataType = 'uniqueidentifier'">#Left(arguments.to.<xsl:value-of select="@name" />, 23)#-#Right(arguments.to.<xsl:value-of select="@name" />, 12)#</xsl:when>
										<xsl:otherwise>#arguments.to.<xsl:value-of select="@name" />#</xsl:otherwise>
									</xsl:choose>"
									<xsl:if test="@nullable = 'true'">	
										null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@name" />), DE(true), DE(false))#"
									</xsl:if> /&gt;
									<xsl:if test="position() != last()">
										<xsl:text>,</xsl:text>
									</xsl:if>
								</xsl:if>
							</xsl:for-each>
						)
						
						<xsl:if test="object/columns/column[@identity = 'true']">
							SELECT SCOPE_IDENTITY() as Id
						</xsl:if>
					&lt;/cfquery&gt;
				&lt;/cftransaction&gt;
			</xsl:when>
			<xsl:when test="object[@dbms = 'mysql']">
				.... MYSQL CODE WILL GO HERE ...
			</xsl:when>
		</xsl:choose>
			
		<xsl:if test="object/columns/column[@identity = 'true']">
		&lt;cfif qCreate.recordCount&gt;
			&lt;cfset arguments.to.<xsl:value-of select="object/columns/column[@identity = 'true']/@name" /> = qCreate.id /&gt;
		&lt;/cfif&gt;
		</xsl:if>
	&lt;/cffunction&gt;
	
	<xsl:if test="count(object/columns/column[@primaryKey = 'true'])">
	&lt;cffunction name="read" access="public" hint="I read a  <xsl:value-of select="object/@name" /> object." output="false" returntype="void"&gt;
		&lt;cfargument name="to" hint="I am the transfer object for <xsl:value-of select="object/@name" /> which will be populated." required="yes" type="<xsl:value-of select="object/@mapping"/>.To.<xsl:value-of select="object/@dbms"/>.<xsl:value-of select="object/@name"/>To" /&gt;
		&lt;cfset var qRead = 0 /&gt;
		<xsl:if test="count(object/super) &gt; 0">
			<xsl:if test="object/super/relate/@from != object/super/relate/@to">
				&lt;cfset arguments.to.<xsl:value-of select="object/super/relate/@from" /> = arguments.to.<xsl:value-of select="object/super/relate/@to" /> /&gt;
			</xsl:if>
		</xsl:if>
		
		<xsl:choose>
		<xsl:when test="object[@dbms = 'mssql']">
		&lt;cfquery name="qRead" datasource="#getConfig().getDsn()#"&gt;
			SELECT 
				<xsl:for-each select="object/superTables[@sort = 'backward']//columns/column[@overridden = 'false']">[<xsl:value-of select="../../@toTable" />].[<xsl:value-of select="@name" />],
				</xsl:for-each>
				<xsl:for-each select="object/columns/column[@primaryKey = 'false']">[<xsl:value-of select="../../@name" />].[<xsl:value-of select="@name" />]<xsl:if test="position() != last()">, 
				</xsl:if>
				</xsl:for-each>
			FROM [<xsl:value-of select="object/@name" />] <xsl:if test="object/columns/column[@primaryKey = 'true']"> <xsl:for-each select="object/superTables[@sort = 'backward']/superobject/relationship/column">JOIN [<xsl:value-of select="../../@toTable" />]
				ON [<xsl:value-of select="../../@fromTable" />].[<xsl:value-of select="@name" />] = [<xsl:value-of select="../../@toTable" />].[<xsl:value-of select="@referencedColumn" />]
			</xsl:for-each>
			WHERE
				<xsl:for-each select="object/columns/column[@primaryKey = 'true']">[<xsl:value-of select="@name" />] = &lt;cfqueryparam cfsqltype="<xsl:value-of select="@cfSqlType" />"<xsl:if test="@length > 0"> scale="<xsl:value-of select="@length" />"</xsl:if> value="<xsl:choose>
					<xsl:when test="@dbDataType = 'uniqueidentifier'">#Left(arguments.to.<xsl:value-of select="@name" />, 23)#-#Right(arguments.to.<xsl:value-of select="@name" />, 12)#</xsl:when>
					<xsl:otherwise>#arguments.to.<xsl:value-of select="@name" />#</xsl:otherwise>
				</xsl:choose>"<xsl:if test="@nullable = 'true'"> null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@name" />), DE(true), DE(false))#"</xsl:if> /&gt;<xsl:if test="position() != last()"> AND 
				</xsl:if>
				</xsl:for-each>
				</xsl:if>
		&lt;/cfquery&gt;
		</xsl:when>
		<xsl:when test="object[@dbms = 'mysql']">
			.... MYSQL CODE WILL GO HERE ...
		</xsl:when>
		</xsl:choose>
		
		&lt;cfif qRead.recordCount&gt;<xsl:for-each select="object/superTables[@sort = 'backward']//columns/column[@overridden = 'false']">
			&lt;cfset arguments.to.<xsl:value-of select="@name" /> = qRead.<xsl:value-of select="@name" /> /&gt;</xsl:for-each>
			<xsl:for-each select="object/columns/column[@primaryKey = 'false']">
			&lt;cfset arguments.to.<xsl:value-of select="@name" /> = qRead.<xsl:value-of select="@name" /> /&gt;</xsl:for-each>
		&lt;/cfif&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="update" access="public" hint="I update a <xsl:value-of select="object/@name" /> object." output="false" returntype="void"&gt;
		&lt;cfargument name="to" hint="I am the transfer object for <xsl:value-of select="object/@name" /> which will be used to update a record in the table." required="yes" type="<xsl:value-of select="object/@mapping"/>.To.<xsl:value-of select="object/@dbms"/>.<xsl:value-of select="object/@name"/>To" /&gt;
		&lt;cfset var qUpdate = 0 /&gt;
		<xsl:if test="count(object/super) &gt; 0">
		&lt;cfset super.update(arguments.to) /&gt;
		<xsl:if test="object/superTables[@sort = 'backward']/superobject/relationship/column/@name != object/superTables[@sort = 'backward']/superobject/relationship/column/@referencedColumn">&lt;cfset arguments.to.<xsl:value-of select="object/superTables[@sort = 'backward']/superobject/relationship/column/@name" /> = arguments.to.<xsl:value-of select="object/superTables[@sort = 'backward']/superobject/relationship/column/@referencedColumn" /> /&gt;
		</xsl:if>
		</xsl:if>
		<xsl:choose>
		<xsl:when test="object[@dbms = 'mssql']">
		&lt;cfquery name="qUpdate" datasource="#getConfig().getDsn()#"&gt;
			UPDATE [<xsl:value-of select="object/@name" />]
			SET <xsl:for-each select="object/columns/column[@primaryKey = 'false']">
				[<xsl:value-of select="@name" />] = &lt;cfqueryparam cfsqltype="<xsl:value-of select="@cfSqlType" />"<xsl:if test="@length > 0"> scale="<xsl:value-of select="@length" />"</xsl:if> value="<xsl:choose>
							<xsl:when test="@dbDataType = 'uniqueidentifier'">#Left(arguments.to.<xsl:value-of select="@name" />, 23)#-#Right(arguments.to.<xsl:value-of select="@name" />, 12)#</xsl:when>
							<xsl:otherwise>#arguments.to.<xsl:value-of select="@name" />#</xsl:otherwise>
						</xsl:choose>"<xsl:if test="@nullable = 'true'"> null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@name" />), DE(true), DE(false))#"</xsl:if> /&gt;<xsl:if test="position() != last()">
				<xsl:text>,</xsl:text>
				</xsl:if></xsl:for-each>
			WHERE <xsl:for-each select="object/columns/column[@primaryKey = 'true']">[<xsl:value-of select="@name" />] = &lt;cfqueryparam cfsqltype="<xsl:value-of select="@cfSqlType" />"<xsl:if test="@length > 0"> scale="<xsl:value-of select="@length" />"</xsl:if> value="<xsl:choose>
							<xsl:when test="@dbDataType = 'uniqueidentifier'">#Left(arguments.to.<xsl:value-of select="@name" />, 23)#-#Right(arguments.to.<xsl:value-of select="@name" />, 12)#</xsl:when>
							<xsl:otherwise>#arguments.to.<xsl:value-of select="@name" />#</xsl:otherwise>
						</xsl:choose>"<xsl:if test="@nullable = 'true'"> null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@name" />), DE(true), DE(false))#"</xsl:if> /&gt;<xsl:if test="position() != last()"> AND 
				</xsl:if>
				</xsl:for-each>
		&lt;/cfquery&gt;
		</xsl:when>
		<xsl:when test="object[@dbms = 'mysql']">
			.... MYSQL CODE WILL GO HERE ...
		</xsl:when>
		</xsl:choose>
	&lt;/cffunction&gt;
	</xsl:if>
	&lt;cffunction name="delete" access="public" hint="I delete a record in the <xsl:value-of select="object/@name" /> table." output="false" returntype="void"&gt;
		&lt;cfargument name="to" hint="I am the transfer object for <xsl:value-of select="object/@name" /> which will be used to delete from the table." required="yes" type="<xsl:value-of select="object/@mapping"/>.To.<xsl:value-of select="object/@dbms"/>.<xsl:value-of select="object/@name"/>To" /&gt;
		&lt;cfset var qDelete = 0 /&gt;
		<xsl:if test="count(object/super) &gt; 0">
		<xsl:for-each select="object/superTables[@sort = 'forward']/superobject/relationship/column">
		<xsl:if test="@name != @referencedColumn">&lt;cfset arguments.to.<xsl:value-of select="@name" /> = arguments.to.<xsl:value-of select="@referencedColumn" /> /&gt;
		</xsl:if>
		</xsl:for-each>
		</xsl:if>
		
		<xsl:choose>
		<xsl:when test="object[@dbms = 'mssql']">
		&lt;cfquery name="qDelete" datasource="#getConfig().getDsn()#"&gt;
			DELETE FROM [<xsl:value-of select="object/@name" />]
			WHERE <xsl:choose>
			<xsl:when test="count(object/columns/column[@primaryKey = 'true']) &gt; 0">
				<xsl:for-each select="object/columns/column[@primaryKey = 'true']">[<xsl:value-of select="@name" />] = &lt;cfqueryparam cfsqltype="<xsl:value-of select="@cfSqlType" />"<xsl:if test="@length > 0"> scale="<xsl:value-of select="@length" />"</xsl:if> value="<xsl:choose>
							<xsl:when test="@dbDataType = 'uniqueidentifier'">#Left(arguments.to.<xsl:value-of select="@name" />, 23)#-#Right(arguments.to.<xsl:value-of select="@name" />, 12)#</xsl:when>
							<xsl:otherwise>#arguments.to.<xsl:value-of select="@name" />#</xsl:otherwise>
						</xsl:choose>"<xsl:if test="@nullable = 'true'"> null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@name" />), DE(true), DE(false))#"</xsl:if> /&gt;<xsl:if test="position() != last()"> AND 
				</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="count(object/columns/column[@primaryKey = 'true']) = 0">
				<xsl:for-each select="object/columns/column">[<xsl:value-of select="@name" />] = &lt;cfqueryparam cfsqltype="<xsl:value-of select="@cfSqlType" />"<xsl:if test="@length > 0"> scale="<xsl:value-of select="@length" />"</xsl:if> value="<xsl:choose>
							<xsl:when test="@dbDataType = 'uniqueidentifier'">#Left(arguments.to.<xsl:value-of select="@name" />, 23)#-#Right(arguments.to.<xsl:value-of select="@name" />, 12)#</xsl:when>
							<xsl:otherwise>#arguments.to.<xsl:value-of select="@name" />#</xsl:otherwise>
						</xsl:choose>"<xsl:if test="@nullable = 'true'"> null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@name" />), DE(true), DE(false))#"</xsl:if> /&gt;<xsl:if test="position() != last()"> AND 
				</xsl:if>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
		&lt;/cfquery&gt;
		</xsl:when>
		<xsl:when test="object[@dbms = 'mysql']">
			.... MYSQL CODE WILL GO HERE ...
		</xsl:when>
		</xsl:choose>
		<xsl:if test="count(object/super) &gt; 0">
		&lt;cfset super.delete(arguments.to) /&gt;</xsl:if>
	&lt;/cffunction&gt;
	
&lt;/cfcomponent&gt;
	</xsl:template>
	
	<xsl:template name="hierarchy" match="//relationship/column">
		<xsl:value-of select="//@name"/>
	</xsl:template>
	
</xsl:stylesheet>