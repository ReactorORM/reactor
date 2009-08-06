<cfcomponent hint="I read Object data from a MSSQL database." extends="reactor.data.abstractObjectDao">
	
	<cffunction name="read" access="public" hint="I populate an Object object based on it's name" output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to populate." required="yes" type="reactor.core.object" />
		
		<!--- get all field data --->
		<cfset readObject(arguments.Object) />
		<cfset readFields(arguments.Object) />
	</cffunction>
	
	<cffunction name="readObject" access="private" hint="I confirm that this object exists at all.  If not, I throw an error." output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to check on." required="yes" type="reactor.core.object" />
		<cfset var qObject = 0 />
		
		<cfquery name="qObject" datasource="#getDsn()#" username="#getUsername()#" password="#getPassword()#">
			select owner as database_name,
			owner as table_schema,
			tabname as table_name, 
			tabtype as table_type
			from systables where tabname =<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="64" value="#lcase(arguments.Object.getName())#" />
		</cfquery>
		
		<cfif qObject.recordCount>
			<!--- set the owner --->
			<cfset arguments.Object.setDatabase(trim(qObject.DATABASE_NAME)) />
			<cfset arguments.Object.setType(Iif(qObject.TABLE_TYPE IS "T", DE('table'), DE('view'))) />
		<cfelse>
			<cfthrow type="Reactor.NoSuchObject" />
		</cfif>		
	</cffunction>
	
	<cffunction name="readFields" access="private" hint="I populate the table with fields." output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to read fields into." required="yes" type="reactor.core.object" />
		<cfset var qFields = 0 />
		<cfset var qPrimary = 0>
		<cfset var Field = 0 />
				
		<!--- this is taken from Perls Informix class http://search.cpan.org/src/JSTOWE/Class-DBI-Loader-Informix-0.02/lib/Class/DBI/Informix.pm --->
		<cfquery name="qPrimary" datasource="#getDsn()#" username="#getUsername()#" password="#getPassword()#">
		SELECT p1.colname as col1,
	       p2.colname as col2,
	       p3.colname as col3,
	       p4.colname as col4,
	       p5.colname as col5,
	       p6.colname as col6,
	       p7.colname as col7,
	       p8.colname as col8,
	       p9.colname as col9,
	       p10.colname as col10,
	       p11.colname as col11,
	       p12.colname as col12,
	       p13.colname as col13,
	       p14.colname as col14,
	       p15.colname as col15
		from sysconstraints
		join systables
		on sysconstraints.tabid = systables.tabid
		join sysindexes on sysconstraints.idxname = sysindexes.idxname
		left outer join syscolumns as p1 on p1.colno = sysindexes.part1 and p1.tabid = systables.tabid
		left outer join syscolumns as p2 on p2.colno = sysindexes.part2 and p2.tabid = systables.tabid
		left outer join syscolumns as p3 on p3.colno = sysindexes.part3 and p3.tabid = systables.tabid
		left outer join syscolumns as p4 on p4.colno = sysindexes.part4 and p4.tabid = systables.tabid
		left outer join syscolumns as p5 on p5.colno = sysindexes.part5 and p5.tabid = systables.tabid
		left outer join syscolumns as p6 on p6.colno = sysindexes.part6 and p6.tabid = systables.tabid
		left outer join syscolumns as p7 on p7.colno = sysindexes.part7 and p7.tabid = systables.tabid
		left outer join syscolumns as p8 on p8.colno = sysindexes.part8 and p8.tabid = systables.tabid
		left outer join syscolumns as p9 on p9.colno = sysindexes.part9 and p9.tabid = systables.tabid
		left outer join syscolumns as p10 on p10.colno = sysindexes.part10 and p10.tabid = systables.tabid
		left outer join syscolumns as p11 on p11.colno = sysindexes.part11 and p11.tabid = systables.tabid
		left outer join syscolumns as p12 on p12.colno = sysindexes.part12 and p12.tabid = systables.tabid
		left outer join syscolumns as p13 on p13.colno = sysindexes.part13 and p13.tabid = systables.tabid
		left outer join syscolumns as p14 on p14.colno = sysindexes.part14 and p14.tabid = systables.tabid
		left outer join syscolumns as p15 on p15.colno = sysindexes.part15 and p15.tabid = systables.tabid
		where systables.tabname = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="128" value="#lcase(arguments.Object.getName())#" />
		and constrtype = 'P'
		</cfquery>
		<cfquery name="qFields" datasource="#getDsn()#" username="#getUsername()#" password="#getPassword()#">
		select colname as name,
		coltype as primaryKey,
		coltype as identity,
		coltype as nullable,
		coltype as dbDataType,
		collength as length,
		'' as default
		from syscolumns where tabid= (select tabid from systables where tabname =<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="128" value="#lcase(arguments.Object.getName())#" />)
		</cfquery>
		
		<cfloop query="qFields">
			<!--- create the field --->
			<!--- identity is MSSQL for 'auto-increment', Informix calls these 'serial'--->
			<cfset Field = StructNew() />
			<cfset Field.name = qFields.name />
			<cfset Field.primaryKey = isThisFieldInPrimarykeyList(qPrimary,qFields.name) />
			<cfset Field.identity = isDbType6(qFields.identity) />
			<cfset Field.nullable = is3rdBitNot1(qFields.nullable) />
			<cfset Field.dbDataType = qFields.dbDataType />
			<cfset Field.cfDataType = getCfDataType(qFields.dbDataType) />
			<cfset Field.cfSqlType = getCfSqlType(qFields.dbDataType) />

			<!--- field length for text fields is held as 56 in the db, but text can be 2^31 or space available on disk, whichever is less --->
			<cfif qFields.dbDataType NEQ 12>
				<cfif qFields.dbDataType eq 2><!--- for integer is length in bits --->
					<cfset Field.length = len(2^((2^(qFields.length+1))-1)) >
				<cfelse>	
					<cfset Field.length = qFields.length />
				</cfif>
			<cfelse>
				<cfset Field.length = 2147483648>
			</cfif>

			<cfset Field.default = getDefault(qFields.default, Field.cfDataType, Field.nullable) />
			<cfset Field.sequenceName = "" />
			<cfset Field.readOnly=false/>
			<cfset Field.scale = "0" />
			
			<!--- add the field to the table --->
			<cfset arguments.Object.addField(Field) />
		</cfloop>
		
	</cffunction>
	
	<cffunction name="getDefault" access="public" hint="I get a default value for a cf datatype." output="false" returntype="any" _returntype="string">
		<cfargument name="sqlDefaultValue" hint="I am the default value defined by SQL." required="yes" type="any" _type="string" />
		<cfargument name="typeName" hint="I am the cf type name to get a default value for." required="yes" type="any" _type="string" />
		<cfargument name="nullable" hint="I indicate if the column is nullable." required="yes" type="boolean" />
		
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="numeric">
				<cfif IsNumeric(arguments.sqlDefaultValue)>
					<cfreturn arguments.sqlDefaultValue />
				<cfelseif arguments.nullable>
					<cfreturn ""/>
				<cfelse>
					<cfreturn 0 />
				</cfif>
			</cfcase>
			<cfcase value="binary">
				<cfreturn "" />
			</cfcase>
			<cfcase value="boolean">
				<cfif IsBoolean(arguments.sqlDefaultValue)>
					<cfreturn Iif(arguments.sqlDefaultValue, DE(true), DE(false)) />
				<cfelse>
					<cfreturn false />
				</cfif>
			</cfcase>
			<cfcase value="string">
				<!--- insure that the first and last characters are "'" --->
				<cfif Left(arguments.sqlDefaultValue, 1) IS "'" AND Right(arguments.sqlDefaultValue, 1) IS "'">
					<!--- mssql functions must be constants.  for this reason I can convert anything quoted in single quotes safely to a string --->
					<cfset arguments.sqlDefaultValue = Mid(arguments.sqlDefaultValue, 2, Len(arguments.sqlDefaultValue)-2) />
					<cfset arguments.sqlDefaultValue = Replace(arguments.sqlDefaultValue, "''", "'", "All") />
					<cfset arguments.sqlDefaultValue = Replace(arguments.sqlDefaultValue, """", """""", "All") />
					<cfreturn arguments.sqlDefaultValue />
				<cfelse>
					<cfreturn "" />
				</cfif>
			</cfcase>
			<cfcase value="date">
				<cfif Left(arguments.sqlDefaultValue, 1) IS "'" AND Right(arguments.sqlDefaultValue, 1) IS "'">
					<cfreturn Mid(arguments.sqlDefaultValue, 2, Len(arguments.sqlDefaultValue)-2) />
				<cfelseif arguments.sqlDefaultValue IS "getDate()">
					<cfreturn "##Now()##" />
				<cfelse>
					<cfreturn "" />
				</cfif>
			</cfcase>
			<cfdefaultcase>
				<cfreturn "" />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="getCfSqlType" access="private" hint="I translate the Informix data type names into ColdFusion cf_sql_xyz names" output="false" returntype="any" _returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="any" _type="string" />
		
		<cfset typeName = getLowestTwoBits(typeName)>
				
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="bit,bool,boolean">
				<cfreturn "cf_sql_bit" />
			</cfcase>
			<cfcase value="1,2,5,6"><!--- 6 is  'serial'--->
				<cfreturn "cf_sql_integer" />
			</cfcase>
			<cfcase value="3,4">
				<cfreturn "cf_sql_float" />
			</cfcase>
			<cfcase value="7">
				<cfreturn "cf_sql_date" />
			</cfcase>
			<cfcase value="10">
				<cfreturn "cf_sql_timestamp" />
			</cfcase>
			<cfcase value="0,15"><!--- 15 is nchar --->
				<cfreturn "cf_sql_char" />
			</cfcase>
			<cfcase value="13,16,40"><!--- 16 is nvarchar, 40 is LVARCHAR --->
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="12">
				<cfreturn "cf_sql_longvarchar" />
			</cfcase>
			<cfcase value="11">
				<cfreturn "cf_sql_binary" />
			</cfcase>
		</cfswitch>
		
		<cfthrow message="Unsupported (or incorrectly supported) SQL database datatype: #arguments.typeName#." />
	</cffunction>

	<cffunction name="getCfDataType" access="private" hint="I translate the Informix data type names into ColdFusion data type names" output="false" returntype="any" _returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="any" _type="string" />
		
		<cfset typeName = getLowestTwoBits(typeName)>
				
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="1,2,3,4,5,6"><!--- 6 is  'serial'--->
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="7,10">
				<cfreturn "date" />
			</cfcase>
			<cfcase value="0,15,16,21,19">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="12,13,40">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="11">
				<cfreturn "binary" />
			</cfcase>			
		</cfswitch>
	
		<cfthrow message="Unsupported (or incorrectly supported) CF database datatype: #arguments.typeName#." />
		
	</cffunction>

	<cffunction name="getLowestTwoBits" access="private" hint="I strip off the high bits of a data type as per http://publib.boulder.ibm.com/infocenter/ids9help/index.jsp?topic=/com.ibm.sqlr.doc/sqlrmst41.htm" output="false" returntype="any" _returntype="string">
		<cfargument name="num" required="true" hint="A decimal number greater than 256 (other wise no high bits to strip)" type="any" _type="string">
		<cfscript>
		var asHex=0;
		var lowTwo='';
		if (arguments.num lt 256){
			return arguments.num;
		}
		asHex=FormatBaseN(arguments.num,16);
		lowTwo=mid(asHex,len(num)-1,2);
		lowTwo=inputBaseN(lowTwo,16);	
		</cfscript>
		<cfreturn lowTwo>
	</cffunction>
	
	<cffunction name="is3rdBitNot1" access="private" hint="I use the 3rd bit of a datatype to see if its a nullable or not as per http://publib.boulder.ibm.com/infocenter/ids9help/index.jsp?topic=/com.ibm.sqlr.doc/sqlrmst41.htm" returntype="any" _returntype="string" output="false">
		<cfargument name="num" required="true" hint="A decimal number" type="any" _type="numeric">
		<cfscript>
		var asHex=0;
		var third=0;
		if (arguments.num lt 256){
			return 'true';
		}
		asHex=FormatBaseN(arguments.num,16);
		third=mid(asHex,len(arguments.num)-2,1);
		if (third eq '1'){
			return 'false';
		}
		</cfscript>
		<cfreturn 'true'/>
	</cffunction>
	
	<cffunction name="isDbType6"access="private" output="false" hint="determine if this is a serial column type" returntype="any" _returntype="string">
		<cfargument name="num" required="true" hint="A decimal number" type="any" _type="numeric">
		<cfif getLowestTwoBits(arguments.num) is 6>
			<cfreturn 'true'>
		</cfif>
		<cfreturn 'false'>
	</cffunction>
	
	<cffunction name="isThisFieldInPrimarykeyList" access="private" output="false" returntype="any" _returntype="string">
		<cfargument name="a" required="true" type="any" _type="string">
		<cfargument name="b" required="true" type="any" _type="string">
		<cfset var i=0>
		<cfif a.recordCount eq 0>
			<cfreturn 'false'>
		</cfif>
		<cfloop from="1" to="15" index="i">
			<cfif a["col#i#"][1] is b>
				<cfreturn 'true'>
			</cfif>
		</cfloop>
		<cfreturn 'false'>
	</cffunction>

</cfcomponent>
