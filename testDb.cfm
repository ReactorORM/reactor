
<style>
	label{
		display: block;
		width: 100px;
		float: left;
	}
</style>

<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init("/config/reactor.xml") />

<cfif NOT IsDefined("session.Customer")>
	<cfset session.Customer = reactor.createRecord("Customer").load(customerId=5) />
</cfif>

<cfform action="testDb.cfm">
	<label for="username">User Name:</label>
	<cfinput type="text" name="username" value="#session.Customer.getUsername()#" />
	<br />
	<label for="password">Password:</label>
	<cfinput type="text" name="password" value="#session.Customer.getPassword()#" />
	<br />
	<label for="firstname">First Name:</label>
	<cfinput type="text" name="firstname" value="#session.Customer.getFirstName()#" />
	<br />
	<label for="lastname">Last Name:</label>
	<cfinput type="text" name="lastname" value="#session.Customer.getLastName()#" />

	<h3>Addresses</h3>
	<cfset AddressIterator = session.Customer.getAddressIterator() />
	<cfset AddressIterator.getOrder().setDesc("Address", "street") />

	<cfloop condition="#AddressIterator.hasMore()#">
		<cfset AddressRecord = AddressIterator.getNext() />
		<cfdump var="#AddressRecord._getTo()#" />
	</cfloop>

</cfform>