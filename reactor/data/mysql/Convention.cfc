<cfcomponent hint="I am the convention object for mssql.  I translate data into formats that the DBMS supports." extends="reactor.data.abstractConvention">
	

	<cffunction name="formatObjectName" access="public" hint="I format the object" output="false" returntype="string">
		<cfargument name="ObjectMetadata" hint="I am the metadata to use." required="yes" type="reactor.base.abstractMetadata" />
		<cfargument name="alias" hint="I am this object's alias" required="yes" type="string" />
		
		<cfreturn "`#arguments.ObjectMetadata.getDatabase()#`.`#arguments.ObjectMetadata.getName()#` AS `#arguments.alias#`" />
		
	</cffunction>
	
	<cffunction name="formatFieldName" access="public" hint="I format the field name" output="false" returntype="string">
		<cfargument name="fieldName" hint="I am the field name." required="yes" type="string" />
		<cfargument name="alias" hint="I am this object's alias" required="yes" type="string" />
		
		<cfreturn "`#arguments.alias#`.`#arguments.fieldName#`" />
		
	</cffunction>
	
	<cffunction name="formatFieldAlias" access="public" hint="I format the field name" output="false" returntype="string">
		<cfargument name="fieldName" hint="I am the field name." required="yes" type="string" />
		<cfargument name="alias" hint="I am this object's alias" required="no" type="string" default="" />
		
		<cfreturn "`#arguments.alias##arguments.fieldName#`" />
		
	</cffunction>
	
	<cffunction name="formatValue" access="public" hint="I format a value based on it's type." output="false" returntype="string">
		<cfargument name="value" hint="I am the value to format" required="yes" type="string" />
		<cfargument name="dbDataType" hint="I am the type of data in the database" required="yes" type="string" />
		
		<cfreturn arguments.value />		
	</cffunction>	
	
</cfcomponent>