<cfcomponent hint="I am an abstract record.  I am used primarly to allow type definitions for return values.  I also loosely define an interface for a record objects and some core methods." extends="reactor.base.abstractObject">
	
	<cfset variables.To = 0 />
	<cfset variables.InitialTo = 0 />
	<cfset variables.Dao = 0 />
	<cfset variables.ObjectFactory = 0 />
	<cfset variables.Observers = StructNew() />
	<cfset variables.ErrorCollection = 0 />
	<cfset variables.children = StructNew() />
	<cfset variables.Parent = 0 />
	<cfset variables.deleted = false />
	<cfset variables.alias = "" />
		
	<cffunction name="configure" access="public" hint="I configure and return this object." output="false" returntype="reactor.base.abstractObject">
		<cfargument name="config" hint="I am the configuration object to use." required="yes" type="reactor.config.config" />
		<cfargument name="alias" hint="I am the alias of this object." required="yes" type="string" />
		<cfargument name="ReactorFactory" hint="I am the reactor factory." required="yes" type="reactor.reactorFactory" />
		<cfset super.configure(arguments.config, arguments.alias, arguments.ReactorFactory) />
		
		<cfset _setTo(_getReactorFactory().createTo(arguments.alias)) />
		<cfset _setInitialTo(_getReactorFactory().createTo(arguments.alias)) />
		<cfset _setDao(_getReactorFactory().createDao(arguments.alias)) />
		<cfset _setAlias(arguments.alias) />
		
		<cfset clean() />
		
		<cfreturn this />
	</cffunction>
		
	<!--- _getObjectMetadata --->
    <cffunction name="_getObjectMetadata" access="public" output="false" returntype="reactor.base.abstractMetadata">
       <cfreturn _getReactorFactory().createMetadata(_getName()) />
    </cffunction>
	
	<cffunction name="clean" access="public" hint="I copy the current to into the initial to.  Assuming the TOs dont have any complex objects this should cause isDirty to return false." output="false" returntype="void">
		<cfset _getInitialTo().copy(_getTo()) />
	</cffunction>	
	
	<!--- isDirty --->
	<cffunction name="isDirty" access="public" hint="I indicate if this object has been modified since it was created, loaded, saved, deleted or cleaned." output="false" returntype="boolean">
		<cfreturn NOT _getTo().isEqual(_getInitialTo()) />
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
				<cfset func = this["set#item#"] />
				<cfset func(arguments[item]) />
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
		<!--- something may go here some day --->
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
	</cffunction>
	
	<!--- beforeSave --->
	<cffunction name="beforeSave" access="private" hint="I am code executed before saving the record." output="false" returntype="void">
		<cfset var item = 0 />
		
		<cfloop collection="#variables.children#" item="item">
			<!--- check to see if this child is either a linking iteator a record --->
			<cfif IsObject(variables.children[item]) AND (
				(GetMetadata(variables.children[item]).name IS "reactor.iterator.iterator" AND variables.children[item].isLinkedIterator()) 
				OR GetMetadata(variables.children[item]).name IS NOT "reactor.iterator.iterator"
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
				
		<!--- check to see if this object has children in iterators.  If so, set the related fields in the child from this parent. --->
		<cfloop collection="#variables.children#" item="item">
			<!--- check to make sure this child is an iterator or record (links are skipped) --->
			<cfif GetMetadata(variables.children[item]).name IS "reactor.iterator.iterator" AND NOT variables.children[item].isLinkedIterator()>
				<cfset variables.children[item].relateTo(this) />
				<!--- save any loaded and dirty records in the iterator --->
				<cfset variables.children[item].save(false) />
				
			<cfelseif GetMetadata(variables.children[item]).name IS NOT "reactor.iterator.iterator">
				<!--- save the changed record --->
				<cfif IsObject(variables.children[item])>
					<cfset variables.children[item].save(false) />
				</cfif>
				
			</cfif>
		</cfloop>
		
		<!--- check to see if this object has a parent.  If so, set the related fields in the parent from this child. --->
		<cfif hasParent() AND GetMetadata(_getParent()).name IS NOT "reactor.iterator.iterator">
						
			<cfset relationship = _getParent()._getObjectMetadata().getRelationship(_getAlias()) />
			
			<!--- check to see if there is a relationship and if it's a hasOne relationship --->
			<cfif relationship.type IS "hasOne">
				<cfloop from="1" to="#ArrayLen(relationship.relate)#" index="x">
					<!--- get the value for this relationship from the child --->
					<cfinvoke component="#this#" method="get#relationship.relate[x].to#" returnvariable="value" />
					
					<!--- set the value into the parent --->
					<cfinvoke component="#_getParent()#" method="set#relationship.relate[x].from#">
						<cfinvokeargument name="#relationship.relate[x].from#" value="#value#" />
					</cfinvoke>
				</cfloop>			
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
		
	<!--- alias --->
    <cffunction name="_setAlias" access="private" output="false" returntype="void">
       <cfargument name="alias" hint="I am the alias of this object." required="yes" type="string" />
       <cfset variables.alias = arguments.alias />
    </cffunction>
    <cffunction name="_getAlias" access="public" output="false" returntype="string">
       <cfreturn variables.alias />
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
		<cfreturn _getErrorCollection().count() GT 0 />
	</cffunction>
	
	<!--- getDictionary --->
	<cffunction name="_getDictionary" access="public" output="false" returntype="reactor.dictionary.dictionary">
		<cfreturn _getReactorFactory().createDictionary(_getName()) />
	</cffunction>
	
	<!--- isDeleted --->
    <cffunction name="isDeleted" hint="I indicate if this record has been deleted.  If an object has been deleted access to any of its data through its properties will throw errors." access="public" output="false" returntype="boolean">
       <cfreturn variables.deleted />
    </cffunction>
	
	<!--- parent --->
    <cffunction name="_setParent" hint="I set this record's parent.  This is for Reactor's use only.  Don't set this value.  If you set it you'll get errrors!  Don't say you weren't warned." access="public" output="false" returntype="void">
       <cfargument name="parent" hint="I am the object which loaded this record" required="yes" type="any" />
       <cfset variables.parent = arguments.parent />
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
</cfcomponent>
