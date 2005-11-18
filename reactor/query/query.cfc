<cfcomponent hint="I am a component used to define ad-hoc queries.">
	
	<!--- the from object --->
	<cfset variables.From = 0 />

	<!--- query parts --->
	<cfset variables.maxRows = -1 />
	<cfset variables.distinct = false />	
	
	<!--- where --->
	<cfset variables.where = CreateObject("Component", "reactor.query.where").init(this) />
	
	<!--- init --->
	<cffunction name="init" access="public" hint="I configure and return the criteria object" output="false" returntype="reactor.query.query">
		<cfargument name="BaseObjectMetadata" hint="I am the Metadata for the base object being queried" required="yes" type="reactor.base.abstractMetadata">
		<cfset var Object = CreateObject("Component", "reactor.query.object").init(arguments.BaseObjectMetadata) />
		
		<cfset setFrom(Object) />

		<cfset joinSuper(Object) />

		<cfreturn this />
	</cffunction>
	
	<!--- from --->
    <cffunction name="setFrom" access="private" output="false" returntype="void">
       <cfargument name="from" hint="I am the to from statement" required="yes" type="reactor.query.object" />
       <cfset variables.from = arguments.from />
    </cffunction>
    <cffunction name="getFrom" access="public" output="false" returntype="reactor.query.object">
       <cfreturn variables.from />
    </cffunction>
	
	<!--- getFromAsString --->
	<cffunction name="getFromAsString" access="public" hint="I convert the from objects to a sql from fragment." output="false" returntype="string">
		<cfargument name="Convention" hint="I am the convention object to use." required="yes" type="reactor.data.abstractConvention" />
		<cfreturn getFrom().getFromAsString(arguments.Convention) />
	</cffunction>
	
	<!--- getSelectAsString --->
	<cffunction name="getSelectAsString" access="public" hint="I convert the from objects to a sql select fragment" output="false" returntype="string">
	<cfargument name="Convention" hint="I am the convention object to use." required="yes" type="reactor.data.abstractConvention" />
		<cfreturn getFrom().getSelectAsString(arguments.Convention) />
	</cffunction>
	
	<!--- findObject --->
	<cffunction name="findObject" access="package" hint="I find an object in the query" output="false" returntype="reactor.query.object">
		<cfargument name="name" hint="I am the name or alias of a object being searched for." required="yes" type="string" />
		<cfset var Object = getFrom().findObject(arguments.name) />
		
		<cfif IsObject(Object)>
			<cfreturn Object />
		</cfif>

		<cfthrow message="Can Not Find Object" detail="Can not find the object '#arguments.name#' as an alias or name within the query." type="reactor.findObject.CanNotFindObject" />
	</cffunction>
	
	<!--- joinSuper --->
	<cffunction name="joinSuper" access="private" hint="I join any super objects." output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to join onto supers." required="yes" type="reactor.query.object" />
		<cfset var ObjectMetadata = arguments.Object.getObjectMetadata() />
		
		<cfif ObjectMetadata.hasSuper()>
			<cfset join(arguments.Object.getAlias(), ObjectMetadata.getSuperAlias()) />
		</cfif>		
	</cffunction>
	
	<!--- join --->
	<cffunction name="join" access="public" hint="I join one object to another." output="false" returntype="reactor.query.query">
		<cfargument name="from" hint="I am the name or alias of a object being joined from." required="yes" type="string" />
		<cfargument name="to" hint="I am the name or alias of an object being joined to." required="yes" type="string" />
		<cfargument name="type" hint="I am the type of join. Options are: left, right, full" required="no" type="string" default="left" />
		<cfset var FromObject = findObject(arguments.from) />
		<cfset var ToObject = FromObject.getRelatedObject(arguments.to) />
		<cfset FromObject.join(ToObject, arguments.type) />
		
		<cfset joinSuper(ToObject) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- maxrows --->
    <cffunction name="setMaxrows" hint="I configure the number of rows returned by the query." access="public" output="false" returntype="void">
       <cfargument name="maxrows" hint="I set the maximum number of rows to return. If -1 all rows are returned." required="yes" type="numeric" />
       <cfset variables.maxrows = arguments.maxrows />
    </cffunction>
    <cffunction name="getMaxrows" access="public" output="false" returntype="numeric">
       <cfreturn variables.maxrows />
    </cffunction>
	
	<!--- distinct --->
    <cffunction name="setDistinct" hint="I indicate if only distinct rows should be returned" access="public" output="false" returntype="void">
       <cfargument name="distinct" hint="I indicate if the query should only return distinct matches" required="yes" type="boolean" />
       <cfset variables.distinct = arguments.distinct />
    </cffunction>
    <cffunction name="getDistinct" access="public" output="false" returntype="boolean">
       <cfreturn variables.distinct />
    </cffunction>
	
		
	<!--- where --->
    <cffunction name="setWhere" access="public" output="false" returntype="void">
       <cfargument name="where" hint="I am the query's where experssion" required="yes" type="reactor.query.where" />
       <cfset variables.where = arguments.where />
    </cffunction>
    <cffunction name="getWhere" access="public" output="false" returntype="reactor.query.where">
       <cfreturn variables.where />
    </cffunction>
	
	<!--- getField --->
	<cffunction name="getField" access="public" hint="I get a column based on the provided object name/alias and field name" output="false" returntype="struct">
		<cfargument name="object" hint="I am the name or alias of the object." required="yes" type="string" />
		<cfargument name="field" hint="I am the name of the field." required="yes" type="string" />
		<cfreturn findObject(arguments.object).getObjectMetadata().getField(arguments.field) />
	</cffunction>
	
