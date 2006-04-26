
<cfcomponent hint="I am the database agnostic custom Record object for the Address table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.ContactManager.Record.AddressRecord" >
	<!--- Place custom code here, it will not be overwritten --->
	
	
	
	<cffunction name="format" access="public" hint="I am a custom method created to demonstrate how to extend and customize Reactor created objects" output="false" returntype="string">
		<cfset var format = "" />
		
		<cfoutput>
			<cfsavecontent variable="format">
				#getLine1()#<br>
				<cfif Len(getLine2())>
					#getLine2()#<br>
				</cfif>
				#getCity()#, #getState().getAbbreviation()# #getPostalCode()#<br>
				#getCountry().getName()#
			</cfsavecontent>
		</cfoutput>
		
		<cfreturn format />
	</cffunction>
	
</cfcomponent>
	
