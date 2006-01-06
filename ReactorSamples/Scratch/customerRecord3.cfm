<!--- create the reactorFactory --->
<cfset Reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("reactor.xml")) />

<!--- create a customerRecord --->
<cfset CustomerRecord = Reactor.createRecord("Customer") />

<!--- get the user record's address --->
<cfset AddressRecord = CustomerRecord.getAddressRecord() />

<!--- populate the customer and address --->
<cfset CustomerRecord.setUsername("jblow") />
<cfset CustomerRecord.setPassword("9ummy") />
<cfset CustomerRecord.setFirstName("Joe") />
<cfset CustomerRecord.setLastName("Blow") />

<cfset AddressRecord.setStreet1("1234 Left Turn Ln.") />
<cfset AddressRecord.setCity("Albuquerque") />
<cfset AddressRecord.setState("New Mexico") />
<cfset AddressRecord.setZip("87112") />

<!--- save the customer! --->
<cfset AddressRecord.save() />
<cfset CustomerRecord.setAddressRecord(AddressRecord) />
<cfset CustomerRecord.save() />