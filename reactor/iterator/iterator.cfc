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
	<cfset variables.relationshipAlias = "" />
	<cfset variables.linked = 0 />
	<cfset variables.linkedThrough = 0 />

	<!--- init --->
	<cffunction name="init" access="public" hint="I configure and return the iterator" output="false" returntype="any" _returntype="Iterator">
		<cfargument name="ReactorFactory" hint="I am the reactor factor." required="yes" type="any" _type="reactor.reactorFactory" />
		<cfargument name="alias" hint="I am the alias of the type of data being iterated." required="yes" type="any" _type="string" />

		<cfset setReactorFactory(arguments.ReactorFactory) />
		<cfset setAlias(arguments.alias) />
		<!--- create and set the gateway we'll use to execute queries --->
		<cfset setGateway(getReactorFactory().createGateway(arguments.alias)) />

		<!--- get the query object that will back this iterator --->
		<cfset setQueryObject(getGateway().createQuery()) />
		<!--- filter to only this object's fields --->
		<cfset getQueryObject().returnObjectFields(getAlias()) />

		<cfreturn this />
	</cffunction>

	<!--- sizeTo --->
	<cffunction name="sizeTo" access="public" hint="I set the minimum number of items in the iterator." output="false" returntype="void">
		<cfargument name="length" hint="I am the minimum number of items in the iterator." required="yes" type="any" _type="numeric" />
		<cfset var x = 0 />

		<cfloop from="#getRecordCount()+1#" to="#arguments.length#" index="x">
			<cfset add() />
		</cfloop>
	</cffunction>

	<!--- getAt --->
	<cffunction name="getAt" access="public" hint="I return a specific element based on it's index." output="false" returntype="any" _returntype="reactor.base.abstractRecord">
		<cfargument name="index" hint="I am the index of the record to get." required="yes" type="any" _type="numeric" />
		<cfset var Array = get(arguments.index) />

		<cfreturn Array[1] />
	</cffunction>

	<!--- get --->
	<cffunction name="get" access="public" hint="I return an array of matching objects from the iterator.  I do not impact the state of the object.  Pass either an index for a specific item or a name/value list for matching records." output="false" returntype="any" _returntype="array">
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

			<cfif ArrayLen(indexArray)>
				<cfloop from="1" to="#ArrayLen(indexArray)#" index="x">
					<cfset ArrayAppend(Array, Records[indexArray[x]]) />
				</cfloop>
			</cfif>
		</cfif>

		<!--- return the matches --->
		<cfreturn Array />
	</cffunction>

	<!--- findMatchingIndexes --->
	<cffunction name="findMatchingIndexes" access="package" hint="I return an array of the indexes of items which match provided arguments." output="false" returntype="any" _returntype="array">
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

	<!--- isDirty --->
	<cffunction name="isDirty" access="public" hint="I indicate if there are any records in this iterator that are dirty." output="false" returntype="any" _returntype="boolean">
		<cfset var array = getArray() />
		<cfset var x = 0 />

		<!--- loop over all the records that have been loaded and changed and save them --->
		<cfloop from="1" to="#ArrayLen(array)#" index="x">
			<cfif IsObject(array[x]) AND array[x].isDirty()>
				<cfreturn true />
			</cfif>
		</cfloop>

		<cfreturn false />
	</cffunction>

	<!--- delete --->
	<cffunction name="delete" access="public" hint="I delete matching elements in the iterator. Pass either an index for a specific item, a name/value list for matching records or an instance of an object." output="false" returntype="any" _returntype="any">
		<cfset var fieldList = StructKeyList(arguments) />
		<cfset var Record = 0 />
		<cfset var indexArray = 0 />
		<cfset var Records = 0 />
		<cfset var x = 0 />
		<cfset var field = "" />
		<cfset var To = "" />
		<cfset var useTransaction = true />
		<cfset var newArgs = StructNew() />
				
		<!--- this is a bit of a hack to manage deleting in a manual transaction --->
		<cfif StructKeyExists(arguments, "useTransaction")>
			<cfset useTransaction = arguments.useTransaction />
			<cfset structDelete(arguments, "useTransaction") />
			<cfset fieldList = ListDeleteAt(fieldList, ListFindNoCase(fieldList, "useTransaction")) />
		</cfif>
		
		<cfif NOT StructCount(arguments)>
			<!--- nothing was provided, throw an error --->
			<cfthrow message="No Arguments" detail="No arguments were passed to the delete method. Pass either an index for a specific item or a name/value list for matching records." type="reactor.iterator.delete.NoArguments" />

		<cfelseif fieldList IS 1 AND NOT IsObject(arguments[1])>
			<!--- an index was passed --->
			<!--- get the record at the index --->
			<cfset Record = getAt(arguments[1], 1) />

			<!--- check to see if we're a linking relationship --->
			<cfif getLinked()>
				<!--- this obeject is in a linked iterator.  we need to delete the object that acts as the midpoint between the parent and this object being deleted --->
				<cfset Record._getParent().delete(useTransaction=useTransaction) />
			<cfelse>
				<!--- delete the record --->
				<cfset Record.delete(useTransaction=useTransaction) />
			</cfif>

		<cfelseif (fieldList IS 1 AND IsObject(arguments[1])) OR (fieldList IS "record" AND IsObject(arguments["record"]))> 
			<!--- an object was passed in either without a name for the argument or the argument name is record and the value is an object (messy, sorry) --->
			<!--- get the object passed in --->
			<cfif fieldList IS 1>
				<cfset Record = arguments[1] />
			<cfelse>
				<cfset Record = arguments["record"] />
			</cfif>
			
			<!--- make sure this object is of the correct type --->
			<cftry>
				<cfif Record._getAlias() IS NOT getAlias()>
					<cfthrow message="Object Not Correct Record"
						detail="The object passed into the delete method is not a #getAlias()# Record and can't be deleted from this iterator."
						type="reactor.iterator.delete.ObjectNotCorrectRecord" />
				</cfif>
				<cfcatch type="object">
					<cfthrow message="Object Not A Record"
						detail="The object passed into the delete method is not a reactor Record and ca't be deleted."
						type="reactor.iterator.delete.ObjectNotARecord" />
				</cfcatch>
				<cfcatch>
					<cfrethrow />
				</cfcatch>
			</cftry>

			<!--- check to see if we're a linking relationship --->
			<cfif getLinked()>
				<!--- make sure that we've loaded the record into the iterator before we try to unlink it --->
				<cfset fieldList = Record._getObjectMetadata().getFieldList() />
				<cfset To = Record._getTo() />

				<cfinvoke method="get" returnvariable="Record">
					<cfloop list="#fieldList#" index="field">
						<cfinvokeargument name="#field#" value="#To[field]#" />
					</cfloop>
				</cfinvoke>
				
				<!--- this object is in a linked iterator.  we need to delete the object that acts as the midpoint between the parent and this object being deleted --->
				<cfset Record[1]._getParent().delete(useTransaction=useTransaction) />
			<cfelse>
				<!--- delete the record --->
				<cfset Record.delete(useTransaction=useTransaction) />
			</cfif>

		<cfelseif fieldList IS NOT 1>
			<!--- name/value pairs were passed in --->
			
			<!--- a set of name/value pairs was passed in.  get the matching records --->
			<cfset Records = get(argumentCollection=arguments) />
			
			<cfloop from="1" to="#ArrayLen(Records)#" index="x">
				<cfset newArgs["1"] = Records[x] />
				<cfset newArgs["useTransaction"] = useTransaction />
				
				<cfinvoke method="delete">
					<cfinvokeargument name="record" value="#Records[x]#" />
					<cfinvokeargument name="useTransaction" value="#useTransaction#" />
				</cfinvoke>
			</cfloop>
		</cfif>

	</cffunction>

	<!--- deleteAll --->
	<cffunction name="deleteAll" access="public" hint="I delete all elements in this iterator" output="false" returntype="void">
		<cfargument name="useTransaction" hint="I indicate if this save should be executed within a transaction." required="no" type="any" _type="boolean" default="true" />
		<cfset var Array = getArray() />
		<cfset var x = 0 />
		<cfset var args = StructNew() />

		<cfloop from="#ArrayLen(Array)#" to="1" index="x" step="-1">
			<cfset args[1] = x />
			<cfset args["useTransaction"] = useTransaction />
			<cfset delete(argumentCollection=args) />
		</cfloop>
	</cffunction>

	<!--- getDictionary --->
	<cffunction name="getDictionary" access="public" hint="I return a dictionary for the type of object being iterated." output="false" returntype="any" _returntype="reactor.dictionary.dictionary">
		<cfif NOT IsObject(variables.Dictionary)>
			<cfset variables.Dictionary = getReactorFactory().createDictionary(getAlias()) />
		</cfif>

		<cfreturn variables.Dictionary />
	</cffunction>

	<!--- hasMore --->
	<cffunction name="hasMore" access="public" hint="I indicate if the iterator has more elements" output="false" returntype="any" _returntype="boolean">
		<cfreturn getIndex() LT getRecordCount() />
	</cffunction>

	<!--- index --->
    <cffunction name="setIndex" access="public" output="false" returntype="void">
       <cfargument name="index" hint="I am the iterator's index" required="yes" type="any" _type="numeric" />
       <cfset variables.index = arguments.index />
    </cffunction>
    <cffunction name="getIndex" access="public" output="false" returntype="any" _returntype="numeric">
       <cfreturn variables.index />
    </cffunction>
	
	<!--- getRecordCount --->
	<cffunction name="getRecordCount" access="public" hint="I get the iterator's recordcount" output="false" returntype="any" _returntype="numeric">
		<cfreturn getQuery().recordcount />
	</cffunction>

	<!--- getNext --->
	<cffunction name="getNext" access="public" hint="I get the next element from the iterator" output="false" returntype="any" _returntype="reactor.base.abstractRecord">
		<cfset var array = 0 />
		<cfif NOT hasMore()>
			<cfthrow message="No More Records" detail="There are no more records in the iterator." type="reactor.iterator.NoMoreRecords" />
		</cfif>
		<!--- incrament the iterator --->
		<cfset setIndex(getIndex() + 1) />

		<cfset array = get(getIndex()) />

		<cfreturn array[1] />
	</cffunction>

	<!--- getValueList --->
	<cffunction name="getValueList" access="public" hint="I return a value list based on a specific field." output="false" returntype="any" _returntype="string">
		<cfargument name="field" hint="I am the name of the field to get the value list for" required="yes" type="any" _type="string" />
		<cfargument name="delimiter" hint="I am the delimiter to use for the list.  I default to ','." required="no" type="any" _type="string" default="," />
		<cfset var query = getQuery() />
		<cfset var list = Evaluate("ValueList(query.#arguments.field#, arguments.delimiter)") />

		<cfreturn list />
	</cffunction>

	<!--- save --->
	<cffunction name="save" access="public" hint="I save any records in this iterator which are loaded and are dirty (have been changed)" output="false" returntype="void">
		<cfargument name="useTransaction" hint="I indicate if this save should be executed within a transaction." required="no" type="any" _type="boolean" default="true" />

		<cfif arguments.useTransaction>
			<cfset saveInTransaction() />
		<cfelse>
			<cfset executeSave() />
		</cfif>

	</cffunction>

	<!--- saveInTransaction --->
	<cffunction name="saveInTransaction" access="private" hint="I save the record in a transaction." output="false" returntype="void">
		<cftransaction>
			<cfset executeSave() />
		</cftransaction>
	</cffunction>

	<!--- executeSave --->
	<cffunction name="executeSave" access="private" hint="I actually save the record." output="false" returntype="void">
		<cfset var x = 0 />

		<!--- loop over all the records that have been loaded and changed and save them --->
		<cfloop from="1" to="#ArrayLen(variables.array)#" index="x">
			<cfif IsObject(variables.array[x]) AND NOT variables.array[x].isDeleted() AND variables.array[x].isDirty()>
				<cfset variables.array[x].save(useTransaction=false) />
			</cfif>
		</cfloop>
	</cffunction>

	<!--- validate --->
	<cffunction name="validate" access="public" hint="I loop over all records in this iterator which are not deleted and call their validate method." output="false" returntype="void">
		<cfset var x = 0 />

		<!--- loop over all the records that have been loaded and changed and save them --->
		<cfloop from="1" to="#ArrayLen(variables.array)#" index="x">
			<cfif IsObject(variables.array[x]) AND NOT variables.array[x].isDeleted()>
				<cfset variables.array[x].validate() />
			</cfif>
		</cfloop>
	</cffunction>

	<!--- validated --->
	<cffunction name="validated" access="public" hint="I loop over all records in this iterator which are not deleted and check to see if they're validated.  If any one is not then this returns false.  Unloaded records are ignored." output="false" returntype="any" _returntype="boolean">
		<cfset var x = 0 />

		<!--- loop over all the records that have been loaded and changed and save them --->
		<cfloop from="1" to="#ArrayLen(variables.array)#" index="x">
			<cfif IsObject(variables.array[x]) AND NOT variables.array[x].isDeleted() AND NOT variables.array[x].validated()>
				<cfreturn false />
			</cfif>
		</cfloop>

		<cfreturn true />
	</cffunction>

	<!--- hasErrors --->
	<cffunction name="hasErrors" access="public" hint="I loop over all records in this iterator which are not deleted and check to see if they have errors.  If any one has errors this returns true.  Unloaded records are ignored." output="false" returntype="any" _returntype="boolean">
		<cfset var x = 0 />

		<!--- loop over all the records that have been loaded and changed and save them --->
		<cfloop from="1" to="#ArrayLen(variables.array)#" index="x">
			<cfif IsObject(variables.array[x]) AND NOT variables.array[x].isDeleted() AND variables.array[x].validated() AND variables.array[x].hasErrors()>
				<cfreturn true />
			</cfif>
		</cfloop>

		<cfreturn false />
	</cffunction>

	<!--- relateTo --->
	<cffunction name="relateTo" access="public" hint="This is for Reactor use only.  I recieve a record object and use the metadata in that object to populate the values of any loaded records that are dirty." output="false" returntype="void">
		<cfargument name="Record" hint="I am the record to relate to." required="yes" type="any" _type="reactor.base.abstractRecord" />
		<cfset var relationship = 0 />
		<cfset var value = 0 />
		<cfset var x = 0 />
		<cfset var y = 0 />

		<!--- the record provided has many of the items in this iterator via a hasMany relationship without a link --->
		<cfset relationship = arguments.Record._getObjectMetadata().getRelationship(_getRelationshipAlias()) />


		<!--- this is a standard relationship --->
		<cfloop from="1" to="#ArrayLen(relationship.relate)#" index="x">
			<!--- get the value from the record  --->
			<cfinvoke component="#arguments.Record#" method="get#relationship.relate[x].from#" returnvariable="value" />

			<!--- loop over the array of loaded records and set the value --->
			<cfloop from="1" to="#ArrayLen(variables.array)#" index="y">
				<cfif IsObject(variables.array[y]) AND NOT variables.array[y].isDeleted()>

					<!--- set the value into the child objects --->
					<cfinvoke component="#variables.array[y]#" method="set#relationship.relate[x].to#">
						<cfinvokeargument name="#relationship.relate[x].to#" value="#value#" />
					</cfinvoke>
				</cfif>
			</cfloop>
		</cfloop>

	</cffunction>

	<!--- add --->
	<cffunction name="add" access="public" hint="I add another element to the END of this iterator.  The iterator must be saved before this will be sorted." output="false" returntype="any" _returntype="reactor.base.abstractRecord">
		<cfset var fieldList = StructKeyList(arguments) />
		<cfset var Record = 0 />
		<cfset var item = 0 />
		<cfset var column = 0 />
		<cfset var To = 0 />

		<cfset populate() />

		<cfif NOT StructCount(arguments)>
			<!--- if nothing was provided then create a new record --->
			<cfset Record = getReactorFactory().createRecord(getAlias()) />

		<cfelseif fieldList IS 1>
			<!--- a record has been passed in.  make sure it's the correct type --->
			<cfset Record = arguments[fieldList] />

			<!--- confirm that the record is the correct type --->
			<cftry>
				<cfif Record._getAlias() IS NOT getAlias()>
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

		<!--- if this is a linked iterator then add a new object of the type that links this object to the parent to the linkIterator --->
		<cfif getLinked()>
			<!--- create a new object to link the new record to the linked object --->
			<cfinvoke component="#getLinkIterator().add()#" method="set#getAlias()#">
				<cfinvokeargument name="#getAlias()#" value="#Record#" />
			</cfinvoke>

		<cfelse>
			<!--- set the parent of this record --->
			<cfset Record._setParent(this) />

		</cfif>

		<!--- add the new record to the array of records --->
		<cfset ArrayAppend(variables.array, Record) />

		<!--- add a row to the query too --->
		<cfset copyRecordToRow(Record) />

		<cfreturn Record />
	</cffunction>

	<!--- populate --->
	<cffunction name="populate" access="private" hint="I populate this object with data if it's not already populated." output="false" returntype="void">
		<cfset var deletedArray = 0 />
    <cfset var addColumn = "" />
    
		<cfif NOT isPopulated()>
			<cfset variables.query = getGateway().getByQuery(getQueryObject(), false) />

			<!--- make note of the column names --->
			<cfset variables.columnList = variables.query.columnList />

			<!--- add a "reactorRowDeleted" field to the query --->
			<cfset deletedArray = ArrayNew(1) />
			<cfif variables.query.recordCount>
				<cfset ArraySet(deletedArray, 1, variables.query.recordCount, 0) />
			</cfif>

      <cfif ListFirst(Server.ColdFusion.ProductVersion) GTE 7>
          <cfset addColumn = "QueryAddColumn(variables.query, 'reactorRowDeleted', 'Bit', deletedArray)" />
      <cfelse>
          <cfset addColumn = "QueryAddColumn(variables.query, 'reactorRowDeleted', deletedArray)" />
      </cfif>
      <cfset evaluate( addColumn ) />

			<cfif variables.query.recordCount GT 0>
				<cfset ArraySet(variables.array, 1, variables.query.recordCount, "") />
			</cfif>
		</cfif>
	</cffunction>

	<!--- isPopulated --->
	<cffunction name="isPopulated" access="public" hint="I indicate if this iterator has been populated with data." output="false" returntype="any" _returntype="boolean">
		<cfreturn IsQuery(variables.query) />
	</cffunction>

	<!--- cleanup --->
	<cffunction name="cleanup" access="private" hint="I clean up deleted items in the iterator" output="false" returntype="void">
		<cfset var x = 0 />


		<cfloop from="1" to="#ArrayLen(variables.array)#" index="x">
			
			<cfif IsObject(variables.array[x])>
				<cfif variables.array[x].isDeleted()
					OR
					(
						getLinked()
						AND
						variables.array[x]._getParent().isDeleted()
					)>
					<cfset QuerySetCell(variables.query, "reactorRowDeleted", 1, x) />
				<cfelse>
					<!--- the record exists --->
					<cfset copyRecordToRow(variables.array[x], x) />
				</cfif>
			</cfif>
			
		</cfloop>
	</cffunction>

	<!--- getArray --->
	<cffunction name="getArray" access="public" hint="I return an array of objects in the iterator" output="false" returntype="any" _returntype="array">
		<cfargument name="from" hint="I am the first index to return." required="no" type="any" _type="numeric" default="1" />
		<cfargument name="count" hint="I am the maximum number of indexes to return." required="no" type="any" _type="numeric" default="-1" />
		<cfset var x = 0 />
		<cfset var sourceArray = ArrayNew(1) />
		<cfset var returnArray = ArrayNew(1) />

		<!--- populate this object --->
		<cfset populate() />

		<!--- build the source array --->
 		<cfloop from="1" to="#ArrayLen(variables.array)#" index="x">
			<!--- if this item's not loaded, or is not deleted add it's index to the source array. --->
			<cfif NOT IsObject(variables.array[x]) OR NOT( variables.array[x].isDeleted() OR ( getLinked() AND variables.array[x]._getParent().isDeleted() ) ) >
				<cfset ArrayAppend(sourceArray, x) />
			</cfif>
		</cfloop>

		<!--- if arguments.count is -1 then we need to set the upper bounds of the loop.  We couldn't do this initially because we only now know for sure that data was loaded --->
		<cfif arguments.count IS -1>
			<cfset arguments.count = ArrayLen(sourceArray) />
		</cfif>

		<!--- make sure that all of the requested objects have been loaded --->
		<cfloop from="#arguments.from#" to="#arguments.from + arguments.count - 1#" index="x">
			<cfif NOT IsObject(variables.array[sourceArray[x]])>
				<cfset variables.array[sourceArray[x]] = loadRecord(sourceArray[x]) />
			</cfif>

			<cfif NOT( variables.array[sourceArray[x]].isDeleted() OR ( getLinked() AND variables.array[sourceArray[x]]._getParent().isDeleted() ) ) >
				<!--- add this into the array we're returning --->
				<cfset ArrayAppend(returnArray, variables.array[sourceArray[x]]) />
			</cfif>
		</cfloop>

		<!--- return the requested array! --->
		<cfreturn returnArray />
	</cffunction>

	<!--- loadRecord --->
	<cffunction name="loadRecord" access="private" hint="I load a specific record based on the query backing the iterator" output="false" returntype="any" _returntype="reactor.base.abstractRecord">
		<cfargument name="index" hint="I am the index of the row in the query which we will use to load this object" required="yes" type="any" _type="numeric" />
		<cfset var Record = 0 />
		<cfset var To = 0 />
		<cfset var column = 0 />
		<cfset var linkRelationship = 0 />
		<cfset var Link = 0 />
		<cfset var x = 0 />

		<cfif getLinked()>
 			<cfset linkRelationship = getLinkRelationshipMetadata() />

			<!--- get the specific linked object from the linked Iterator --->
			<cfinvoke component="#getLinkIterator()#" method="get" returnvariable="Link">
				<cfloop from="1" to="#ArrayLen(linkRelationship.relate)#" index="x">
					<cfinvokeArgument name="#linkRelationship.relate[x].from#"  value="#variables.query[linkRelationship.relate[x].to][arguments.index]#"  />
				</cfloop>
			</cfinvoke>

			<!--- get the record from the link --->
			<cfinvoke component="#Link[1]#" method="get#linkRelationship.alias#" returnvariable="Record" />
		<cfelse>
			<!--- create a new record --->
			<cfset Record = getReactorFactory().createRecord(getAlias()) /> />

			<!--- get the record's to --->
			<cfset To = Record._getTo() />

			<!--- loop over the columns in the query and set all the values into the TO for this record--->
			<cfloop list="#variables.query.columnList#" index="column">
				<!--- set the value of this column into the record's to --->
				<cfif column IS NOT "reactorRowDeleted">
					<cfset To[column] = variables.query[column][arguments.index] />
				</cfif>
			</cfloop>

			<!--- because we manually set the state of the record we need to clean it so that isDirty doesn't return true --->
			<cfset Record.clean() />

			<!--- set the parent of this record --->
			<cfset Record._setParent(this) />
		</cfif>

		<!--- return this squeaky clean record --->
		<cfreturn Record />
	</cffunction>

	<!--- query --->
    <cffunction name="getQuery" access="public" output="false" returntype="any" _returntype="query">
		<cfargument name="from" hint="I am the first row to return." required="no" type="any" _type="numeric" default="1" />
		<cfargument name="count" hint="I am the maximum number of indexes to return." required="no" type="any" _type="numeric" default="-1" />
		<cfset var query = 0 />
		<cfset var filterIndex = ArrayNew(1) />
		<cfset var fields = 0 />
		<cfset var columnName = "" />
		<cfset var x = "" />

		<cfset populate() />

		<!--- mark any deleted records --->
		<cfset cleanup() />


		<cfquery name="query" dbtype="query">
			SELECT <cfloop list="#variables.columnlist#" index="columnName">[#columnName#]<cfif columnName neq listLast(variables.columnList)>,</cfif></cfloop>
			FROM variables.query
			<cfif ListFindNoCase(variables.columnList, "reactorRowDeleted")>
			WHERE reactorRowDeleted = 0
			</cfif>
			
		</cfquery>

		<!--- if we're filtering the rows then filter them --->
		<cfif NOT (arguments.from IS 1 AND arguments.count IS -1) AND query.RecordCount GT 0>

			<!--- create an index row with rownumbers stored in the index --->
			<cfset ArrayResize(filterIndex, query.recordcount) />

			<cfloop from="1" to="#query.recordcount#" index="x">
				<cfset filterIndex[x] = x />
			</cfloop>

			<cfset QueryAddColumn(query, "reactorRowIndex", filterIndex) />

			<!--- filter the query --->
			<cfquery name="query" dbtype="query">
				SELECT <cfloop list="#variables.columnlist#" index="columnName">[#columnName#]<cfif columnName neq listLast(variables.columnList)>,</cfif></cfloop>
				FROM query
				WHERE reactorRowIndex >= #arguments.from#
					<cfif arguments.count IS NOT -1>
						AND reactorRowIndex < #arguments.from + arguments.count#
					</cfif>
			</cfquery>
		</cfif>

		<cfreturn query />
    </cffunction>

	<!--- copyRecordToRow --->
	<cffunction name="copyRecordToRow" access="private" hint="I copy a record's to data to a specific row in the query" output="false" returntype="void">
		<cfargument name="Record" hint="I am the record to copy." required="yes" type="any" _type="reactor.base.abstractRecord" />
		<cfargument name="index" hint="I am the index of the row to copy into.  If not provided a new row is appended." required="no" type="any" _type="numeric" default="-1" />
		<cfset var To = arguments.Record._getTo() />
		<cfset var column = "" />

		<!--- add a row if needed --->
		<cfif arguments.index IS -1>
			<cfset QueryAddRow(variables.query) />
			<cfset arguments.index = variables.query.recordcount />
		</cfif>

		<!--- set all the column values --->
		<cfloop list="#variables.columnList#" index="column">
			<cftry>
				<cfset QuerySetCell(variables.query, column, To[column], arguments.index) />
				<cfcatch>
					<!--- this catch is here incase the data simply can't be stuffed into the query --->
				</cfcatch>
			</cftry>
		</cfloop>

		<!--- set the deleted column value --->
		<cfset QuerySetCell(variables.query, "reactorRowDeleted", 0) />
	</cffunction>

	<!--- getLinkRelationshipMetadata --->
	<cffunction name="getLinkRelationshipMetadata" access="private" hint="If this object is a linking iterator this method is returns the metadata structure describing the relationship between the link and this object." output="false" returntype="any" _returntype="struct">

		<!--- get the relationship to this object from the linking object --->

		<cfreturn getReactorFactory().createMetadata( getLinkIterator().getAlias() ).getRelationship( getLinkRelationshipAlias() ) />
	</cffunction>

	<!--- reset --->
	<cffunction name="reset" access="public" hint="I reset the array and query data that backs this iterator." output="false" returntype="void">
		<cfset variables.query = 0 />
		<cfset variables.array = ArrayNew(1) />
		<cfset setIndex(0) />
	</cffunction>

	<!--- resetIndex --->
	<cffunction name="resetIndex" hint="I reset the iterator's index." output="false" returntype="void">
		<cfset setIndex(0) />
	</cffunction>

	<!--- join --->
	<cffunction name="join" access="public" hint="I am a convenience method which simply calls innerJoin." output="false" returntype="any" _returntype="reactor.iterator.iterator">
		<cfargument name="joinFromObjectAlias" hint="I am the alias of the object being joined from." required="yes" type="any" _type="string" />
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="any" _type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="any" _type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="no" type="any" _type="string" default="#arguments.joinToObjectAlias#" />

		<cfset innerJoin(joinFromObjectAlias=arguments.joinFromObjectAlias, joinToObjectAlias=arguments.joinToObjectAlias, relationshipAlias=arguments.relationshipAlias, alias=arguments.alias) />

		<cfreturn this />
	</cffunction>

	<!--- innerJoin --->
	<cffunction name="innerJoin" access="public" hint="I create an iuner join from this object to another object via the specified relationship which can be on either object." output="false" returntype="any" _returntype="reactor.iterator.iterator">
		<cfargument name="joinFromObjectAlias" hint="I am the alias of the object being joined from." required="yes" type="any" _type="string" />
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="any" _type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="any" _type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="no" type="any" _type="string" default="#arguments.joinToObjectAlias#" />

		<!---<cfset findObject(arguments.joinFromObjectAlias).addJoin(joinToObjectAlias=arguments.joinToObjectAlias, relationshipAlias=arguments.relationshipAlias, alias=arguments.alias, joinType="inner") />--->
		<cfif NOT IsQuery(variables.query)>
			<cfset getQueryObject().innerJoin(arguments.joinFromObjectAlias, arguments.joinToObjectAlias, arguments.relationshipAlias, arguments.alias) />
		<cfelse>
			<cfthrow message="Can Not Add Join"
				detail="Calls to join are not allowed after getting an iterators query or array data or using any method that returns data from the database.  You must call reset first, which reset any changes you have made to objects in the iterator."
				type="reactor.iterator.join.CanNotAddJoin" />
		</cfif>

		<cfreturn this />
	</cffunction>

	<!--- leftJoin --->
	<cffunction name="leftJoin" access="public" hint="I create a left join from this object to another object via the specified relationship which can be on either object." output="false" returntype="any" _returntype="reactor.iterator.iterator">
		<cfargument name="joinFromObjectAlias" hint="I am the alias of the object being joined from." required="yes" type="any" _type="string" />
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="any" _type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="any" _type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="no" type="any" _type="string" default="#arguments.joinToObjectAlias#" />

		<cfif NOT IsQuery(variables.query)>
			<cfset getQueryObject().leftJoin(arguments.joinFromObjectAlias, arguments.joinToObjectAlias, arguments.relationshipAlias, arguments.alias) />
		<cfelse>
			<cfthrow message="Can Not Add Join"
				detail="Calls to join are not allowed after getting an iterators query or array data or using any method that returns data from the database.  You must call reset first, which reset any changes you have made to objects in the iterator."
				type="reactor.iterator.join.CanNotAddJoin" />
		</cfif>

		<cfreturn this />
	</cffunction>

	<!--- rightJoin --->
	<cffunction name="rightJoin" access="public" hint="I create a right join from this object to another object via the specified relationship which can be on either object." output="false" returntype="any" _returntype="reactor.iterator.iterator">
		<cfargument name="joinFromObjectAlias" hint="I am the alias of the object being joined from." required="yes" type="any" _type="string" />
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="any" _type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="any" _type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="no" type="any" _type="string" default="#arguments.joinToObjectAlias#" />

		<cfif NOT IsQuery(variables.query)>
			<cfset getQueryObject().rightJoin(arguments.joinFromObjectAlias, arguments.joinToObjectAlias, arguments.relationshipAlias, arguments.alias) />
		<cfelse>
			<cfthrow message="Can Not Add Join"
				detail="Calls to join are not allowed after getting an iterators query or array data or using any method that returns data from the database.  You must call reset first, which reset any changes you have made to objects in the iterator."
				type="reactor.iterator.join.CanNotAddJoin" />
		</cfif>

		<cfreturn this />
	</cffunction>

	<!--- fullJoin --->
	<cffunction name="fullJoin" access="public" hint="I create a right join from this object to another object via the specified relationship which can be on either object." output="false" returntype="any" _returntype="reactor.iterator.iterator">
		<cfargument name="joinFromObjectAlias" hint="I am the alias of the object being joined from." required="yes" type="any" _type="string" />
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="any" _type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="any" _type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="no" type="any" _type="string" default="#arguments.joinToObjectAlias#" />

		<cfif NOT IsQuery(variables.query)>
			<cfset getQueryObject().fullJoin(arguments.joinFromObjectAlias, arguments.joinToObjectAlias, arguments.relationshipAlias, arguments.alias) />
		<cfelse>
			<cfthrow message="Can Not Add Join"
				detail="Calls to join are not allowed after getting an iterators query or array data or using any method that returns data from the database.  You must call reset first, which reset any changes you have made to objects in the iterator."
				type="reactor.iterator.join.CanNotAddJoin" />
		</cfif>

		<cfreturn this />
	</cffunction>

	<!--- getWhere --->
	<cffunction name="getWhere" access="public" hint="I get the where object that filters the query that backs this iterator.  Important: I reset the query and array data that backs the iterator.  If you've made changes to the iterator you will loose them if you call this method." output="false" returntype="any" _returntype="reactor.query.where">
		<cfset reset() />
		<cfreturn getQueryObject().getWhere() />
	</cffunction>

	<!--- setDistinct --->
	<cffunction name="setDistinct" access="public" hint="I filter the query that backs this iterator to return only distinct values.  Important: I reset the query and array data that backs the iterator.  If you've made changes to the iterator you will loose them if you call this method." output="false" returntype="void">
		<cfargument name="distinct" hint="I indicate if the query should only return distinct matches" required="yes" type="any" _type="boolean" />
		<cfset reset() />
		<cfreturn getQueryObject().setDistinct(arguments.distinct) />
	</cffunction>

	<!--- getOrder --->
	<cffunction name="getOrder" access="public" hint="I get the order object that sorts the query that backs this iterator.  Important: I reset the query and array data that backs the iterator.  If you've made changes to the iterator you will loose them if you call this method." output="false" returntype="any" _returntype="reactor.query.order">
		<cfset reset() />
		<cfreturn getQueryObject().getOrder() />
	</cffunction>

	<!--- resetOrder --->
	<cffunction name="resetOrder" access="public" hint="I reset the order object that sorts the query that backs this iterator.  Important: I reset the query and array data that backs the iterator.  If you've made changes to the iterator you will loose them if you call this method." output="false" returntype="void">
		<cfset reset() />
		<cfset getQueryObject().resetOrder() />
	</cffunction>

	<!--- resetWhere --->
	<cffunction name="resetWhere" access="public" hint="I reset the where object that filters the query that backs this iterator.  Important: I reset the query and array data that backs the iterator.  If you've made changes to the iterator you will loose them if you call this method." output="false" returntype="void">
		<cfset reset() />
		<cfset getQueryObject().resetWhere() />
	</cffunction>

	<!--- gateway --->
    <cffunction name="setGateway" access="private" output="false" returntype="void">
       <cfargument name="gateway" hint="I am the gateway object used to query the DB." required="yes" type="any" _type="reactor.base.abstractGateway" />
       <cfset variables.gateway = arguments.gateway />
    </cffunction>
    <cffunction name="getGateway" access="private" output="false" returntype="any" _returntype="reactor.base.abstractGateway">
       <cfreturn variables.gateway />
    </cffunction>

	<!--- queryObject --->
    <cffunction name="setQueryObject" access="private" output="false" returntype="void">
       <cfargument name="queryObject" hint="I am the OO query being managed by this iterator" required="yes" type="any" _type="reactor.query.query" />
       <cfset variables.queryObject = arguments.queryObject />
    </cffunction>
    <cffunction name="getQueryObject" access="private" output="false" returntype="any" _returntype="reactor.query.query">
       <cfreturn variables.queryObject />
    </cffunction>

	<!--- name --->
    <cffunction name="setAlias" access="private" output="false" returntype="void">
       <cfargument name="name" hint="I am the name of the object this iterator encapsulates" required="yes" type="any" _type="string" />
       <cfset variables.name = arguments.name />
    </cffunction>
    <cffunction name="getAlias" access="public" output="false" returntype="any" _returntype="string">
       <cfreturn variables.name />
    </cffunction>

	<!--- reactorFactory --->
    <cffunction name="setReactorFactory" access="private" output="false" returntype="void">
       <cfargument name="reactorFactory" hint="I am the ReactorFactory" required="yes" type="any" _type="reactor.ReactorFactory" />
       <cfset variables.reactorFactory = arguments.reactorFactory />
    </cffunction>
    <cffunction name="getReactorFactory" access="private" output="false" returntype="any" _returntype="reactor.ReactorFactory">
       <cfreturn variables.reactorFactory />
    </cffunction>

	<!--- parent --->
    <cffunction name="_setParent" hint="I set this record's parent.  This is for Reactor's use only.  Don't set this value.  If you set it you'll get errrors!  Don't say you weren't warned." access="public" output="false" returntype="void">
		<cfargument name="parent" hint="I am the object which loaded this record" required="yes" type="any" _type="any" />
		<cfargument name="relationshipAlias" hint="I am the alias of relationship the parent has to the child" required="no" type="any" _type="string" />

		<cfset variables.parent = arguments.parent />

		<!--- if variables.parent is not an iterator then the relationship alias is required! --->
		<cfif GetMetadata(arguments.parent).name IS NOT "reactor.iterator.iterator" AND NOT StructKeyExists(arguments, "relationshipAlias")>
			<cfthrow message="No Relationship Alias Provided" detail="Because the parent object is a record the relationshipAlias argument is required." type="reactor.setParent.NoRelationshipAliasProvided" />
		</cfif>

		<!--- set the relationship --->
		<cfif StructKeyExists(arguments, "relationshipAlias")>
			<cfset _setRelationshipAlias(arguments.relationshipAlias) />
		</cfif>
    </cffunction>
    <cffunction name="_getParent" hint="I get this record's parent.  Call hasParent before calling me in case this record doesn't have a parent." access="public" output="false" returntype="any" _returntype="any">
       <cfreturn variables.parent />
    </cffunction>
	<cffunction name="hasParent" access="public" hint="I indicate if this object has a parent." output="false" returntype="any" _returntype="boolean">
		<cfreturn IsObject(variables.parent) />
	</cffunction>
	<cffunction name="resetParent" access="public" hint="I remove the reference to a parent object." output="false" returntype="void">
		<cfset variables.parent = 0 />
	</cffunction>

	<!--- relationshipAlias --->
    <cffunction name="_setRelationshipAlias" access="private" output="false" returntype="void">
       <cfargument name="relationshipAlias" hint="I am the relationship used to relate the object's parent to it." required="yes" type="any" _type="string" />
       <cfset variables.relationshipAlias = arguments.relationshipAlias />
    </cffunction>
    <cffunction name="_getRelationshipAlias" access="private" output="false" returntype="any" _returntype="string">
       <cfreturn variables.relationshipAlias />
    </cffunction>

	<!--- setLink --->
    <cffunction name="setLink" access="public" output="false" returntype="void">
       <cfargument name="linkIterator" hint="I am the iterator between this iterator and it's parent" required="yes" type="any" _type="reactor.iterator.iterator" />
	   <cfargument name="linkRelationshipAlias" hint="I am the alias of the relationship from the linkIterator to this iterator" required="yes" type="any" _type="string" />
       <cfset setLinked(true) />
	   <cfset setLinkIterator(arguments.linkIterator) />
	   <cfset setLinkRelationshipAlias(arguments.linkRelationshipAlias) />
    </cffunction>

	<!--- linkRelationshipAlias --->
    <cffunction name="setLinkRelationshipAlias" access="private" output="false" returntype="void">
       <cfargument name="linkRelationshipAlias" hint="I am the alias of the relationship on the link iterator" required="yes" type="any" _type="string" />
       <cfset variables.linkRelationshipAlias = arguments.linkRelationshipAlias />
    </cffunction>
    <cffunction name="getLinkRelationshipAlias" access="private" output="false" returntype="any" _returntype="string">
       <cfreturn variables.linkRelationshipAlias />
    </cffunction>

	<!--- linkIterator --->
    <cffunction name="setLinkIterator" access="private" output="false" returntype="void">
       <cfargument name="linkIterator" hint="I am the iterator between this iterator and it's parent" required="yes" type="any" _type="reactor.iterator.iterator" />
       <cfset variables.linkIterator = arguments.linkIterator />
    </cffunction>
    <cffunction name="getLinkIterator" access="private" output="false" returntype="any" _returntype="reactor.iterator.iterator">
       <cfreturn variables.linkIterator />
    </cffunction>

	<!--- linked --->
    <cffunction name="setLinked" access="private" output="false" returntype="void">
       <cfargument name="linked" hint="I indicate if this is a linked iterator" required="yes" type="any" _type="boolean" />
       <cfset variables.linked = arguments.linked />
    </cffunction>
    <cffunction name="getLinked" access="public" output="false" returntype="any" _returntype="boolean">
       <cfreturn variables.linked />
    </cffunction>

	<!--- getLastExecutedQuery --->
	<cffunction name="getLastExecutedQuery" access="public" output="false" returntype="any" _returntype="struct">
     	<cfreturn getGateway().getLastExecutedQuery() />
    </cffunction>

 	<!--- setFieldPrefix --->
	<cffunction name="setFieldPrefix" access="public" hint="I am prefix field names." output="false" returntype="void">
		<cfargument name="objectAlias" hint="I am the alias of the object that the prefix is being added to." required="yes" type="any" _type="string" />
		<cfargument name="prefix" hint="I am the prefix to prepend." required="yes" type="any" _type="string" />
		<cfset getQueryObject().setFieldPrefix(objectAlias=arguments.objectAlias,prefix=arguments.prefix) />
	</cffunction>

</cfcomponent>

