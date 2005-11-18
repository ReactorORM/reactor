

<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/config/reactor.xml")) />
<!---
<cfset userGateway = reactor.createGateway("User") />
<cfset query = userGateway.createQuery() />

<cfset query.join("User", "Merchant") /> 
<cfset query.join("Merchant", "Company") />
<cfset query.join("Company", "Product") />
<cfset query.join("Merchant", "Product") />

--->




<cfset myGateway = reactor.createGateway("Company") />
<cfset query = myGateway.createQuery() />

<cfset query.join("Company", "BillingAddress").join("BillingAddress", "StateProv").join("Company", "MailingAddress") />
<cfset query.getOrder().setDesc("BillingAddress", "AddressId") />

<cfdump var="#myGateway.getByQuery(query)#" />
