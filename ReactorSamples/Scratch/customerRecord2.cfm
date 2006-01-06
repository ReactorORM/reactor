<!--- create the reactorFactory --->
<cfset Reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("reactor.xml")) />

<!--- create a customerRecord --->
<cfset CustomerRecord = Reactor.createRecord("Customer") />

<!--- read customer 1 --->
<cfset CustomerRecord.setCustomerId(1) />
<cfset CustomerRecord.load() />

<!--- get the customer's address record --->
<cfset CustomerAddressRecord = CustomerRecord.getAddressRecord() />

<!--- output the customer's name and address --->
<cfoutput>
	<p>
	<strong>#CustomerRecord.getFirstName()#
	#CustomerRecord.getLastName()#</strong><br />
	#CustomerAddressRecord.getStreet1()#<br />
	<cfif Len(CustomerAddressRecord.getStreet2())>
		#CustomerAddressRecord.getStreet2()#<br />
	</cfif>
	#CustomerAddressRecord.getCity()#,
	#CustomerAddressRecord.getState()#
	#CustomerAddressRecord.getZip()#
	</p>
</cfoutput>