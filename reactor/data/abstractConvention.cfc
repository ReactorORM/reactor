<cfcomponent hint="I am an abstract convention object used to define the convention object's interface.">

	<cffunction name="lastInsertedIdSyntax" access="public" hint="I return a simple query which can be used to get the last ID inserted into the database." output="false" returntype="any" _returntype="string">
		<cfargument name="ObjectMetadata" hint="I am the metadata to use." required="yes" type="any" _type="reactor.base.abstractMetadata" />
		
	</cffunction>
	
	<cffunction name="formatObjectAlias" access="public" hint="I format the object name" output="false" returntype="any" _returntype="string">
		<cfargument name="ObjectMetadata" hint="I am the metadata to use." required="yes" type="any" _type="reactor.base.abstractMetadata" />
		<cfargument name="alias" hint="I am this object's alias" required="yes" type="any" _type="string" />
		
	</cffunction>
	
	<cffunction name="formatObjectName" access="public" hint="I format the object" output="false" returntype="any" _returntype="string">
		<cfargument name="ObjectMetadata" hint="I am the metadata to use." required="yes" type="any" _type="reactor.base.abstractMetadata" />
		<cfargument name="alias" hint="I am this object's alias" required="yes" type="any" _type="string" />
		
	</cffunction>
	
	<cffunction name="formatFieldName" access="public" hint="I format the field name" output="false" returntype="any" _returntype="string">
		<cfargument name="fieldName" hint="I am the field name." required="yes" type="any" _type="string" />
		<cfargument name="alias" hint="I am this object's alias" required="yes" type="any" _type="string" />
		
	</cffunction>
	
	<cffunction name="formatUpdateFieldName" access="public" hint="I format the field name" output="false" returntype="any" _returntype="string">
		<cfargument name="fieldName" hint="I am the field name." required="yes" type="any" _type="string" />
		
	</cffunction>
	
	<cffunction name="formatFieldAlias" access="public" hint="I format the field name" output="false" returntype="any" _returntype="string">
		<cfargument name="fieldName" hint="I am the field name." required="yes" type="any" _type="string" />
		<cfargument name="alias" hint="I am this object's alias" required="no" type="any" _type="string" default="" />
		
	</cffunction>
	
	<cffunction name="formatValue" access="public" hint="I format a value based on it's type." output="false" returntype="any" _returntype="string">
		<cfargument name="value" hint="I am the value to format" required="yes" type="any" _type="string" />
		<cfargument name="dbDataType" hint="I am the type of data in the database" required="yes" type="any" _type="string" />
		
	</cffunction>	
	
	
	<cffunction name="supportsPagination" access="public" hint="I return whether this object supports pagination, otherwise we use the inbuilt function" output="false" returntype="boolean" _returntype="boolean">
		<cfreturn false />
	</cffunction>
	
	
	<cffunction name="formatPaginationSetting" access="public" hint="I return the pagination statement for this object" output="false" returntype="string" _returntype="string">
		<cfargument name="page" hint="the page to retrieve from the query" required="yes" type="numeric" _type="numeric">
		<cfargument name="rows" hint="the page to retrieve from the query" required="yes" type="numeric" _type="numeric">

		<cfreturn "" />
	</cffunction>
	
	
</cfcomponent>
