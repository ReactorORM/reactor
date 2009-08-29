<cfset factory=createObject('component','reactor.reactorFactory')>
<cfset factory.init(expandPath("reactor.xml"))>

<cfset gw=factory.createGateway('foo')>

<!---
<cfset rec=factory.createRecord('foo')>
<cfset rec.setName('the one')>
<cfset rec.save()>--->
All filter:
<cfdump var="#gw.getByFilter()#">

<cfset result = gw.getByFilter(include={id=1})>

inc id 1 filter:
<cfdump var="#result#">

<cfset result = gw.getByFilter(include={id=1},contains={name="oNe"})>
inc id 1, contains oNe
<cfdump var="#result#">

<cfset result = gw.getByFilter(isIn={id="1,2"})>
inc id 1,2
<cfdump var="#result#">

<cfset result = gw.getByFilter(notIn={id="2,3"})>
ex id 2,3
<cfdump var="#result#">