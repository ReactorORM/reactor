<cfcomponent hint="I am a component which translates a table object into an xml document">

	<cfset variables.Table = 0 />
	<cfset variables.Config = 0 />
	
	<cffunction name="init" access="public" hint="I configure and return the tableTranslator" output="false" returntype="reactor.core.tableTranslator">
		<cfargument name="config" hint="I am a reactor config object" required="yes" type="reactor.bean.config" />
		<cfargument name="name" hint="I am a mapping to the location where objects are created." required="yes" type="string" />
		<cfset var Table = CreateObject("Component", "reactor.core.table").init(arguments.config, arguments.name) />
		<cfset var TableDao = CreateObject("Component", "reactor.data.#arguments.config.getDbType()#.TableDao").init(arguments.config.getDsn()) />
		<cfset TableDao.read(Table) />
		
		<cfset setConfig(arguments.config) />
		<cfset setTable(Table) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getSignature" access="public" hint="I get this table's signature" output="false" returntype="string">
		<cfreturn getXml().table.XmlAttributes.signature />
	</cffunction>
		
	<cffunction name="getXml" access="public" hint="I return this table expressed as an XML document" output="false" returntype="string">
		<cfset var structure = 0 />
		<cfset var Table = getTable() />
		<cfset var Columns = Table.getColumns() />
		<cfset var Column = 0 />
		<cfset var ForeignKeys = Table.getForeignKeys() />
		<cfset var ForeignKey = 0 />
		<cfset var ReferencingKeys = Table.getReferencingKeys() />
		<cfset var ReferencingKey = 0 />
		<cfset var RelationShips = 0 />
		<cfset var x = 0 />
		<cfset var y = 0 />
					
		<cfsavecontent variable="structure">
			<cfoutput>
				<table
					name="#Table.getName()#"
					dbType="#getConfig().getDbType()#"
					
					baseToSuper="#Table.getBaseToSuper()#"
					baseDaoSuper="#Table.getBaseDaoSuper()#"
					baseGatewaySuper="#Table.getBaseGatewaySuper()#"
					baseRecordSuper="#Table.getBaseRecordSuper()#"
					
					customToSuper="#Table.getCustomToSuper()#"
					customDaoSuper="#Table.getCustomDaoSuper()#"
					customGatewaySuper="#Table.getCustomGatewaySuper()#"
					customRecordSuper="#Table.getCustomRecordSuper()#">
					
					<columns>
						<cfloop from="1" to="#ArrayLen(Columns)#" index="x">
							<cfset Column = Columns[x] />
							<column name="#Column.getName()#"
								type="#Column.getDataType()#"
								cfSqlType="#Column.getCfSqlType()#"
								identity="#Column.getIdentity()#"
								nullable="#Column.getNullable()#"
								length="#Column.getLength()#"
								default="#XMLFormat(Column.getDefault())#"
								primaryKey="#Column.getPrimaryKey()#"/>
						</cfloop>
					</columns>
					
					<foreignKeys>
						<cfloop from="1" to="#ArrayLen(ForeignKeys)#" index="x">
							<cfset ForeignKey = ForeignKeys[x] />
							<foreignKey name="#ForeignKey.getName()#"
								table="#ForeignKey.getToTableName()#">
								<!--- recordType="#getObjectName("Record", ForeignKey.getToTableName())#" --->
								<cfset RelationShips = ForeignKey.getRelationships() />
								<cfloop from="1" to="#ArrayLen(Relationships)#" index="y">
									<column name="#RelationShips[y].getFromColumnName()#"
										referencedColumn="#RelationShips[y].getToColumnName()#" />
								</cfloop>
							</foreignKey>
						</cfloop>
					</foreignKeys>
					<referencingKeys>
						<cfloop from="1" to="#ArrayLen(ReferencingKeys)#" index="x">
							<cfset ReferencingKey = ReferencingKeys[x] />
							<referencingKey name="#ReferencingKey.getName()#"
								table="#ReferencingKey.getFromTableName()#">
								<!--- recordType="#getObjectName("Record", ForeignKey.getToTableName())#" --->
								<cfset RelationShips = ReferencingKey.getRelationships() />
								<cfloop from="1" to="#ArrayLen(Relationships)#" index="y">
									<column name="#RelationShips[y].getFromColumnName()#"
										referencedColumn="#RelationShips[y].getToColumnName()#" />
								</cfloop>
							</referencingKey>
						</cfloop>
					</referencingKeys>
					<cfif Table.hasSuperTable()>
						#getSuperTableXml(Table.getSuperTable())#
					</cfif>
				</table>
			</cfoutput>
		</cfsavecontent>
		
		<cfset structure = XmlParse(structure) />
		<cfset signature = Hash(structure) />
		<cfset structure.XmlRoot.XmlAttributes["signature"] = signature />
		
		<cfreturn structure />
	</cffunction>
	
	<cffunction name="getSuperTableXml" access="private" hint="I return an XML fragement describing the super table structure." output="false" returntype="string">
		<cfargument name="SuperTable" hint="I am the supertable to return XML for." required="yes" type="reactor.core.SuperTable" />
		<cfset var xml = "" />
		<cfset var Columns = arguments.SuperTable.getColumns() />
		<cfset var Column = 0 />
		<cfset var Relationships = arguments.SuperTable.getRelationships() />
		<cfset var Relationship = 0 />
		<cfset var x = 0 />
		
		<cfsavecontent variable="xml">
			<cfoutput>
				<superTable name="#arguments.SuperTable.getToTablename()#">
					<relationship>
						<cfloop from="1" to="#ArrayLen(Relationships)#" index="x">
							<cfset Relationship = Relationships[x] />
							<column name="#Relationship.getFromColumnName()#"
								referencedColumn="#Relationship.getToColumnName()#" />
						</cfloop>
					</relationship>
					
					<columns>
						<cfloop from="1" to="#ArrayLen(Columns)#" index="x">
							<cfset Column = Columns[x] />
							<column name="#Column.getName()#"
								type="#Column.getDataType()#"
								cfSqlType="#Column.getCfSqlType()#"
								nullable="#Column.getNullable()#"
								length="#Column.getLength()#"
								default="#XMLFormat(Column.getDefault())#"/>
						</cfloop>
					</columns>
					<cfif SuperTable.hasSuperTable()>
						#getSuperTableXml(SuperTable.getSuperTable())#
					</cfif>
				</superTable>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn xml />
	</cffunction>
	
	<!--- table --->
    <cffunction name="setTable" access="private" output="false" returntype="void">
       <cfargument name="table" hint="I am the table being translated" required="yes" type="reactor.core.table" />
       <cfset variables.table = arguments.table />
    </cffunction>
    <cffunction name="getTable" access="private" output="false" returntype="reactor.core.table">
       <cfreturn variables.table />
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