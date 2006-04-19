<cfcomponent hint="I am an abstract record.  I am used primarly to allow type definitions for return values.  I also loosely define an interface for a record objects and some core methods." extends="reactor.base.abstractObject">
	
	<cfset variables.To = 0 />
	<cfset variables.InitialTo = 0 />
	<cfset variables.Dao = 0 />
	<cfset variables.ObjectFactory = 0 />
	<cfset variables.Observers = StructNew() />
	<!---<cfset variables.broadcasters = ArrayNew(1) />
	<cfset variables.listeners = ArrayNew(1) />--->
	<cfset variables.ValidationErrorCollection = 0 />
	<cfset variables.children = StructNew() />
	<cfset variables.Parent = 0 />
	<cfset variables.deleted = false />
		
	<cffunction name="configure" access="public" hint="I configure and return this object." output="false" returntype="reactor.base.abstractObject">
		<cfargument name="config" hint="I am the configuration object to use." required="yes" type="reactor.config.config" />
		<cfargument name="alias" hint="I am the alias of this object." required="yes" type="string" />
		<cfargument name="ReactorFactory" hint="I am the reactor factory." required="yes" type="reactor.reactorFactory" />
		<cfset super.configure(arguments.config, arguments.alias, arguments.ReactorFactory) />
		
		<cfset _setTo(_getReactorFactory().createTo(arguments.alias)) />
		<cfset _setInitialTo(_getReactorFactory().createTo(arguments.alias)) />
		<cfset _setDao(_getReactorFactory().createDao(arguments.alias)) />
		
		<cfset clean() />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="dumpparent">
		<cfdump var="#getParent()#"/><cfabort>
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
	
	<!--- beforeLoad --->
	<cffunction name="beforeLoad" access="private" hint="I am code executed before loading the record." output="false" returntype="void">
		<!--- something may go here some day --->
	</cffunction>
	
	<!--- afterLoad --->
	<cffunction name="afterLoad" access="private" hint="I am code executed after loading the record." output="false" returntype="void">
		<!--- clean the object --->
		<cfset clean() />
	</cffunction>
	
	<!--- beforeDelete --->
	<cffunction name="beforeDelete" access="private" hint="I am code executed before deleting the record." output="false" returntype="void">
		<!--- <cfset var relationship = 0 />
		<cfset var x = 0 />
		<cfset var nullable = true />
		<cfset var parentMetadata = 0 />
		<cfset var linkMetadata = 0 />
		<cfset var LinkedIterator = 0 />
		<cfset var To = 0 />
		
		This record may have:
			- no parent:
				do nothing
			- a record parent:
				this is a result of a hasOne relationship.  if the parent has one of this record and that field can be null, null it.  
				otherwise delete the parent. (I hope that's right!!!! - may add a cascade argument to the record's delete method)
			- an iterator parent:
				this is a result of a hasMany (not linking) relationship.  In this case do nothing.  The object will automatically
				disappear from the iterator				
		<!--- check to see if this object has a parent.  If so, get the relationship the parent has to this child. --->
		<cfif hasParent() AND GetMetadata(getParent()).name IS NOT "reactor.iterator.iterator">

			<!--- get the parent's metadata --->
			<cfset parentMetadata = getParent()._getObjectMetadata() />
						
			<!--- get this object's relationship with its parent --->
			<cfset relationship = parentMetadata.getRelationship(_getObjectMetadata().getAlias()) />
			
			<!--- check to see if the parent's relationships can be nulled --->
			<cfloop from="1" to="#ArrayLen(relationship.relate)#" index="x">
				<!--- check to see if the parent's field can be nulled --->
				<cfif NOT parentMetadata.getField(relationship.relate[x].from).nullable>
					<cfset nullable = false />
					<cfbreak />
				</cfif>
			</cfloop>
			
			<cfif nullable>
				<!--- null all relationships --->
				<cfloop from="1" to="#ArrayLen(relationship.relate)#" index="x">
					<cfinvoke component="#getParent()#" method="set#relationship.relate[x].from#">
						<cfinvokeargument name="#relationship.relate[x].from#" value="" />
					</cfinvoke>
				</cfloop>
				
			<cfelse>
				<!--- delete the parent.  (By running the next line of code you agree not to sue Doug if something goes horribly wrong.) --->
				<cfset getParent().delete() />
				
			</cfif>
		
		</cfif>
		--->
	</cffunction>
	
	<!--- afterDelete --->
	<cffunction name="afterDelete" access="private" hint="I am code executed after deleting the record." output="false" returntype="void">
		<!--- reset the to --->
		<cfset _setTo(_getReactorFactory().createTo(_getObjectMetadata().getAlias())) />
		<!--- clean the object --->
		<cfset clean() />
		<!--- set the deleted status of this cfc --->
		<cfset variables.deleted = true />
	</cffunction>
	
	<cffunction name="isInLinkedRelationship" access="private" hint="I indicate if this record is currently in a has many linked relationship." output="false" returntype="boolean">
		<cfset var Parent = 0 />
		
		<!--- does this item have a parent? --->
		<cfif hasParent()>
			<cfset Parent = getParent() />
		<cfelse>
			<cfreturn false />
		</cfif>
		
		<!--- does the parent have a parent? --->
		<cfif getParent().hasParent()>
			<cfset Parent = getParent().getParent() />
		<cfelse>
			<cfreturn false />
		</cfif>
		
		<cfif GetMetadata(Parent).name IS "reactor.iterator.iterator">
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>
	
	<!--- beforeSave --->
	<cffunction name="beforeSave" access="private" hint="I am code executed before saving the record." output="false" returntype="void">
		<cfset var item = 0 />
		<cfset var relationship = 0 />
		<cfset var x = 0 />
		<cfset var value = 0 />
		
		<cfloop collection="#variables.children#" item="item">
			<!--- check to see if this child is either a linking iteator a record --->
			<cfif (GetMetadata(variables.children[item]).name IS "reactor.iterator.iterator" AND variables.children[item].isLinkedIterator()) 
				OR GetMetadata(variables.children[item]).name IS NOT "reactor.iterator.iterator" >
			
				<!--- save the child. --->
				<cfset variables.children[item].save() />
			
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
				<cfset variables.children[item].save() />
				
			<cfelseif GetMetadata(variables.children[item]).name IS NOT "reactor.iterator.iterator">
				<!--- save the changed record --->
				<cfset variables.children[item].save() />
				
			</cfif>
		</cfloop>
		
		<!--- check to see if this object has a parent.  If so, set the related fields in the parent from this child. --->
		<cfif hasParent() AND GetMetadata(getParent()).name IS NOT "reactor.iterator.iterator">
						
			<cfset relationship = getParent()._getObjectMetadata().getRelationship(_getObjectMetadata().getAlias()) />
			
			<!--- check to see if there is a relationship and if it's a hasOne relationship --->
			<cfif relationship.type IS "hasOne">
				<cfloop from="1" to="#ArrayLen(relationship.relate)#" index="x">
					<!--- get the value for this relationship from the child --->
					<cfinvoke component="#this#" method="get#relationship.relate[x].from#" returnvariable="value" />
					
					<!--- set the value into the parent --->
					<cfinvoke component="#getParent()#" method="set#relationship.relate[x].from#">
						<cfinvokeargument name="#relationship.relate[x].from#" value="#value#" />
					</cfinvoke>
				</cfloop>			
			</cfif>
		</cfif>
		
		<!--- clean the object --->
		<cfset clean() />
	</cffunction>
	
	<cffunction name="createErrorCollection" access="public" hint="I return a new validationErrorCollection" output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfreturn CreateObject("Component", "reactor.util.ValidationErrorCollection").init() />
	</cffunction>
		
	<cffunction name="load" access="public" hint="I load this record." output="false" returntype="boolean">
	</cffunction>
	
	<cffunction name="save" access="public" hint="I save this record." output="false" returntype="boolean">
	</cffunction>
	
	<cffunction name="delete" access="public" hint="I delete this record." output="false" returntype="boolean">
	</cffunction>
	
	<!--- validationErrorCollection --->
    <cffunction name="_setValidationErrorCollection" access="private" output="false" returntype="void">
       <cfargument name="validationErrorCollection" hint="I am this object's ValidationErrorCollection" required="yes" type="reactor.util.ValidationErrorCollection" />
       <cfset variables.validationErrorCollection = arguments.validationErrorCollection />
    </cffunction>
    <cffunction name="_getValidationErrorCollection" access="public" output="false" returntype="reactor.util.ValidationErrorCollection">
       <cfreturn variables.validationErrorCollection />
    </cffunction>
	
	<!--- validated --->
	<cffunction name="validated" access="public" hint="I indicate if this object has been validated at all" output="false" returntype="boolean">
		<cfreturn IsObject(variables.validationErrorCollection) />
	</cffunction>
	
	<!--- hasErrors --->
	<cffunction name="hasErrors" access="public" hint="I indicate if this object has errors or not (based in the last call to validate)" output="false" returntype="boolean">
		<cfreturn _getValidationErrorCollection().hasErrors() />
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

