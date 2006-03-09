
<cfcomponent hint="I am the db2 custom Gateway object for the EntryCategory object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="EntryCategoryGateway" >
	<!--- Place custom code here, it will not be overwritten --->
	
	<cffunction name="deleteByEntryId" access="public" hint="I delete all associations for an entry" output="false" returntype="void">
		<cfargument name="entryId" hint="I am the id of the entry to delete categories for" required="yes" type="numeric" />
		<cfquery datasource="#_getConfig().getDsn()#">
			DELETE FROM "NULLID"."EntryCategory"
			WHERE "entryId" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.entryId#" />
		</cfquery>
	</cffunction>
</cfcomponent>
	
