
	
<cfcomponent hint="I am the base DAO object for the Country table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractDao" >
	
	<cfset variables.signature = "208CB1E61781E239F5562C506D6BEEA6" />

	<cffunction name="save" access="public" hint="I create or update a Country record." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Country" required="yes" type="ReactorSamples.ContactManager.data.To.mssql.CountryTo" />

		
		<cfif IsNumeric(arguments.to.CountryId) AND Val(arguments.to.CountryId)>
			<cfset update(arguments.to) />
		<cfelse>
			<cfset create(arguments.to) />
		</cfif>
			
	</cffunction>
	
	
	
	<cffunction name="create" access="public" hint="I create a Country object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Country" required="yes" type="ReactorSamples.ContactManager.data.To.mssql.CountryTo" />
		<cfset var Convention = getConventions() />
		<cfset var qCreate = 0 />
		
			
		<cftransaction>
			<cfquery name="qCreate" datasource="#_getConfig().getDsn()#">
				INSERT INTO #Convention.FormatObjectName(getObjectMetadata(), '')#
				(
					
							#Convention.formatFieldName('Abbreviation', 'Country')#
							,
							#Convention.formatFieldName('Name', 'Country')#
							,
							#Convention.formatFieldName('SortOrder', 'Country')#
							
				) VALUES (
					
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="10"
							
							value="#arguments.to.Abbreviation#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="50"
							
							value="#arguments.to.Name#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_tinyint"
							
							value="#arguments.to.SortOrder#"
							 />
							
				)
				
								#Convention.lastInseredIdSyntax(getObjectMetadata())#
							</cfquery>
						
		</cftransaction>
			
		
			<cfif qCreate.recordCount>
				<cfset arguments.to.CountryId = qCreate.id />
			</cfif>
		
	</cffunction>
	
	
	<cffunction name="read" access="public" hint="I read a  Country object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Country which will be populated." required="yes" type="ReactorSamples.ContactManager.data.To.mssql.CountryTo" />
		<cfset var qRead = 0 />
		<cfset var CountryGateway = _getReactorFactory().createGateway("Country") />
		
		<cfset qRead = CountryGateway.getByFields(
			CountryId = arguments.to.CountryId
		) />
		
		<cfif qRead.recordCount>
				<cfset arguments.to.CountryId = 
				
						qRead.CountryId
				/>
			
				<cfset arguments.to.Abbreviation = 
				
						qRead.Abbreviation
				/>
			
				<cfset arguments.to.Name = 
				
						qRead.Name
				/>
			
				<cfset arguments.to.SortOrder = 
				
						qRead.SortOrder
				/>
			
		</cfif>
	</cffunction>
	
	<cffunction name="update" access="public" hint="I update a Country object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Country which will be used to update a record in the table." required="yes" type="ReactorSamples.ContactManager.data.To.mssql.CountryTo" />
		<cfset var Convention = getConventions() />
		<cfset var qUpdate = 0 />
		
		
		<cfquery name="qUpdate" datasource="#_getConfig().getDsn()#">
			UPDATE #Convention.FormatObjectName(getObjectMetadata(), '')#
			SET 
			
				#Convention.formatUpdateFieldName('Abbreviation')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="10"
					
					value="#arguments.to.Abbreviation#"
					 />
				,
				#Convention.formatUpdateFieldName('Name')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="50"
					
					value="#arguments.to.Name#"
					 />
				,
				#Convention.formatUpdateFieldName('SortOrder')# = <cfqueryparam
					cfsqltype="cf_sql_tinyint"
					
					value="#arguments.to.SortOrder#"
					 />
				
			WHERE
			
				#Convention.formatUpdateFieldName('CountryId')# = <cfqueryparam
					cfsqltype="cf_sql_smallint"
					
					value="#arguments.to.CountryId#"
					 />
				
		</cfquery>
	</cffunction>
	
	<cffunction name="delete" access="public" hint="I delete a record in the Country table." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Country which will be used to delete from the table." required="yes" type="ReactorSamples.ContactManager.data.To.mssql.CountryTo" />
		<cfset var Convention = getConventions() />
		<cfset var qDelete = 0 />
		
		
		<cfquery name="qDelete" datasource="#_getConfig().getDsn()#">
			DELETE FROM #Convention.FormatObjectName(getObjectMetadata(), '')#
			WHERE
			
				#Convention.formatFieldName('CountryId', 'Country')# = <cfqueryparam
					cfsqltype="cf_sql_smallint"
					
					value="#arguments.to.CountryId#"
					 />
				
		</cfquery>
		
		
	</cffunction>
	
</cfcomponent>
	
