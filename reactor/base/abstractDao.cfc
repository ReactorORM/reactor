<cfcomponent hint="I am used primarly to allow type definitions for return values.  I also loosely define an interface for Dao objects and some core methods.">

	<cfinclude template="base.cfm" />
	
	<cffunction name="_configure" access="public" hint="I configure and return this object." output="false" returntype="any" _returntype="reactor.base.abstractDao">
		<cfargument name="config" hint="I am the configuration object to use." required="yes" type="any" _type="reactor.config.config" />
		<cfargument name="alias" hint="I am the alias of this object." required="yes" type="any" _type="string" />
		<cfargument name="ReactorFactory" hint="I am the reactorFactory object." required="yes" type="any" _type="reactor.reactorFactory" />
		<cfargument name="Convention" hint="I am a database Convention object." required="yes" type="any" _type="reactor.data.abstractConvention" />
		<cfargument name="ObjectMetadata" hint="I am a database metadata object." required="yes" type="any" _type="reactor.base.abstractMetadata" />
		
		<cfset _setConfig(arguments.config) />
		<cfset _setAlias(arguments.alias) />
		<cfset _setReactorFactory(arguments.ReactorFactory) />
		<cfset _setConvention(arguments.Convention) />
		<cfset setObjectMetadata(arguments.ObjectMetadata) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="dump" returntype="string">
	<cfsavecontent variable="dump">
		<cfdump var="#variables#" />
	</cfsavecontent>
	<cfreturn dump />
	</cffunction>
	
	<!--- objectMetadata --->
    <cffunction name="setObjectMetadata" access="private" output="false" returntype="void">
       <cfargument name="objectMetadata" hint="I set the object metadata." required="yes" type="any" _type="reactor.base.abstractMetadata" />
       <cfset variables.objectMetadata = arguments.objectMetadata />
    </cffunction>
    <cffunction name="getObjectMetadata" access="private" output="false" returntype="any" _returntype="reactor.base.abstractMetadata">
       <cfreturn variables.objectMetadata />
    </cffunction>
	
	<cffunction name="getConventions" access="private" output="false" returntype="any" _returntype="reactor.data.abstractConvention">
  		<cfreturn _getConvention() />
	</cffunction>
	
	<cffunction name="create" access="public" hint="I create a row in the database." output="false" returntype="void">
	
	</cffunction>
	
	<cffunction name="read" access="public" hint="I read a row from the database." output="false" returntype="void">
	
	</cffunction>
	
	<cffunction name="update" access="public" hint="I update a row in the database." output="false" returntype="void">
	
	</cffunction>
	
	<cffunction name="delete" access="public" hint="I delete a row in the database." output="false" returntype="void">
	
	</cffunction>
	
</cfcomponent>

