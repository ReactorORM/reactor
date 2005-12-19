
	
<cfcomponent hint="I am the base DAO object for the State table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractDao" >
	
	<cfset variables.signature = "208F6ACA3B35ADF1A45F3F56E12BD13A" />

	<cffunction name="save" access="public" hint="I create or update a State record." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for State" required="yes" type="ReactorSamples.ContactManager.data.To.mssql.StateTo" />

		
		<cfif IsNumeric(arguments.to.StateId) AND Val(arguments.to.StateId)>
			<cfset update(arguments.to) />
		<cfelse>
			<cfset create(arguments.to) />
		</cfif>
			
	</cffunction>
	
	
	
	<cffunction name="create" access="public" hint="I create a State object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for State" required="yes" type="ReactorSamples.ContactManager.data.To.mssql.StateTo" />
		<cfset var Convention = getConventions() />
		<cfset var qCreate = 0 />
		
			
		<cftransaction>
			<cfquery name="qCreate" datasource="#_getConfig().getDsn()#">
				INSERT INTO #Convention.FormatObjectName(getObjectMetadata(), '')#
				(
					
							#Convention.formatFieldName('Abbreviation', 'State')#
							,
							#Convention.formatFieldName('Name', 'State')#
							
				) VALUES (
					
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="5"
							
							value="#arguments.to.Abbreviation#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="50"
							
							value="#arguments.to.Name#"
							 />
							
				)
				
								#Convention.lastInseredIdSyntax(getObjectMetadata())#
							</cfquery>
						
		</cftransaction>
			
		
			<cfif qCreate.recordCount>
				<cfset arguments.to.StateId = qCreate.id />
			</cfif>
		
	</cffunction>
	
	
	<cffunction name="read" access="public" hint="I read a  State object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for State which will be populated." required="yes" type="ReactorSamples.ContactManager.data.To.mssql.StateTo" />
		<cfset var qRead = 0 />
		<cfset var StateGateway = _getReactorFactory().createGateway("State") />
		
		<cfset qRead = StateGateway.getByFields(
			StateId = arguments.to.StateId
		) />
		
		<cfif qRead.recordCount>
				<cfset arguments.to.StateId = 
				
						qRead.StateId
				/>
			
				<cfset arguments.to.Abbreviation = 
				
						qRead.Abbreviation
				/>
			
				<cfset arguments.to.Name = 
				
						qRead.Name
				/>
			
		</cfif>
	</cffunction>
	
	<cffunction name="update" access="public" hint="I update a State object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for State which will be used to update a record in the table." required="yes" type="ReactorSamples.ContactManager.data.To.mssql.StateTo" />
		<cfset var Convention = getConventions() />
		<cfset var qUpdate = 0 />
		
		
		<cfquery name="qUpdate" datasource="#_getConfig().getDsn()#">
			UPDATE #Convention.FormatObjectName(getObjectMetadata(), '')#
			SET 
			
				#Convention.formatUpdateFieldName('Abbreviation')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="5"
					
					value="#arguments.to.Abbreviation#"
					 />
				,
				#Convention.formatUpdateFieldName('Name')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="50"
					
					value="#arguments.to.Name#"
					 />
				
			WHERE
			
				#Convention.formatUpdateFieldName('StateId')# = <cfqueryparam
					cfsqltype="cf_sql_smallint"
					
					value="#arguments.to.StateId#"
					 />
				
		</cfquery>
	</cffunction>
	
	<cffunction name="delete" access="public" hint="I delete a record in the State table." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for State which will be used to delete from the table." required="yes" type="ReactorSamples.ContactManager.data.To.mssql.StateTo" />
		<cfset var Convention = getConventions() />
		<cfset var qDelete = 0 />
		
		
		<cfquery name="qDelete" datasource="#_getConfig().getDsn()#">
			DELETE FROM #Convention.FormatObjectName(getObjectMetadata(), '')#
			WHERE
			
				#Convention.formatFieldName('StateId', 'State')# = <cfqueryparam
					cfsqltype="cf_sql_smallint"
					
					value="#arguments.to.StateId#"
					 />
				
		</cfquery>
		
		
	</cffunction>
	
</cfcomponent>
	
