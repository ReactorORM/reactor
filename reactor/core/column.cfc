<cfcomponent hint="I represent a column in the database">
	
	<cfset variables.name = "" />
	<cfset variables.dataType = "" />
	<cfset variables.cfSqlType = "" />
	<cfset variables.identity = false />
	<cfset variables.nullable = false />
	<cfset variables.length = 0 />
	<cfset variables.default = "" />
	<cfset variables.defaultExpression = "" />
	<cfset variables.primaryKey = false />
	
	<cffunction name="init" access="public" hint="I configure and return a column object." output="false" returntype="reactor.core.column">
		<cfargument name="name" hint="I am the name of the column" required="yes" type="string" />
		<cfargument name="dataType" hint="I am the data type of the column" required="yes" type="string" />
		<cfargument name="cfSqlType" hint="I am the cf_sql_xzy data type used in cfqueryparam tags" required="yes" type="string" />
		<cfargument name="identity" hint="I indicate if the column is an identity column" required="yes" type="boolean" />
		<cfargument name="nullable" hint="I indicate if the column is nullable" required="yes" type="boolean" />
		<cfargument name="length" hint="I am the length of the column" required="yes" type="numeric" />
		<cfargument name="default" hint="I am the default value of the column" required="yes" type="string" />
		<cfargument name="defaultExpression" hint="I am the default expression of the column" required="yes" type="string" />
		<cfargument name="primaryKey" hint="I indicate if the column is a primary key" required="no" type="boolean" default="false" />
		
		<cfset setName(arguments.name) />
		<cfset setDataType(arguments.dataType) />
		<cfset setCfSqlType(arguments.cfSqlType) />
		<cfset setIdentity(arguments.identity) />
		<cfset setNullable(arguments.nullable) />
		<cfset setLength(arguments.length) />
		<cfset setDefault(arguments.default) />
		<cfset setDefaultExpression(arguments.defaultExpression) />
		<cfset setPrimaryKey(arguments.primaryKey) />
		
		<cfreturn this />		
	</cffunction>
	
	<!--- name --->
    <cffunction name="setName" access="public" output="false" returntype="void">
       <cfargument name="name" hint="I am the name of the column" required="yes" type="string" />
       <cfset variables.name = arguments.name />
    </cffunction>
    <cffunction name="getName" access="public" output="false" returntype="string">
       <cfreturn variables.name />
    </cffunction>
	
	<!--- dataType --->
    <cffunction name="setDataType" access="public" output="false" returntype="void">
       <cfargument name="dataType" hint="I am the data type of the column" required="yes" type="string" />
       <cfset variables.dataType = arguments.dataType />
    </cffunction>
    <cffunction name="getDataType" access="public" output="false" returntype="string">
       <cfreturn variables.dataType />
    </cffunction>
	
	<!--- cfSqlType --->
    <cffunction name="setCfSqlType" access="public" output="false" returntype="void">
       <cfargument name="cfSqlType" hint="I am the cf_sql_xzy data type used in cfqueryparam tags" required="yes" type="string" />
       <cfset variables.cfSqlType = arguments.cfSqlType />
    </cffunction>
    <cffunction name="getCfSqlType" access="public" output="false" returntype="string">
       <cfreturn variables.cfSqlType />
    </cffunction>
	
	<!--- identity --->
    <cffunction name="setIdentity" access="public" output="false" returntype="void">
       <cfargument name="identity" hint="I indicate if the column is an identity column" required="yes" type="boolean" />
       <cfset variables.identity = arguments.identity />
    </cffunction>
    <cffunction name="getIdentity" access="public" output="false" returntype="boolean">
       <cfreturn variables.identity />
    </cffunction>
	
	<!--- nullable --->
    <cffunction name="setNullable" access="public" output="false" returntype="void">
       <cfargument name="nullable" hint="I indicate if the column is nullable" required="yes" type="boolean" />
       <cfset variables.nullable = arguments.nullable />
    </cffunction>
    <cffunction name="getNullable" access="public" output="false" returntype="boolean">
       <cfreturn variables.nullable />
    </cffunction>
	
	<!--- length --->
    <cffunction name="setLength" access="public" output="false" returntype="void">
       <cfargument name="length" hint="I am the length of the column" required="yes" type="numeric" />
       <cfset variables.length = arguments.length />
    </cffunction>
    <cffunction name="getLength" access="public" output="false" returntype="numeric">
       <cfreturn variables.length />
    </cffunction>
	
	<!--- default --->
    <cffunction name="setDefault" access="public" output="false" returntype="void">
       <cfargument name="default" hint="I am teh default value of this column" required="yes" type="string" />
       <cfset variables.default = arguments.default />
    </cffunction>
    <cffunction name="getDefault" access="public" output="false" returntype="string">
       <cfreturn variables.default />
    </cffunction>
	
	<!--- defaultExpression --->
    <cffunction name="setDefaultExpression" access="public" output="false" returntype="void">
       <cfargument name="defaultExpression" hint="I am the default expression of the column" required="yes" type="string" />
       <cfset variables.defaultExpression = arguments.defaultExpression />
    </cffunction>
    <cffunction name="getDefaultExpression" access="public" output="false" returntype="string">
       <cfreturn variables.defaultExpression />
    </cffunction>
	
	<!--- primaryKey --->
    <cffunction name="setPrimaryKey" access="public" output="false" returntype="void">
       <cfargument name="primaryKey" hint="I indicate if the colum is part of the primary key" required="yes" type="boolean" />
       <cfset variables.primaryKey = arguments.primaryKey />
    </cffunction>
    <cffunction name="getPrimaryKey" access="public" output="false" returntype="boolean">
       <cfreturn variables.primaryKey />
    </cffunction>
</cfcomponent>