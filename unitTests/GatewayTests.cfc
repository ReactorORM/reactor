<cfcomponent extends="reactorUnitTests.base">
	
	<cffunction name="setup" returntype="void">
		<cfargument name="type" required="yes" type="string" />
		<cfset super.setup(arguments.type) />
	</cffunction>
	
	<cffunction name="testCreateSimpleGateway" returntype="void" access="public">
		<cfset var reactor = getReactor() />
		<cfset var AddressGateway = reactor.createGateway("Address") />
		
		<cfset assertIsOfType(AddressGateway, "reactor.base.abstractGateway") />
	</cffunction>
	
	<cffunction name="testSimpleGateway" returntype="void" access="public">
		<cfset var reactor = getReactor() />
		<cfset var UserTypeTo = 0 />
		<cfset var UserTypeDao = reactor.createDao("UserType") />
		<cfset var UserTypeGateway = reactor.createGateway("UserType") />
		<cfset var results = 0 />
		<cfset var Criteria = CreateObject("Component", "reactor.query.criteria") />
		
		<!--- create some objects --->
		<cfset UserTypeTo = reactor.createTo("UserType") />
		<cfset UserTypeTo.type = "Customer" />
		<cfset UserTypeDao.create(UserTypeTo) />
		
		<cfset UserTypeTo = reactor.createTo("UserType") />
		<cfset UserTypeTo.type = "Merchant" />
		<cfset UserTypeDao.create(UserTypeTo) />
		
		<cfset UserTypeTo = reactor.createTo("UserType") />
		<cfset UserTypeTo.type = "Administrator" />
		<cfset UserTypeDao.create(UserTypeTo) />
		
		<!--- check get by fields --->
		<cfset results = UserTypeGateway.getByFields() />
		<!--- results should have 3 rows --->
		<cfset assertEqualsNumber(3, results.recordCount) />
		
		<cfset results = UserTypeGateway.getByFields(type='Customer') />
		<!--- results should have 1 row --->
		<cfset assertEqualsNumber(1, results.recordCount) />
		<cfset assertEqualsString("Customer", results.type) />
		
		<!--- check get all --->
		<cfset results = UserTypeGateway.getAll() />
		<!--- results should have 3 rows --->
		<cfset assertEqualsNumber(3, results.recordCount) />
		
		<!--- check getByCriteria --->
		<cfset Criteria.getExpression().isLt("[userTypeId]", 2) />
		<cfset results = UserTypeGateway.getByCriteria(Criteria) />
		<!--- results should have 1 row --->
		<cfset assertEqualsNumber(1, results.recordCount) />
		<cfset assertEqualsString("Customer", results.type) />
		
	</cffunction>
	
	<cffunction name="testComplexGateway" returntype="void" access="public">
		<cfset var reactor = getReactor() />
		<cfset var UserTypeTo = reactor.createTo("UserType") />
		<cfset var CountryTo = reactor.createTo("Country") />
		<cfset var StateProvTo = reactor.createTo("StateProv") />
		<cfset var AddressTo = reactor.createTo("Address") />
		<cfset var CustomerTo = reactor.createTo("Customer") />
		
		<cfset var UserTypeDao = reactor.createDao("UserType") />
		<cfset var CountryDao = reactor.createDao("Country") />
		<cfset var StateProvDao = reactor.createDao("StateProv") />
		<cfset var AddressDao = reactor.createDao("Address") />
		<cfset var CustomerDao = reactor.createDao("Customer") />
		
		<cfset var CustomerGateway = reactor.createGateway("Customer") />
		<cfset var results = 0 />
		<cfset var Criteria = CreateObject("Component", "reactor.query.criteria") />
		
		<!--- create the needed user type --->
		<cfset UserTypeTo.type = "Customer" />
		<cfset UserTypeDao.create(UserTypeTo) />
		
		<!--- create a country --->
		<cfset CountryTo.name = "USA" />
		<cfset CountryDao.create(CountryTo) />
		
		<!--- create a state --->
		<cfset StateProvTo.code = "VA" />
		<cfset StateProvTo.name = "Virginia" />
		<cfset StateProvTo.countryId = 1 />
		<cfset StateProvDao.create(StateProvTo) />
		
		<!--- create the needed addresses --->
		<cfset AddressTo.street1 = "1234 North Street" />
		<cfset AddressTo.street2 = "Apt 123" />
		<cfset AddressTo.city = "Happyville" />
		<cfset AddressTo.stateProvId = 1 />
		<cfset AddressTo.countryId = 1 />
		<cfset AddressTo.postalCode = 17123 />
		<cfset AddressDao.create(AddressTo) />
		
		<cfset AddressTo = reactor.createTo("Address") />
		<cfset AddressTo.street1 = "2987 South Street" />
		<cfset AddressTo.city = "Mooville" />
		<cfset AddressTo.stateProvId = 1 />
		<cfset AddressTo.countryId = 1 />
		<cfset AddressTo.postalCode = 54321 />
		<cfset AddressDao.create(AddressTo) />
			
		<cfset CustomerTo.mailingAddressId = 1 />
		<cfset CustomerTo.billingAddressId = 2 />
		<cfset CustomerTo.username = "testUser" />
		<cfset CustomerTo.password = "sadfsadffasd"  />
		<cfset CustomerTo.firstName = "Foo" />
		<cfset CustomerTo.lastName = "Bar" />
		<cfset CustomerTo.userTypeId = 1 />
		<cfset CustomerDao.create(CustomerTo) />
		
		<!--- check get by fields --->
		<cfset results = CustomerGateway.getByFields() />
		<!--- results should have 1 row --->
		<cfset assertEqualsNumber(1, results.recordCount) />
		
		<cfset results = CustomerGateway.getByFields(firstName='Foo') />
		<!--- results should have 1 row --->
		<cfset assertEqualsNumber(1, results.recordCount) />
		<cfset assertEqualsString("Foo", results.firstName) />
		
		<!--- check get all --->
		<cfset results = CustomerGateway.getAll() />
		<!--- results should have 1 rows --->
		<cfset assertEqualsNumber(1, results.recordCount) />
		
		<!--- check getByCriteria --->
		<cfset Criteria.getExpression().isEqual("[User].[lastName]", "Bar") />
		<cfset results = CustomerGateway.getByCriteria(Criteria) />
		<!--- results should have 1 row --->
		<cfset assertEqualsNumber(1, results.recordCount) />
		<cfset assertEqualsString("Bar", results.lastName) />
	</cffunction>
	
	<cffunction name="testCreateBadGateway" returntype="void" access="public">
		<cfset var reactor = getReactor() />
		<cfset var BadGateway = 0 />
		
		<cftry>
			<cfset BadGateway = reactor.createGateway("Bad") />
			<cfcatch type="Reactor.NoSuchTable">
				<!--- success --->
				<cfreturn />
			</cfcatch>
		</cftry>
		
		<cfset fail("Reactor did not correctly throw an error for a non-existing table.") />
	</cffunction>
	
	
</cfcomponent>