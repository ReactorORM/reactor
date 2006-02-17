<cfcomponent displayname="Iterator" hint="I represent an iteratable collection.">
	
	<cfset variables.ReactorFactory = 0 />
	<cfset variables.name = 0 />
 	<cfset variables.Gateway = 0 />
	<cfset variables.QueryObject = 0 />
	
	<cfset variables.query = 0/>
	<cfset variables.array = ArrayNew(1) />
	
	<cfset variables.index = 0 />
	
	<cffunction name="init" access="public" hint="I configure and return the iterator" output="false" returntype="Iterator">
		<cfargument name="ReactorFactory" hint="I am the gateway object used to query the DB." required="yes" type="reactor.reactorFactory" />
		<cfargument name="name" hint="I am the gateway object used to query the DB." required="yes" type="string" />
		<cfargument name="join" hint="I am the name of an optional object to join." required="no" default="" type="string" />
				
		<cfset setReactorFactory(arguments.ReactorFactory) />
		<cfset setName(arguments.name) />
		
		<!--- create and set the gateway we'll use to execute queries --->		
		<cfset setGateway(arguments.ReactorFactory.createGateway(arguments.name)) />
		<!--- get the query object that will back this iterator --->
		<cfset setQueryObject(getGateway().createQuery()) />
		<!--- filter to only this object's fields --->
		<cfset getQueryObject().returnObjectFields(arguments.name) />
		
		<cfif Len(arguments.join)>
			<cfset getQueryObject().join(arguments.name, arguments.join) />
		</cfif>
		
		<cfreturn this />
	</cffunction>
	
	<!--- hasMore --->
	<cffunction name="hasMore" access="public" hint="I indicate if the iterator has more elements" output="false" returntype="boolean">
		<cfreturn variables.index LT getRecordCount() />
	</cffunction>
	
	<!--- getRecordCount --->
	<cffunction name="getRecordCount" access="public" hint="I get the iterator's recordcount" output="false" returntype="numeric">
		<cfreturn getQuery().recordCount />
	</cffunction>
	
	<!--- getNext --->
	<cffunction name="getNext" access="public" hint="I get the next element from the iterator" output="false" returntype="reactor.base.abstractRecord">
		<cfset var Array = getArray() />
		<cfif NOT hasMore()>
			<cfthrow message="No More Records" detail="There are no more records in the iterator." type="reactor.iterator.NoMoreRecords" />
		</cfif>
		<!--- incrament the iterator --->
		<cfset variables.index = variables.index + 1 />
		
		<cfreturn Array[variables.index] />
	</cffunction>
	
	<!--- getArray --->
	<cffunction name="getArray" access="public" hint="I return an array of objects in the iterator" output="false" returntype="array">
		<cfset var Query = 0 />
		<cfset var Array = ArrayNew(1) />
		<cfset var Record = 0 />
		<cfset var To = 0 />
		<cfset var field = "" />
		
		<cfif NOT IsArray(variables.array)>
			<cfset Query = getQuery() />
			
			<cfloop query="Query">
				<cfset Record = getReactorFactory().createRecord(getName()) >
				<cfset To = Record._getTo() />
	
				<!--- populate the record's to --->
				<cfloop list="#Query.columnList#" index="field">
					<cfset To[field] = Query[field][Query.currentrow] >
				</cfloop>
				
				<cfset Record._setTo(To) />
				
				<cfset Array[ArrayLen(Array) + 1] = Record >
			</cfloop>
		
			<cfset variables.array = Array />
		</cfif>
		
		<cfreturn variables.array />
	</cffunction>
		
	<!--- reset --->
	<cffunction name="reset" access="public" hint="I reset the array and query that backs this iterator." output="false" returntype="void">
		<cfset variables.query = 0 />
		<cfset variables.array = 0 />
		<cfset variables.index = 0 />
	</cffunction>
	
	<!--- getWhere --->
	<cffunction name="getWhere" access="public" hint="I get the where object that filters the query that backs this iterator" output="false" returntype="reactor.query.where">
		<cfset reset() />
		<cfreturn getQueryObject().getWhere() />
	</cffunction>
	
	<!--- setDistinct --->
	<cffunction name="setDistinct" access="public" hint="I filter the query that backs this iterator to return only distinct values." output="false" returntype="void">
		<cfargument name="distinct" hint="I indicate if the query should only return distinct matches" required="yes" type="boolean" />
		<cfset reset() />
		<cfreturn getQueryObject().setDistinct(arguments.distinct) />
	</cffunction>
		
	<!--- getOrder --->
	<cffunction name="getOrder" access="public" hint="I get the order object that filters the query that backs this iterator" output="false" returntype="reactor.query.order">
		<cfset reset() />
		<cfreturn getQueryObject().getOrder() />
	</cffunction>
	
	<!--- gateway --->
    <cffunction name="setGateway" access="public" output="false" returntype="void">
       <cfargument name="gateway" hint="I am the gateway object used to query the DB." required="yes" type="reactor.base.abstractGateway" />
       <cfset variables.gateway = arguments.gateway />
    </cffunction>
    <cffunction name="getGateway" access="public" output="false" returntype="reactor.base.abstractGateway">
       <cfreturn variables.gateway />
    </cffunction>
	
	<!--- queryObject --->
    <cffunction name="setQueryObject" access="private" output="false" returntype="void">
       <cfargument name="queryObject" hint="I am the OO query being managed by this iterator" required="yes" type="reactor.query.query" />
       <cfset variables.queryObject = arguments.queryObject />
    </cffunction>
    <cffunction name="getQueryObject" access="private" output="false" returntype="reactor.query.query">
       <cfreturn variables.queryObject />
    </cffunction>
	
	<!--- query --->
    <cffunction name="getQuery" access="public" output="false" returntype="query">
		<cfset var x = 0 />
		<cfset var To = 0 />
		<cfset var column = 0 />
		
		<cfif NOT IsQuery(variables.query)>
			<cfset variables.query = getGateway().getByQuery(getQueryObject()) />
		</cfif>
		
		<cfreturn variables.query />
    </cffunction>
	
	<!--- name --->
    <cffunction name="setName" access="private" output="false" returntype="void">
       <cfargument name="name" hint="I am the name of the object this iterator encapsulates" required="yes" type="string" />
       <cfset variables.name = arguments.name />
    </cffunction>
    <cffunction name="getName" access="private" output="false" returntype="string">
       <cfreturn variables.name />
    </cffunction>
	
	<!--- reactorFactory --->
    <cffunction name="setReactorFactory" access="private" output="false" returntype="void">
       <cfargument name="reactorFactory" hint="I am the ReactorFactory" required="yes" type="reactor.ReactorFactory" />
       <cfset variables.reactorFactory = arguments.reactorFactory />
    </cffunction>
    <cffunction name="getReactorFactory" access="private" output="false" returntype="reactor.ReactorFactory">
       <cfreturn variables.reactorFactory />
    </cffunction>
		
