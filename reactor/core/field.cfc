<cfcomponent hint="I represent a field in the database">
	
	<cfset variables.name = "" />
	<cfset variables.primaryKey = false />
	<cfset variables.identity = false />
	<cfset variables.nullable = false />
	
	<cfset variables.dbDataType = "" />
	<cfset variables.cfCfDataType = "" />
	<cfset variables.cfSqlType = "" />
	<cfset variables.length = 0 />
	
	<cfset variables.default = "" />
	
	<!---- 
	<cffunction name="init" access="public" hint="I configure and return a field object." output="false" returntype="reactor.core.field">
		<cfargument name="name" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="dbDataType" hint="I am the data type of the field in the database" required="yes" type="string" />
		<cfargument name="cfCfDataType" hint="I am the data type of the coldfusion property" required="yes" type="string" />
		<cfargument name="cfSqlType" hint="I am the cf_sql_xzy data type used in cfqueryparam tags" required="yes" type="string" />
		<cfargument name="identity" hint="I indicate if the field is an identity field" required="yes" type="boolean" />
		<cfargument name="nullable" hint="I indicate if the field is nullable" required="yes" type="boolean" />
		<cfargument name="length" hint="I am the length of the field" required="yes" type="numeric" />
		<cfargument name="default" hint="I am the default value of the field" required="yes" type="string" />
		<cfargument name="defaultExpression" hint="I am the default expression of the field" required="yes" type="string" />
		<cfargument name="primaryKey" hint="I indicate if the field is a primary key" required="no" type="boolean" default="false" />
		
		<cfset setName(arguments.name) />
		<cfset setDbDataType(arguments.dbDataType) />
		<cfset setCfDataType(arguments.cfCfDataType) />
		<cfset setCfSqlType(arguments.cfSqlType) />
		<cfset setIdentity(arguments.identity) />
		<cfset setNullable(arguments.nullable) />
		<cfset setLength(arguments.length) />
		<cfset setDefault(arguments.default) />
		<cfset setDefaultExpression(arguments.defaultExpression) />
		<cfset setPrimaryKey(arguments.primaryKey) />
		
		<cfreturn this />		
	</cffunction>
	---->
	
	<!--- name --->
    <cffunction name="setName" access="public" output="false" returntype="void">
       <cfargument name="name" hint="I am the name of the field" required="yes" type="string" />
       <cfset variables.name = arguments.name />
    </cffunction>
    <cffunction name="getName" access="public" output="false" returntype="string">
       <cfreturn Ucase(Left(variables.name, 1)) & Right(variables.name, Len(variables.name) - 1) />
    </cffunction>
	
	<!--- dbDataType --->
    <cffunction name="setDbDataType" access="public" output="false" returntype="void">
       <cfargument name="dbDataType" hint="I am the type of the data in the database." required="yes" type="string" />
       <cfset variables.dbDataType = arguments.dbDataType />
    </cffunction>
    <cffunction name="getDbDataType" access="public" output="false" returntype="string">
       <cfreturn variables.dbDataType />
    </cffunction>
	
	<!--- cfCfDataType --->
    <cffunction name="setCfDataType" access="public" output="false" returntype="void">
       <cfargument name="cfCfDataType" hint="I am the data type of the field" required="yes" type="string" />
       <cfset variables.cfCfDataType = arguments.cfCfDataType />
    </cffunction>
    <cffunction name="getCfDataType" access="public" output="false" returntype="string">
       <cfreturn variables.cfCfDataType />
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
       <cfargument name="identity" hint="I indicate if the field is an identity field" required="yes" type="boolean" />
       <cfset variables.identity = arguments.identity />
    </cffunction>
    <cffunction name="getIdentity" access="public" output="false" returntype="boolean">
       <cfreturn Iif(variables.identity, DE('true'), DE('false')) />
    </cffunction>
	
	<!--- nullable --->
    <cffunction name="setNullable" access="public" output="false" returntype="void">
       <cfargument name="nullable" hint="I indicate if the field is nullable" required="yes" type="boolean" />
       <cfset variables.nullable = arguments.nullable />
    </cffunction>
    <cffunction name="getNullable" access="public" output="false" returntype="boolean">
       <cfreturn Iif(variables.nullable, DE('true'), DE('false')) />
    </cffunction>
	
	<!--- length --->
    <cffunction name="setLength" access="public" output="false" returntype="void">
       <cfargument name="length" hint="I am the length of the field" required="yes" type="numeric" />
       <cfset variables.length = arguments.length />
    </cffunction>
    <cffunction name="getLength" access="public" output="false" returntype="numeric">
       <cfreturn variables.length />
    </cffunction>
	
	<!--- default --->
    <cffunction name="setDefault" access="public" output="false" returntype="void">
       <cfargument name="default" hint="I am teh default value of this field" required="yes" type="string" />
       <cfset variables.default = arguments.default />
    </cffunction>
    <cffunction name="getDefault" access="public" output="false" returntype="string">
       <cfreturn variables.default />
    </cffunction>
	
	<!--- primaryKey --->
    <cffunction name="setPrimaryKey" access="public" output="false" returntype="void">
       <cfargument name="primaryKey" hint="I indicate if the colum is part of the primary key" required="yes" type="boolean" />
       <cfset variables.primaryKey = arguments.primaryKey />
    </cffunction>
    <cffunction name="getPrimaryKey" access="public" output="false" returntype="boolean">
       <cfreturn Iif(variables.primaryKey, DE('true'), DE('false')) />
    </cffunction>
</cfcomponent>