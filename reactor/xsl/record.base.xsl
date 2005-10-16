<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">
&lt;cfcomponent hint="I am the base record representing the <xsl:value-of select="table/@name"/> table.  I am generated.  DO NOT EDIT ME."
	extends="<xsl:value-of select="table/@baseRecordSuper" />" &gt;
	
	&lt;cfset variables.signature = "<xsl:value-of select="table/@signature" />" /&gt;
	&lt;cfset variables.To = 0 /&gt;
	&lt;cfset variables.Dao = 0 /&gt;
	&lt;cfset variables.ObjectFactory = 0 /&gt;
	
	&lt;cffunction name="config" access="public" hint="I configure and return the <xsl:value-of select="table/@name"/> record." output="false" returntype="<xsl:value-of select="table/@customRecordSuper" />"&gt;
		&lt;cfargument name="config" hint="I am the configuration object to use." required="yes" type="reactor.bean.config" /&gt;
		&lt;cfargument name="name" hint="I am the name of the database object this record abstracts." required="yes" type="string" /&gt;
		&lt;cfargument name="ObjectFactory" hint="I am the object use to create other data objects." required="yes" type="reactor.core.objectFactory" /&gt;
		&lt;cfset setObjectFactory(arguments.ObjectFactory) /&gt;
		
		&lt;cfset setConfig(arguments.config) /&gt;
		&lt;cfset setTo(getObjectFactory().create(arguments.name, "To")) /&gt;
		&lt;cfset setDao(getObjectFactory().create(arguments.name, "Dao")) /&gt;

		&lt;cfreturn this /&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="populate" access="public" hint="I populate this record from a <xsl:value-of select="table/@name"/>Bean object." output="false" returntype="void"&gt;
		&lt;cfargument name="<xsl:value-of select="table/@name"/>Bean" hint="I am the bean object to use to populate this Record." required="yes" type="<xsl:value-of select="table/@customBeanSuper" />" /&gt;
			
		&lt;cfset setTo(arguments.<xsl:value-of select="table/@name"/>Bean.getTo()) />
	&lt;/cffunction&gt;	
	<xsl:for-each select="table/columns/column">
	&lt;!--- <xsl:value-of select="@name"/> ---&gt;
	&lt;cffunction name="set<xsl:value-of select="@name"/>" access="public" output="false" returntype="void"&gt;
	    &lt;cfargument name="<xsl:value-of select="@name"/>" hint="I am this record's <xsl:value-of select="@name"/> value." required="yes" type="<xsl:value-of select="@type" />" /&gt;
		&lt;cfset getTo().<xsl:value-of select="@name"/> = arguments.<xsl:value-of select="@name"/> /&gt;
	&lt;/cffunction&gt;
	&lt;cffunction name="get<xsl:value-of select="@name"/>" access="public" output="false" returntype="<xsl:value-of select="@type" />"&gt;
	    &lt;cfreturn getTo().<xsl:value-of select="@name"/> /&gt;
	&lt;/cffunction&gt;	
	</xsl:for-each>
	&lt;cffunction name="load" access="public" hint="I load the <xsl:value-of select="table/@name"/> record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void"&gt;
		&lt;cfset getDao().read(getTo()) /&gt;
	&lt;/cffunction&gt;	
	
	&lt;cffunction name="save" access="public" hint="I save the <xsl:value-of select="table/@name"/> record.  All of the Primary Key and required values must be provided and valid for this to work." output="false" returntype="void"&gt;
		<xsl:if test="table/superTables[@sort = 'backward']/superTable/relationship/column/@name != table/superTables[@sort = 'backward']/superTable/relationship/column/@referencedColumn">&lt;cfset set<xsl:value-of select="table/superTables[@sort = 'backward']/superTable/relationship/column/@name" />(get<xsl:value-of select="table/superTables[@sort = 'backward']/superTable/relationship/column/@referencedColumn" />()) /&gt;
		</xsl:if>
		<xsl:choose>
			<xsl:when test="count(table/columns/column[@primaryKey = 'true']) &gt; 0">
		&lt;cfif <xsl:for-each select="table/columns/column[@primaryKey = 'true']">(IsNumeric(get<xsl:value-of select="@name" />()) AND Val(get<xsl:value-of select="@name" />()) OR NOT IsNumeric(get<xsl:value-of select="@name" />()) AND Len(get<xsl:value-of select="@name" />()))<xsl:if test="position() != last()"> AND </xsl:if>
		</xsl:for-each>&gt;
			&lt;cfset getDao().update(getTo()) /&gt;
		&lt;cfelse&gt;
			&lt;cfset getDao().create(getTo()) /&gt;
		&lt;/cfif&gt;</xsl:when>
			<xsl:when test="count(table/columns/column[@primaryKey = 'true']) = 0">
		&lt;cfset getDao().create(getTo()) /&gt;
			</xsl:when>
		</xsl:choose>
	&lt;/cffunction&gt;	
	
	&lt;cffunction name="delete" access="public" hint="I delete the <xsl:value-of select="table/@name"/> record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void"&gt;
		&lt;cfset getDao().delete(getTo()) /&gt;
		&lt;!--- reset the to ---&gt;
		&lt;cfset setTo(CreateObject("Component", "<xsl:value-of select="table/@customToSuper" />")) /&gt;
	&lt;/cffunction&gt;
	<xsl:for-each select="table/foreignKeys/foreignKey">
	&lt;!--- Record For <xsl:for-each select="column"><xsl:value-of select="@name"/> <xsl:if test="position() != last()">And</xsl:if></xsl:for-each> ---&gt;
	&lt;cffunction name="setRecordFor<xsl:for-each select="column"><xsl:value-of select="@name"/><xsl:if test="position() != last()">And</xsl:if></xsl:for-each>" access="public" output="false" returntype="void"&gt;
	    &lt;cfargument name="Record" hint="I am the Record to set the <xsl:for-each select="column"><xsl:value-of select="@name"/> value<xsl:if test="position() != last()"> And </xsl:if></xsl:for-each> from." required="yes" type="<xsl:value-of select="@remoteRecordSuper" />" /&gt;
		
		<xsl:for-each select="column">&lt;cfset set<xsl:value-of select="@name" />(Record.get<xsl:value-of select="@referencedColumn" />()) /&gt;<xsl:if test="position() != last()"><xsl:text>
		</xsl:text></xsl:if>
		</xsl:for-each>
	&lt;/cffunction&gt;
	&lt;cffunction name="getRecordFor<xsl:for-each select="column"><xsl:value-of select="@name"/><xsl:if test="position() != last()">And</xsl:if></xsl:for-each>" access="public" output="false" returntype="<xsl:value-of select="@remoteRecordSuper" />"&gt;
		&lt;cfset var Record = getObjectFactory().create("<xsl:value-of select="@table" />", "Record") /&gt;
		<xsl:for-each select="column">
		&lt;cfset Record.set<xsl:value-of select="@referencedColumn" />(get<xsl:value-of select="@name" />()) /&gt;</xsl:for-each>
		&lt;cfset Record.load() /&gt;
		&lt;cfreturn Record /&gt;
	&lt;/cffunction&gt;
	</xsl:for-each>
		
	<xsl:for-each select="table/referencingKeys/referencingKey">
	&lt;cffunction name="get<xsl:value-of select="@table"/>Query" access="public" output="false" returntype="query"&gt;
		&lt;cfargument name="Criteria" hint="I am the criteria object to use to filter the results of this method" required="no" default="#CreateObject("Component", "reactor.core.criteria")#" type="reactor.core.criteria" /&gt;
		&lt;cfset var <xsl:value-of select="@table"/>Gateway = getObjectFactory().create("<xsl:value-of select="@table"/>", "Gateway") /&gt;
		<xsl:for-each select="column">&lt;cfset arguments.Criteria.getExpression().isEqual("<xsl:value-of select="@name"/>", get<xsl:value-of select="@referencedColumn"/>()) /&gt;
		</xsl:for-each>
		&lt;cfreturn <xsl:value-of select="@table"/>Gateway.getByCriteria(arguments.Criteria)&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="get<xsl:value-of select="@table"/>Array" access="public" output="false" returntype="array"&gt;
		&lt;cfargument name="Criteria" hint="I am the criteria object to use to filter the results of this method" required="no" default="#CreateObject("Component", "reactor.core.criteria")#" type="reactor.core.criteria" /&gt;
		&lt;cfset var <xsl:value-of select="@table"/>Query = get<xsl:value-of select="@table"/>Query(arguments.Criteria) /&gt;
		&lt;cfset var <xsl:value-of select="@table"/>Array = ArrayNew(1) /&gt;
		&lt;cfset var <xsl:value-of select="@table"/>Record = 0 /&gt;
		&lt;cfset var <xsl:value-of select="@table"/>To = 0 /&gt;
		&lt;cfset var column = "" /&gt;
		
		&lt;cfloop query="<xsl:value-of select="@table"/>Query"&gt;
			&lt;cfset <xsl:value-of select="@table"/>Record = getObjectFactory().create("<xsl:value-of select="@table"/>", "Record") &gt;
			&lt;cfset <xsl:value-of select="@table"/>To = <xsl:value-of select="@table"/>Record.getTo() /&gt;

			&lt;!--- populate the record's to ---&gt;
			&lt;cfloop list="#<xsl:value-of select="@table"/>Query.columnList#" index="column"&gt;
				&lt;cfset <xsl:value-of select="@table"/>To[column] = <xsl:value-of select="@table"/>Query[column] &gt;
			&lt;/cfloop&gt;
			
			&lt;cfset <xsl:value-of select="@table"/>Record.setTo(<xsl:value-of select="@table"/>To) /&gt;
			
			&lt;cfset <xsl:value-of select="@table"/>Array[ArrayLen(<xsl:value-of select="@table"/>Array) + 1] = <xsl:value-of select="@table"/>Record &gt;
		&lt;/cfloop&gt;

		&lt;cfreturn <xsl:value-of select="@table"/>Array /&gt;
	&lt;/cffunction&gt;
	</xsl:for-each>
	
	&lt;!--- 
	&lt;cffunction name="populate" access="public" hint="I populate the <xsl:value-of select="table/@name"/> record from a bean." output="false" returntype="void"&gt;
		&lt;cfargument name="Bean" hint="I am the form record to use to populate this record." required="yes" type="reactor.base.abstractBean" /&gt;
		&lt;cfset var fields = arguments.Bean.getFields() /&gt;
		<xsl:for-each select="table/columns/column">
		&lt;cfif ListFindNoCase(fields, "<xsl:value-of select="@name"/>")&gt;
			&lt;cfset set<xsl:value-of select="@name"/>(arguments.FormRecord.get<xsl:value-of select="@name"/>()) /&gt;
		&lt;/cfif&gt;
		</xsl:for-each>
	&lt;/cffunction&gt;
	---&gt;
			
	&lt;!--- to ---&gt;
	&lt;cffunction name="setTo" access="public" output="false" returntype="void"&gt;
	    &lt;cfargument name="to" hint="I am this record's transfer object." required="yes" type="<xsl:value-of select="table/@customToSuper" />" /&gt;
	    &lt;cfset variables.to = arguments.to /&gt;
	&lt;/cffunction&gt;
	&lt;cffunction name="getTo" access="public" output="false" returntype="<xsl:value-of select="table/@customToSuper" />"&gt;
	    &lt;cfreturn variables.to /&gt;
	&lt;/cffunction&gt;	
	
	&lt;!--- dao ---&gt;
	&lt;cffunction name="setDao" access="private" output="false" returntype="void"&gt;
	    &lt;cfargument name="dao" hint="I am the Dao this Record uses to load and save itself." required="yes" type="<xsl:value-of select="table/@customDaoSuper" />" /&gt;
	    &lt;cfset variables.dao = arguments.dao /&gt;
	&lt;/cffunction&gt;
	&lt;cffunction name="getDao" access="private" output="false" returntype="<xsl:value-of select="table/@customDaoSuper" />"&gt;
	    &lt;cfreturn variables.dao /&gt;
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