</cfcomponent>


<!---



	
	<!--- order expression --->
	<cfset variables.order = CreateObject("Component", "reactor.query.order").init(this) />
	
	<cffunction name="dump">
		<cfdump var="#variables.objectMetadataCollection#" expand="no" />
		
		<cfloop from="1" to="#ArrayLen(variables.joins)#" index="x">
			<cfdump var="#variables.joins[x].getfromObjectMetadata().getName()#"  />
			<cfdump var="#variables.joins[x].gettoObjectMetadata().getName()#" /><br>
		</cfloop>
		
		
		<cfabort>
	</cffunction>
	
	<!--- init --->
	<cffunction name="init" access="public" hint="I configure and return the criteria object" output="false" returntype="reactor.query.query">
		<cfargument name="baseObjectMetadata" hint="I am the Metadata for the base object being queried" required="yes" type="reactor.base.abstractMetadata">

		<cfset setBaseObjectMetadata(arguments.baseObjectMetadata) />
		<cfset addMetadata(arguments.baseObjectMetadata.getName(), baseObjectMetadata) />
		
		<!--- add this object's columns --->
		<cfset addFields(arguments.baseObjectMetadata.getFields()) />

		<cfreturn this />
	</cffunction>
		
	<!--- addMetadata --->
	<cffunction name="addMetadata" hint="I add an object's Metadata to the query" access="private" output="false" returntype="void">
		<cfargument name="alias" hint="I am the alias of the object." required="yes" type="string" />
		<cfargument name="Metadata" hint="I am the object's Metadata to add." required="yes" type="reactor.base.abstractMetadata" />
		<cfset var objectMetadataCollection = getObjectMetadataCollection() />
		
		<cfset objectMetadataCollection[arguments.alias] = arguments.Metadata />
		
		<!--- if this object has a superObject add it --->
		<cfif arguments.Metadata.hasSuper()>
			<cfset join(arguments.alias, arguments.Metadata.getSuperAlias()) />
		</cfif>
	</cffunction>
	
	<!--- objectMetedataExists
	<cffunction name="objectMetedataExists" hint="I check to see if an object metedata is referred to in this query" access="private" output="false" returntype="boolean">
		<cfargument name="name" hint="I am the name of the object." required="yes" type="string" />
		<cfset var metadataArray = getMetadataArray() />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(metadataArray)#" index="x">
			<cfif metadataArray[x].getName() IS arguments.name>
				<cfreturn true />
			</cfif>
		</cfloop>
		
		<cfreturn false />
	</cffunction> --->
	
	<!--- getObjectMetadata
	<cffunction name="getObjectMetadata" access="package" hint="I get an object's metadata" output="false" returntype="reactor.base.abstractMetadata">
		<cfargument name="name" hint="I am the name of the object." required="yes" type="string" />
		<cfset var metadataArray = getMetadataArray() />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(metadataArray)#" index="x">
			<cfif metadataArray[x].getName() IS arguments.name>
				<cfreturn metadataArray[x] />
			</cfif>
		</cfloop>
		
		<cfthrow message="Object Not In Query" detail="The object, '#arguments.name#' has not yet been added to this query." type="reactor.getObjectMetadata.ObjectNotInQuery" />
	</cffunction> --->
	
	<!--- getObjectNameByAlias
	<cffunction name="getObjectNameByAlias" access="private" hint="I get the specific object name based on the provided alias.  If this is no an alias it's returned unchanged." output="false" returntype="string">
		<cfargument name="alias" hint="I am the alias to find the object name for" required="yes" type="string" />
		<cfset var joins = getJoins() />
		<cfset var x = 0 />
			
		<cfloop from="1" to="#ArrayLen(joins)#" index="x">
			<cfif joins[x].getAlias() & joins[x].getToObjectMetadata().getName() IS arguments.alias>
				<cfreturn joins[x].getToObjectMetadata().getName() />
			</cfif>
		</cfloop>
		
		<cfreturn arguments.alias />
	</cffunction> --->
	
	<!--- checkObjectNamePrecision 
	<cffunction name="checkObjectNamePrecision" access="private" hint="I check to insure that a specific name is precise enough to identify a specific object in the query." output="false" returntype="void">
		<cfargument name="name" hint="I am the name of the object (or an alias) to check." required="yes" type="string" />
		<cfset var joins = getJoins() />
		
		
		
	</cffunction>--->
	
	<!--- getAliasMetadata --->
	<cffunction name="getAliasMetadata" access="private" hint="I get an object's metadata based on the provided alias" output="false" returntype="reactor.base.abstractMetadata">
		<cfargument name="alias" hint="I am the alias to get the object for." required="yes" type="string" />
		<cfset var objectMetadataCollection = getObjectMetadataCollection() />
		<cfreturn objectMetadataCollection[arguments.alias] />
	</cffunction>
	
	<!--- join --->
	<cffunction name="join" access="public" hint="I add a join to another object in the database." output="false" returntype="reactor.query.query">
		<cfargument name="fromAlias" hint="I am the alias of the object which is being joined from.  The 'main' object's alias is always its name.  Other object's aliases are defined in relationship in the reactor config xml." required="yes" type="string" />
		<cfargument name="toAlias" hint="I am the name of the object which is being joined tp." required="yes" type="string" />
		<cfargument name="type" hint="I am the type of join.  Options are: left, right, full" required="no" default="left" type="string" />
		<cfset var fromObjectMetadata = getAliasMetadata(arguments.fromAlias) />
		<cfset var toObjectMetadata = fromObjectMetadata.getRelatedObjectMetadata(arguments.toAlias) />
		<cfset var Join = 0 />
		
		<cfif arguments.fromAlias IS NOT fromObjectMetadata.getName()>
			<cfset arguments.toAlias = fromAlias & arguments.toAlias />
		</cfif>		
		
		<cfset addJoin(CreateObject("Component", "reactor.query.join").init(arguments.type, fromObjectMetadata, toObjectMetadata, arguments.toAlias)) />
		
		
		<cfset addMetadata(arguments.toAlias, toObjectMetadata) />
		
		<cfreturn this />
		<!--- 
		
		
		<cfset var relationshipTypes = fromObjectMetadata.getHasRelationships(toObjectMetadata.getName()) />
		<cfset var relationshipType = 0 />
		<cfset var relationship = 0 />
		<cfset var item = 0 />
		<cfset var aliasRoot = "" />
		
		<!--- insure that the named object exists
		<cfif arguments.fromObject IS "address">
			<cfdump var="#arguments.fromObject#" /><cfabort>
			<cfset checkObjectNamePrecision(arguments.fromObject) />
		</cfif> --->
		
				
		<!--- add joins for each relationship the from object has to the to object --->
		<cfloop collection="#relationshipTypes#" item="item">
			<cfset relationshipType = relationshipTypes[item] />
			
			<cfif arguments.fromObject IS NOT fromObjectMetadata.getName()>
				<cfset aliasRoot = Left(arguments.fromObject, Len(arguments.fromObject) - Len(fromObjectMetadata.getName())) />
			</cfif>
			
			<cfloop from="1" to="#ArrayLen(relationshipType)#" index="x">
				<cfset relationship = relationshipType[x] />
				
				<cfset addJoin(CreateObject("Component", "reactor.query.join").init(arguments.type, fromObjectMetadata, toObjectMetadata, aliasRoot & relationship.alias)) />
			</cfloop>
		</cfloop>
		
		<!--- add the object metadata --->
		<cfif NOT objectMetedataExists(arguments.toObject)>
			<cfset addMetadata(toObjectMetadata) />
		</cfif>

		<cfreturn this />
		--->
	</cffunction>
	
	<!--- addJoin --->
	<cffunction name="addJoin" access="private" hint="I add a join to the query" output="false" returntype="void">
		<cfargument name="Join" hint="I am the join to add" required="yes" type="reactor.query.Join" />
		<cfset var toObjectMetadata = arguments.join.getToObjectMetadata() />
		
		<!--- add the fields --->
		<cfset addFields(toObjectMetadata.getFields(), arguments.Join.getAlias()) />
				
		<!--- add the join --->
		<cfset ArrayAppend(getJoins(), Join) />
	</cffunction>
	
	<!--- addFields --->
	<cffunction name="addFields" access="private" hint="I add an array of fields to the query" output="false" returntype="void">
		<cfargument name="newFields" hint="I am the array of fields to add" required="yes" type="array" />
		<cfargument name="alias" hint="I am the alias to prepend for the columns" required="no" type="string" default="" />
		<cfset var fields = getFields() />
		<cfset var field = 0 />
		<cfset var x = 0 />
		
		<!--- add the fields that are a product of this join --->
		<cfloop from="1" to="#ArrayLen(arguments.newFields)#" index="x">
			<cfset field = Duplicate(arguments.newFields[x]) />
			<cfset field["alias"] = arguments.alias />
			
			<cfset ArrayAppend(fields, field) />
		</cfloop>
		
		<!--- add the fields --->
		<cfset setFields(fields) />
	</cffunction>
	
	<!--- fields --->
    <cffunction name="setFields" access="public" output="false" returntype="void">
       <cfargument name="fields" hint="I am the fields in this query" required="yes" type="array" />
       <cfset variables.fields = arguments.fields />
    </cffunction>
    <cffunction name="getFields" access="public" output="false" returntype="array">
       <cfreturn variables.fields />
    </cffunction>
	
	<!--- joins --->
    <cffunction name="setJoins" access="private" output="false" returntype="void">
       <cfargument name="joins" hint="I am an array of joins in the query" required="yes" type="array" />
       <cfset variables.joins = arguments.joins />
    </cffunction>
    <cffunction name="getJoins" access="private" output="false" returntype="array">
       <cfreturn variables.joins />
    </cffunction>

	
	<!--- order --->
    <cffunction name="setOrder" access="public" output="false" returntype="void">
       <cfargument name="order" hint="I am the order expression" required="yes" type="reactor.query.order" />
       <cfset variables.order = arguments.order />
    </cffunction>
    <cffunction name="getOrder" access="public" output="false" returntype="reactor.query.order">
       <cfreturn variables.order />
    </cffunction>
	
	<!--- createWhere --->
	<cffunction name="createWhere" access="public" hint="I create and return a new where." output="false" returntype="reactor.query.where">
		<cfreturn CreateObject("Component", "reactor.query.where").init(this) />
	</cffunction>
	
	
	
	<!--- baseObjectMetadata --->
    <cffunction name="setBaseObjectMetadata" access="public" output="false" returntype="void">
       <cfargument name="baseObjectMetadata" hint="I am the base object's metadata" required="yes" type="reactor.base.abstractMetadata" />
       <cfset variables.baseObjectMetadata = arguments.baseObjectMetadata />
    </cffunction>
    <cffunction name="getBaseObjectMetadata" access="public" output="false" returntype="reactor.base.abstractMetadata">
       <cfreturn variables.baseObjectMetadata />
    </cffunction>
	
	<!--- objectMetadataCollection --->
    <cffunction name="setObjectMetadataCollection" access="public" output="false" returntype="void">
       <cfargument name="objectMetadataCollection" hint="I am a collection of named metadata objects" required="yes" type="struct" />
       <cfset variables.objectMetadataCollection = arguments.objectMetadataCollection />
    </cffunction>
    <cffunction name="getObjectMetadataCollection" access="public" output="false" returntype="struct">
       <cfreturn variables.objectMetadataCollection />
    </cffunction>
	
--->