<!--- addBroadcaster
	<cffunction name="addBroadcaster" access="public" hint="I add a broadcaster to this object. As events occur they are broadcast to this record." output="false" returntype="void">
		<cfargument name="Broadcaster" hint="I am the record that is listening for events from this record." required="yes" type="reactor.base.abstractRecord" />
		
	</cffunction> --->
	
	<!---<!--- addListener --->
	<cffunction name="addListener" access="public" hint="I add a listener to this object.  As events occur they are broadcast to listeners." output="false" returntype="void">
		<cfargument name="Listener" hint="I am the record that is listening for events from this record." required="yes" type="reactor.base.abstractRecord" />
		
		<!--- create a connection object which will connect the listner to this object --->
		<cfset var Connection = CreateObject("Component", "reactor.event.connection").init(this, arguments.listener) />
		
		<!--- add the connection to both objects --->
		<cfset addConnection(Connection) />
		<cfset arguments.Listener.addConnection(Connection) />
				
	</cffunction>--->
	
	<!--- attachDelegate
	<cffunction name="attachDelegate" access="public" hint="I attach a delegate which will listen for specific events.  Default events are: beforeValidate, afterValidate, beforeSave, afterSave, beforeLoad, afterLoad, beforeDelete, afterDelete" output="false" returntype="void">
		<cfargument name="event" hint="I am the name of the event being listened for." required="yes" type="string" />
		<cfargument name="object" hint="I am the object which contains the delegate." required="yes" type="reactor.base.abstractRecord" />
		<cfargument name="method" hint="I the name of a method on the object being delegated to handle this event." required="yes" type="any" />
		<cfset var Observers = getObservers() />
		<cfset var delegates = 0 />
		<cfset var delegate = CreateObject("Component", "reactor.event.delegate").init(arguments.object, arguments.method) />
		<cfset var x = 0 />
		
		<!--- check to see if there are any delegates for this event --->
		<cfif StructKeyExists(Observers, arguments.event)>
			<cfset delegates = Observers[arguments.event] />
		<cfelse>
			<cfset delegates = ArrayNew(1) />
		</cfif>
						
		<!--- make sure this delegate hasn't already been attached --->
		<cfloop from="1" to="#ArrayLen(delegates)#" index="x">
			<cfif delegates[x].getSignature() IS delegate.getSignature()>
				<cfreturn />
			</cfif>
		</cfloop>
		
		<!--- attach the delegate --->
		<cfset ArrayAppend(delegates, delegate) />
				
		<!--- add it into the obveservers --->
		<cfset Observers[arguments.event]  = delegates />
	</cffunction> --->
	
	<!--- detachDelegate
	<cffunction name="detachDelegate" access="public" hint="I detach a delegate from an event." output="false" returntype="void">
		<cfargument name="event" hint="I am the name of the event being listened for." required="yes" type="string" />
		<cfargument name="object" hint="I am the object which contains the delegate." required="yes" type="reactor.base.abstractRecord" />
		<cfargument name="method" hint="I the name of a method on the object being delegated to handle this event." required="yes" type="any" />
		<cfset var Observers = getObservers() />
		<cfset var delegates = Observers[arguments.event] />
		<cfset var delegate = CreateObject("Component", "reactor.event.delegate").init(arguments.object, arguments.method) />
		<cfset var x = 0 />
				
		<cfloop from="1" to="#ArrayLen(delegates)#" index="x">
			<cfif delegates[x].getSignature() IS delegate.getSignature()>
				<cfset ArrayDeleteAt(delegates, x) />
				<cfbreak />
			</cfif>
		</cfloop>
		
		<cfset Observers[arguments.event] = delegates />
	</cffunction> --->
	
	<!--- detatchAllDelegates
	<cffunction name="detatchAllDelegates" access="public" hint="I detach all delegates.  If an even is passed it only delegates for that event are removed." output="false" returntype="void">
		<cfargument name="event" hint="I am the name of the event being listened for." required="no" default="" type="string" />
		<cfset var Observers = getObservers() />
		
		<cfif Len(arguments.event)>
			<cfset StructDelete(Observers, arguments.event) />
		<cfelse>
			<cfset StructClear(Observers) />
		</cfif>
	</cffunction> --->
	
	<!--- newEvent
	<cffunction name="newEvent" access="public" hint="I create and return a new event" output="false" returntype="reactor.event.event">
		<cfargument name="name" hint="I am the name of the event" required="yes" type="string" />
		<cfreturn CreateObject("Component", "reactor.event.event").init(arguments.name, this) />
	</cffunction> --->
	
	<!--- announceEvent
	<cffunction name="announceEvent" access="public" hint="I announce an event to observers." output="false" returntype="void">
		<cfargument name="Event" hint="I am the event being announced." required="yes" type="reactor.event.event" /> 
		<!--- get the Observers --->
		<cfset var Observers = getObservers() />
		<cfset var delegates = ArrayNew(1) />
		<cfset var x = 0 />
		<cfset var delegate = 0 />
		
		<cfif StructKeyExists(Observers, arguments.Event.getName())>
			<cfset delegates = Observers[arguments.Event.getName()] />
		</cfif>

		<cfloop from="1" to="#ArrayLen(delegates)#" index="x">
			<cfset delegate = delegates[x] />
			<cfset delegate.execute(arguments.event) />
		</cfloop>
	</cffunction> --->
	
	<!--- observers
    <cffunction name="setObservers" access="private" output="false" returntype="void">
       <cfargument name="observers" hint="I am an array of observers watching this record" required="yes" type="struct" />
       <cfset variables.observers = arguments.observers />
    </cffunction>
    <cffunction name="getObservers" access="private" output="false" returntype="struct">
       <cfreturn variables.observers />
    </cffunction> --->
	
	<!---
	<!--- beforeDelete --->
	<cffunction name="beforeDelete" access="private" hint="I am code executed before deleting the record." output="false" returntype="void">
		<cfset var relationship = 0 />
		<cfset var x = 0 />
		<!---<cfset var To = 0 />
 		<cfset var linkName = 0 />
		<cfset var LinkRoot = 0 />
		<cfset var LinkIterator = 0 />--->
		
		<!---<cfif isInLinkedRelationship()>
			<!---<cfset LinkRoot = getParent().getParent().getParent() />
			
			<cfset linkName = getParent().getParent().getAlias() />
			<cfinvoke component="#LinkRoot#" method="get#linkName#Iterator" returnvariable="LinkIterator" />
			<cfset LinkIterator.delete(getParent()) />
			
			<cfset linkName = _getObjectMetadata().getAlias() />
			<cfinvoke component="#LinkRoot#" method="get#linkName#Iterator" returnvariable="LinkIterator" />
			<cfset LinkIterator.remove(this) />--->
			
		<cfelse>--->
		
		<!--- check to see if this object has a parent.  If so, get the relationship the parent has to this child. --->
		<cfif hasParent() AND GetMetadata(getParent()).name IS NOT "reactor.iterator.iterator">
						
			<!--- get this object's relationship with its parent --->
			<cfset relationship = getParent()._getObjectMetadata().getRelationship(_getObjectMetadata().getAlias()) />
			
			<!--- remove this item from it's parent --->
			<cfloop from="1" to="#ArrayLen(relationship.relate)#" index="x">
				<cfinvoke component="#getParent()#" method="set#relationship.relate[x].from#">
					<cfinvokeargument name="#relationship.relate[x].from#" value="" />
				</cfinvoke>
			</cfloop>
			
		<!---<cfelseif hasParent() AND GetMetadata(getParent()).name IS "reactor.iterator.iterator">
			<!--- get this object's relationship with its parent --->
			<cfset relationship = getParent().getParent()._getObjectMetadata().getRelationship(_getObjectMetadata().getAlias()) />
			
			<!--- Because this object is being deleted we need to remove it from the iterator.  To do so we'll pass this into the iterator's remove method. --->
			<cfset getParent().remove(this) />--->
		</cfif>
			
		<!---</cfif>--->
		
	</cffunction>--->