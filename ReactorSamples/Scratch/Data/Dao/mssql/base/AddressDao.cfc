
	
<cfcomponent hint="I am the base DAO object for the Address table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractDao" >
	
	<cfset variables.signature = "83C36EF059D7F69183D9588239ABED3E" />

	<cffunction name="save" access="public" hint="I create or update a Address record." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Address" required="yes" type="ScratchData.To.mssql.AddressTo" />

		
		<cfif IsNumeric(arguments.to.AddressId) AND Val(arguments.to.AddressId)>
			<cfset update(arguments.to) />
		<cfelse>
			<cfset create(arguments.to) />
		</cfif>
			
	</cffunction>
	
	
	
	<cffunction name="create" access="public" hint="I create a Address object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Address" required="yes" type="ScratchData.To.mssql.AddressTo" />
		<cfset var Convention = getConventions() />
		<cfset var qCreate = 0 />
		
			
		<cftransaction>
			<cfquery name="qCreate" datasource="#_getConfig().getDsn()#">
				INSERT INTO #Convention.FormatObjectName(getObjectMetadata(), '')#
				(
					
							#Convention.formatFieldName('Street1', 'Address')#
							,
							#Convention.formatFieldName('Street2', 'Address')#
							,
							#Convention.formatFieldName('City', 'Address')#
							,
							#Convention.formatFieldName('State', 'Address')#
							,
							#Convention.formatFieldName('Zip', 'Address')#
							
				) VALUES (
					
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="50"
							
							value="#arguments.to.Street1#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="50"
							
							value="#arguments.to.Street2#"
								
								null="#Iif(NOT Len(arguments.to.Street2), DE(true), DE(false))#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="50"
							
							value="#arguments.to.City#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="50"
							
							value="#arguments.to.State#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="10"
							
							value="#arguments.to.Zip#"
							 />
							
				)
				
								#Convention.lastInseredIdSyntax(getObjectMetadata())#
						
				
				</cfquery>
		</cftransaction>
			
		
			<cfif qCreate.recordCount>
				<cfset arguments.to.AddressId = qCreate.id />
			</cfif>
		
	</cffunction>
	
	
	<cffunction name="read" access="public" hint="I read a  Address object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Address which will be populated." required="yes" type="ScratchData.To.mssql.AddressTo" />
		<cfset var qRead = 0 />
		<cfset var AddressGateway = _getReactorFactory().createGateway("Address") />
		
		<cfset qRead = AddressGateway.getByFields(
			AddressId = arguments.to.AddressId
		) />
		
		<cfif qRead.recordCount>
				<cfset arguments.to.AddressId = 
				
						qRead.AddressId
				/>
			
				<cfset arguments.to.Street1 = 
				
						qRead.Street1
				/>
			
				<cfset arguments.to.Street2 = 
				
						qRead.Street2
				/>
			
				<cfset arguments.to.City = 
				
						qRead.City
				/>
			
				<cfset arguments.to.State = 
				
						qRead.State
				/>
			
				<cfset arguments.to.Zip = 
				
						qRead.Zip
				/>
			
		</cfif>
	</cffunction>
	
	<cffunction name="update" access="public" hint="I update a Address object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Address which will be used to update a record in the table." required="yes" type="ScratchData.To.mssql.AddressTo" />
		<cfset var Convention = getConventions() />
		<cfset var qUpdate = 0 />
		
		
		<cfquery name="qUpdate" datasource="#_getConfig().getDsn()#">
			UPDATE #Convention.FormatObjectName(getObjectMetadata(), '')#
			SET 
			
				#Convention.formatUpdateFieldName('Street1')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="50"
					
					value="#arguments.to.Street1#"
					 />
				,
				#Convention.formatUpdateFieldName('Street2')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="50"
					
					value="#arguments.to.Street2#"
					
						null="#Iif(NOT Len(arguments.to.Street2), DE(true), DE(false))#"
					 />
				,
				#Convention.formatUpdateFieldName('City')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="50"
					
					value="#arguments.to.City#"
					 />
				,
				#Convention.formatUpdateFieldName('State')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="50"
					
					value="#arguments.to.State#"
					 />
				,
				#Convention.formatUpdateFieldName('Zip')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="10"
					
					value="#arguments.to.Zip#"
					 />
				
			WHERE
			
				#Convention.formatUpdateFieldName('AddressId')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.AddressId#"
					 />
				
		</cfquery>
	</cffunction>
	
	<cffunction name="delete" access="public" hint="I delete a record in the Address table." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Address which will be used to delete from the table." required="yes" type="ScratchData.To.mssql.AddressTo" />
		<cfset var Convention = getConventions() />
		<cfset var qDelete = 0 />
		
		
		<cfquery name="qDelete" datasource="#_getConfig().getDsn()#">
			DELETE FROM #Convention.FormatObjectName(getObjectMetadata(), '')#
			WHERE
			
				#Convention.formatFieldName('AddressId', 'Address')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.AddressId#"
					 />
				
		</cfquery>
		
		
	</cffunction>
	
</cfcomponent>
	
