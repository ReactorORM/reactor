<cfcomponent displayname="Iterator" hint="I represent an iteratable collection.">
	
	<cfset variables.ReactorFactory = 0 />
	<cfset variables.name = 0 />
 	<cfset variables.Gateway = 0 />
	<cfset variables.QueryObject = 0 />
	
	<cfset variables.query = 0/>
	<cfset variables.array = 0 />
	<cfset variables.index = 0 />
	
	<cffunction name="init" access="public" hint="I configure and return the iterator" output="false" returntype="Iterator">
		<cfargument name="ReactorFactory" hint="I am the gateway object used to query the DB." required="yes" type="reactor.reactorFactory" />
		<cfargument name="name" hint="I am the gateway object used to query the DB." required="yes" type="string" />
		<cfargument name="join" hint="I am the name of an optional object to join." required="no" default="" type="string" />
				
		<cfset setReactorFactory(arguments.ReactorFactory) />
		<cfset setName(arguments.name) />
		<cfset setJoin(arguments.join) />
		<!--- create and set the gateway we'll use to execute queries --->		
		<cfset setGateway(getReactorFactory().createGateway(arguments.name)) />
		
		<!--- get the query object that will back this iterator --->
		<cfset setQueryObject(getGateway().createQuery()) />
		<!--- filter to only this object's fields --->
		<cfset getQueryObject().returnObjectFields(getName()) />
		
		<cfif Len(getJoin())>
			<cfset getQueryObject().join(getName(), getJoin()) />
		</cfif>
		
		<cfset reset() />
		
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
	
	<!--- query --->
    <cffunction name="getQuery" access="public" output="false" returntype="query">
		<cfargument name="from" hint="I am the first row to return." required="no" type="numeric" default="0" />
		<cfargument name="count" hint="I am the maximum number of indexes to return." required="no" type="numeric" default="0" />
		<cfset var x = 0 />
		<cfset var To = 0 />
		<cfset var column = 0 />
		<cfset var querysubset = 0 />
		
		<cfif NOT IsQuery(variables.query)>
			<cfset variables.query = getGateway().getByQuery(getQueryObject()) />
		</cfif>
		
		<!--- check to see if we're limiting the records that can be returned. --->
		<cfif arguments.from AND arguments.count>
			<cfset querysubset = QueryNew(variables.query.columnList) />
				
			<cfloop query="variables.query" startrow="#arguments.from#" endrow="#arguments.from + arguments.count - 1#">
				<cfset QueryAddRow(querysubset) />
				
				<cfloop list="#variables.query.columnList#" index="column">
					<cfset querysubset[column][querysubset.recordcount] = variables.query[column][variables.query.currentRow] />
				</cfloop>
			</cfloop>
				
			<cfreturn querysubset/>			
		<cfelse>
			<cfreturn variables.query />
		</cfif>
		
		
    </cffunction>
	
	<!--- getArray --->
	<cffunction name="getArray" access="public" hint="I return an array of objects in the iterator" output="false" returntype="array">
		<cfargument name="from" hint="I am the first index to return." required="no" type="numeric" default="0" />
		<cfargument name="count" hint="I am the maximum number of indexes to return." required="no" type="numeric" default="0" />
		
		<cfif NOT IsArray(variables.array) AND NOT (arguments.from AND arguments.count)>
			<cfset variables.array = queryRecords(getQuery()) />
		
		<cfelseif arguments.from AND arguments.count>
			<cfreturn queryRecords(getQuery(arguments.from, arguments.count)) />

		</cfif>
		
		<cfreturn variables.array />
	</cffunction>
	
	<!--- queryRecords --->
	<cffunction name="queryRecords" access="private" hint="I translate a query to an array of records" output="false" returntype="array">
		<cfargument name="query" hint="I am the query to translate." required="yes" type="query" />
		<cfset var Array = ArrayNew(1) />
		<cfset var Record = 0 />
		<cfset var To = 0 />
		<cfset var field = "" />
		
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
		
		<cfreturn Array />		
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
	<cffunction name="getOrder" access="public" hint="I get the order object that sorts the query that backs this iterator" output="false" returntype="reactor.query.order">
		<cfset reset() />
		<cfreturn getQueryObject().getOrder() />
	</cffunction>
	
	<!--- resetOrder --->
	<cffunction name="resetOrder" access="public" hint="I reset the order object that sorts the query that backs this iterator" output="false" returntype="void">
		<cfset reset() />
		<cfset getQueryObject().resetOrder() />
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
	
	<!--- name --->
    <cffunction name="setName" access="private" output="false" returntype="void">
       <cfargument name="name" hint="I am the name of the object this iterator encapsulates" required="yes" type="string" />
       <cfset variables.name = arguments.name />
    </cffunction>
    <cffunction name="getName" access="private" output="false" returntype="string">
       <cfreturn variables.name />
    </cffunction>
	
	<!--- join --->
    <cffunction name="setJoin" access="private" output="false" returntype="void">
       <cfargument name="join" hint="I am the name of an optional object to join" required="yes" type="string" />
       <cfset variables.join = arguments.join />
    </cffunction>
    <cffunction name="getJoin" access="private" output="false" returntype="string">
       <cfreturn variables.join />
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