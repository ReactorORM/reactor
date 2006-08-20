
<cfcomponent hint="I am the sqlanywhere custom Gateway object for the Comment object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="CommentGateway" >
	<!--- Place custom code here, it will not be overwritten --->

	<cffunction name="setSubscriptionStatus" access="public" hint="I update the subscription status for an email address and entry." output="false" returntype="void">
		<cfargument name="emailAddress" hint="I am the email address to set the subscription status for." required="yes" type="string" />
		<cfargument name="subscribe" hint="I indicate if the user wants to subscribe or not." required="yes" type="boolean" />
		<cfargument name="entryId" hint="I am the entryId of the entry to set the subscription status for." required="no" type="numeric" default="0" />

		<cfquery datasource="#_getConfig().getDsn()#">
			UPDATE "Comment"
			SET "subscribe" = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.subscribe#" />
			WHERE "emailAddress" = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="50" value="#arguments.emailAddress#" />
				<cfif arguments.entryId>
					AND "entryId" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.entryId#" />
				</cfif>
		</cfquery>
	</cffunction>

</cfcomponent>

