<cfcomponent extends="reactorUnitTests.base">
	
	<cffunction name="setup" returntype="void">
		<cfargument name="type" required="yes" type="string" />
		<cfset super.setup(arguments.type) />
	</cffunction>
	
	<cffunction name="testCreateSimpleDao" returntype="void" access="public">
		<cfset var reactor = getReactor() />
		<cfset var ProductDao = reactor.createDao("Product") />
		
		<cfset assertIsOfType(ProductDao, "reactor.base.abstractDao") />
	</cffunction>
	
	<cffunction name="testSimpleDaoFunctions" returntype="void" access="public">
		<cfset var reactor = getReactor() />
		<cfset var UserTypeTo = 0 />
		<cfset var UserTypeDao = reactor.createDao("UserType") />
		
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
		
		<!--- read an object --->
		<cfset UserTypeTo = reactor.createTo("UserType") />
		<cfset UserTypeTo.userTypeId = 1 />
		<cfset UserTypeDao.read(UserTypeTo) />
		
		<cfset assertEqualsString("Customer", UserTypeTo.type)  />
		
		<!--- change the TO and update --->
		<cfset UserTypeTo.type = "New Customer" />
		<cfset UserTypeDao.update(UserTypeTo) />
		
		<!--- create a new TO and re-read the last updated item --->
		<cfset UserTypeTo = reactor.createTo("UserType") />
		<cfset UserTypeTo.userTypeId = 1 />
		<cfset UserTypeDao.read(UserTypeTo) />
		
		<cfset assertEqualsString("New Customer", UserTypeTo.type)  />
		
		<!--- delete this to --->
		<cfset UserTypeDao.delete(UserTypeTo) />
		<!--- create a new TO and re-read the last updated item --->
		<cfset UserTypeTo = reactor.createTo("UserType") />
		<cfset UserTypeTo.userTypeId = 1 />
		<cfset UserTypeDao.read(UserTypeTo) />
		
		<cfset assertEqualsString("", UserTypeTo.type)  />		
	</cffunction>
	
	<cffunction name="testComplexDao" returntype="void" access="public">
		<cfset var reactor = getReactor() />
		<cfset var CustomerDao = reactor.createDao("Customer") />
		
		<cfset assertIsOfType(CustomerDao, "reactorUnitTests.data.Dao.#getConfig().getDbType()#.UserDao") />
		<cfset assertIsOfType(CustomerDao, "reactor.base.abstractDao") />
	</cffunction>
	
	<cffunction name="testComplexDaoFunctions" returntype="void" access="public">
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
		
		<!--- read and confirm it saved correctly --->
		<cfset CustomerTo = reactor.createTo("Customer") />
		<cfset CustomerTo.userId = 1 />
		<cfset CustomerDao.read(CustomerTo) />
		
		<cfset assertEqualsNumber(1, CustomerTo.mailingAddressId) />
		<cfset assertEqualsNumber(2, CustomerTo.billingAddressId) />
		<cfset assertEqualsString("testUser", CustomerTo.username) />
		<cfset assertEqualsString("sadfsadffasd", CustomerTo.password) />
		<cfset assertEqualsString("Foo", CustomerTo.firstName) />
		<cfset assertEqualsString("Bar", CustomerTo.lastName) />
		<cfset assertEqualsNumber(1, CustomerTo.userTypeId) />
		
		<!--- update the customerto and update in the db --->
		<cfset CustomerTo.mailingAddressId = 2 />
		<cfset CustomerTo.billingAddressId = 1 />
		<cfset CustomerTo.username = "fooUser" />
		<cfset CustomerTo.username = "fooPass" />
		<cfset CustomerTo.firstName = "Moo" />
		<cfset CustomerTo.lastName = "Far" />
		<cfset CustomerDao.update(CustomerTo) />
		
		<!--- delete the record in the db --->
		<cfset CustomerDao.delete(CustomerTo) />
	</cffunction>

	
	<cffunction name="testCreateBadDao" returntype="void" access="public">
		<cfset var reactor = getReactor() />
		<cfset var BadDao = 0 />
		
		<cftry>
			<cfset BadDao = reactor.createDao("Bad") />
			<cfcatch type="Reactor.NoSuchTable">
				<!--- success --->
				<cfreturn />
			</cfcatch>
		</cftry>
		
		<cfset fail("Reactor did not correctly throw an error for a non-existing table.") />
	</cffunction>
	
</cfcomponent>