<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />
	<xsl:template match="/">
	
&lt;cfcomponent hint="I am the base DAO object for the <xsl:value-of select="object/@alias"/> object.  I am generated.  DO NOT EDIT ME (but feel free to delete me)."
	extends="reactor.base.abstractDao" &gt;
	
	&lt;cfset variables.signature = "<xsl:value-of select="object/@signature" />" /&gt;

	&lt;cffunction name="save" access="public" hint="I create or update a <xsl:value-of select="object/@alias" /> record." output="false" returntype="void"&gt;
		&lt;cfargument name="to" hint="I am the transfer object for <xsl:value-of select="object/@alias" />" required="yes" 	 /&gt;

		<xsl:choose>
			<xsl:when test="count(object/fields/field[@primaryKey = 'true']) &gt; 0 and count(object/fields/field[@identity = 'true']) &gt; 0">
		&lt;cfif <xsl:for-each select="object/fields/field[@primaryKey = 'true']">IsNumeric(arguments.to.<xsl:value-of select="@alias" />) AND Val(arguments.to.<xsl:value-of select="@alias" />)<xsl:if test="position() != last()"> AND </xsl:if>
			</xsl:for-each>&gt;
			&lt;cfset update(arguments.to) /&gt;
		&lt;cfelse&gt;
			&lt;cfset create(arguments.to) /&gt;
		&lt;/cfif&gt;
			</xsl:when>
			<xsl:when test="count(object/fields/field[@primaryKey = 'true']) &gt; 0 and count(object/fields/field[@identity = 'true']) = 0">
		
		&lt;cfif <xsl:for-each select="object/fields/field[@primaryKey = 'true']">Len(arguments.to.<xsl:value-of select="@alias" />) AND </xsl:for-each>exists(arguments.to)&gt;
			&lt;cfset update(arguments.to) /&gt;
		&lt;cfelse&gt;
			&lt;cfset create(arguments.to) /&gt;
		&lt;/cfif&gt;
			</xsl:when>
			<xsl:when test="count(object/fields/field[@primaryKey = 'true']) = 0">
		&lt;cfset create(arguments.to) /&gt;
			</xsl:when>
		</xsl:choose>
	&lt;/cffunction&gt;
	
	<xsl:if test="count(object/fields/field[@primaryKey = 'true']) &gt; 0">
	&lt;cffunction name="exists" access="public" hint="I check to see if the <xsl:value-of select="object/@alias" /> object exists." output="false" returntype="any" _returntype="boolean"&gt;
		&lt;cfargument name="to" hint="I am the transfer object for <xsl:value-of select="object/@alias" /> which will be checked." required="yes" type="any" _type="reactor.project.<xsl:value-of select="object/@project"/>.To.<xsl:value-of select="object/@alias"/>To" /&gt;
		&lt;cfset var qExists = 0 /&gt;
		&lt;cfset var <xsl:value-of select="object/@alias" />Gateway = _getReactorFactory().createGateway("<xsl:value-of select="object/@alias" />") /&gt;
				
		&lt;cfset qExists = <xsl:value-of select="object/@alias" />Gateway.getByFields(
			<xsl:for-each select="object/fields/field[@primaryKey = 'true']">
				<xsl:value-of select="@alias" /> = arguments.to.<xsl:value-of select="@alias" />
				<xsl:if test="position() != last()">,</xsl:if>
			</xsl:for-each>
		) /&gt;
		
		&lt;cfif qExists.recordCount&gt;
			&lt;cfreturn true /&gt;
		&lt;cfelse&gt;
			&lt;cfreturn false /&gt;
		&lt;/cfif&gt;
	&lt;/cffunction&gt;
	</xsl:if>
	
	&lt;cffunction name="create" access="public" hint="I create a <xsl:value-of select="object/@alias" /> object." output="false" returntype="void"&gt;
		&lt;cfargument name="to" hint="I am the transfer object for <xsl:value-of select="object/@alias" />" required="yes" type="any" _type="reactor.project.<xsl:value-of select="object/@project"/>.To.<xsl:value-of select="object/@alias"/>To"/&gt;
		&lt;cfset var Convention = getConventions() /&gt;
		&lt;cfset var qCreate = 0 /&gt;
		
		<xsl:if test="//field[@sequence != '']">
			&lt;cfif Convention.supportsSequences()&gt;
				<xsl:for-each select="//field[@sequence != '']">
					<xsl:if test="not(@primaryKey = 'true' and @identity = 'true')">
						&lt;cfquery name="qCreate" datasource="#_getConfig().getDsn()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#"&gt;
							#Convention.getNextSequenceSyntax("<xsl:value-of select="@sequence" />")#
						&lt;/cfquery&gt;
						&lt;cfset arguments.to.<xsl:value-of select="@alias" /> = qCreate.ID /&gt;
					</xsl:if>
				</xsl:for-each>
			&lt;/cfif&gt;
		</xsl:if>
	
		&lt;cfquery name="qCreate" datasource="#_getConfig().getDsn()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#"&gt;
			INSERT INTO #Convention.FormatObjectName(getObjectMetadata())#
			(
				<xsl:for-each select="object/fields/field[@readOnly = 'false']">
					
					<xsl:if test="@identity = 'true' or @sequence != ''">
						&lt;cfif (NOT Convention.supportsIdentity()) OR (<xsl:if test="not(@sequence != '' and (@identity = 'false' or (@identity = 'true' and @primaryKey = 'false')))">false AND</xsl:if> Convention.supportsSequences())&gt;
					</xsl:if>
					
					#Convention.formatInsertFieldName('<xsl:value-of select="@name" />', '<xsl:value-of select="../../@name" />')#
						
					<xsl:if test="position() != last()">,</xsl:if>
					
					<xsl:if test="@identity = 'true' or @sequence != ''">
						&lt;/cfif&gt;
					</xsl:if>
				</xsl:for-each>
			) VALUES (
				<xsl:for-each select="object/fields/field[@readOnly = 'false']">
					<xsl:if test="@identity = 'true' or @sequence != ''">
						&lt;cfif (NOT Convention.supportsIdentity()) OR (<xsl:if test="not(@sequence != '' and (@identity = 'false' or (@identity = 'true' and @primaryKey = 'false')))">false AND</xsl:if> Convention.supportsSequences())&gt;
					</xsl:if>
					
					&lt;cfqueryparam cfsqltype="<xsl:value-of select="@cfSqlType" />"
					<xsl:if test="@length > 0 and @cfSqlType != 'cf_sql_longvarchar'">
						maxlength="<xsl:value-of select="@length" />"
					</xsl:if>
					<xsl:if test="@scale > 0">
						scale="<xsl:value-of select="@scale" />" 
					</xsl:if>
					value="<xsl:choose>
						<xsl:when test="@dbDataType = 'uniqueidentifier'">#Left(arguments.to.<xsl:value-of select="@alias" />, 23)#-#Right(arguments.to.<xsl:value-of select="@alias" />, 12)#</xsl:when>
						<xsl:otherwise>#arguments.to.<xsl:value-of select="@alias" />#</xsl:otherwise>
					</xsl:choose>"
					<xsl:if test="@nullable = 'true'">	
						null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@alias" />), DE(true), DE(false))#"
					</xsl:if> /&gt;
					
					<xsl:if test="position() != last()">,</xsl:if>
					
					<xsl:if test="@identity = 'true' or @sequence != ''">
						&lt;/cfif&gt;
					</xsl:if>
					
				</xsl:for-each>
			)
			
			<!-- some dbms require the last inserted id syntax to be run at the same time as the query -->
			<xsl:if test="object/fields/field[@identity = 'true']">
				&lt;cfif Convention.supportsMultiStatementQueries() AND Convention.supportsIdentity() &gt;
					#Convention.lastInsertedIdSyntax(getObjectMetadata())#
				&lt;/cfif&gt;	
			</xsl:if>
		&lt;/cfquery&gt;
				
		<xsl:if test="object/fields/field[@identity = 'true']">
			<!-- other dbms require this in a seperate query -->	
			&lt;cfif NOT Convention.supportsMultiStatementQueries() AND Convention.supportsIdentity() &gt;
				&lt;cfquery name="qCreate" datasource="#_getConfig().getDsn()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#"&gt;	
					#Convention.lastInsertedIdSyntax(getObjectMetadata())#
				&lt;/cfquery&gt;		
			&lt;/cfif&gt;

			&lt;cfif Convention.supportsIdentity() AND qCreate.recordCount&gt;
				&lt;cfset arguments.to.<xsl:value-of select="object/fields/field[@identity = 'true']/@alias" /> = qCreate.id /&gt;
			&lt;/cfif&gt;
		</xsl:if>
	&lt;/cffunction&gt;
	
	&lt;cffunction name="read" access="public" hint="I read a  <xsl:value-of select="object/@alias" /> object." output="false" returntype="void"&gt;
		&lt;cfargument name="to" hint="I am the transfer object for <xsl:value-of select="object/@alias" /> which will be populated." required="yes" type="any" _type="reactor.project.<xsl:value-of select="object/@project"/>.To.<xsl:value-of select="object/@alias"/>To"/&gt;
		&lt;cfargument name="loadFieldList" hint="I am an optional list of fields to load the record based on.  If not provided I default to the primary key values." required="no" type="any" _type="string" default="" /&gt;
		&lt;cfset var qRead = 0 /&gt;
		&lt;cfset var <xsl:value-of select="object/@alias" />Gateway = _getReactorFactory().createGateway("<xsl:value-of select="object/@alias" />") /&gt;
		&lt;cfset var <xsl:value-of select="object/@alias" />Query = 0 /&gt;
		&lt;cfset var field = "" /&gt;
		
		&lt;cfif Len(arguments.loadFieldList)&gt;
			&lt;cfset <xsl:value-of select="object/@alias" />Query = <xsl:value-of select="object/@alias" />Gateway.createQuery() /&gt;
			&lt;cfloop list="#arguments.loadFieldList#" index="field"&gt;
				&lt;cfset <xsl:value-of select="object/@alias" />Query.getWhere().isEqual("<xsl:value-of select="object/@alias" />", field, arguments.to[field]) /&gt;
			&lt;/cfloop&gt;
			
			&lt;cfset qRead = <xsl:value-of select="object/@alias" />Gateway.getByQuery(<xsl:value-of select="object/@alias" />Query,true) /&gt;
		&lt;cfelse&gt;
			&lt;cfset qRead = <xsl:value-of select="object/@alias" />Gateway.getByFields(
				<xsl:for-each select="object/fields/field[@primaryKey = 'true']">
					<xsl:value-of select="@alias" /> = arguments.to.<xsl:value-of select="@alias" />
					<xsl:if test="position() != last()">, </xsl:if>
				</xsl:for-each>
			) /&gt;
		&lt;/cfif&gt;
		
		&lt;cfif qRead.recordCount IS 1&gt;
			<xsl:for-each select="//field">
				&lt;cfset arguments.to.<xsl:value-of select="@alias" /> = 
				<xsl:choose>
					<xsl:when test="string-length(../../../@alias) and ../../../@alias != ../../../@name">
						qRead.<xsl:value-of select="../../../@alias" /><xsl:value-of select="@alias" />
					</xsl:when>
					<xsl:otherwise>
						qRead.<xsl:value-of select="@alias" />
					</xsl:otherwise>
				</xsl:choose>
				/&gt;
			</xsl:for-each>
			<xsl:for-each select="//externalField">
				&lt;cfset arguments.to.<xsl:value-of select="@fieldAlias" /> = qRead.<xsl:value-of select="@fieldAlias" /> /&gt;
			</xsl:for-each>
		&lt;cfelseif qRead.recordCount GT 1&gt;
			&lt;cfthrow message="Ambiguous Record" detail="Your request matched more than one record." type="Reactor.Record.AmbiguousRecord" /&gt;
		&lt;cfelseif qRead.recordCount IS 0&gt;
			&lt;cfthrow message="No Matching Record" detail="Your request matched no records." type="Reactor.Record.NoMatchingRecord" /&gt;
		&lt;/cfif&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="update" access="public" hint="I update a <xsl:value-of select="object/@alias" /> object." output="false" returntype="void"&gt;
		&lt;cfargument name="to" hint="I am the transfer object for <xsl:value-of select="object/@alias" /> which will be used to update a record in the table." required="yes" type="any" _type="reactor.project.<xsl:value-of select="object/@project"/>.To.<xsl:value-of select="object/@alias"/>To" /&gt;
  <xsl:if test="count(object/fields/field[@primaryKey = 'false']) &gt; 0">
		&lt;cfset var Convention = getConventions() /&gt;
		&lt;cfset var qUpdate = 0 /&gt;
				
		&lt;cfquery name="qUpdate" datasource="#_getConfig().getDsn()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#"&gt;
			UPDATE #Convention.FormatObjectName(getObjectMetadata())#
			SET 
			<xsl:for-each select="object/fields/field[@primaryKey = 'false' and @readOnly = 'false']">
				#Convention.formatUpdateFieldName('<xsl:value-of select="@name" />')# = &lt;cfqueryparam
					cfsqltype="<xsl:value-of select="@cfSqlType" />"
					<xsl:if test="@length > 0 and @cfSqlType != 'cf_sql_longvarchar'">
						maxlength="<xsl:value-of select="@length" />"
					</xsl:if>
					<xsl:if test="@scale > 0">
						scale="<xsl:value-of select="@scale" />" 
					</xsl:if>
					value="<xsl:choose>
						<xsl:when test="@dbDataType = 'uniqueidentifier'">#Left(arguments.to.<xsl:value-of select="@alias" />, 23)#-#Right(arguments.to.<xsl:value-of select="@alias" />, 12)#</xsl:when>
						<xsl:otherwise>#arguments.to.<xsl:value-of select="@alias" />#</xsl:otherwise>
					</xsl:choose>"
					<xsl:if test="@nullable = 'true'">
						null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@alias" />), DE(true), DE(false))#"
					</xsl:if> /&gt;
				<xsl:if test="position() != last()">
					<xsl:text>,</xsl:text>
				</xsl:if>
			</xsl:for-each>
			WHERE
			<xsl:for-each select="object/fields/field[@primaryKey = 'true' and @readOnly = 'false']">
				#Convention.formatUpdateFieldName('<xsl:value-of select="@name" />')# = &lt;cfqueryparam
					cfsqltype="<xsl:value-of select="@cfSqlType" />"
					<xsl:if test="@length > 0 and @cfSqlType != 'cf_sql_longvarchar'">
						maxlength="<xsl:value-of select="@length" />"
					</xsl:if>
					<xsl:if test="@scale > 0">
						scale="<xsl:value-of select="@scale" />" 
					</xsl:if>
					value="<xsl:choose>
						<xsl:when test="@dbDataType = 'uniqueidentifier'">#Left(arguments.to.<xsl:value-of select="@alias" />, 23)#-#Right(arguments.to.<xsl:value-of select="@alias" />, 12)#</xsl:when>
						<xsl:otherwise>#arguments.to.<xsl:value-of select="@alias" />#</xsl:otherwise>
					</xsl:choose>"
					<xsl:if test="@nullable = 'true'">
						null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@alias" />), DE(true), DE(false))#"
					</xsl:if> /&gt;
				<xsl:if test="position() != last()">
					AND 
				</xsl:if>
			</xsl:for-each>
		&lt;/cfquery&gt;
	</xsl:if>
	&lt;/cffunction&gt;
	
	&lt;cffunction name="delete" access="public" hint="I delete a record in the <xsl:value-of select="object/@alias" /> table." output="false" returntype="void"&gt;
		&lt;cfargument name="to" hint="I am the transfer object for <xsl:value-of select="object/@alias" /> which will be used to delete from the table." required="yes" type="any" _type="reactor.project.<xsl:value-of select="object/@project"/>.To.<xsl:value-of select="object/@alias"/>To" /&gt;
		&lt;cfset var Convention = getConventions() /&gt;
		&lt;cfset var qDelete = 0 /&gt;
		
		&lt;cfquery name="qDelete" datasource="#_getConfig().getDsn()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#"&gt;
			DELETE FROM #Convention.FormatObjectName(getObjectMetadata())#
			WHERE
			<xsl:for-each select="object/fields/field[@primaryKey = 'true']">
				#Convention.formatUpdateFieldName('<xsl:value-of select="@name" />', '<xsl:value-of select="../../@name" />')# = &lt;cfqueryparam
					cfsqltype="<xsl:value-of select="@cfSqlType" />"
					<xsl:if test="@length > 0 and @cfSqlType != 'cf_sql_longvarchar'">
						maxlength="<xsl:value-of select="@length" />"
					</xsl:if>
					<xsl:if test="@scale > 0">
						scale="<xsl:value-of select="@scale" />" 
					</xsl:if>
					value="<xsl:choose>
						<xsl:when test="@dbDataType = 'uniqueidentifier'">#Left(arguments.to.<xsl:value-of select="@alias" />, 23)#-#Right(arguments.to.<xsl:value-of select="@alias" />, 12)#</xsl:when>
						<xsl:otherwise>#arguments.to.<xsl:value-of select="@alias" />#</xsl:otherwise>
					</xsl:choose>"
					<xsl:if test="@nullable = 'true'">
						null="#Iif(NOT Len(arguments.to.<xsl:value-of select="@alias" />), DE(true), DE(false))#"
					</xsl:if> /&gt;
				<xsl:if test="position() != last()">
					AND 
				</xsl:if>
			</xsl:for-each>
		&lt;/cfquery&gt;
		
	&lt;/cffunction&gt;
	
&lt;/cfcomponent&gt;
	</xsl:template>
		
</xsl:stylesheet>
