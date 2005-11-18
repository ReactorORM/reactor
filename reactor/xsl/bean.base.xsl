<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">
&lt;cfcomponent hint="I am the base Bean object for the <xsl:value-of select="table/@name"/> table.  I am generated.  DO NOT EDIT ME."
	extends="<xsl:choose>
		<xsl:when test="count(object/super)"><xsl:value-of select="object/@mapping"/>.Bean.<xsl:value-of select="object/@dbms"/>.<xsl:value-of select="object/super/@name"/>Bean</xsl:when>
		<xsl:otherwise>reactor.base.abstractBean</xsl:otherwise>
	</xsl:choose>" &gt;
	
	&lt;cfset variables.signature = "<xsl:value-of select="table/@signature" />" /&gt;
	&lt;cfset variables.To = 0 /&gt;
	&lt;cfset variables.ObjectFactory = 0 /&gt;

	&lt;cffunction name="init" access="public" hint="I configure and return this bean object." output="false" returntype="<xsl:value-of select="object/@mapping"/>.Bean.<xsl:value-of select="object/@dbms"/>.base.<xsl:value-of select="object/@name"/>Bean"&gt;
		<xsl:for-each select="//field[@overridden = 'false']">
			&lt;cfargument name="<xsl:value-of select="@name" />" hint="I am the default value for the  <xsl:value-of select="@name" /> field." required="no" type="string" default="<xsl:value-of select="@default" />" /&gt;
		</xsl:for-each>
		
		<xsl:if test="count(object/super) &gt; 0">
		
				&lt;cfset super.init(
					<xsl:for-each select="object/super//fields/field[@overridden = 'false']">
						<xsl:value-of select="@name" />=arguments.<xsl:value-of select="@name" />
						<xsl:if test="position() != last()">, </xsl:if>
					</xsl:for-each>)
				/&gt;
			
		</xsl:if>
		
		<xsl:for-each select="object/fields/field">
			&lt;cfset set<xsl:value-of select="@name" />(arguments.<xsl:value-of select="@name" />) /&gt;
		</xsl:for-each>
		&lt;cfreturn this /&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection"&gt;
		&lt;cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" /&gt;
		&lt;cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) /&gt;
		
		<xsl:if test="count(object/super) &gt; 0">
			&lt;cfset arguments.ValidationErrorCollection = super.validate(arguments.ValidationErrorCollection) /&gt;
		</xsl:if>
		
		<xsl:for-each select="object/fields/field">
			<xsl:choose>
				<xsl:when test="@cfDataType = 'binary'">
					<xsl:if test="@nullable = 'false'">
						&lt;!--- validate <xsl:value-of select="@name" /> is provided ---&gt;
						&lt;cfif NOT Len(Trim(get<xsl:value-of select="@name" />()))&gt;
							&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@name" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@name" />", "notProvided")) /&gt;
						&lt;/cfif&gt;
					</xsl:if>
					
					&lt;!--- validate <xsl:value-of select="@name" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
					&lt;cfif NOT IsBinary(get<xsl:value-of select="@name" />())&gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@name" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@name" />", "invalidType")) /&gt;
					&lt;/cfif&gt;
					
					&lt;!--- validate <xsl:value-of select="@name" /> length ---&gt;
					&lt;cfif Len(get<xsl:value-of select="@name" />()) GT <xsl:value-of select="@length" /> &gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@name" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@name" />", "invalidLength")) /&gt;
					&lt;/cfif&gt;				
				</xsl:when>
				
				<xsl:when test="@cfDataType = 'boolean'">
					<xsl:if test="@nullable = 'false'">
						&lt;!--- validate <xsl:value-of select="@name" /> is provided ---&gt;
						&lt;cfif NOT Len(Trim(get<xsl:value-of select="@name" />()))&gt;
							&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@name" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@name" />", "notProvided")) /&gt;
						&lt;/cfif&gt;
					</xsl:if>
					
					&lt;!--- validate <xsl:value-of select="@name" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
					&lt;cfif NOT IsBoolean(get<xsl:value-of select="@name" />())&gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@name" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@name" />", "invalidType")) /&gt;
					&lt;/cfif&gt;					
				</xsl:when>
			
				<xsl:when test="@cfDataType = 'date'">
					<xsl:if test="@nullable = 'false'">
						&lt;!--- validate <xsl:value-of select="@name" /> is provided ---&gt;
						&lt;cfif NOT Len(Trim(get<xsl:value-of select="@name" />()))&gt;
							&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@name" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@name" />", "notProvided")) /&gt;
						&lt;/cfif&gt;
					</xsl:if>
					
					&lt;!--- validate <xsl:value-of select="@name" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
					&lt;cfif NOT IsDate(get<xsl:value-of select="@name" />())&gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@name" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@name" />", "invalidType")) /&gt;
					&lt;/cfif&gt;					
				</xsl:when>
				
				<xsl:when test="@cfDataType = 'numeric'">
					<xsl:if test="@nullable = 'false'">
						&lt;!--- validate <xsl:value-of select="@name" /> is provided ---&gt;
						&lt;cfif NOT Len(Trim(get<xsl:value-of select="@name" />()))&gt;
							&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@name" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@name" />", "notProvided")) /&gt;
						&lt;/cfif&gt;
					</xsl:if>
					
					&lt;!--- validate <xsl:value-of select="@name" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
					&lt;cfif NOT IsNumeric(get<xsl:value-of select="@name" />())&gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@name" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@name" />", "invalidType")) /&gt;
					&lt;/cfif&gt;					
				</xsl:when>
				
				<xsl:when test="@cfDataType = 'string'">
					<xsl:if test="@nullable = 'false'">
						&lt;!--- validate <xsl:value-of select="@name" /> is provided ---&gt;
						&lt;cfif NOT Len(Trim(get<xsl:value-of select="@name" />()))&gt;
							&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@name" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@name" />", "notProvided")) /&gt;
						&lt;/cfif&gt;
					</xsl:if>
					
					&lt;!--- validate <xsl:value-of select="@name" /> is <xsl:value-of select="@cfDataType" /> ---&gt;
					&lt;cfif NOT IsSimpleValue(get<xsl:value-of select="@name" />())&gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@name" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@name" />", "invalidType")) /&gt;
					&lt;/cfif&gt;
					
					&lt;!--- validate <xsl:value-of select="@name" /> length ---&gt;
					&lt;cfif Len(get<xsl:value-of select="@name" />()) GT <xsl:value-of select="@length" /> &gt;
						&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@name" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@name" />", "invalidLength")) /&gt;
					&lt;/cfif&gt;					
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
		&lt;cfreturn arguments.ValidationErrorCollection /&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="populate" access="public" hint="I populate this bean from a <xsl:value-of select="table/@name"/>Record object." output="false" returntype="void"&gt;
		&lt;cfargument name="<xsl:value-of select="table/@name"/>Record" hint="I am the record object to use to populate this Bean." required="yes" type="<xsl:value-of select="object/@mapping"/>.Record.<xsl:value-of select="object/@dbms"/>.base.<xsl:value-of select="object/@name"/>Record" /&gt;
			
		&lt;cfset _setTo(arguments.<xsl:value-of select="table/@name"/>Record._getTo()) />
	&lt;/cffunction&gt;		
	 
	<xsl:for-each select="object/fields/field">
	&lt;!--- <xsl:value-of select="@name" /> ---&gt;
	&lt;cffunction name="set<xsl:value-of select="@name" />" access="public" output="false" returntype="void"&gt;
	    &lt;cfargument name="<xsl:value-of select="@name" />" hint="I am the <xsl:value-of select="@name" /> value." required="yes" type="string" /&gt;
	    &lt;cfset _getTo().<xsl:value-of select="@name" /> = arguments.<xsl:value-of select="@name" /> /&gt;
	&lt;/cffunction&gt;
	&lt;cffunction name="get<xsl:value-of select="@name" />" access="public" output="false" returntype="string"&gt;
	    &lt;cfreturn _getTo().<xsl:value-of select="@name" /> /&gt;
	&lt;/cffunction&gt;
	</xsl:for-each>
		
	&lt;!--- to ---&gt;
	&lt;cffunction name="_setTo" access="public" output="false" returntype="void"&gt;
	    &lt;cfargument name="to" hint="I am this record's transfer object." required="yes" type="<xsl:value-of select="object/@mapping"/>.To.<xsl:value-of select="object/@dbms"/>.<xsl:value-of select="object/@name"/>To" /&gt;
	    &lt;cfset variables.to = arguments.to /&gt;
	&lt;/cffunction&gt;
	&lt;cffunction name="_getTo" access="public" output="false" returntype="<xsl:value-of select="object/@mapping"/>.To.<xsl:value-of select="object/@dbms"/>.<xsl:value-of select="object/@name"/>To"&gt;
		&lt;cfreturn variables.to /&gt;
	&lt;/cffunction&gt;	
	
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>