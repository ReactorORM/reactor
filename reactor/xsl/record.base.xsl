<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">
&lt;cfcomponent hint="I am the base record representing the <xsl:value-of select="table/@name"/> table.  I am generated.  DO NOT EDIT ME."
	extends="<xsl:choose>
		<xsl:when test="table/@name = table/@baseTable">reactor.core.abstractRecord</xsl:when>
		<xsl:when test="table/@name != table/@baseTable"><xsl:value-of select="table/@customRecordBase" /></xsl:when>
	</xsl:choose>" &gt;
	
	&lt;cfset variables.signature = "<xsl:value-of select="table/@signature" />" /&gt;
	&lt;cfset variables.To = 0 /&gt;
	&lt;cfset variables.Dao = 0 /&gt;
	&lt;cfset variables.ObjectFactory = 0 /&gt;
	
	&lt;cffunction name="init" access="public" hint="I configure and return the <xsl:value-of select="table/@name"/> record." output="false" returntype="<xsl:value-of select="table/@recordBase" />"&gt;
		&lt;cfargument name="name" hint="I am the name of the database object this record abstracts." required="yes" type="string" /&gt;
		&lt;cfargument name="ObjectFactory" hint="I am the object use to create other data objects." required="yes" type="reactor.core.abstractObjectFactory" /&gt;
		&lt;cfset setObjectFactory(arguments.ObjectFactory) /&gt;
		
		&lt;cfset setTo(getObjectFactory().createTo(arguments.name)) /&gt;
		&lt;cfset setDao(getObjectFactory().createDao(arguments.name)) /&gt;

		&lt;cfreturn this /&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="populate" access="public" hint="I populate the <xsl:value-of select="table/@name"/> record from a bean." output="false" returntype="void"&gt;
		&lt;cfargument name="Bean" hint="I am the form record to use to populate this record." required="yes" type="Reactor.core.abstractBean" /&gt;
		&lt;cfset var fields = arguments.Bean.getFields() /&gt;
		<xsl:for-each select="table/columns/column">
		&lt;cfif ListFindNoCase(fields, "<xsl:value-of select="@name"/>")&gt;
			&lt;cfset set<xsl:value-of select="@name"/>(arguments.FormRecord.get<xsl:value-of select="@name"/>()) /&gt;
		&lt;/cfif&gt;
		</xsl:for-each>
	&lt;/cffunction&gt;	
	
	&lt;cffunction name="load" access="public" hint="I load the <xsl:value-of select="table/@name"/> record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void"&gt;
		&lt;cfset getDao().read(getTo()) /&gt;
	&lt;/cffunction&gt;	
	
	&lt;cffunction name="save" access="public" hint="I save the <xsl:value-of select="table/@name"/> record.  All of the Primary Key and required values must be provided and valid for this to work." output="false" returntype="void"&gt;
		&lt;cfif <xsl:for-each select="table/columns/column[@primaryKey = 'true']">(IsNumeric(get<xsl:value-of select="@name" />()) AND Val(get<xsl:value-of select="@name" />()) OR NOT IsNumeric(get<xsl:value-of select="@name" />()) AND Len(get<xsl:value-of select="@name" />()))<xsl:if test="position() != last()"> AND </xsl:if>
		</xsl:for-each>&gt;
			&lt;cfset getDao().update(getTo()) /&gt;
		&lt;cfelse&gt;
			&lt;cfset getDao().create(getTo()) /&gt;
		&lt;/cfif&gt;
	&lt;/cffunction&gt;	
	
	&lt;cffunction name="delete" access="public" hint="I delete the <xsl:value-of select="table/@name"/> record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void"&gt;
		&lt;cfset getDao().delete(getTo()) /&gt;
		&lt;!--- reset the to ---&gt;
		&lt;cfset setTo(CreateObject("Component", "<xsl:value-of select="table/@toBase" />")) /&gt;
	&lt;/cffunction&gt;	
	<xsl:for-each select="table/columns/column">
	&lt;!--- <xsl:value-of select="@name"/> ---&gt;
	&lt;cffunction name="set<xsl:value-of select="@name"/>" access="public" output="false" returntype="void"&gt;
	    &lt;cfargument name="<xsl:value-of select="@name"/>" hint="I am this record's <xsl:value-of select="@name"/> value." required="yes" type="<xsl:choose>
		<xsl:when test="@type = 'bigint'">numeric</xsl:when>
		<xsl:when test="@type = 'binary'">binary</xsl:when>
		<xsl:when test="@type = 'bit'">boolean</xsl:when>
		<xsl:when test="@type = 'char'">string</xsl:when>
		<xsl:when test="@type = 'datetime'">date</xsl:when>
		<xsl:when test="@type = 'decimal'">numeric</xsl:when>
		<xsl:when test="@type = 'float'">numeric</xsl:when>
		<xsl:when test="@type = 'image'">binary</xsl:when>
		<xsl:when test="@type = 'int'">numeric</xsl:when>
		<xsl:when test="@type = 'money'">numeric</xsl:when>
		<xsl:when test="@type = 'nchar'">string</xsl:when>
		<xsl:when test="@type = 'ntext'">string</xsl:when>
		<xsl:when test="@type = 'numeric'">numeric</xsl:when>
		<xsl:when test="@type = 'nvarchar'">string</xsl:when>
		<xsl:when test="@type = 'real'">numeric</xsl:when>
		<xsl:when test="@type = 'smalldatetime'">date</xsl:when>
		<xsl:when test="@type = 'smallint'">numeric</xsl:when>
		<xsl:when test="@type = 'smallmoney'">numeric</xsl:when>
		<xsl:when test="@type = 'text'">string</xsl:when>
		<xsl:when test="@type = 'timestamp'">numeric</xsl:when>
		<xsl:when test="@type = 'tinyint'">numeric</xsl:when>
		<xsl:when test="@type = 'uniqueidentifier'">string</xsl:when>
		<xsl:when test="@type = 'varbinary'">binary</xsl:when>
		<xsl:when test="@type = 'varchar'">string</xsl:when>
		<xsl:otherwise>any</xsl:otherwise>
	</xsl:choose>" /&gt;
		&lt;cfset getTo().<xsl:value-of select="@name"/> = arguments.<xsl:value-of select="@name"/> /&gt;
	&lt;/cffunction&gt;
	&lt;cffunction name="get<xsl:value-of select="@name"/>" access="public" output="false" returntype="<xsl:choose>
		<xsl:when test="@type = 'bigint'">numeric</xsl:when>
		<xsl:when test="@type = 'binary'">binary</xsl:when>
		<xsl:when test="@type = 'bit'">boolean</xsl:when>
		<xsl:when test="@type = 'char'">string</xsl:when>
		<xsl:when test="@type = 'datetime'">date</xsl:when>
		<xsl:when test="@type = 'decimal'">numeric</xsl:when>
		<xsl:when test="@type = 'float'">numeric</xsl:when>
		<xsl:when test="@type = 'image'">binary</xsl:when>
		<xsl:when test="@type = 'int'">numeric</xsl:when>
		<xsl:when test="@type = 'money'">numeric</xsl:when>
		<xsl:when test="@type = 'nchar'">string</xsl:when>
		<xsl:when test="@type = 'ntext'">string</xsl:when>
		<xsl:when test="@type = 'numeric'">numeric</xsl:when>
		<xsl:when test="@type = 'nvarchar'">string</xsl:when>
		<xsl:when test="@type = 'real'">numeric</xsl:when>
		<xsl:when test="@type = 'smalldatetime'">date</xsl:when>
		<xsl:when test="@type = 'smallint'">numeric</xsl:when>
		<xsl:when test="@type = 'smallmoney'">numeric</xsl:when>
		<xsl:when test="@type = 'text'">string</xsl:when>
		<xsl:when test="@type = 'timestamp'">numeric</xsl:when>
		<xsl:when test="@type = 'tinyint'">numeric</xsl:when>
		<xsl:when test="@type = 'uniqueidentifier'">string</xsl:when>
		<xsl:when test="@type = 'varbinary'">binary</xsl:when>
		<xsl:when test="@type = 'varchar'">string</xsl:when>
		<xsl:otherwise>any</xsl:otherwise>
	</xsl:choose>"&gt;
	    &lt;cfreturn getTo().<xsl:value-of select="@name"/> /&gt;
	&lt;/cffunction&gt;	
	</xsl:for-each>
	
	<xsl:for-each select="table/columns/column[@foreignKey = 'true']">
	<!-- find this column in the foreign keys section -->
	<!-- for instance, if this column is named addressId, find addressId in the foreign keys table, then get it's parent foreign key -->
	<xsl:variable name="columnName" select="@name" />
	<xsl:variable name="foreignKeyName" select="/table/foreignKeys/foreignKey/column[@name = $columnName]/../@name" />
	<xsl:variable name="foreignTable" select="/table/foreignKeys/foreignKey/column[@name = $columnName]/../@table" />
	<xsl:variable name="foreignObject" select="/table/foreignKeys/foreignKey/column[@name = $columnName]/../@recordType" />
	&lt;!--- Record For <xsl:value-of select="@name"/> ---&gt;
	&lt;cffunction name="setRecordFor<xsl:value-of select="@name"/>" access="public" output="false" returntype="void"&gt;
	    &lt;cfargument name="Record" hint="I am the Record to set the <xsl:value-of select="@name"/> value from." required="yes" type="<xsl:value-of select="$foreignObject" />" /&gt;
		<xsl:for-each select="/table/foreignKeys/foreignKey[@name = $foreignKeyName]/column">&lt;cfset set<xsl:value-of select="@name" />(Record.get<xsl:value-of select="@referencedColumn" />()) /&gt;<xsl:if test="position() != last()"><xsl:text>
		</xsl:text></xsl:if>
		</xsl:for-each>
	&lt;/cffunction&gt;
	&lt;cffunction name="getRecordFor<xsl:value-of select="@name"/>" access="public" output="false" returntype="<xsl:value-of select="$foreignObject" />"&gt;
		&lt;cfset var Record = getObjectFactory().createRecord("<xsl:value-of select="$foreignTable" />") /&gt;<xsl:for-each select="/table/foreignKeys/foreignKey[@name = $foreignKeyName]/column">
		&lt;cfset Record.set<xsl:value-of select="@referencedColumn" />(get<xsl:value-of select="@name" />()) /&gt;</xsl:for-each>
		&lt;cfset Record.load() />
		&lt;cfreturn Record /&gt;
	&lt;/cffunction&gt;	
	</xsl:for-each>
	
	<xsl:for-each select="table/referencingKeys/referencingKey">
	&lt;cffunction name="get<xsl:value-of select="@table"/>Query" access="public" output="false" returntype="query"&gt;
		&lt;cfargument name="Criteria" hint="I am the criteria object to use to filter the results of this method" required="no" default="#CreateObject("Component", "reactor.core.criteria")#" type="reactor.core.criteria" /&gt;
		&lt;cfset var <xsl:value-of select="@table"/>Gateway = getObjectFactory().createGateway("<xsl:value-of select="@table"/>") /&gt;
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
			&lt;cfset <xsl:value-of select="@table"/>Record = getObjectFactory().createRecord("<xsl:value-of select="@table"/>") &gt;
			&lt;cfset <xsl:value-of select="@table"/>To = <xsl:value-of select="@table"/>Record.getTo() /&gt;

			&lt;!--- populate the record's to ---&gt;
			&lt;cfloop list="#<xsl:value-of select="@table"/>Query.columnList#" index="column"&gt;
				&lt;cfset <xsl:value-of select="@table"/>To[column] = <xsl:value-of select="@table"/>Query[column] &gt;
			&lt;/cfloop&gt;
			
			&lt;cfset <xsl:value-of select="@table"/>Array[ArrayLen(<xsl:value-of select="@table"/>Array) + 1] = getObjectFactory().createRecord("<xsl:value-of select="@table"/>") &gt;
		&lt;/cfloop&gt;

		&lt;cfreturn <xsl:value-of select="@table"/>Array /&gt;
	&lt;/cffunction&gt;
	</xsl:for-each>		
	&lt;!--- to ---&gt;
	&lt;cffunction name="setTo" access="public" output="false" returntype="void"&gt;
	    &lt;cfargument name="to" hint="I am this record's transfer object." required="yes" type="<xsl:value-of select="table/@toBase" />" /&gt;
	    &lt;cfset variables.to = arguments.to /&gt;
	&lt;/cffunction&gt;
	&lt;cffunction name="getTo" access="public" output="false" returntype="<xsl:value-of select="table/@toBase" />"&gt;
	    &lt;cfreturn variables.to /&gt;
	&lt;/cffunction&gt;	
	
	&lt;!--- dao ---&gt;
	&lt;cffunction name="setDao" access="private" output="false" returntype="void"&gt;
	    &lt;cfargument name="dao" hint="I am the Dao this Record uses to load and save itself." required="yes" type="<xsl:value-of select="table/@daoBase" />" /&gt;
	    &lt;cfset variables.dao = arguments.dao /&gt;
	&lt;/cffunction&gt;
	&lt;cffunction name="getDao" access="private" output="false" returntype="<xsl:value-of select="table/@daoBase" />"&gt;
	    &lt;cfreturn variables.dao /&gt;
	&lt;/cffunction&gt;
	
	&lt;!--- ObjectFactory ---&gt;
    &lt;cffunction name="setObjectFactory" access="private" output="false" returntype="void"&gt;
	    &lt;cfargument name="ObjectFactory" hint="I am the table factory to use to create objects." required="yes" type="reactor.core.abstractObjectFactory" /&gt;
	    &lt;cfset variables.ObjectFactory = arguments.ObjectFactory /&gt;
    &lt;/cffunction&gt;
    &lt;cffunction name="getObjectFactory" access="private" output="false" returntype="reactor.core.abstractObjectFactory"&gt;
	    &lt;cfreturn variables.ObjectFactory /&gt;
    &lt;/cffunction&gt;
	
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>