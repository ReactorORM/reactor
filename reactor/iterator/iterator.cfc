<cfcomponent displayname="Iterator" hint="I represent an iteratable collection.">
	
	<cfset variables.ReactorFactory = 0 />
	<cfset variables.name = 0 />
 	<cfset variables.Gateway = 0 />
	<cfset variables.QueryObject = 0 />

	<cfset variables.Dictionary = 0 />
	
	<cfset variables.query = 0/>
	<cfset variables.array = ArrayNew(1) />
	<cfset variables.index = 0 />
	
	<cfset variables.parent = 0 />
	
	<cffunction name="init" access="public" hint="I configure and return the iterator" output="false" returntype="Iterator">
		<cfargument name="ReactorFactory" hint="I am the reactor factor." required="yes" type="reactor.reactorFactory" />
		<cfargument name="alias" hint="I am the alias of the type of data being iterated." required="yes" type="string" />
		<cfargument name="joinList" hint="I am comma delimited list of optional object to join." required="no" default="" type="string" />
		<cfset var joinTo = 0 />
		<cfset var joinFrom = 0 />
		<cfset var joins = 0 />
		<cfset var x = 0 />
		
		<cfset setReactorFactory(arguments.ReactorFactory) />
		<cfset setAlias(arguments.alias) />
		<!--- create and set the gateway we'll use to execute queries --->		
		<cfset setGateway(getReactorFactory().createGateway(arguments.alias)) />
		
		<!--- get the query object that will back this iterator --->
		<cfset setQueryObject(getGateway().createQuery()) />
		<!--- filter to only this object's fields --->
		<cfset getQueryObject().returnObjectFields(getAlias()) />
		
		<cfset joins = ListToArray(joinList) />
		<cfset joinFrom = getAlias() />
		
		<cfif Len(arguments.joinList)>
			<cfloop from="#ArrayLen(joins)#" to="1" index="x" step="-1">
				<cfset joinTo = joins[x] />
				<cfset getQueryObject().join(joinFrom, joinTo) />
				<cfset joinFrom = joinTo />
			</cfloop>
		</cfif>
		
		<cfreturn this />
	</cffunction>
	
	<!--- getAt --->
	<cffunction name="getAt" access="public" hint="I return a specific element based on it's index." output="false" returntype="reactor.base.abstractRecord">
		<cfargument name="index" hint="I am the index of the record to get." required="yes" type="numeric" />
		<cfset var Array = get(arguments.index) />
		
		<cfreturn Array[1] />
	</cffunction>
		
	<!--- get --->
	<cffunction name="get" access="public" hint="I return an array of matching objects from the iterator.  I do not impact the state of the object.  Pass either an index for a specific item or a name/value list for matching records." output="false" returntype="array">
		<cfset var fieldList = StructKeyList(arguments) />
		<cfset var Records = 0 />
		<cfset var Array = ArrayNew(1) />
		<cfset var indexArray = ArrayNew(1) />
		<cfset var x = 0 />
		
		<cfif NOT StructCount(arguments)>
			<!--- nothing was provided, throw an error --->
			<cfthrow message="No Arguments" detail="No arguments were passed to the get method. Pass either an index for a specific item or a name/value list for matching records." type="reactor.iterator.get.NoArguments" />

		<cfelseif fieldList IS 1>
			<!--- an index was passed --->
			<cfset Array = getArray(arguments[1], 1) />
		
		<cfelseif fieldList IS NOT 1>
			<!--- a set of name/value pairs were passed in.  get the matching indexes --->
			<cfinvoke component="#this#" method="findMatchingIndexes" argumentcollection="#arguments#" returnvariable="indexArray" />
			
			<!--- get the array of existing records --->
			<cfset Records = getArray() />
			
			<!--- get all the specified indexes and return them --->
			<cfloop from="1" to="#ArrayLen(indexArray)#" index="x">
				<cfset ArrayAppend(Array, Records[indexArray[x]]) />
			</cfloop>
		</cfif>
		
		<!--- return the matches --->
		<cfreturn Array />
	</cffunction>
	
	<!--- findMatchingIndexes --->
	<cffunction name="findMatchingIndexes" access="package" hint="I return an array of the indexes of items which match provided argumetns." output="false" returntype="array">
		<cfset var fieldList = StructKeyList(arguments) />
		<cfset var Records = 0 />
		<cfset var field = 0 />
		<cfset var To = 0 />
		<cfset var match = 0 />
		<cfset var indexArray = ArrayNew(1) />
		<cfset var x = 0 />
		
		<!--- loop over the query to find matching items --->
		<cfset Records = getArray() />
		<cfloop from="1" to="#ArrayLen(Records)#" index="x">
			<!--- assume this is a match (it's easier this way) --->
			<cfset match = true />
			<!--- loop over the fields we're commaring and check to insure they DO match.  if not, it's not a match --->
			<cfloop list="#fieldList#" index="field">
				<!--- check the to of the object to see if the value is the same as the desired value --->
				<cfset To = Records[x]._getTo() />

				<cfif To[field] IS NOT arguments[field]>
					<cfset match = false />
					<cfbreak />
				</cfif>
			</cfloop>
			<!--- if this is a match make not of the index --->
			<cfif match>
				<cfset ArrayAppend(indexArray, x) />
			</cfif>
		</cfloop>
		
		<cfreturn indexArray />
	</cffunction>
	
	<!--- remove --->
	<cffunction name="remove" access="public" hint="I remove matching elements from the iterator.  I do not delete the removed records. Pass either an index for a specific item or a name/value list for matching records." output="false" returntype="any">
		<cfset var fieldList = StructKeyList(arguments) />
		<cfset var Record = 0 />
		<cfset var indexArray = 0 />
		<cfset var Records = 0 />
		
		<cfif NOT StructCount(arguments)>
			<!--- nothing was provided, throw an error --->
			<cfthrow message="No Arguments" detail="No arguments were passed to the delete method. Pass either an index for a specific item or a name/value list for matching records." type="reactor.iterator.delete.NoArguments" />

		<cfelseif fieldList IS 1 AND NOT IsObject(arguments[1])>
			<!--- an index was passed --->
			<!--- delete the index --->
			<cfset ArrayDeleteAt(variables.array, arguments[1]) />
		
		<cfelseif fieldList IS 1 AND IsObject(arguments[1])>
			<!--- an instance of a record was passed in! Find it's index --->
			<cfset Records = getArray() />
			
			<cfloop from="1" to="#ArrayLen(Records)#" index="x">
				<cfif Records[x]._getInstanceId() IS arguments[1]._getInstanceId() >
					<!--- remove the record --->
					<cfset remove(x) />
					<cfbreak />
				</cfif>
			</cfloop>
			
		<cfelseif fieldList IS NOT 1>
			<!--- a set of name/value pairs were passed in.  get the matching indexes --->
			<cfinvoke component="#this#" method="findMatchingIndexes" argumentcollection="#arguments#" returnvariable="indexArray" />
			
			<!--- sort and reverse the array (so we don't get errors when deleting multiple items and the length of the array changes --->
			<cfset ArraySort(indexArray, "Numeric", "desc") />
			
			<!--- get all the specified indexes and return them --->
			<cfloop from="1" to="#ArrayLen(indexArray)#" index="x">
				<!--- remove the record --->
				<cfset remove(indexArray[x]) />
			</cfloop>
			
		</cfif>
	</cffunction>
	
	<!--- removeAll --->
	<cffunction name="removeAll" access="public" hint="I remove all elements in this iterator" output="false" returntype="void">
		<cfset var Array = getArray() />
		<cfset var x = 0 />
		
		<cfloop from="#ArrayLen(Array)#" to="1" index="x" step="-1">
			<cfset remove(x) />
		</cfloop>
	</cffunction>
	
	<!--- deleteAll --->
	<cffunction name="deleteAll" access="public" hint="I delete all elements in this iterator" output="false" returntype="void">
		<cfset var Array = getArray() />
		<cfset var x = 0 />
		
		<cfloop from="#ArrayLen(Array)#" to="1" index="x" step="-1">
			<cfset delete(x) />
		</cfloop>
	</cffunction>
	
	<!--- delete --->
	<cffunction name="delete" access="public" hint="I delete matching elements in the iterator. Pass either an index for a specific item or a name/value list for matching records." output="false" returntype="any">
		<cfset var fieldList = StructKeyList(arguments) />
		<cfset var Record = 0 />
		<cfset var indexArray = 0 />
		<cfset var Records = 0 />
		
		<cfif NOT StructCount(arguments)>
			<!--- nothing was provided, throw an error --->
			<cfthrow message="No Arguments" detail="No arguments were passed to the delete method. Pass either an index for a specific item or a name/value list for matching records." type="reactor.iterator.delete.NoArguments" />

		<cfelseif fieldList IS 1 AND NOT IsObject(arguments[1])>
			<!--- an index was passed --->
			<!--- get the record at the index --->
			<cfset Record = getAt(arguments[1], 1) />
			<!--- delete the index --->
			<cfset ArrayDeleteAt(variables.array, arguments[1]) />
			<!--- delete the record --->
			<cfset Record.delete() />
		
		<cfelseif fieldList IS 1 AND IsObject(arguments[1])>
			<!--- an instance of a record was passed in! --->
			<cfset remove(arguments[1]) />
			<cfset arguments[1].delete() />			
				
		<cfelseif fieldList IS NOT 1>
			<!--- a set of name/value pairs were passed in.  get the matching indexes --->
			<cfinvoke component="#this#" method="findMatchingIndexes" argumentcollection="#arguments#" returnvariable="indexArray" />
			
			<!--- sort and reverse the array (so we don't get errors when deleting multiple items and the length of the array changes --->
			<cfset ArraySort(indexArray, "Numeric", "desc") />
			
			<!--- get all the specified indexes and return them --->
			<cfloop from="1" to="#ArrayLen(indexArray)#" index="x">
				<!--- delete the record --->
				<cfset delete(indexArray[x]) />
			</cfloop>
			
		</cfif>
	</cffunction>
	
	<!--- getDictionary --->
	<cffunction name="getDictionary" access="public" hint="I return a dictionary for the type of object being iterated." output="false" returntype="reactor.dictionary.dictionary">
		<cfif NOT IsObject(variables.Dictionary)>
			<cfset variables.Dictionary = getReactorFactory().createDictionary(getAlias()) />
		</cfif>
		
		<cfreturn variables.Dictionary />
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
		<cfset var array = 0 />
		<cfif NOT hasMore()>
			<cfthrow message="No More Records" detail="There are no more records in the iterator." type="reactor.iterator.NoMoreRecords" />
		</cfif>
		<!--- incrament the iterator --->
		<cfset variables.index = variables.index + 1 />
		
		<cfset array = get(variables.index) />
		
		<cfreturn array[1] />
	</cffunction>
	
	<!--- getValueList --->
	<cffunction name="getValueList" access="public" hint="I return a value list based on a specific field." output="false" returntype="string">
		<cfargument name="field" hint="I am the name of the field to get the value list for" required="yes" type="string" />
		<cfargument name="delimiter" hint="I am the delimiter to use for the list.  I default to ','." required="no" type="string" default="," />
		<cfset var query = getQuery() />
		<cfset var list = Evaluate("ValueList(query.#arguments.field#, arguments.delimiter)") />
		<cfthrow detail="I'm not returning the OBJECT's data!!!" />
		<cfreturn list />
	</cffunction>
	
	<!--- save --->
	<cffunction name="save" access="public" hint="I save any records in this iterator which are loaded and are dirty (have been changed)" output="false" returntype="void">
		<cfset var x = 0 />
		
		<!--- loop over all the records that have been loaded and changed and save them --->
		<cfloop from="1" to="#ArrayLen(variables.array)#" index="x">
			<cfif IsObject(variables.array[x]) AND variables.array[x].isDirty()>
				<cfset variables.array[x].save() />
			</cfif>
		</cfloop>
		
	</cffunction>
	
	<!--- relateTo --->
	<cffunction name="relateTo" access="public" hint="This is for Reactor use only.  I recieve a record object and use the metadata in that object to populate the values of any loaded records that are dirty." output="false" returntype="void">
		<cfargument name="Record" hint="I am the record to relate to." required="yes" type="reactor.base.abstractRecord" />
		<cfset var relationship = arguments.Record._getObjectMetadata().getRelationship(getAlias()) />
		<cfset var value = 0 />
		<cfset var x = 0 />
		<cfset var y = 0 />
				
		<cfloop from="1" to="#ArrayLen(relationship.relate)#" index="x">
			<!--- get the value from the record  --->
			<cfinvoke component="#arguments.Record#" method="get#relationship.relate[x].from#" returnvariable="value" />
			
			<!--- loop over the array of loaded records and set the value --->
			<cfloop from="1" to="#ArrayLen(variables.array)#" index="y">
				<cfif IsObject(variables.array[x]) AND variables.array[y].isDirty()>
					
					<!--- set the value into the child objects --->
					<cfinvoke component="#variables.array[y]#" method="set#relationship.relate[x].to#">
						<cfinvokeargument name="#relationship.relate[x].to#" value="#value#" />
					</cfinvoke>
				</cfif>
			</cfloop>
		</cfloop>
	</cffunction>
	
	<!--- add --->
	<cffunction name="add" access="public" hint="I add another element to the END of this iterator.  The iterator must be saved before this will be sorted." output="false" returntype="reactor.base.abstractRecord">
		<cfset var fieldList = StructKeyList(arguments) />
		<cfset var Record = 0 />
		<cfset var relationship = 0 />
		<cfset var value = 0 />
		
		<cfif NOT StructCount(arguments)>
			<!--- if nothing was provided then create a new record --->
			<cfset Record = getReactorFactory().createRecord(getAlias()) />
			
		<cfelseif fieldList IS 1>
			<!--- a record has been passed in.  make sure it's the correct type --->
			<cfset Record = arguments[fieldList] />
			
			<!--- confirm that the record is the correct type --->
			<cftry>
				<cfif Record._getObjectMetadata().getAlias() IS NOT getAlias()>
					<cfthrow message="Argument Is Not #getAlias()# Record" detail="The value passed to the add method is not a #getAlias()# record." type="reactor.iterator.add.ArgumentIsNotCorrectRecord" />
				</cfif>
				<cfcatch type="Object">
					<cfthrow message="Argument Is Not Record" detail="The value passed to the add method is not a record." type="reactor.iterator.add.ArgumentIsNotRecord" />
				</cfcatch>
			</cftry>
		
		<cfelseif fieldList IS NOT 1>
			<!--- load a record based on the provided values --->
			<cfset Record = getReactorFactory().createRecord(getAlias()) />
			
			<!--- populate the record --->
			<cfloop collection="#arguments#" item="item">
				<cfinvoke component="#Record#" method="set#item#">
					<cfinvokeargument name="#item#" value="#arguments[item]#" />
				</cfinvoke>
			</cfloop>
			
			<!--- load the record --->
			<cfset Record.load() />
			
		</cfif>
		
		<!--- look up how this record is related to the iterator's parent --->
		<cfset relationship = getParent()._getObjectMetadata().getRelationship(getAlias()) />
		
		<cfloop from="1" to="#ArrayLen(relationship.relate)#" index="x">
			<!--- get this value from the parent for this relationship --->
			<cfinvoke component="#getParent()#" method="get#relationship.relate[x].from#" returnvariable="value" />
			
			<!--- set this value into the new record --->
			<cfinvoke component="#Record#" method="set#relationship.relate[x].to#">
				<cfinvokeargument name="#relationship.relate[x].to#" value="#value#" />
			</cfinvoke>
		</cfloop>
		
		<!--- set this record's parent --->
		<cfset Record.setParent(this) />
		
		<!--- add the new record to the array of records --->
		<cfset ArrayAppend(variables.array, Record) />
		
		<cfreturn Record />	
	</cffunction>
	
	<!--- populate --->
	<cffunction name="populate" access="public" hint="I populate this object with data if it's not already populated." output="false" returntype="void">
		<cfif NOT IsQuery(variables.query)>
			<cfset variables.query = getGateway().getByQuery(getQueryObject(), false) />

			<cfif variables.query.recordCount GT 0>
				<cfset ArraySet(variables.array, 1, variables.query.recordCount, "") />
			</cfif>
		</cfif>
	</cffunction>
	
	<!--- getArray --->
	<cffunction name="getArray" access="public" hint="I return an array of objects in the iterator" output="false" returntype="array">
		<cfargument name="from" hint="I am the first index to return." required="no" type="numeric" default="1" />
		<cfargument name="count" hint="I am the maximum number of indexes to return." required="no" type="numeric" default="-1" />
		<cfset var x = 0 />
		<cfset var returnArray = ArrayNew(1) />
		
		<!--- populate this object --->
		<cfset populate() />
		
		<!--- if arguments.count is -1 then we need to set the upper bounds of the loop.  We couldn't do this initially because we only now know for sure that data was loaded --->
		<cfif arguments.count IS -1>
			<cfset arguments.count = ArrayLen(variables.array) />
		</cfif>
				
		<!--- make sure that all of the requested objects have been loaded --->
		<cfloop from="#arguments.from#" to="#arguments.from + arguments.count - 1#" index="x">
			<cfif NOT IsObject(variables.array[x])>
				<cfset variables.array[x] = loadRecord(x) />
			</cfif>
			
			<!--- add this into the array we're returning --->
			<cfset ArrayAppend(returnArray, variables.array[x]) />
		</cfloop>
		
		<!--- return the requested array! --->
		<cfreturn returnArray />
	</cffunction>
	
	<cffunction name="dumpArray">
		<cfdump var="#variables.array#" />
	</cffunction>
	
	<!--- loadRecord --->
	<cffunction name="loadRecord" access="public" hint="I load a specific record based on the query backing the iterator" output="false" returntype="reactor.base.abstractRecord">
		<cfargument name="index" hint="I am the index of the row in the query which we will use to load this object" required="yes" type="numeric" />
		<cfset var Record = getReactorFactory().createRecord(getAlias()) />
		<cfset var To = Record._getTo() />
		<cfset var column = 0 />
		
		<!--- loop over the columns in the query and set all the values into the TO for this record--->
		<cfloop list="#variables.query.columnList#" index="column">
			<!--- set the value of this column into the record's to --->
			<cfset To[column] = variables.query[column][arguments.index] />
		</cfloop>
		
		<!--- because we manually set the state of the record we need to clean it so that isDirty doesn't return true --->
		<cfset Record.clean() />
		
		<!--- set this iterator as the record's parent --->
		<cfset Record.setParent(this) />
		
		<!--- return this squeaky clean record --->
		<cfreturn Record />
	</cffunction>
	
	<!--- query --->
    <cffunction name="getQuery" access="public" output="false" returntype="query">
		<cfargument name="from" hint="I am the first row to return." required="no" type="numeric" default="1" />
		<cfargument name="count" hint="I am the maximum number of indexes to return." required="no" type="numeric" default="-1" />
		<cfset var array = getArray(arguments.from, arguments.count) />
		<cfset var query = QueryNew(variables.query.columnList) />
		<cfset var x = 0 />
		<cfset var column = 0 />
		<cfset var To = 0 />
		
		<!--- loop over the objects and build the query --->
		<cfloop from="1" to="#ArrayLen(array)#" index="x">
			<!--- get this record's To --->
			<cfset To = array[x]._getTo() />
			
			<!--- add a row to the query --->
			<cfset QueryAddRow(query) />
			
			<!--- set the cell values --->
			<cfloop list="#query.columnList#" index="column">
				<!--- set the value of this column into the record's to --->
				<cfset QuerySetCell(query, column, To[column]) />
			</cfloop>
			
		</cfloop>
		
		<cfreturn query />		
    </cffunction>
	
	<!--- queryRecords --->
	<cffunction name="queryRecords" access="private" hint="I translate a query to an array of records" output="false" returntype="array">
		<cfargument name="query" hint="I am the query to translate." required="yes" type="query" />
		<cfset var Array = ArrayNew(1) />
		<cfset var Record = 0 />
		<cfset var To = 0 />
		<cfset var field = "" />
		
		<cfloop query="Query">
			<cfset Record = getReactorFactory().createRecord(getAlias()) >
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
		<cfset variables.array = ArrayNew(1) />
		<cfset variables.index = 0 />
	</cffunction>
	
	<!--- getWhere --->
	<cffunction name="getWhere" access="public" hint="I get the where object that filters the query that backs this iterator" output="false" returntype="reactor.query.where">
		<cfif NOT IsQuery(variables.query)>
			<cfreturn getQueryObject().getWhere() />
		<cfelse>
			<cfthrow message="Can Not Get Where"
				detail="Calls to getWhere are not allowed after getting an iterators query or array data.  You must call reset first, which reset any changes you have made to objects in the iterator."
				type="reactor.iterator.getWhere.CanNotGetWhere" />
		</cfif>
	</cffunction>
	
	<!--- setDistinct --->
	<cffunction name="setDistinct" access="public" hint="I filter the query that backs this iterator to return only distinct values." output="false" returntype="void">
		<cfargument name="distinct" hint="I indicate if the query should only return distinct matches" required="yes" type="boolean" />
		<cfif NOT IsQuery(variables.query)>
			<cfreturn getQueryObject().setDistinct(arguments.distinct) />
		<cfelse>
			<cfthrow message="Can Not Set Distinct"
				detail="Calls to setDistinct are not allowed after getting an iterators query or array data.  You must call reset first, which reset any changes you have made to objects in the iterator."
				type="reactor.iterator.setDistinct.CanNotSetDistinct" />
		</cfif>
	</cffunction>
		
	<!--- getOrder --->
	<cffunction name="getOrder" access="public" hint="I get the order object that sorts the query that backs this iterator" output="false" returntype="reactor.query.order">
		<cfif NOT IsQuery(variables.query)>
			<cfreturn getQueryObject().getOrder() />
		<cfelse>
			<cfthrow message="Can Not Get Order"
				detail="Calls to getOrder are not allowed after getting an iterators query or array data.  You must call reset first, which reset any changes you have made to objects in the iterator."
				type="reactor.iterator.getOrder.CanNotGetOrder" />
		</cfif>
	</cffunction>
	
	<!--- resetOrder --->
	<cffunction name="resetOrder" access="public" hint="I reset the order object that sorts the query that backs this iterator" output="false" returntype="void">
		<cfif NOT IsQuery(variables.query)>
			<cfset getQueryObject().resetOrder() />
		<cfelse>
			<cfthrow message="Can Not Reset Order"
				detail="Calls to resetOrder are not allowed after getting an iterators query or array data.  You must call reset first, which reset any changes you have made to objects in the iterator."
				type="reactor.iterator.resetOrder.CanNotResetOrder" />
		</cfif>
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
    <cffunction name="setAlias" access="private" output="false" returntype="void">
       <cfargument name="name" hint="I am the name of the object this iterator encapsulates" required="yes" type="string" />
       <cfset variables.name = arguments.name />
    </cffunction>
    <cffunction name="getAlias" access="public" output="false" returntype="string">
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
		
	<!--- parent --->
    <cffunction name="setParent" hint="I set this record's parent.  This is for Reactor's use only.  Don't set this value.  If you set it you'll get errrors!  Don't say you weren't warned." access="public" output="false" returntype="void">
       <cfargument name="parent" hint="I am the object which loaded this record" required="yes" type="any" />
       <cfset variables.parent = arguments.parent />
    </cffunction>
    <cffunction name="getParent" hint="I get this record's parent.  Call hasParent before calling me in case this record doesn't have a parent." access="public" output="false" returntype="any">
       <cfreturn variables.parent />
    </cffunction>
	<cffunction name="hasParent" access="public" hint="I indicate if this object has a parent." output="false" returntype="boolean">
		<cfreturn IsObject(variables.parent) />
	</cffunction>
	<cffunction name="resetParent" access="public" hint="I remove the reference to a parent object." output="false" returntype="void">
		<cfset variables.parent = 0 />
	</cffunction>
</cfcomponent>