<cfcomponent hint="I am an abstract record.  I am used primarly to allow type definitions for return values.  I also loosely define an interface for a record objects and some core methods." extends="reactor.base.abstractObject">

	<cfset variables.ErrorCollection = 0 />
	<cfset variables.children = StructNew() />
	<cfset variables.Parent = 0 />
	<cfset variables.relationshipAlias = "" />
	<cfset variables.deleted = false />
	<cfset variables.alias = "" />
		
	<!--- configure --->
	<cffunction name="_configure" access="public" hint="I configure and return this object." output="false" returntype="reactor.base.abstractRecord">
		<cfargument name="config" hint="I am the configuration object to use." required="yes" type="reactor.config.config" />
		<cfargument name="alias" hint="I am the alias of this object." required="yes" type="string" />
		<cfargument name="ReactorFactory" hint="I am the reactorFactory object." required="yes" type="reactor.reactorFactory" />
		<cfargument name="Convention" hint="I am a database Convention object." required="yes" type="reactor.data.abstractConvention" />
		<cfargument name="ObjectMetadata" hint="I am a database Convention object." required="yes" type="reactor.base.abstractMetadata" />
		
		<cfset super._configure(arguments.Config, arguments.alias, arguments.ReactorFactory, arguments.Convention) />
		<cfset _setObjectMetadata(arguments.ObjectMetadata) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- objectMetadata --->
    <cffunction name="_setObjectMetadata" access="private" output="false" returntype="void">
       <cfargument name="objectMetadata" hint="I set the object metadata." required="yes" type="reactor.base.abstractMetadata" />
       <cfset variables.objectMetadata = arguments.objectMetadata />
    </cffunction>
    <cffunction name="_getObjectMetadata" access="public" output="false" returntype="reactor.base.abstractMetadata">
       <cfreturn variables.objectMetadata />
    </cffunction>
	
	<cffunction name="clean" access="public" hint="I copy the current to into the initial to.  Assuming the TOs dont have any complex objects this should cause isDirty to return false." output="false" returntype="void">
		<cfset _getInitialTo()._copy(_getTo()) />
	</cffunction>	
	
	<!--- isDirty --->
	<cffunction name="isDirty" access="public" hint="I indicate if this object has been modified since it was created, loaded, saved, deleted or cleaned." output="false" returntype="boolean">
		<cfreturn NOT _getTo()._isEqual(_getInitialTo()) />
	</cffunction>
	
	<!--- load --->
	<cffunction name="load" access="public" hint="I load the record." output="false" returntype="reactor.base.abstractRecord">
		<cfset var fieldList = StructKeyList(arguments) />
		<cfset var item = 0 />
		<cfset var func = 0 />
		<cfset var nothingLoaded = false />
		
		<cfset beforeLoad() />
		
		<cfif IsDefined("arguments") AND fieldList IS 1>
			<cfset fieldList = arguments[1] />
			
		<cfelseif IsDefined("arguments") AND fieldList IS NOT 1>
			<cfloop collection="#arguments#" item="item">
				<cfinvoke component="#this#" method="set#item#">
					<cfinvokeargument name="#item#" value="#arguments[item]#" />
				</cfinvoke>
			</cfloop>
			
		</cfif>
		
		<cftry>
			<cfset _getDao().read(_getTo(), fieldList) />
			<cfcatch type="Reactor.Record.NoMatchingRecord">
				<cfset nothingLoaded = true />
			</cfcatch>		
		</cftry>
		
		<cfif NOT nothingLoaded>
			<!--- clean the object --->
			<cfset clean() />
		</cfif>
				
		<cfset afterLoad() />
		
		<cfreturn this />
	</cffunction>	
	
	<!--- validate --->
	<cffunction name="validate" access="public" hint="I validate this object." output="false" returntype="void">
		<cfset beforeValidate() />
		
		<cfset _setErrorCollection(_getReactorFactory().createValidator(_getAlias()).validate(this)) />
		
		<cfset afterValidate() />	
	</cffunction>
	
	<cffunction name="save" access="public" hint="I save the record." output="false" returntype="void">
		<cfargument name="useTransaction" hint="I indicate if this save should be executed within a transaction." required="no" type="boolean" default="true" />
		
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
		<cfset beforeSave() />
		
		<cfif isDirty()>
			<cfset _getDao().save(_getTo()) />	
		</cfif>
		
		<cfset afterSave() />	
	</cffunction>	
	
	<!--- delete --->
	<cffunction name="delete" access="public" hint="I delete the record." output="false" returntype="void">
		<cfargument name="useTransaction" hint="I indicate if this delete should be executed within a transaction." required="no" type="boolean" default="true" />
		
		<cfif arguments.useTransaction>
			<cfset deleteInTransaction() />
		<cfelse>
			<cfset executeDelete() />
		</cfif>
		
	</cffunction>
	
	<!--- deleteInTransaction --->
	<cffunction name="deleteInTransaction" access="private" hint="I delete the record in a transaction." output="false" returntype="void">
		<cftransaction>
			<cfset executeDelete() />
		</cftransaction>
	</cffunction>
	
	<!--- executeDelete --->
	<cffunction name="executeDelete" access="private" hint="I actually delete the record." output="false" returntype="void">
		<cfset beforeDelete() />
		
		<cfif StructCount(arguments)>
			<cfinvoke component="#this#" method="load" argumentcollection="#arguments#" />
		</cfif>
				
		<cfset _getDao().delete(_getTo()) />
		
		<cfset afterDelete() />
	</cffunction>
	
	<!--- beforeValidate --->
	<cffunction name="beforeValidate" access="private" hint="I am code executed before validating the record." output="false" returntype="void">
		<!--- something may go here some day --->
	</cffunction>
	
	<!--- aftervalidate --->
	<cffunction name="aftervalidate" access="private" hint="I am code executed after validating the record." output="false" returntype="void">
		<cfset var item = 0 />
		
		<!--- validate all loaded children --->
		<cfloop collection="#variables.children#" item="item">
			<!--- check to see if this child is loaded --->
			<cfif IsObject(variables.children[item])>
			
				<!--- save the child. --->
				<cfset variables.children[item].validate() />
				
			</cfif>
		</cfloop>
	</cffunction>
	
	<!--- beforeLoad --->
	<cffunction name="beforeLoad" access="private" hint="I am code executed before loading the record." output="false" returntype="void">
		<!--- reset the children --->
		<cfset variables.children = StructNew() />
		<!--- remove the error collection --->
		<cfset variables.ErrorCollection = 0 />
	</cffunction>
	
	<!--- afterLoad --->
	<cffunction name="afterLoad" access="private" hint="I am code executed after loading the record." output="false" returntype="void">
		<!--- something may go here some day --->
	</cffunction>
	
	<!--- beforeDelete --->
	<cffunction name="beforeDelete" access="private" hint="I am code executed before deleting the record." output="false" returntype="void">
		<!--- something may go here some day --->
	</cffunction>
	
	<!--- afterDelete --->
	<cffunction name="afterDelete" access="private" hint="I am code executed after deleting the record." output="false" returntype="void">
		<!--- reset the to --->
		<cfset _setTo(_getReactorFactory().createTo(_getAlias())) />
		<!--- clean the object --->
		<cfset clean() />
		<!--- set the deleted status of this cfc --->
		<cfset variables.deleted = true />
		<!--- remove children --->
		<cfset variables.children = StructNew() />
		<!--- remove the error collection --->
		<cfset variables.ErrorCollection = 0 />
	</cffunction>
	
	<!--- beforeSave --->
	<cffunction name="beforeSave" access="private" hint="I am code executed before saving the record." output="false" returntype="void">
		<cfset var item = 0 />
		
		<cfloop collection="#variables.children#" item="item">
			<!--- check to see if this child is either a linking iteator a record.  If it's a record then the check to see if the child hasOne of the parent.  If so then don't save before. --->
			<cfif IsObject(variables.children[item]) AND (
				(GetMetadata(variables.children[item]).name IS "reactor.iterator.iterator" AND variables.children[item].getLinked()) 
				OR GetMetadata(variables.children[item]).name IS NOT "reactor.iterator.iterator" AND NOT _getObjectMetadata().hasSharedkey(variables.children[item]._getAlias())
			)>
				<!--- save the child. --->
				<cfset variables.children[item].save(false) />
				
			</cfif>
		</cfloop>
		
	</cffunction>
	
	<!--- afterSave --->
	<cffunction name="afterSave" access="private" hint="I am code executed after saving the record." output="false" returntype="void">
		<cfset var relationship = 0 />
		<cfset var x = 0 />
		<cfset var value = 0 />
		<cfset var item = 0 />
		
		<!--- check to see if this object has children in iterators.  If so, set the related fields in the child from this parent. --->
		<cfloop collection="#variables.children#" item="item">
			<!--- check to make sure this child is an iterator or record (links are skipped) --->
			<cfif GetMetadata(variables.children[item]).name IS "reactor.iterator.iterator" AND NOT variables.children[item].getLinked()>
				<cfset variables.children[item].relateTo(this) />
				<!--- save any loaded and dirty records in the iterator --->
				<cfset variables.children[item].save(false) />
				
			<cfelseif IsObject(variables.children[item]) AND GetMetadata(variables.children[item]).name IS NOT "reactor.iterator.iterator" AND _getObjectMetadata().hasSharedkey(variables.children[item]._getAlias())>
				<!--- save the changed record --->
				<cfset relationship = _getObjectMetadata().getRelationship(variables.children[item]._getAlias()) />
				
				<cfif relationship.sharedKey>
					<!--- this is a shared key one to one object we're trying to save. --->
					<cfloop from="1" to="#ArrayLen(relationship.relate)#" index="x">
						<!--- get the value from the record  --->
						<cfinvoke component="#this#" method="get#relationship.relate[x].from#" returnvariable="value" />
						
						<!--- set the value into the child object --->
						<cfinvoke component="#variables.children[item]#" method="set#relationship.relate[x].to#">
							<cfinvokeargument name="#relationship.relate[x].to#" value="#value#" />
						</cfinvoke>
							
					</cfloop>
											
				</cfif>
				
				<!--- save the child --->
				<cfset variables.children[item].save(false) />
				
			</cfif>
		</cfloop>
				
		<!--- check to see if this object has a parent.  If so, set the related fields in the parent from this child. --->
		<cfif hasParent() AND GetMetadata(_getParent()).name IS NOT "reactor.iterator.iterator">
			
			<!--- the following cfif is a stupid hack --->		
			<cfif _getParent()._getObjectMetadata().hasRelationship(_getAlias(), _getRelationshipAlias())>
				<cfset relationship = _getParent()._getObjectMetadata().getRelationship(_getAlias(), _getRelationshipAlias()) />
				
			<cfelse>
				
				<cfset relationship = _getParent()._getObjectMetadata().getRelationship(_getRelationshipAlias()) />
				
			</cfif>
			
			
			<!--- check to see if there is a relationship and if it's a hasOne relationship --->
			<cfif relationship.type IS "hasOne">
				
				<!--- set the value into the parent --->
				<cfinvoke component="#_getParent()#" method="set#relationship.alias#">
					<cfinvokeargument name="#relationship.alias#" value="#this#" />
				</cfinvoke>	
				
			</cfif>
		</cfif>
		
		<!--- clean the object --->
		<cfset clean() />
	</cffunction>
	
	<cffunction name="isInLinkedRelationship" access="private" hint="I indicate if this record is currently in a has many linked relationship." output="false" returntype="boolean">
		<cfset var Parent = 0 />
		
		<!--- does this item have a parent? --->
		<cfif hasParent()>
			<cfset Parent = _getParent() />
		<cfelse>
			<cfreturn false />
		</cfif>
		
		<!--- does the parent have a parent? --->
		<cfif _getParent().hasParent()>
			<cfset Parent = _getParent()._getParent() />
		<cfelse>
			<cfreturn false />
		</cfif>
		
		<cfif GetMetadata(Parent).name IS "reactor.iterator.iterator">
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>
		
	<!--- ErrorCollection --->
    <cffunction name="_setErrorCollection" access="private" output="false" returntype="void">
       <cfargument name="ErrorCollection" hint="I am this object's ErrorCollection" required="yes" type="reactor.util.ErrorCollection" />
       <cfset variables.ErrorCollection = arguments.ErrorCollection />
    </cffunction>
    <cffunction name="_getErrorCollection" access="public" output="false" returntype="reactor.util.ErrorCollection">
       <cfreturn variables.ErrorCollection />
    </cffunction>
	
	<!--- validated --->
	<cffunction name="validated" access="public" hint="I indicate if this object has been validated at all" output="false" returntype="boolean">
		<cfreturn IsObject(variables.ErrorCollection) />
	</cffunction>
	
	<!--- hasErrors --->
	<cffunction name="hasErrors" access="public" hint="I indicate if this object has errors or not (based in the last call to validate)" output="false" returntype="boolean">
		<cfset var item = 0 />
		
		<cfif _getErrorCollection().count() GT 0>
			<cfreturn true />
		</cfif>
		
		<!--- validate all loaded children --->
		<cfloop collection="#variables.children#" item="item">
			<!--- check to see if this child is loaded --->
			<cfif IsObject(variables.children[item]) AND variables.children[item].validated() AND variables.children[item].hasErrors()>
				<cfreturn true />
			</cfif>
		</cfloop>
		
		<cfreturn false />
	</cffunction>
	
	<!--- getDictionary --->
	<cffunction name="_getDictionary" access="public" output="false" returntype="reactor.dictionary.dictionary">
		
		<cfif NOT StructKeyExists(variables, "Dictionary")>
			<cfset variables.Dictionary = _getReactorFactory().createDictionary(_getAlias()) />
		</cfif>
		
		<cfreturn variables.Dictionary />
	</cffunction>
	
	<!--- isDeleted --->
    <cffunction name="isDeleted" hint="I indicate if this record has been deleted.  If an object has been deleted access to any of its data through its properties will throw errors." access="public" output="false" returntype="boolean">
       <cfreturn variables.deleted />
    </cffunction>
	
	<!--- parent --->
    <cffunction name="_setParent" hint="I set this record's parent.  This is for Reactor's use only.  Don't set this value.  If you set it you'll get errrors!  Don't say you weren't warned." access="public" output="false" returntype="void">
		<cfargument name="parent" hint="I am the object which loaded this record" required="yes" type="any" />
		<cfargument name="relationshipAlias" hint="I am the alias of relationship the parent has to the child" required="no" type="string" />
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
    <cffunction name="_getParent" hint="I get this record's parent.  Call hasParent before calling me in case this record doesn't have a parent." access="public" output="false" returntype="any">
       <cfreturn variables.parent />
    </cffunction>
	<cffunction name="hasParent" access="public" hint="I indicate if this object has a parent." output="false" returntype="boolean">
		<cfreturn IsObject(variables.parent) />
	</cffunction>
	<cffunction name="resetParent" access="public" hint="I remove the reference to a parent object." output="false" returntype="void">
		<cfset variables.parent = 0 />
	</cffunction>
	
	<!--- relationshipAlias --->
    <cffunction name="_setRelationshipAlias" access="private" output="false" returntype="void">
       <cfargument name="relationshipAlias" hint="I am the relationship used to relate the object's parent to it." required="yes" type="string" />
       <cfset variables.relationshipAlias = arguments.relationshipAlias />
    </cffunction>
    <cffunction name="_getRelationshipAlias" access="private" output="false" returntype="string">
       <cfreturn variables.relationshipAlias />
    </cffunction>
</cfcomponent>
