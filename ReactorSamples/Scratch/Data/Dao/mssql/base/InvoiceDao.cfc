
	
<cfcomponent hint="I am the base DAO object for the Invoice table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractDao" >
	
	<cfset variables.signature = "4BB04E77F8C785BFEC9964C618CFF1F3" />

	<cffunction name="save" access="public" hint="I create or update a Invoice record." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Invoice" required="yes" type="ScratchData.To.mssql.InvoiceTo" />

		
		<cfif IsNumeric(arguments.to.InvoiceId) AND Val(arguments.to.InvoiceId)>
			<cfset update(arguments.to) />
		<cfelse>
			<cfset create(arguments.to) />
		</cfif>
			
	</cffunction>
	
	
	
	<cffunction name="create" access="public" hint="I create a Invoice object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Invoice" required="yes" type="ScratchData.To.mssql.InvoiceTo" />
		<cfset var Convention = getConventions() />
		<cfset var qCreate = 0 />
		
			
		<cftransaction>
			<cfquery name="qCreate" datasource="#_getConfig().getDsn()#">
				INSERT INTO #Convention.FormatObjectName(getObjectMetadata(), '')#
				(
					
							#Convention.formatFieldName('CustomerId', 'Invoice')#
							
				) VALUES (
					
							<cfqueryparam cfsqltype="cf_sql_integer"
							
							value="#arguments.to.CustomerId#"
							 />
							
				)
				
								#Convention.lastInseredIdSyntax(getObjectMetadata())#
						
				
				</cfquery>
		</cftransaction>
			
		
			<cfif qCreate.recordCount>
				<cfset arguments.to.InvoiceId = qCreate.id />
			</cfif>
		
	</cffunction>
	
	
	<cffunction name="read" access="public" hint="I read a  Invoice object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Invoice which will be populated." required="yes" type="ScratchData.To.mssql.InvoiceTo" />
		<cfset var qRead = 0 />
		<cfset var InvoiceGateway = _getReactorFactory().createGateway("Invoice") />
		
		<cfset qRead = InvoiceGateway.getByFields(
			InvoiceId = arguments.to.InvoiceId
		) />
		
		<cfif qRead.recordCount>
				<cfset arguments.to.InvoiceId = 
				
						qRead.InvoiceId
				/>
			
				<cfset arguments.to.CustomerId = 
				
						qRead.CustomerId
				/>
			
		</cfif>
	</cffunction>
	
	<cffunction name="update" access="public" hint="I update a Invoice object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Invoice which will be used to update a record in the table." required="yes" type="ScratchData.To.mssql.InvoiceTo" />
		<cfset var Convention = getConventions() />
		<cfset var qUpdate = 0 />
		
		
		<cfquery name="qUpdate" datasource="#_getConfig().getDsn()#">
			UPDATE #Convention.FormatObjectName(getObjectMetadata(), '')#
			SET 
			
				#Convention.formatUpdateFieldName('CustomerId')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.CustomerId#"
					 />
				
			WHERE
			
				#Convention.formatUpdateFieldName('InvoiceId')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.InvoiceId#"
					 />
				
		</cfquery>
	</cffunction>
	
	<cffunction name="delete" access="public" hint="I delete a record in the Invoice table." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Invoice which will be used to delete from the table." required="yes" type="ScratchData.To.mssql.InvoiceTo" />
		<cfset var Convention = getConventions() />
		<cfset var qDelete = 0 />
		
		
		<cfquery name="qDelete" datasource="#_getConfig().getDsn()#">
			DELETE FROM #Convention.FormatObjectName(getObjectMetadata(), '')#
			WHERE
			
				#Convention.formatFieldName('InvoiceId', 'Invoice')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.InvoiceId#"
					 />
				
		</cfquery>
		
		
	</cffunction>
	
</cfcomponent>
	
