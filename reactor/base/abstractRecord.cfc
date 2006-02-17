<cfcomponent hint="I am an abstract record.  I am used primarly to allow type definitions for return values.  I also loosely define an interface for a record objects and some core methods." extends="reactor.base.abstractObject">
	
	<cfset variables.To = 0 />
	<cfset variables.Dao = 0 />
	<cfset variables.ObjectFactory = 0 />
	<cfset variables.Observers = StructNew() />
	
	<cffunction name="configure" access="public" hint="I configure and return this object." output="false" returntype="reactor.base.abstractObject">
		<cfargument name="config" hint="I am the configuration object to use." required="yes" type="reactor.config.config" />
		<cfargument name="name" hint="I am the name of this object." required="yes" type="string" />
		<cfargument name="ReactorFactory" hint="I am the reactor factory." required="yes" type="reactor.reactorFactory" />
		<cfset super.configure(arguments.config, arguments.name, arguments.ReactorFactory) />
		<!---
		<cfdump var="#getMetadata(_getReactorFactory().createTo(arguments.name))#" /><cfabort>
		--->
		<cfset _setTo(_getReactorFactory().createTo(arguments.name)) />
		<cfset _setDao(_getReactorFactory().createDao(arguments.name)) />
		
		<cfreturn this />
	</cffunction>
	
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
		<cfset Observers = getObservers() />
		
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
	
	<cffunction name="createErrorCollection" access="public" hint="I return a new validationErrorCollection" output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfreturn CreateObject("Component", "reactor.util.ValidationErrorCollection").init() />
	</cffunction>
		
	<cffunction name="load" access="public" hint="I load this record." output="false" returntype="boolean">
	</cffunction>
	
	<cffunction name="save" access="public" hint="I save this record." output="false" returntype="boolean">
	</cffunction>
	
	<cffunction name="delete" access="public" hint="I delete this record." output="false" returntype="boolean">
	</cffunction>
	
</cfcomponent>