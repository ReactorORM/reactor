<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">
&lt;cfcomponent hint="I am the base Bean object for the <xsl:value-of select="table/@name"/> table.  I am generated.  DO NOT EDIT ME."
	extends="<xsl:value-of select="table/@baseBeanSuper" />" &gt;
	
	&lt;cfset variables.signature = "<xsl:value-of select="table/@signature" />" /&gt;
	&lt;cfset variables.To = 0 /&gt;
	&lt;cfset variables.ObjectFactory = 0 /&gt;
	
	&lt;cffunction name="config" access="public" hint="I configure and return the <xsl:value-of select="table/@name"/> record." output="false" returntype="<xsl:value-of select="table/@customBeanSuper" />"&gt;
		&lt;cfargument name="config" hint="I am the configuration object to use." required="yes" type="reactor.bean.config" /&gt;
		&lt;cfargument name="name" hint="I am the name of the database object this record abstracts." required="yes" type="string" /&gt;
		&lt;cfargument name="ObjectFactory" hint="I am the object use to create other data objects." required="yes" type="reactor.core.objectFactory" /&gt;
		
		&lt;cfset setConfig(arguments.config) /&gt;
		&lt;cfset setObjectFactory(arguments.ObjectFactory) /&gt;
		&lt;cfset setTo(getObjectFactory().create(arguments.name, "To")) /&gt;
		
		&lt;cfreturn this /&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection"&gt;
		&lt;cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="yes" type="reactor.util.ValidationErrorCollection" /&gt;
		&lt;cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#getConfig().getCreationPath()#/ErrorMessages.xml")) /&gt;
		
		<xsl:for-each select="table/columns/column">
		&lt;cfset ValidationErrorCollection.addError("<xsl:value-of select="@name" />", ErrorManager.getError("<xsl:value-of select="../../@name" />", "<xsl:value-of select="@name" />", "UserIdInvalidNumber")) /&gt;
		</xsl:for-each>
				
		&lt;cfreturn arguments.ValidationErrorCollection /&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="init" access="public" hint="I configure and return this bean object." output="false" returntype="<xsl:value-of select="table/@baseBeanSuper" />"&gt;
		<xsl:for-each select="table/superTables[@sort = 'backward']//columns/column[@overridden = 'false']">&lt;cfargument name="<xsl:value-of select="@name" />" hint="I am the default value for the <xsl:value-of select="@name" /> field." required="no" type="string" default="<xsl:value-of select="@defaultExpression" />" /&gt;
		</xsl:for-each>
		<xsl:for-each select="table/columns/column">&lt;cfargument name="<xsl:value-of select="@name" />" hint="I am the default value for the <xsl:value-of select="@name" /> field." required="no" type="string" default="<xsl:value-of select="@defaultExpression" />" /&gt;
		</xsl:for-each>
		&lt;cfset super.init(<xsl:for-each select="table/superTables[@sort = 'backward']//columns/column[@overridden = 'false']">
			<xsl:value-of select="@name" />=arguments.<xsl:value-of select="@name" />
			<xsl:if test="position() != last()">, </xsl:if>
		</xsl:for-each>) &gt;
			
		<xsl:for-each select="table/columns/column">&lt;cfset set<xsl:value-of select="@name" />(arguments.<xsl:value-of select="@name" />) /&gt;
		</xsl:for-each>
		&lt;cfreturn this /&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="populate" access="public" hint="I populate this bean from a <xsl:value-of select="table/@name"/>Record object." output="false" returntype="void"&gt;
		&lt;cfargument name="<xsl:value-of select="table/@name"/>Record" hint="I am the record object to use to populate this Bean." required="yes" type="<xsl:value-of select="table/@customRecordSuper" />" /&gt;
			
		&lt;cfset setTo(arguments.<xsl:value-of select="table/@name"/>Record.getTo()) />
	&lt;/cffunction&gt;		
	
	<xsl:for-each select="table/columns/column">
	&lt;!--- <xsl:value-of select="@name" /> ---&gt;
	&lt;cffunction name="set<xsl:value-of select="@name" />" access="public" output="false" returntype="void"&gt;
	    &lt;cfargument name="<xsl:value-of select="@name" />" hint="I am the <xsl:value-of select="@name" /> value." required="yes" type="string" /&gt;
	    &lt;cfset getTo().<xsl:value-of select="@name" /> = arguments.<xsl:value-of select="@name" /> /&gt;
	&lt;/cffunction&gt;
	&lt;cffunction name="get<xsl:value-of select="@name" />" access="public" output="false" returntype="string"&gt;
	    &lt;cfreturn getTo().variables.<xsl:value-of select="@name" /> /&gt;
	&lt;/cffunction&gt;
	</xsl:for-each>
		
	&lt;!--- to ---&gt;
	&lt;cffunction name="setTo" access="public" output="false" returntype="void"&gt;
	    &lt;cfargument name="to" hint="I am this record's transfer object." required="yes" type="<xsl:value-of select="table/@customToSuper" />" /&gt;
	    &lt;cfset variables.to = arguments.to /&gt;
	&lt;/cffunction&gt;
	&lt;cffunction name="getTo" access="public" output="false" returntype="<xsl:value-of select="table/@customToSuper" />"&gt;
	    &lt;cfreturn variables.to /&gt;
	&lt;/cffunction&gt;	 
	
	&lt;!--- ObjectFactory ---&gt;
    &lt;cffunction name="setObjectFactory" access="private" output="false" returntype="void"&gt;
	    &lt;cfargument name="ObjectFactory" hint="I am the table factory to use to create objects." required="yes" type="reactor.core.objectFactory" /&gt;
	    &lt;cfset variables.ObjectFactory = arguments.ObjectFactory /&gt;
    &lt;/cffunction&gt;
    &lt;cffunction name="getObjectFactory" access="private" output="false" returntype="reactor.core.objectFactory"&gt;
	    &lt;cfreturn variables.ObjectFactory /&gt;
    &lt;/cffunction&gt;
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>