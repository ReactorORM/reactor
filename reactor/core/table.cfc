<cfcomponent hint="I represent metadata about a table.">

	<cfset variables.config = "" />
	<cfset variables.name = "" />
	<cfset variables.superRelationshipName = "" />
	
	<cfset variables.columns = ArrayNew(1) />
	<cfset variables.primaryKey = 0 />
	<cfset variables.foreignKeys = ArrayNew(1) />
	<cfset variables.referencingKeys = ArrayNew(1) />
	<cfset variables.SuperTable = 0 />
	
	<cffunction name="init" access="public" hint="I configure the table." returntype="reactor.core.table">
		<cfargument name="config" hint="I am a reactor config object" required="yes" type="reactor.bean.config" />
		<cfargument name="name" hint="I am a mapping to the location where objects are created." required="yes" type="string" />
		
		<cfset setConfig(arguments.config) />
		<cfset setName(arguments.name) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addColumn" access="public" hint="I add a column to this table." output="false" returntype="void">
		<cfargument name="column" hint="I am the column to add" required="yes" type="reactor.core.column" />
		<cfset var columns = getColumns() />
		<cfset columns[ArrayLen(columns) + 1] = arguments.column />
		<cfset setColumns(columns) />
	</cffunction>

	<cffunction name="getColumn" access="public" hint="I return a specific column." output="false" returntype="reactor.core.column">
		<cfargument name="name" hint="I am the name of the column to return" required="yes" type="string" />
		<cfset var columns = getColumns() />
		<cfset var x = 1 />
		
		<cfloop from="1" to="#ArrayLen(columns)#" index="x">
			<cfif columns[x].getName() IS arguments.name>
				<cfreturn columns[x] />
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="addForeignKey" access="public" hint="I add a foreign key to this table." output="false" returntype="void">
		<cfargument name="foreignKey" hint="I am the foreign key to add" required="yes" type="reactor.core.key" />
		<cfset var foreignKeys = getForeignKeys() />
		<cfset foreignKeys[ArrayLen(foreignKeys) + 1] = arguments.foreignKey />
		<cfset setForeignKeys(foreignKeys) />
	</cffunction>

	<cffunction name="getForeignKey" access="public" hint="I return a specific foreign key." output="false" returntype="reactor.core.key">
		<cfargument name="name" hint="I am the name of the foreign key to return" required="yes" type="string" />
		<cfset var foreignKeys = getForeignKeys() />
		<cfset var x = 1 />
		
		<cfloop from="1" to="#ArrayLen(foreignKeys)#" index="x">
			<cfif foreignKeys[x].getName() IS arguments.name>
				<cfreturn foreignKeys[x] />
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="addReferencingKey" access="public" hint="I add a foreign key to this table." output="false" returntype="void">
		<cfargument name="referencingKey" hint="I am the foreign key to add" required="yes" type="reactor.core.key" />
		<cfset var referencingKeys = getReferencingKeys() />
		<cfset referencingKeys[ArrayLen(referencingKeys) + 1] = arguments.referencingKey />
		<cfset setReferencingKeys(referencingKeys) />
	</cffunction>

	<cffunction name="getReferencingKey" access="public" hint="I return a specific foreign key." output="false" returntype="reactor.core.key">
		<cfargument name="name" hint="I am the name of the foreign key to return" required="yes" type="string" />
		<cfset var referencingKeys = getReferencingKeys() />
		<cfset var x = 1 />
		
		<cfloop from="1" to="#ArrayLen(referencingKeys)#" index="x">
			<cfif referencingKeys[x].getName() IS arguments.name>
				<cfreturn referencingKeys[x] />
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="getBaseDaoSuper" access="public" hint="I return the name of the super object for this Dao." output="false" returntype="string">
		<cfif hasSuperTable()>
			<!--- determine the super To object's name --->
			<cfreturn getCreationRoot() & ".Dao." & getConfig().getDbType() & "." & getSuperTable().getToTableName() & "Dao"  />
		<cfelse>
			<cfreturn "reactor.base.abstractDao" />
		</cfif>
	</cffunction>

	<cffunction name="getBaseGatewaySuper" access="public" hint="I return the name of the super object for this Gateway." output="false" returntype="string">
		<cfif hasSuperTable()>
			<!--- determine the super To object's name --->
			<cfreturn getCreationRoot() & ".Gateway." & getConfig().getDbType() & "." & getSuperTable().getToTableName() & "Gateway"  />
		<cfelse>
			<cfreturn "reactor.base.abstractGateway" />
		</cfif>
	</cffunction>

	<cffunction name="getBaseRecordSuper" access="public" hint="I return the name of the super object for this Record." output="false" returntype="string">
		<cfif hasSuperTable()>
			<!--- determine the super To object's name --->
			<cfreturn getCreationRoot() & ".Record." & getConfig().getDbType() & "." & getSuperTable().getToTableName() & "Record"  />
		<cfelse>
			<cfreturn "reactor.base.abstractRecord" />
		</cfif>
	</cffunction>

	<cffunction name="getBaseToSuper" access="public" hint="I return the name of the super object for this To." output="false" returntype="string">
		<cfif hasSuperTable()>
			<!--- determine the super To object's name --->
			<cfreturn getCreationRoot() & ".TO." & getConfig().getDbType() & "." & getSuperTable().getToTableName() & "TO"  />
		<cfelse>
			<cfreturn "reactor.base.abstractTo" />
		</cfif>
	</cffunction>
	
	<cffunction name="getCustomDaoSuper" access="public" hint="I return the name of the super object for this custom Dao" output="false" returntype="string">
		<cfreturn getCreationRoot() & ".Dao." & getConfig().getDbType() & ".base." & getName() & "Dao"  />
	</cffunction>
	
	<cffunction name="getCustomGatewaySuper" access="public" hint="I return the name of the super object for this custom Gateway" output="false" returntype="string">
		<cfreturn getCreationRoot() & ".Gateway." & getConfig().getDbType() & ".base." & getName() & "Gateway"  />
	</cffunction>
	
	<cffunction name="getCustomRecordSuper" access="public" hint="I return the name of the super object for this customRecord" output="false" returntype="string">
		<cfreturn getCreationRoot() & ".Record." & getConfig().getDbType() & ".base." & getName() & "Record"  />
	</cffunction>
	
	<cffunction name="getCustomToSuper" access="public" hint="I return the name of the super object for this custom To" output="false" returntype="string">
		<cfreturn getCreationRoot() & ".TO." & getConfig().getDbType() & ".base." & getName() & "TO"  />
	</cffunction>
	
	<cffunction name="getCreationRoot" access="private" hint="I return the creation path as the root portion of an object's package." output="false" returntype="string">
		<cfreturn replaceNoCase(right(getConfig().getCreationPath(), Len(getConfig().getCreationPath()) - 1), "/", ".") />
	</cffunction>
	
	<!--- 
	<cffunction name="getSuperTableName" hint="I return the name, if any of this table's super table." output="false" returntype="string">
		<cfif Len(getSuperRelationshipName())>
			<cfreturn getForeignKey(getSuperRelationshipName()).getToTableName() />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>
	--->
	
	<cffunction name="hasSuperTable" hint="I indicate if this Table has a superTable" output="false" returntype="boolean">
		<cfif IsObject(variables.superTable)>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>
	
	<!----
	<cffunction name="getSuperRelationshipName" hint="I return the name, if any of this table's super relationship." output="false" returntype="string">
		<cfset var superRelationshipName = variables.superRelationshipName />
		<cfset var pkColumns = 0 />
		<cfset var foreignKeys = 0 />
		<cfset var column = 0 />
		<cfset var listPos = 0 />
		
		<!--- check to see if the entire primary key is represented in a single foreign key --->
		<cfif hasPrimaryKey() AND NOT Len(superRelationshipName)>
			<!--- get the array of foreign keys --->
			<cfset foreignKeys = getForeignKeys() />
			
			<!--- loop over the array offoreign keys --->
			<cfloop from="1" to="#ArrayLen(foreignKeys)#" index="x">
				<!--- for each foreign key, get the primary key and foreign key colum names to compare --->
				<cfset pkColumns = getPrimaryKey().getColumnNames() />
				<cfset fkColumns = foreignKeys[x].getFromColumnNames() />
				
				<!--- loop over the fkColumns and delete matching columns from the primary key.  if the pk is 0 len then we have a match --->
				<cfloop list="#fkColumns#" index="column">
					<!--- find the position of this colum in the fk column list --->
					<cfset listPos = ListFindNoCase(pkColumns, column) />
					<!--- if the position exists, delete the item from the list --->
					<cfif listPos>
						<cfset pkColumns = ListDeleteAt(pkColumns, listPos) />
					</cfif>
					<!--- if the list has a zero length then we have a match --->
					<cfif NOT Len(pkColumns)>
						<cfset superRelationshipName = foreignKeys[x].getName() />
						<cfbreak />
					</cfif>					
				</cfloop>
				
				<cfif Len(superRelationshipName)>
					<cfbreak />
				</cfif>
			</cfloop>
		</cfif>
	
		<cfreturn superRelationshipName />
	</cffunction> --->

	<cffunction name="hasPrimaryKey" access="public" hint="I indicate if this table has a primary key" output="false" returntype="boolean">
		<cfif IsNumeric(variables.primaryKey)>
			<cfreturn false />
		<cfelse>
			<cfreturn true />
		</cfif>
	</cffunction>
	
	<!--- superTable --->
    <cffunction name="setSuperTable" access="public" output="false" returntype="void">
       <cfargument name="superTable" hint="I am this table's super table." required="yes" type="reactor.core.superTable" />
       <cfset variables.superTable = arguments.superTable />
    </cffunction>
    <cffunction name="getSuperTable" access="public" output="false" returntype="reactor.core.superTable">
       <cfreturn variables.superTable />
    </cffunction>
	
	<!--- referencingKeys --->
    <cffunction name="setReferencingKeys" access="public" output="false" returntype="void">
       <cfargument name="referencingKeys" hint="I am an array of foreign keys on other tables which reference this table." required="yes" type="array" />
       <cfset variables.referencingKeys = arguments.referencingKeys />
    </cffunction>
    <cffunction name="getReferencingKeys" access="public" output="false" returntype="array">
       <cfreturn variables.referencingKeys />
    </cffunction>
	
	<!--- foreignKeys --->
    <cffunction name="setForeignKeys" access="public" output="false" returntype="void">
       <cfargument name="foreignKeys" hint="I am an array of foreign keys on this table, referring to other tables." required="yes" type="array" />
       <cfset variables.foreignKeys = arguments.foreignKeys />
    </cffunction>
    <cffunction name="getForeignKeys" access="public" output="false" returntype="array">
       <cfreturn variables.foreignKeys />
    </cffunction>
	
	<!--- primaryKey --->
    <cffunction name="setPrimaryKey" access="public" output="false" returntype="void">
       <cfargument name="primaryKey" hint="I am the table's primary key" required="yes" type="reactor.core.primaryKey" />
       <cfset variables.primaryKey = arguments.primaryKey />
    </cffunction>
    <cffunction name="getPrimaryKey" access="public" output="false" returntype="reactor.core.primaryKey">
       <cfreturn variables.primaryKey />
    </cffunction>
	
	<!--- columns --->
    <cffunction name="setColumns" access="public" output="false" returntype="void">
       <cfargument name="columns" hint="I am this table's columns" required="yes" type="array" />
       <cfset variables.columns = arguments.columns />
    </cffunction>
    <cffunction name="getColumns" access="public" output="false" returntype="array">
       <cfreturn variables.columns />
    </cffunction>
	
	<!--- name --->
    <cffunction name="setName" access="public" output="false" returntype="void">
       <cfargument name="name" hint="I am the name of the table" required="yes" type="string" />
       <cfset variables.name = arguments.name />
    </cffunction>
    <cffunction name="getName" access="public" output="false" returntype="string">
       <cfreturn variables.name />
    </cffunction>
	
	<!--- config --->
    <cffunction name="setConfig" access="public" output="false" returntype="void">
       <cfargument name="config" hint="I am the config object used to configure reactor" required="yes" type="reactor.bean.config" />
       <cfset variables.config = arguments.config />
    </cffunction>
    <cffunction name="getConfig" access="public" output="false" returntype="reactor.bean.config">
       <cfreturn variables.config />
    </cffunction>

</cfcomponent>