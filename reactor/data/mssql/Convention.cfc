<cfcomponent hint="I am the convention object for mssql.  I translate data into formats that the DBMS supports." extends="reactor.data.abstractConvention">
	
	<cffunction name="lastInseredIdSyntax" access="public" hint="I return a simple query which can be used to get the last ID inserted into the database." output="false" returntype="string">
		<cfargument name="ObjectMetadata" hint="I am the metadata to use." required="yes" type="reactor.base.abstractMetadata" />
		
		<cfreturn "SELECT SCOPE_IDENTITY() as Id" />
		
	</cffunction>
	
	<cffunction name="formatObjectAlias" access="public" hint="I format the object/table name with an alias" output="false" returntype="string">
		<cfargument name="ObjectMetadata" hint="I am the metadata to use." required="yes" type="reactor.base.abstractMetadata" />
		<cfargument name="alias" hint="I am this object's alias" required="yes" type="string" />
		
		<cfreturn formatObjectName(arguments.ObjectMetadata, arguments.alias) & " AS [#arguments.alias#]" />
		
	</cffunction>
	
	<cffunction name="formatObjectName" access="public" hint="I format the object/table name" output="false" returntype="string">
		<cfargument name="ObjectMetadata" hint="I am the metadata to use." required="yes" type="reactor.base.abstractMetadata" />
		<cfargument name="alias" hint="I am this object/tables's alias" required="yes" type="string" />
		
		<cfreturn "[#arguments.ObjectMetadata.getDatabase()#].[#arguments.ObjectMetadata.getOwner()#].[#arguments.ObjectMetadata.getName()#]" />
		
	</cffunction>
	
	<cffunction name="formatFieldName" access="public" hint="I format the field name" output="false" returntype="string">
		<cfargument name="fieldName" hint="I am the field name." required="yes" type="string" />
		<cfargument name="alias" hint="I am this object's alias" required="yes" type="string" />
		
		<cfreturn "[#arguments.alias#].[#arguments.fieldName#]" />
		
	</cffunction>
	
	<cffunction name="formatUpdateFieldName" access="public" hint="I format the field name" output="false" returntype="string">
		<cfargument name="fieldName" hint="I am the field name." required="yes" type="string" />
		
		<cfreturn "[#arguments.fieldName#]" />
		
	</cffunction>
	
	<cffunction name="formatFieldAlias" access="public" hint="I format the field name" output="false" returntype="string">
		<cfargument name="fieldName" hint="I am the field name." required="yes" type="string" />
		<cfargument name="alias" hint="I am this object's alias" required="no" type="string" default="" />
		
		<cfreturn "[#arguments.alias##arguments.fieldName#]" />
		
	</cffunction>
	
	<cffunction name="formatValue" access="public" hint="I format a value based on it's type." output="false" returntype="string">
		<cfargument name="value" hint="I am the value to format" required="yes" type="string" />
		<cfargument name="dbDataType" hint="I am the type of data in the database" required="yes" type="string" />
		
		<cfif arguments.dbDataType IS "UniqueIdentifier">
			<cfreturn Left(arguments.value, 23) & "-" & Right(arguments.value, 12) />
		<cfelse>
			<cfreturn arguments.value />
		</cfif>
		
	</cffunction>	
	
</cfcomponent>