<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">
&lt;cfcomponent hint="I am the base record representing the <xsl:value-of select="object/@alias"/> object.  I am generated.  DO NOT EDIT ME (but feel free to delete me)."
	extends="reactor.base.abstractRecord" &gt;
	
	&lt;cfset variables.signature = "<xsl:value-of select="object/@signature" />" /&gt;
	
	&lt;cffunction name="init" access="public" hint="I configure and return this record object." output="false" returntype="reactor.project.<xsl:value-of select="object/@project"/>.Record.<xsl:value-of select="object/@alias"/>Record"&gt;
		<xsl:for-each select="//field">
			&lt;cfargument name="<xsl:value-of select="@alias" />" hint="I am the default value for the <xsl:value-of select="@alias" /> field." required="no" type="string" default="<xsl:value-of select="@default" />" /&gt;
		</xsl:for-each>
		
		<xsl:for-each select="object/fields/field">
			&lt;cfset set<xsl:value-of select="@alias" />(arguments.<xsl:value-of select="@alias" />) /&gt;
		</xsl:for-each>
		&lt;cfreturn this /&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection"&gt;
		&lt;cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" /&gt;
		&lt;cfset var ErrorManager = CreateObject("Component", "reactor.core.errorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) /&gt;
		&lt;cfset var Event = 0 /&gt;
				
		&lt;!--- raise the beforeValidate event ---&gt;
		&lt;cfset Event = newEvent("beforeValidate") /&gt;
		&lt;cfset Event.setValue("ValidationErrorCollection", arguments.ValidationErrorCollection) /&gt;
		&lt;cfset Event.setValue("SourceRecord", this) /&gt;
		&lt;cfset announceEvent(Event) /&gt;
		
		<xsl:for-each select="object/fields/field">
			<xsl:choose>
				<xsl:when test="@cfDataType = 'binary'">
					<xsl:if test="@nullable = 'false'">
						&lt;!--- validate <xsl:value-of select="@alias" /> is provided ---&gt;
						&lt;cfif NOT Len(Trim(get<xsl:value-of select="@alias" />()))&gt;
							&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@alias" />", "notProvided")) /&gt;
						&lt;/cfif&gt;
					</xsl:if>
					
					&lt;!--- validate <xsl:value-of select="@alias" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
					&lt;cfif NOT IsBinary(get<xsl:value-of select="@alias" />())&gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@alias" />", "invalidType")) /&gt;
					&lt;/cfif&gt;
					
					&lt;!--- validate <xsl:value-of select="@alias" /> length ---&gt;
					&lt;cfif Len(get<xsl:value-of select="@alias" />()) GT <xsl:value-of select="@length" /> &gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@alias" />", "invalidLength")) /&gt;
					&lt;/cfif&gt;				
				</xsl:when>
				
				<xsl:when test="@cfDataType = 'boolean'">
					<xsl:if test="@nullable = 'false'">
						&lt;!--- validate <xsl:value-of select="@alias" /> is provided ---&gt;
						&lt;cfif NOT Len(Trim(get<xsl:value-of select="@alias" />()))&gt;
							&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@alias" />", "notProvided")) /&gt;
						&lt;/cfif&gt;
					</xsl:if>
					
					&lt;!--- validate <xsl:value-of select="@alias" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
					&lt;cfif NOT IsBoolean(get<xsl:value-of select="@alias" />())&gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@alias" />", "invalidType")) /&gt;
					&lt;/cfif&gt;					
				</xsl:when>
			
				<xsl:when test="@cfDataType = 'date'">
					<xsl:if test="@nullable = 'false'">
						&lt;!--- validate <xsl:value-of select="@alias" /> is provided ---&gt;
						&lt;cfif NOT Len(Trim(get<xsl:value-of select="@alias" />()))&gt;
							&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@alias" />", "notProvided")) /&gt;
						&lt;/cfif&gt;
					</xsl:if>
					
					&lt;!--- validate <xsl:value-of select="@alias" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
					&lt;cfif NOT IsDate(get<xsl:value-of select="@alias" />())<xsl:if test="@nullable = 'true'"> AND Len(Trim(get<xsl:value-of select="@name" />()))</xsl:if>&gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@alias" />", "invalidType")) /&gt;
					&lt;/cfif&gt;					
				</xsl:when>
				
				<xsl:when test="@cfDataType = 'numeric'">
					<xsl:if test="@nullable = 'false'">
						&lt;!--- validate <xsl:value-of select="@alias" /> is provided ---&gt;
						&lt;cfif NOT Len(Trim(get<xsl:value-of select="@alias" />()))&gt;
							&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@alias" />", "notProvided")) /&gt;
						&lt;/cfif&gt;
					</xsl:if>
					
					&lt;!--- validate <xsl:value-of select="@alias" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
					&lt;cfif Len(Trim(get<xsl:value-of select="@alias" />())) AND NOT IsNumeric(get<xsl:value-of select="@name" />())&gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@alias" />", "invalidType")) /&gt;
					&lt;/cfif&gt;					
				</xsl:when>
				
				<xsl:when test="@cfDataType = 'string'">
					<xsl:if test="@nullable = 'false'">
						&lt;!--- validate <xsl:value-of select="@alias" /> is provided ---&gt;
						&lt;cfif NOT Len(Trim(get<xsl:value-of select="@alias" />()))&gt;
							&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@alias" />", "notProvided")) /&gt;
						&lt;/cfif&gt;
					</xsl:if>
					
					&lt;!--- validate <xsl:value-of select="@alias" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
					&lt;cfif NOT IsSimpleValue(get<xsl:value-of select="@alias" />())&gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@alias" />", "invalidType")) /&gt;
					&lt;/cfif&gt;
					
					&lt;!--- validate <xsl:value-of select="@alias" /> length ---&gt;
					&lt;cfif Len(get<xsl:value-of select="@alias" />()) GT <xsl:value-of select="@length" /> AND <xsl:value-of select="@length" /> IS NOT -1 &gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@alias" />", "invalidLength")) /&gt;
					&lt;/cfif&gt;					
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
		
		&lt;!--- raise the afterValidate event ---&gt;
		&lt;cfset Event = newEvent("afterValidate") /&gt;
		&lt;cfset Event.setValue("ValidationErrorCollection", arguments.ValidationErrorCollection) /&gt;
		&lt;cfset Event.setValue("SourceRecord", this) /&gt;
		&lt;cfset announceEvent(Event) /&gt;
		
		&lt;cfreturn arguments.ValidationErrorCollection /&gt;
	&lt;/cffunction&gt;
	
	<xsl:for-each select="object/fields/field">
		&lt;!--- <xsl:value-of select="@alias"/> ---&gt;
		&lt;cffunction name="set<xsl:value-of select="@alias"/>" access="public" output="false" returntype="void"&gt;
			&lt;cfargument name="<xsl:value-of select="@alias"/>" hint="I am this record's <xsl:value-of select="@alias"/> value." required="yes" type="string" /&gt;
			&lt;cfset _getTo().<xsl:value-of select="@alias"/> = arguments.<xsl:value-of select="@alias"/> /&gt;
		&lt;/cffunction&gt;
		&lt;cffunction name="get<xsl:value-of select="@alias"/>" access="public" output="false" returntype="string"&gt;
			&lt;cfreturn _getTo().<xsl:value-of select="@alias"/> /&gt;
		&lt;/cffunction&gt;	
	</xsl:for-each>
	
	&lt;cffunction name="load" access="public" hint="I load the <xsl:value-of select="object/@alias"/> record.  All of the Primary Key values must be provided for this to work." output="false" returntype="reactor.project.<xsl:value-of select="/object/@project"/>.Record.<xsl:value-of select="object/@alias"/>Record"&gt;
		&lt;cfset var fieldList = StructKeyList(arguments) /&gt;
		&lt;cfset var item = 0 /&gt;
		&lt;cfset var func = 0 /&gt;
		
		&lt;!--- raise the beforeLoad event ---&gt;
		&lt;cfset Event = newEvent("beforeLoad") /&gt;
		&lt;cfset Event.setValue("SourceRecord", this) /&gt;
		&lt;cfset announceEvent(Event) /&gt;
		
		&lt;cfif IsDefined("arguments") AND fieldList IS 1&gt;
			&lt;cfset fieldList = arguments[1] /&gt;
			
		&lt;cfelseif IsDefined("arguments") AND fieldList IS NOT 1&gt;
			&lt;cfloop collection="#arguments#" item="item"&gt;
				&lt;cfset func = this["set#item#"] /&gt;
				&lt;cfset func(arguments[item]) /&gt;
			&lt;/cfloop&gt;
			
		&lt;/cfif&gt;
		
		&lt;cfset _getDao().read(_getTo(), fieldList) /&gt;
		
		&lt;!--- raise the afterLoad event ---&gt;
		&lt;cfset Event = newEvent("afterLoad") /&gt;
		&lt;cfset Event.setValue("SourceRecord", this) /&gt;
		&lt;cfset announceEvent(Event) /&gt;
		
		&lt;cfreturn this /&gt;
	&lt;/cffunction&gt;	
	
	&lt;cffunction name="save" access="public" hint="I save the <xsl:value-of select="object/@alias"/> record.  All of the Primary Key and required values must be provided and valid for this to work." output="false" returntype="void"&gt;
		&lt;!--- raise the beforeSave event ---&gt;
		&lt;cfset Event = newEvent("beforeSave") /&gt;
		&lt;cfset Event.setValue("SourceRecord", this) /&gt;
		&lt;cfset announceEvent(Event) /&gt;
		
		&lt;cfset _getDao().save(_getTo()) /&gt;	
		
		&lt;!--- raise the afterSave event ---&gt;
		&lt;cfset Event = newEvent("afterSave") /&gt;
		&lt;cfset Event.setValue("SourceRecord", this) /&gt;
		&lt;cfset announceEvent(Event) /&gt;	
	&lt;/cffunction&gt;	
	
	&lt;cffunction name="delete" access="public" hint="I delete the <xsl:value-of select="object/@alias"/> record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void"&gt;
		&lt;!--- raise the beforeDelete event ---&gt;
		&lt;cfset Event = newEvent("beforeDelete") /&gt;
		&lt;cfset Event.setValue("SourceRecord", this) /&gt;
		&lt;cfset announceEvent(Event) /&gt;
		
		&lt;cfif IsDefined("arguments")&gt;
			&lt;cfinvoke component="#this#" method="load" argumentcollection="#arguments#" /&gt;
		&lt;/cfif&gt;
	
		&lt;cfset _getDao().delete(_getTo()) /&gt;
		
		&lt;!--- reset the to ---&gt;
		&lt;cfset _setTo(_getReactorFactory().createTo("<xsl:value-of select="object/@alias" />")) /&gt;
		
		&lt;!--- raise the afterDelete event ---&gt;
		&lt;cfset Event = newEvent("afterDelete") /&gt;
		&lt;cfset Event.setValue("SourceRecord", this) /&gt;
		&lt;cfset announceEvent(Event) /&gt;
	&lt;/cffunction&gt;
	
	<xsl:for-each select="object/hasOne">
	&lt;!--- Record For <xsl:value-of select="@alias"/> ---&gt;
	&lt;cffunction name="set<xsl:value-of select="@alias"/>Record" access="public" output="false" returntype="void"&gt;
	    &lt;cfargument name="<xsl:value-of select="@alias"/>Record" hint="I am the Record to set the <xsl:value-of select="@alias"/> value from." required="yes" type="reactor.project.<xsl:value-of select="/object/@project"/>.Record.<xsl:value-of select="@name"/>Record" /&gt;
		<xsl:for-each select="relate">
			&lt;cfset set<xsl:value-of select="@from" />(arguments.<xsl:value-of select="../@alias"/>Record.get<xsl:value-of select="@to" />()) /&gt;
		</xsl:for-each>
		
		&lt;cfset variables.<xsl:value-of select="@alias"/>Record = arguments.<xsl:value-of select="@alias"/>Record /&gt;
	&lt;/cffunction&gt;
	&lt;cffunction name="get<xsl:value-of select="@alias"/>Record" access="public" output="false" returntype="reactor.project.<xsl:value-of select="/object/@project"/>.Record.<xsl:value-of select="@name"/>Record"&gt;
		&lt;cfif NOT IsDefined("variables.<xsl:value-of select="@alias"/>Record")&gt;
			&lt;cfset variables.<xsl:value-of select="@alias"/>Record = _getReactorFactory().createRecord("<xsl:value-of select="@name" />") /&gt;
			<xsl:for-each select="relate">
				&lt;cfset variables.<xsl:value-of select="../@alias"/>Record.set<xsl:value-of select="@to" />(get<xsl:value-of select="@from" />()) /&gt;
			</xsl:for-each>
			&lt;cfset variables.<xsl:value-of select="@alias"/>Record.load('<xsl:for-each select="relate"><xsl:value-of select="@to" />,</xsl:for-each>') /&gt; 
		&lt;/cfif&gt;
		
		&lt;cfreturn variables.<xsl:value-of select="@alias"/>Record /&gt;
	&lt;/cffunction&gt;
	</xsl:for-each>
	
	<xsl:for-each select="object/hasMany">
		&lt;!--- Iterator For <xsl:value-of select="@alias"/> ---&gt;
		&lt;cffunction name="get<xsl:value-of select="@alias"/>Iterator" access="public" output="false" returntype="reactor.iterator.iterator"&gt;
			&lt;cfset var relationship = 0 /&gt;
			
			&lt;cfif NOT IsDefined("variables.<xsl:value-of select="@alias"/>Iterator")&gt;
				&lt;cfset variables.<xsl:value-of select="@alias"/>Iterator = CreateObject("Component", "reactor.iterator.iterator").init(_getReactorFactory(), "<xsl:value-of select="@name"/>", 
					"<xsl:for-each select="link">
						<xsl:value-of select="@name"/>
						<xsl:if test="position() != last()">,</xsl:if>
					</xsl:for-each>") />
					
				<xsl:choose>
					<xsl:when test="count(relate) &gt; 0">
						<xsl:for-each select="relate">
							&lt;cfset variables.<xsl:value-of select="../@alias"/>Iterator.getWhere().isEqual("<xsl:value-of select="../@name"/>", "<xsl:value-of select="@to"/>", get<xsl:value-of select="@from"/>()) /&gt;
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="count(link) &gt; 0">
						&lt;cfset relationship = _getReactorFactory().createMetadata("<xsl:value-of select="link/@name"/>").getRelationship("<xsl:value-of select="/object/@alias"/>").relate /&gt;
			
						&lt;cfloop from="1" to="#ArrayLen(relationship)#" index="x"&gt;
							&lt;cfset variables.<xsl:value-of select="@alias"/>Iterator.getWhere().isEqual("<xsl:value-of select="link/@name"/>", relationship[x].from, evaluate("get#relationship[x].to#()")) /&gt;
						&lt;/cfloop&gt;
					</xsl:when>
				</xsl:choose>
				
			&lt;/cfif&gt;
			
			&lt;cfreturn variables.<xsl:value-of select="@alias"/>Iterator /&gt;
		&lt;/cffunction&gt;
	</xsl:for-each>	
	
	&lt;!--- to ---&gt;
	&lt;cffunction name="_setTo" access="public" output="false" returntype="void"&gt;
	    &lt;cfargument name="to" hint="I am this record's transfer object." required="yes" type="reactor.project.<xsl:value-of select="object/@project"/>.To.<xsl:value-of select="object/@alias"/>To" /&gt;
	    &lt;cfset variables.to = arguments.to /&gt;
	&lt;/cffunction&gt;
	&lt;cffunction name="_getTo" access="public" output="false" returntype="reactor.project.<xsl:value-of select="object/@project"/>.To.<xsl:value-of select="object/@alias"/>To"&gt;
		&lt;cfreturn variables.to /&gt;
	&lt;/cffunction&gt;	
	
	&lt;!--- dao ---&gt;
	&lt;cffunction name="_setDao" access="private" output="false" returntype="void"&gt;
	    &lt;cfargument name="dao" hint="I am the Dao this Record uses to load and save itself." required="yes" type="reactor.project.<xsl:value-of select="object/@project"/>.Dao.<xsl:value-of select="object/@alias"/>Dao" /&gt;
	    &lt;cfset variables.dao = arguments.dao /&gt;
	&lt;/cffunction&gt;
	&lt;cffunction name="_getDao" access="private" output="false" returntype="reactor.project.<xsl:value-of select="object/@project"/>.Dao.<xsl:value-of select="object/@alias"/>Dao"&gt;
	    &lt;cfreturn variables.dao /&gt;
	&lt;/cffunction&gt;
	
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>