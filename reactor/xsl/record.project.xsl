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
		&lt;cfargument name="ExternalValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" /&gt;
		&lt;cfset var Event = 0 /&gt;
		&lt;cfset var ValidationErrorCollection = createErrorCollection() /&gt;
		
		&lt;!--- raise the beforeValidate event
		&lt;cfset Event = newEvent("beforeValidate") /&gt;
		&lt;cfset Event.setValue("ValidationErrorCollection", arguments.ExternalValidationErrorCollection) /&gt;
		&lt;cfset Event.setValue("SourceRecord", this) /&gt;
		&lt;cfset announceEvent(Event) /&gt; ---&gt;
		
		<xsl:for-each select="object/fields/field">
			<xsl:choose>
				<xsl:when test="@cfDataType = 'binary'">
					<xsl:if test="@nullable = 'false'">
						&lt;!--- validate <xsl:value-of select="@alias" /> is provided ---&gt;
						&lt;cfif NOT Len(Trim(get<xsl:value-of select="@alias" />()))&gt;
							&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", _getDictionary().getValue("<xsl:value-of select="@alias" />.notProvided")) /&gt;
						&lt;/cfif&gt;
					</xsl:if>
					
					&lt;!--- validate <xsl:value-of select="@alias" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
					&lt;cfif NOT IsBinary(get<xsl:value-of select="@alias" />())&gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", _getDictionary().getValue("<xsl:value-of select="@alias" />.invalidType")) /&gt;
					&lt;/cfif&gt;
					
					&lt;!--- validate <xsl:value-of select="@alias" /> length ---&gt;
					&lt;cfif Len(get<xsl:value-of select="@alias" />()) GT <xsl:value-of select="@length" /> &gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", _getDictionary().getValue("<xsl:value-of select="@alias" />.invalidLength")) /&gt;
					&lt;/cfif&gt;				
				</xsl:when>
				
				<xsl:when test="@cfDataType = 'boolean'">
					<xsl:if test="@nullable = 'false'">
						&lt;!--- validate <xsl:value-of select="@alias" /> is provided ---&gt;
						&lt;cfif NOT Len(Trim(get<xsl:value-of select="@alias" />()))&gt;
							&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", _getDictionary().getValue("<xsl:value-of select="@alias" />.notProvided")) /&gt;
						&lt;/cfif&gt;
					</xsl:if>
					
					&lt;!--- validate <xsl:value-of select="@alias" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
					&lt;cfif NOT IsBoolean(get<xsl:value-of select="@alias" />())&gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", _getDictionary().getValue("<xsl:value-of select="@alias" />.invalidType")) /&gt;
					&lt;/cfif&gt;					
				</xsl:when>
			
				<xsl:when test="@cfDataType = 'date'">
					<xsl:if test="@nullable = 'false'">
						&lt;!--- validate <xsl:value-of select="@alias" /> is provided ---&gt;
						&lt;cfif NOT Len(Trim(get<xsl:value-of select="@alias" />()))&gt;
							&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", _getDictionary().getValue("<xsl:value-of select="@alias" />.notProvided")) /&gt;
						&lt;/cfif&gt;
					</xsl:if>
					
					&lt;!--- validate <xsl:value-of select="@alias" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
					&lt;cfif NOT IsDate(get<xsl:value-of select="@alias" />())<xsl:if test="@nullable = 'true'"> AND Len(Trim(get<xsl:value-of select="@name" />()))</xsl:if>&gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", _getDictionary().getValue("<xsl:value-of select="@alias" />.invalidType")) /&gt;
					&lt;/cfif&gt;					
				</xsl:when>
				
				<xsl:when test="@cfDataType = 'numeric'">
					<xsl:if test="@nullable = 'false'">
						&lt;!--- validate <xsl:value-of select="@alias" /> is provided ---&gt;
						&lt;cfif NOT Len(Trim(get<xsl:value-of select="@alias" />()))&gt;
							&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", _getDictionary().getValue("<xsl:value-of select="@alias" />.notProvided")) /&gt;
						&lt;/cfif&gt;
					</xsl:if>
					
					&lt;!--- validate <xsl:value-of select="@alias" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
					&lt;cfif Len(Trim(get<xsl:value-of select="@alias" />())) AND NOT IsNumeric(get<xsl:value-of select="@name" />())&gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", _getDictionary().getValue("<xsl:value-of select="@alias" />.invalidType")) /&gt;
					&lt;/cfif&gt;					
				</xsl:when>
				
				<xsl:when test="@cfDataType = 'string'">
					<xsl:if test="@nullable = 'false'">
						&lt;!--- validate <xsl:value-of select="@alias" /> is provided ---&gt;
						&lt;cfif NOT Len(Trim(get<xsl:value-of select="@alias" />()))&gt;
							&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", _getDictionary().getValue("<xsl:value-of select="@alias" />.notProvided")) /&gt;
						&lt;/cfif&gt;
					</xsl:if>
					
					&lt;!--- validate <xsl:value-of select="@alias" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
					&lt;cfif NOT IsSimpleValue(get<xsl:value-of select="@alias" />())&gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", _getDictionary().getValue("<xsl:value-of select="@alias" />.invalidType")) /&gt;
					&lt;/cfif&gt;
					
					&lt;!--- validate <xsl:value-of select="@alias" /> length ---&gt;
					&lt;cfif Len(get<xsl:value-of select="@alias" />()) GT <xsl:value-of select="@length" /> AND <xsl:value-of select="@length" /> IS NOT -1 &gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@alias" />", _getDictionary().getValue("<xsl:value-of select="@alias" />.invalidLength")) /&gt;
					&lt;/cfif&gt;					
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
		
		&lt;!--- save this object's collection ---&gt;
		&lt;cfset _setValidationErrorCollection(ValidationErrorCollection) /&gt;
		
		&lt;!--- merge this object's collection with the provide collection (if any) ---&gt;
		&lt;cfset arguments.ExternalValidationErrorCollection.merge(ValidationErrorCollection) /&gt;
		
		&lt;!--- raise the afterValidate event
		&lt;cfset Event = newEvent("afterValidate") /&gt;
		&lt;cfset Event.setValue("ValidationErrorCollection", arguments.ExternalValidationErrorCollection) /&gt;
		&lt;cfset Event.setValue("SourceRecord", this) /&gt;
		&lt;cfset announceEvent(Event) /&gt; ---&gt;
		
		&lt;cfreturn arguments.ExternalValidationErrorCollection /&gt;
	&lt;/cffunction&gt;
	
	<xsl:for-each select="object/fields/field">
		<xsl:variable name="alias" select="@alias" />
		&lt;!--- <xsl:value-of select="@alias"/> ---&gt;
		&lt;cffunction name="set<xsl:value-of select="@alias"/>" hint="I set the <xsl:value-of select="@alias"/> value <xsl:if test="count(//hasOne/relate[@from = $alias]) &gt; 0"> and reset related objects</xsl:if>." access="public" output="false" returntype="void"&gt;
			&lt;cfargument name="<xsl:value-of select="@alias"/>" hint="I am this record's <xsl:value-of select="@alias"/> value." required="yes" type="string" /&gt;
			<xsl:choose>
				<xsl:when test="count(//hasOne/relate[@from = $alias]) &gt; 0">
					&lt;!--- if the value passed in is different that the current value, reset the valeus in this record ---&gt;
					&lt;cfif arguments.<xsl:value-of select="@alias"/> IS NOT get<xsl:value-of select="@alias"/>()&gt;
						<xsl:for-each select="//hasOne/relate[@from = $alias]">
							&lt;cfif StructKeyExists(variables.children, "<xsl:value-of select="../@alias" />") AND IsObject(variables.children.<xsl:value-of select="../@alias" />)&gt;
								&lt;cfset variables.children.<xsl:value-of select="../@alias" />.resetParent() /&gt;
							&lt;/cfif&gt;
							&lt;cfset variables.children.<xsl:value-of select="../@alias" /> = 0 /&gt;
						</xsl:for-each>
						
						&lt;cfset _getTo().<xsl:value-of select="@alias"/> = arguments.<xsl:value-of select="@alias"/> /&gt;
						
						&lt;!--- load the correct address record ---&gt;
						&lt;cfset get<xsl:value-of select="@alias" />() /&gt;
					&lt;/cfif&gt;
					
				</xsl:when>
				<xsl:otherwise>
					&lt;cfset _getTo().<xsl:value-of select="@alias"/> = arguments.<xsl:value-of select="@alias"/> /&gt;
				</xsl:otherwise>
			</xsl:choose>
		&lt;/cffunction&gt;
		&lt;cffunction name="get<xsl:value-of select="@alias"/>" hint="I get the <xsl:value-of select="@alias"/> value." access="public" output="false" returntype="string"&gt;
			&lt;cfreturn _getTo().<xsl:value-of select="@alias"/> /&gt;
		&lt;/cffunction&gt;	
	</xsl:for-each>
	
	<xsl:for-each select="object/hasOne">
	&lt;!--- Record For <xsl:value-of select="@alias"/> ---&gt;
	&lt;cffunction name="set<xsl:value-of select="@alias"/>" access="public" output="false" returntype="void"&gt;
	    &lt;cfargument name="<xsl:value-of select="@alias"/>" hint="I am the Record to set the <xsl:value-of select="@alias"/> value from." required="yes" type="reactor.project.<xsl:value-of select="/object/@project"/>.Record.<xsl:value-of select="@name"/>Record" /&gt;
		
		&lt;!--- replace the cached version of this <xsl:value-of select="@alias"/> ---&gt;
		&lt;cfset arguments.<xsl:value-of select="@alias"/>._setParent(this) /&gt;
		&lt;cfset variables.children.<xsl:value-of select="@alias"/> = arguments.<xsl:value-of select="@alias"/> /&gt;
		
		&lt;!--- set this object's <xsl:value-of select="@alias"/> record to reflect the object's related values.  This is going directly to the TO to avoid reloading the object and to facilitate compound relationships ---&gt;
		<xsl:for-each select="relate">
			&lt;cfset _getTo().<xsl:value-of select="@from" /> = arguments.<xsl:value-of select="../@alias"/>.get<xsl:value-of select="@to" />()&gt;
		</xsl:for-each>
	&lt;/cffunction&gt;
	
	&lt;cffunction name="get<xsl:value-of select="@alias"/>" access="public" output="false" returntype="reactor.project.<xsl:value-of select="/object/@project"/>.Record.<xsl:value-of select="@name"/>Record"&gt;
		&lt;cfset <xsl:value-of select="@alias"/> = 0 /&gt;
		
		&lt;!--- load the initial <xsl:value-of select="@alias"/> record.  this will be empty ---&gt;
		&lt;cfif NOT StructKeyExists(variables.children, "<xsl:value-of select="@alias"/>") OR (
				StructKeyExists(variables.children, "<xsl:value-of select="@alias"/>")
				AND NOT IsObject(variables.children.<xsl:value-of select="@alias"/>)
		) &gt;
			&lt;cfset <xsl:value-of select="@alias"/> = _getReactorFactory().createRecord("<xsl:value-of select="@name"/>") /&gt;
			&lt;cfset <xsl:value-of select="@alias"/>._setParent(this) /&gt;
			&lt;cfset variables.children.<xsl:value-of select="@alias"/> = <xsl:value-of select="@alias"/> /&gt;
		&lt;/cfif&gt;
		
		&lt;!--- if this object has an related values that are not the same as the values in this object then load the correct values ---&gt;
		&lt;cfif 
			<xsl:for-each select="relate">
				(Len(get<xsl:value-of select="@from" />()) AND get<xsl:value-of select="@from" />() IS NOT variables.children.<xsl:value-of select="../@alias"/>.get<xsl:value-of select="@to" />())
				<xsl:if test="position() != last()">OR</xsl:if>
			</xsl:for-each>
			&gt;
			<xsl:for-each select="relate">
				&lt;cfset variables.children.<xsl:value-of select="../@alias"/>.set<xsl:value-of select="@to" />(get<xsl:value-of select="@from" />()) /&gt;
			</xsl:for-each>
			&lt;cfset variables.children.<xsl:value-of select="@alias"/>.load('<xsl:for-each select="relate"><xsl:value-of select="@to" />,</xsl:for-each>') /&gt; 
		&lt;/cfif&gt;
		
		&lt;cfreturn variables.children.<xsl:value-of select="@alias"/> /&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="remove<xsl:value-of select="@alias"/>" access="public" output="false" returntype="reactor.project.<xsl:value-of select="/object/@project"/>.Record.<xsl:value-of select="@name"/>Record"&gt;
		&lt;cfset var oldRecord = get<xsl:value-of select="@alias"/>() /&gt;
		<xsl:for-each select="relate">
			&lt;cfset set<xsl:value-of select="@from" />("") /&gt;
		</xsl:for-each>
		&lt;cfreturn oldRecord /&gt;
	&lt;/cffunction&gt;
	</xsl:for-each>
	
	<xsl:for-each select="object/hasMany">
		&lt;!--- Iterator For <xsl:value-of select="@alias"/> ---&gt;
		&lt;cffunction name="get<xsl:value-of select="@alias"/>Iterator" access="public" output="false" returntype="reactor.iterator.iterator"&gt;
			&lt;cfset var relationship = 0 /&gt;
			&lt;cfset var <xsl:value-of select="@alias"/>Iterator = 0 /&gt;
			
			&lt;cfif NOT StructKeyExists(variables.children, "<xsl:value-of select="@alias"/>Iterator")&gt;
				&lt;cfset <xsl:value-of select="@alias"/>Iterator = CreateObject("Component", "reactor.iterator.iterator").init(_getReactorFactory(), "<xsl:value-of select="@name"/>", 
					"<xsl:for-each select="link">
						<xsl:value-of select="@name"/>
						<xsl:if test="position() != last()">,</xsl:if>
					</xsl:for-each>") />
				
				<xsl:choose>
					<xsl:when test="count(relate) &gt; 0">
						<xsl:for-each select="relate">
							&lt;cfset <xsl:value-of select="../@alias"/>Iterator.getWhere().isEqual("<xsl:value-of select="../@name"/>", "<xsl:value-of select="@to"/>", get<xsl:value-of select="@from"/>()) /&gt;
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="count(link) &gt; 0">
						&lt;cfset relationship = _getReactorFactory().createMetadata("<xsl:value-of select="link/@name"/>").getRelationship("<xsl:value-of select="/object/@alias"/>").relate /&gt;
			
						&lt;cfloop from="1" to="#ArrayLen(relationship)#" index="x"&gt;
							&lt;cfset <xsl:value-of select="@alias"/>Iterator.getWhere().isEqual("<xsl:value-of select="link/@name"/>", relationship[x].from, evaluate("get#relationship[x].to#()")) /&gt;
						&lt;/cfloop&gt;
					</xsl:when>
				</xsl:choose>
				
				&lt;!--- set parent/child relationships ---&gt;
				&lt;cfset <xsl:value-of select="@alias"/>Iterator._setParent(this) /&gt;			
				&lt;cfset variables.children.<xsl:value-of select="@alias"/>Iterator = <xsl:value-of select="@alias"/>Iterator />
			&lt;/cfif&gt;
			
			&lt;cfreturn variables.children.<xsl:value-of select="@alias"/>Iterator /&gt;
		&lt;/cffunction&gt;
	</xsl:for-each>	
	
	&lt;cffunction name="load" access="public" hint="I load the <xsl:value-of select="object/@alias"/> record.  All of the Primary Key values must be provided for this to work." output="false" returntype="reactor.project.<xsl:value-of select="/object/@project"/>.Record.<xsl:value-of select="object/@alias"/>Record"&gt;
		&lt;cfset var fieldList = StructKeyList(arguments) /&gt;
		&lt;cfset var item = 0 /&gt;
		&lt;cfset var func = 0 /&gt;
		&lt;cfset var nothingLoaded = false /&gt;
		
		&lt;cfset beforeLoad() /&gt;
		
		&lt;cfif IsDefined("arguments") AND fieldList IS 1&gt;
			&lt;cfset fieldList = arguments[1] /&gt;
			
		&lt;cfelseif IsDefined("arguments") AND fieldList IS NOT 1&gt;
			&lt;cfloop collection="#arguments#" item="item"&gt;
				&lt;cfset func = this["set#item#"] /&gt;
				&lt;cfset func(arguments[item]) /&gt;
			&lt;/cfloop&gt;
			
		&lt;/cfif&gt;
		
		&lt;cftry&gt;
			&lt;cfset _getDao().read(_getTo(), fieldList) /&gt;
			&lt;cfcatch type="Reactor.Record.NoMatchingRecord"&gt;
				&lt;cfset nothingLoaded = true /&gt;
			&lt;/cfcatch&gt;		
		&lt;/cftry&gt;
		
		&lt;cfif NOT nothingLoaded&gt;
			&lt;!--- clean the object ---&gt;
			&lt;cfset clean() /&gt;
		&lt;/cfif&gt;
				
		&lt;cfset afterLoad() /&gt;
		
		&lt;cfreturn this /&gt;
	&lt;/cffunction&gt;	
	
	&lt;cffunction name="save" access="public" hint="I save the <xsl:value-of select="object/@alias"/> record.  All of the Primary Key and required values must be provided and valid for this to work." output="false" returntype="void"&gt;
		&lt;cfset beforeSave() /&gt;
		
		&lt;cfif isDirty()&gt;
			&lt;cfset _getDao().save(_getTo()) /&gt;	
		&lt;/cfif&gt;
		
		&lt;cfset afterSave() /&gt;	
	&lt;/cffunction&gt;	
	
	&lt;cffunction name="delete" access="public" hint="I delete the <xsl:value-of select="object/@alias"/> record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void"&gt;
		&lt;cfset beforeDelete() /&gt;
		
		&lt;cfif StructCount(arguments)&gt;
			&lt;cfinvoke component="#this#" method="load" argumentcollection="#arguments#" /&gt;
		&lt;/cfif&gt;
				
		&lt;cfset _getDao().delete(_getTo()) /&gt;
		
		&lt;cfset afterDelete() /&gt;
	&lt;/cffunction&gt;
	
	&lt;!--- to ---&gt;
	&lt;cffunction name="_setTo" access="public" output="false" returntype="void"&gt;
		&lt;cfargument name="to" hint="I am this record's transfer object." required="yes" type="reactor.project.<xsl:value-of select="object/@project"/>.To.<xsl:value-of select="object/@alias"/>To" /&gt;
		&lt;cfif isDeleted()&gt;
			&lt;cfthrow message="Record Deleted"
				detail="The record you're using has been deleted.  There are some properties which will continue to function after a record has been deleted, but not all of them.  Please create a new record and go from there."
				type="reactor.record.RecordDeleted" /&gt;
		&lt;/cfif&gt;
		&lt;cfset variables.to = arguments.to /&gt;
	&lt;/cffunction&gt;
	&lt;cffunction name="_getTo" access="public" output="false" returntype="reactor.project.<xsl:value-of select="object/@project"/>.To.<xsl:value-of select="object/@alias"/>To"&gt;
		&lt;cfif isDeleted()&gt;
			&lt;cfthrow message="Record Deleted"
				detail="The record you're using has been deleted.  There are some properties which will continue to function after a record has been deleted, but not all of them.  Please create a new record and go from there."
				type="reactor.record.RecordDeleted" /&gt;
		&lt;/cfif&gt;
		&lt;cfreturn variables.to /&gt;
	&lt;/cffunction&gt;	
	
	&lt;!--- initialTo ---&gt;
	&lt;cffunction name="_setInitialTo" access="private" output="false" returntype="void"&gt;
		&lt;cfargument name="initialTo" hint="I am this record's initial transfer object." required="yes" type="reactor.project.<xsl:value-of select="object/@project"/>.To.<xsl:value-of select="object/@alias"/>To" /&gt;
		&lt;cfset variables.initialTo = arguments.initialTo /&gt;
	&lt;/cffunction&gt;
	&lt;cffunction name="_getInitialTo" access="private" output="false" returntype="reactor.project.<xsl:value-of select="object/@project"/>.To.<xsl:value-of select="object/@alias"/>To"&gt;
		&lt;cfreturn variables.initialTo /&gt;
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