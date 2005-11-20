<cfcomponent hint="I am an abstract TO.  I am used to define an interface and for return types." extends="reactor.base.abstractObject">
	
	<cffunction name="merge" access="public" hint="I merge another TO into this TO.  Properties in both TOs are copied from the provided TO to this TO." output="false" returntype="void">
		<cfargument name="To" hint="I am the TO to copy data from" required="yes" type="reactor.base.abstractTo" />
		<cfset var item = 0 />
		<cfset var avaliableItems = StructKeyList(arguments.To) />
		
		<cfloop collection="#this#" item="item">
			<!--- only copy simple values --->
			<cfif IsSimpleValue(this[item]) AND StructKeyExists(arguments.To, item)>
				<cfset this[item] = arguments.To[item] />
			</cfif>
		</cfloop>
				
	</cffunction>
	
</cfcomponent>