</cfcomponent>

<!---


	<!---<cfset variables.deleteConditions = ArrayNew(1) />
	<cfset variables.newRecords = ArrayNew(1) />--->

<!--- delete --->
	<cffunction name="delete" access="public" hint="I delete matching items from the collection" output="false" returntype="void">
		<cfset var item = 0 />
		<cfset var Where = getWhere() />
		
		<!--- this method essentially caches an array of the conditions underwhich to delete records. --->
		<cfset ArrayAppend(variables.deleteConditions, arguments) />
		
	</cffunction>
		
	<!--- new --->
	<cffunction name="new" access="public" hint="I create a new record in this collection and return it." output="false" returntype="reactor.base.abstractRecord">
		<cfset var Record = getReactorFactory().createRecord(getName()) />
		<cfset ArrayAppend(variables.newRecords, Record) />
		<cfset reset() />
		<cfreturn Record />
	</cffunction>
	
	<!--- save --->
	<cffunction name="save" access="public" hint="I save the collection" output="false" returntype="void">
		<cfset var item = 0 />
		<cfset var To = 0 />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(variables.newRecords)#" index="x">
			<cfset To = variables.newRecords[x]._getTo() />

			<!--- set the FK values --->
			<cfloop collection="#arguments#" item="item">
				<cfset To[item] = arguments[item] />
 			</cfloop>
			
			<!--- save this object --->
			<cfset variables.newRecords[x].save() />
		</cfloop>
 	</cffunction>

--->