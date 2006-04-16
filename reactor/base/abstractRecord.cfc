<cfcomponent hint="I am an abstract record.  I am used primarly to allow type definitions for return values.  I also loosely define an interface for a record objects and some core methods." extends="reactor.base.abstractObject">
	
	<cfset variables.To = 0 />
	<cfset variables.Dao = 0 />
	<cfset variables.ObjectFactory = 0 />
	<cfset variables.Observers = StructNew() />
	<!---<cfset variables.broadcasters = ArrayNew(1) />
	<cfset variables.listeners = ArrayNew(1) />--->
	<cfset variables.ValidationErrorCollection = 0 />
	<cfset variables.hasOne = StructNew() />
		
	<cffunction name="configure" access="public" hint="I configure and return this object." output="false" returntype="reactor.base.abstractObject">
		<cfargument name="config" hint="I am the configuration object to use." required="yes" type="reactor.config.config" />
		<cfargument name="alias" hint="I am the alias of this object." required="yes" type="string" />
		<cfargument name="ReactorFactory" hint="I am the reactor factory." required="yes" type="reactor.reactorFactory" />
		<cfset super.configure(arguments.config, arguments.alias, arguments.ReactorFactory) />
		<!---
		<cfdump var="#getMetadata(_getReactorFactory().createTo(arguments.name))#" /><cfabort>
		--->
		<cfset _setTo(_getReactorFactory().createTo(arguments.alias)) />
		<cfset _setDao(_getReactorFactory().createDao(arguments.alias)) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- _getObjectMetadata --->
    <cffunction name="_getObjectMetadata" access="public" output="false" returntype="reactor.base.abstractMetadata">
       <cfreturn _getReactorFactory().createMetadata(_getName()) />
    </cffunction>	
	
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
	
	<!--- attachDelegate --->
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
	</cffunction>
	
	<!--- detachDelegate --->
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
	</cffunction>
	
	<!--- detatchAllDelegates --->
	<cffunction name="detatchAllDelegates" access="public" hint="I detach all delegates.  If an even is passed it only delegates for that event are removed." output="false" returntype="void">
		<cfargument name="event" hint="I am the name of the event being listened for." required="no" default="" type="string" />
		<cfset var Observers = getObservers() />
		
		<cfif Len(arguments.event)>
			<cfset StructDelete(Observers, arguments.event) />
		<cfelse>
			<cfset StructClear(Observers) />
		</cfif>
	</cffunction>
	
	<!--- newEvent --->
	<cffunction name="newEvent" access="public" hint="I create and return a new event" output="false" returntype="reactor.event.event">
		<cfargument name="name" hint="I am the name of the event" required="yes" type="string" />
		<cfreturn CreateObject("Component", "reactor.event.event").init(arguments.name, this) />
	</cffunction>
	
	<!--- announceEvent --->
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
	</cffunction>
	
	<!--- observers --->
    <cffunction name="setObservers" access="private" output="false" returntype="void">
       <cfargument name="observers" hint="I am an array of observers watching this record" required="yes" type="struct" />
       <cfset variables.observers = arguments.observers />
    </cffunction>
    <cffunction name="getObservers" access="private" output="false" returntype="struct">
       <cfreturn variables.observers />
    </cffunction>
	
	<!--- genericEventHandler --->
	<cffunction name="genericEventHandler" access="public" hint="I an a generic event handler.  I am used to automatically handle certian events." output="false" returntype="void">
		<cfargument name="Event" hint="I am the event that is being handled." required="yes" type="string" />
		
		
		
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
	
</cfcomponent>