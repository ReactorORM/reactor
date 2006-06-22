<cfcomponent hint="I am used primarly to allow type definitions for return values.  I also loosely define an interface for Dao objects and some core methods." extends="reactor.base.abstractObject">
	
	<cffunction name="configure" access="public" hint="I configure and return this object." output="false" returntype="reactor.base.abstractDao">
		<cfargument name="config" hint="I am the configuration object to use." required="yes" type="reactor.config.config" />
		<cfargument name="alias" hint="I am the alias of this object." required="yes" type="string" />
		<cfargument name="ReactorFactory" hint="I am the reactorFactory object." required="yes" type="reactor.reactorFactory" />
		<cfargument name="Convention" hint="I am a database Convention object." required="yes" type="reactor.data.abstractConvention" />
		<cfargument name="ObjectMetadata" hint="I am a database metadata object." required="yes" type="reactor.base.abstractMetadata" />
		
		<cfset super.configure(arguments.Config, arguments.alias, arguments.ReactorFactory, arguments.Convention) />
		<cfset setObjectMetadata(arguments.ObjectMetadata) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- objectMetadata --->
    <cffunction name="setObjectMetadata" access="private" output="false" returntype="void">
       <cfargument name="objectMetadata" hint="I set the object metadata." required="yes" type="reactor.base.abstractMetadata" />
       <cfset variables.objectMetadata = arguments.objectMetadata />
    </cffunction>
    <cffunction name="getObjectMetadata" access="private" output="false" returntype="reactor.base.abstractMetadata">
       <cfreturn variables.objectMetadata />
    </cffunction>
	
	<cffunction name="getConventions" access="private" output="false" returntype="reactor.data.abstractConvention">
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