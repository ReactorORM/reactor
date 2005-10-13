<cfcomponent extends="reactorUnitTests.base">
	
	<cffunction name="setup" returntype="void">
		<cfargument name="type" required="yes" type="string" />
		<cfset super.setup(arguments.type) />
	</cffunction>
	
	<cffunction name="testCreateSimpleTo" returntype="void" access="public">
		<cfset var reactor = getReactor() />
		<cfset var AddressTo = reactor.createTo("Address") />
		
		<cfset assertIsOfType(AddressTo, "reactor.base.abstractTo") />
	</cffunction>
	
	<cffunction name="testSimpleToStructure" returntype="void" access="public">
		<cfset var reactor = getReactor() />
		<cfset var AddressTo = reactor.createTo("Address") />
		<cfset var temp = "" />
		
		<cfset temp = AddressTo.addressId />
		<cfset temp = AddressTo.street1 />
		<cfset temp = AddressTo.street2 />
		<cfset temp = AddressTo.city />
		<cfset temp = AddressTo.stateProvId />	
		<cfset temp = AddressTo.countryId />	
		<cfset temp = AddressTo.postalCode />	
		<cfset temp = AddressTo.getSignature() />
	</cffunction>
	
	<cffunction name="testComplexTo" returntype="void" access="public">
		<cfset var reactor = getReactor() />
		<cfset var CustomerTo = reactor.createTo("Customer") />
		
		<cfset assertIsOfType(CustomerTo, "reactorUnitTests.data.To.#getConfig().getDbType()#.UserTo") />
		<cfset assertIsOfType(CustomerTo, "reactor.base.abstractTo") />
	</cffunction>
	
	<cffunction name="testComplexToStructure" returntype="void" access="public">
		<cfset var reactor = getReactor() />
		<cfset var CustomerTo = reactor.createTo("Customer") />
		<cfset var temp = "" />
		
		<cfset temp = CustomerTo.customerId />
		<cfset temp = CustomerTo.mailingAddress />
		<cfset temp = CustomerTo.billingAddress />
		<cfset temp = CustomerTo.userId />
		<cfset temp = CustomerTo.username />	
		<cfset temp = CustomerTo.password />	
		<cfset temp = CustomerTo.firstName />	
		<cfset temp = CustomerTo.lastName />	
		<cfset temp = CustomerTo.userTypeId />	
		<cfset temp = CustomerTo.dateCreated />	
		<cfset temp = CustomerTo.getSignature() />
		
		<cfset assertDate(CustomerTo.dateCreated) />
		
	</cffunction>
	
	<cffunction name="testCreateBadTo" returntype="void" access="public">
		<cfset var reactor = getReactor() />
		<cfset var BadTo = 0 />
		
		<cftry>
			<cfset BadTo = reactor.createTo("Bad") />
			<cfcatch type="Reactor.NoSuchTable">
				<!--- success --->
				<cfreturn />
			</cfcatch>
		</cftry>
		
		<cfset fail("Reactor did not correctly throw an error for a non-existing table.") />
	</cffunction>
	
</cfcomponent>