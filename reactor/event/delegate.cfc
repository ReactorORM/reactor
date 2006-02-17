<cfcomponent>
	
	<cfset variables.object = 0 />
	<cfset variables.method = 0 />
	
	<cffunction name="init" access="public" hint="I configure and return this delegate" output="false" returntype="delegate">
		<cfargument name="object" hint="I am the object." required="yes" type="reactor.base.abstractRecord" />
		<cfargument name="method" hint="I the name of a method on the object." required="yes" type="any" />
		
		<cfset variables.object = arguments.object />
		<cfset variables.method = arguments.method />
		
		<cfset validate() />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="validate" access="private" hint="I validate the delegate" output="false" returntype="void">
		<cfset var delegateMetadata = GetMetadata(variables.object[variables.method]) />
		
		<!--- make sure the delegate accepts only one argument and that it's type is reactor.event.event --->
		<cftry>
			<cfif NOT (ArrayLen(delegateMetadata.parameters) IS 1 AND delegateMetadata.parameters[1].type IS "reactor.event.event")>
				<!--- this is not a valid delegate --->
				<cfthrow message="Invalid Delegate Signature" detail="The method passed to attachDelegate '#delegateMetadata.name#' is not valid.  Delegates must have only one parameter that accepts a reactor.event.event object." type="reactor.delegate.InvalidDelegateSignature" />
			</cfif>
			<cfcatch type="reactor.delegate.InvalidDelegateSignature">
				<cfrethrow />
			</cfcatch>
			<cfcatch>
				<cfthrow message="Invalid Delegate" detail="The value passed to the delegate attribute does not appear to be a method." type="reactor.delegate.InvalidDelegate" />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="execute" access="public" hint="I execute this delegate" output="false" returntype="void">
		<cfargument name="Event" hint="I am the event object." required="yes" type="reactor.event.event" /> 
		<cfset var argumentcollection = StructNew() />
		<cfinvoke component="#variables.object#" method="#variables.method#" argumentcollection="#arguments#" />
	</cffunction>
	
	<cffunction name="getSignature" access="public" hint="I return the signature of this delegate" output="false" returntype="string">
		<cfreturn variables.object._getInstanceId() & variables.method />
	</cffunction>
	
</cfcomponent>