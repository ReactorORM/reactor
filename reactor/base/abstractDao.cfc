<cfcomponent hint="I am used primarly to allow type definitions for return values.  I also loosely define an interface for Dao objects and some core methods." extends="reactor.base.abstractObject">
	
	<!--- metadata --->
    <cffunction name="getObjectMetadata" access="private" output="false" returntype="reactor.base.abstractMetadata">
       <cfreturn _getReactorFactory().createMetadata(_getName()) />
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