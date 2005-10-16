<cfcomponent hint="I am an abstract record.  I am used primarly to allow type definitions for return values.  I also loosely define an interface for a record objects and some core methods." extends="reactor.base.abstractObject">

	<cffunction name="load" access="public" hint="I load this record based on its primary key values." output="false" returntype="boolean">
		
	</cffunction>
	
	<cffunction name="save" access="public" hint="I save record based on its primary key values." output="false" returntype="boolean">
		
	</cffunction>
	
</cfcomponent>