<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">
&lt;cfcomponent hint="I am the base validator object for the <xsl:value-of select="object/@alias"/> object.  I am generated.  DO NOT EDIT ME (but feel free to delete me)."
	extends="reactor.base.abstractValidator" &gt;

	&lt;cfset variables.signature = "<xsl:value-of select="object/@signature" />" /&gt;

	&lt;!--- validate ---&gt;
	&lt;cffunction name="validate" access="public" hint="I validate an <xsl:value-of select="@alias" /> record" output="false" returntype="any" _returntype="reactor.util.ErrorCollection"&gt;
		&lt;cfargument name="<xsl:value-of select="object/@alias" />Record" hint="I am the Record to validate." required="no" type="any" _type="reactor.project.<xsl:value-of select="object/@project"/>.Record.<xsl:value-of select="object/@alias"/>Record" /&gt;
		&lt;cfargument name="ErrorCollection" hint="I am the error collection to populate. If not provided a new collection is created." required="no" type="any" _type="reactor.util.ErrorCollection" default="#createErrorCollection(arguments.<xsl:value-of select="object/@alias" />Record._getDictionary())#" /&gt;
		
		<xsl:for-each select="object/fields/field">
			&lt;cfset validate<xsl:value-of select="@alias" />(arguments.<xsl:value-of select="../../@alias" />Record, arguments.ErrorCollection) /&gt;
		</xsl:for-each>
		
		&lt;cfreturn arguments.ErrorCollection /&gt;
	&lt;/cffunction&gt;
	
	<xsl:for-each select="object/fields/field">
		&lt;!--- validate<xsl:value-of select="@alias" /> ---&gt;
		&lt;cffunction name="validate<xsl:value-of select="@alias" />" access="public" hint="I validate the <xsl:value-of select="@alias" /> field" output="false" returntype="any" _returntype="reactor.util.ErrorCollection"&gt;
			&lt;cfargument name="<xsl:value-of select="../../@alias" />Record" hint="I am the Record to validate." required="no" type="any" _type="reactor.project.<xsl:value-of select="../../@project"/>.Record.<xsl:value-of select="../../@alias"/>Record"/&gt;
			&lt;cfargument name="ErrorCollection" hint="I am the error collection to populate. If not provided a new collection is created." required="no" type="any" _type="reactor.util.ErrorCollection" default="#createErrorCollection(arguments.<xsl:value-of select="../../@alias" />Record._getDictionary())#" /&gt;
		
			<xsl:if test="@nullable = 'false'">
				&lt;!--- validate <xsl:value-of select="@alias" /> is provided ---&gt;
				&lt;cfset validate<xsl:value-of select="@alias" />Provided(arguments.<xsl:value-of select="../../@alias" />Record, arguments.ErrorCollection)&gt;
			</xsl:if>
			
			&lt;!--- validate <xsl:value-of select="@alias" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
			&lt;cfset validate<xsl:value-of select="@alias" />Datatype(arguments.<xsl:value-of select="../../@alias" />Record, arguments.ErrorCollection)&gt;
			
			<xsl:if test="(@cfDataType = 'binary' or @cfDataType = 'string') and @dbDataType != 'uniqueidentifier'">
				&lt;!--- validate <xsl:value-of select="@alias" /> length ---&gt;
				&lt;cfset validate<xsl:value-of select="@alias" />Length(arguments.<xsl:value-of select="../../@alias" />Record, arguments.ErrorCollection)&gt;
			</xsl:if>
		
			&lt;cfreturn arguments.ErrorCollection /&gt;
		&lt;/cffunction&gt;
	</xsl:for-each>
	
	<!-- validate provided -->
	<xsl:for-each select="object/fields/field">
		<xsl:if test="@nullable = 'false'">
			&lt;!--- validate<xsl:value-of select="@alias" />Provided ---&gt;
			&lt;cffunction name="validate<xsl:value-of select="@alias" />Provided" access="public" hint="I validate that the <xsl:value-of select="@alias" /> field was provided" output="false" returntype="any" _returntype="reactor.util.ErrorCollection"&gt;
				&lt;cfargument name="<xsl:value-of select="../../@alias" />Record" hint="I am the Record to validate." required="no" type="any" _type="reactor.project.<xsl:value-of select="../../@project"/>.Record.<xsl:value-of select="../../@alias"/>Record" /&gt;
				&lt;cfargument name="ErrorCollection" hint="I am the error collection to populate. If not provided a new collection is created." required="no" type="any" _type="reactor.util.ErrorCollection" default="#createErrorCollection(arguments.<xsl:value-of select="../../@alias" />Record._getDictionary())#" /&gt;
		
				&lt;!--- validate <xsl:value-of select="@alias" /> is provided ---&gt;
				&lt;cfif NOT Len(Trim(arguments.<xsl:value-of select="../../@alias" />Record.get<xsl:value-of select="@alias" />()))&gt;
					&lt;cfset arguments.ErrorCollection.addError("<xsl:value-of select="../../@alias" />.<xsl:value-of select="@alias" />.notProvided") /&gt;
				&lt;/cfif&gt;
				
				&lt;cfreturn arguments.ErrorCollection /&gt;
			&lt;/cffunction&gt;
		</xsl:if>
	</xsl:for-each>
	
	<!-- validate datatype -->
	<xsl:for-each select="object/fields/field">
		&lt;!--- validate<xsl:value-of select="@alias" />Datatype ---&gt;
		&lt;cffunction name="validate<xsl:value-of select="@alias" />Datatype" access="public" hint="I validate that the <xsl:value-of select="@alias" /> field is <xsl:value-of select="@cfDataType" />." output="false" returntype="any" _returntype="reactor.util.ErrorCollection"&gt;
			&lt;cfargument name="<xsl:value-of select="../../@alias" />Record" hint="I am the Record to validate." required="no" type="any" _type="reactor.project.<xsl:value-of select="../../@project"/>.Record.<xsl:value-of select="../../@alias"/>Record" /&gt;
			&lt;cfargument name="ErrorCollection" hint="I am the error collection to populate. If not provided a new collection is created." required="no" type="any" _type="reactor.util.ErrorCollection" default="#createErrorCollection(arguments.<xsl:value-of select="../../@alias" />Record._getDictionary())#" /&gt;
	
			<xsl:choose>
				<xsl:when test="@cfDataType = 'binary'">
					&lt;!--- validate <xsl:value-of select="@alias" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
					&lt;cfif Len(arguments.<xsl:value-of select="../../@alias" />Record.get<xsl:value-of select="@alias" />()) AND NOT IsBinary(arguments.<xsl:value-of select="../../@alias" />Record.get<xsl:value-of select="@alias" />())&gt;
						&lt;cfset arguments.ErrorCollection.addError("<xsl:value-of select="../../@alias" />.<xsl:value-of select="@alias" />.invalidType") /&gt;
					&lt;/cfif&gt;
				</xsl:when>
				<xsl:when test="@cfDataType = 'boolean'">
					&lt;!--- validate <xsl:value-of select="@alias" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
					&lt;cfif NOT IsBoolean(arguments.<xsl:value-of select="../../@alias" />Record.get<xsl:value-of select="@alias" />())&gt;
						&lt;cfset arguments.ErrorCollection.addError("<xsl:value-of select="../../@alias" />.<xsl:value-of select="@alias" />.invalidType") /&gt;
					&lt;/cfif&gt;					
				</xsl:when>
				<xsl:when test="@cfDataType = 'date'">
					&lt;!--- validate <xsl:value-of select="@alias" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
					&lt;cfif NOT IsDate(arguments.<xsl:value-of select="../../@alias" />Record.get<xsl:value-of select="@alias" />())<xsl:if test="@nullable = 'true'"> AND Len(Trim(arguments.<xsl:value-of select="../../@alias" />Record.get<xsl:value-of select="@alias" />()))</xsl:if>&gt;
						&lt;cfset arguments.ErrorCollection.addError("<xsl:value-of select="../../@alias" />.<xsl:value-of select="@alias" />.invalidType") /&gt;
					&lt;/cfif&gt;					
				</xsl:when>
				<xsl:when test="@cfDataType = 'numeric'">
					&lt;!--- validate <xsl:value-of select="@alias" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
					&lt;cfif Len(Trim(arguments.<xsl:value-of select="../../@alias" />Record.get<xsl:value-of select="@alias" />())) AND NOT IsNumeric(arguments.<xsl:value-of select="../../@alias" />Record.get<xsl:value-of select="@alias" />())&gt;
						&lt;cfset arguments.ErrorCollection.addError("<xsl:value-of select="../../@alias" />.<xsl:value-of select="@alias" />.invalidType") /&gt;
					&lt;/cfif&gt;					
				</xsl:when>
				<xsl:when test="@cfDataType = 'guid'">
					&lt;!--- validate <xsl:value-of select="@alias" /> is a Microsoft GUID ---&gt;
					&lt;cfif NOT (ReFindNoCase("[A-F0-9]{8,8}-[A-F0-9]{4,4}-[A-F0-9]{4,4}-[A-F0-9]{4,4}-[A-F0-9]{12,12}", arguments.<xsl:value-of select="../../@alias" />Record.get<xsl:value-of select="@alias" />()) OR ReFindNoCase("[A-F0-9]{8,8}-[A-F0-9]{4,4}-[A-F0-9]{4,4}-[A-F0-9]{4,4}-[A-F0-9]{8,8}", arguments.<xsl:value-of select="../../@alias" />Record.get<xsl:value-of select="@alias" />()) )&gt;	
						&lt;cfset arguments.ErrorCollection.addError("<xsl:value-of select="../../@alias" />.<xsl:value-of select="@alias" />.invalidType") /&gt;
					&lt;/cfif&gt;	
				</xsl:when>
				<xsl:when test="@cfDataType = 'uuid'">
					&lt;!--- validate <xsl:value-of select="@alias" /> is a CF uuid ---&gt;
					&lt;cfif NOT ReFindNoCase("[A-F0-9]{8,8}-[A-F0-9]{4,4}-[A-F0-9]{4,4}-[A-F0-9]{16,16}", arguments.<xsl:value-of select="../../@alias" />Record.get<xsl:value-of select="@alias" />())&gt;
						&lt;cfset arguments.ErrorCollection.addError("<xsl:value-of select="../../@alias" />.<xsl:value-of select="@alias" />.invalidType") /&gt;
					&lt;/cfif&gt;	
				</xsl:when>
				<xsl:when test="@dbDataType = 'uniqueidentifier'">
					&lt;!--- validate <xsl:value-of select="@alias" /> is a CF uuid ---&gt;
					&lt;cfif NOT ReFindNoCase("[A-F0-9]{8,8}-[A-F0-9]{4,4}-[A-F0-9]{4,4}-[A-F0-9]{16,16}", arguments.<xsl:value-of select="../../@alias" />Record.get<xsl:value-of select="@alias" />())&gt;
						&lt;cfset arguments.ErrorCollection.addError("<xsl:value-of select="../../@alias" />.<xsl:value-of select="@alias" />.invalidType") /&gt;
					&lt;/cfif&gt;	
				</xsl:when>
				<xsl:when test="@cfDataType = 'string'">
					&lt;!--- validate <xsl:value-of select="@alias" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
					&lt;cfif NOT IsSimpleValue(arguments.<xsl:value-of select="../../@alias" />Record.get<xsl:value-of select="@alias" />())&gt;
						&lt;cfset arguments.ErrorCollection.addError("<xsl:value-of select="../../@alias" />.<xsl:value-of select="@alias" />.invalidType") /&gt;
					&lt;/cfif&gt;				
				</xsl:when>
				<xsl:otherwise>
					&lt;!--- not sure how to validate <xsl:value-of select="@cfDataType" /> data type ---&gt;
				</xsl:otherwise>
			</xsl:choose>
			
			&lt;cfreturn arguments.ErrorCollection /&gt;
		&lt;/cffunction&gt;
	</xsl:for-each>
	
	<!-- validate length -->
	<xsl:for-each select="object/fields/field">
		<xsl:if test="(@cfDataType = 'binary' or @cfDataType = 'string') and @dbDataType != 'uniqueidentifier'">
			&lt;!--- validate<xsl:value-of select="@alias" />Length ---&gt;
			&lt;cffunction name="validate<xsl:value-of select="@alias" />Length" access="public" hint="I validate that the <xsl:value-of select="@alias" /> field length." output="false" returntype="any" _returntype="reactor.util.ErrorCollection"&gt;
				&lt;cfargument name="<xsl:value-of select="../../@alias" />Record" hint="I am the Record to validate." required="no" type="any" _type="reactor.project.<xsl:value-of select="../../@project"/>.Record.<xsl:value-of select="../../@alias"/>Record" /&gt;
				&lt;cfargument name="ErrorCollection" hint="I am the error collection to populate. If not provided a new collection is created." required="no" type="any" _type="reactor.util.ErrorCollection" default="#createErrorCollection(arguments.<xsl:value-of select="../../@alias" />Record._getDictionary())#" /&gt;
		
				<xsl:choose>
					<xsl:when test="@cfDataType = 'binary'">
						&lt;!--- validate <xsl:value-of select="@alias" /> length ---&gt;
						&lt;cfif Len(arguments.<xsl:value-of select="../../@alias" />Record.get<xsl:value-of select="@alias" />()) GT <xsl:value-of select="@length" /> &gt;
							&lt;cfset arguments.ErrorCollection.addError("<xsl:value-of select="../../@alias" />.<xsl:value-of select="@alias" />.invalidLength") /&gt;
						&lt;/cfif&gt;				
					</xsl:when>
					<xsl:when test="@cfDataType = 'string'">
						&lt;!--- validate <xsl:value-of select="@alias" /> length ---&gt;
						&lt;cfif Len(arguments.<xsl:value-of select="../../@alias" />Record.get<xsl:value-of select="@alias" />()) GT <xsl:value-of select="@length" /> AND <xsl:value-of select="@length" /> IS NOT -1 &gt;
							&lt;cfset arguments.ErrorCollection.addError("<xsl:value-of select="../../@alias" />.<xsl:value-of select="@alias" />.invalidLength") /&gt;
						&lt;/cfif&gt;					
					</xsl:when>
				</xsl:choose>
				
				&lt;cfreturn arguments.ErrorCollection /&gt;
			&lt;/cffunction&gt;
		</xsl:if>
	</xsl:for-each>
	
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>