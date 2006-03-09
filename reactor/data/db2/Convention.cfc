<cfcomponent hint="I am the convention object for db2.  I translate data into formats that the DBMS supports." extends="reactor.data.abstractConvention">
	
	<cffunction name="lastInsertedIdSyntax" access="public" hint="I return a simple query which can be used to get the last ID inserted into the database." output="false" returntype="string">
		<cfargument name="ObjectMetadata" hint="I am the metadata to use." required="yes" type="reactor.base.abstractMetadata" />
		
		<cfreturn "select identity_val_local() as ID from sysibm.sysdummy1" />
		
	</cffunction>
	
	<cffunction name="formatObjectAlias" access="public" hint="I format the object/table name with an alias" output="false" returntype="string">
		<cfargument name="ObjectMetadata" hint="I am the metadata to use." required="yes" type="reactor.base.abstractMetadata" />
		<cfargument name="alias" hint="I am this object's alias" required="yes" type="string" />
		
		<cfreturn formatObjectName(arguments.ObjectMetadata, arguments.alias) & " AS ""#arguments.alias#""" />
		
	</cffunction>
	
	<cffunction name="formatObjectName" access="public" hint="I format the object/table name" output="false" returntype="string">
		<cfargument name="ObjectMetadata" hint="I am the metadata to use." required="yes" type="reactor.base.abstractMetadata" />
		
		<cfreturn """#arguments.ObjectMetadata.getOwner()#"".""#arguments.ObjectMetadata.getName()#""" />
		
	</cffunction>
	
	<cffunction name="formatFieldName" access="public" hint="I format the field name" output="false" returntype="string">
		<cfargument name="fieldName" hint="I am the field name." required="yes" type="string" />
		<cfargument name="alias" hint="I am this object's alias" required="yes" type="string" />
		
		<cfreturn """#arguments.alias#"".""#arguments.fieldName#""" />
		
	</cffunction>
	
	<cffunction name="formatInsertFieldName" access="public" hint="I format the field name" output="false" returntype="string">
		<cfargument name="fieldName" hint="I am the field name." required="yes" type="string" />
		<cfargument name="alias" hint="I am this object's alias" required="yes" type="string" />
		
		<cfreturn formatUpdateFieldName(arguments.fieldName) />
		
	</cffunction>
	
	<cffunction name="formatUpdateFieldName" access="public" hint="I format the field name" output="false" returntype="string">
		<cfargument name="fieldName" hint="I am the field name." required="yes" type="string" />
		
		<cfreturn """#arguments.fieldName#""" />
		
	</cffunction>
	
	<cffunction name="formatFieldAlias" access="public" hint="I format the field name" output="false" returntype="string">
		<cfargument name="fieldName" hint="I am the field name." required="yes" type="string" />
		<cfargument name="alias" hint="I am this object's alias" required="no" type="string" default="" />
		
		<cfreturn """#arguments.alias##arguments.fieldName#""" />
		
	</cffunction>
	
	<cffunction name="supportsSequences" access="public" hint="I indicate if the DB support sequences" output="false" returntype="boolean">
		<cfreturn false />		
	</cffunction>
	
	<cffunction name="formatValue" access="public" hint="I format a value based on it's type." output="false" returntype="string">
		<cfargument name="value" hint="I am the value to format" required="yes" type="string" />
		<cfargument name="dbDataType" hint="I am the type of data in the database" required="yes" type="string" />
		
		<cfreturn arguments.value />		
	</cffunction>	
	
</cfcomponent>