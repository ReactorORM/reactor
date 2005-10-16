<cfset config = CreateObject("Component", "reactor.bean.config").init("scratch", "mssql", "/reactorData", "always") />
<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(config) />



<cfset CustomerBean = reactor.createBean("Customer") />
<cfset ValidationErrorCollection = CreateObject("component", "reactor.util.ValidationErrorCollection").init() />

<cfset ValidationErrorCollection = CustomerBean.validate(ValidationErrorCollection) />

<cfdump var="#ValidationErrorCollection.getErrors()#" />
<cfabort>
