<!---
<cfset reactor = CreateObject("Component", "reactor.reactorFactory") />
<cfset reactor.init("c:\Inetpub\Reactor For ColdFusion\ReactorSamples\ContactManager\reactor.xml") />
<cfset phoneNumberRecord = reactor.createRecord("PhoneNumber").load(phoneNumberId=2) />

<cfdump var="#phoneNumberRecord._getTo()#" />

<cfset phoneNumberRecord.delete() />--->


<cfquery name="test" datasource="ContactManagerDb2">
	SELECT CO."NAME",
		CASE
			WHEN KC."COLUMN_NAME" IS NOT NULL THEN 'true'
			ELSE 'false'
		END AS "PRIMARYKEY",
		CASE
			WHEN CO."IDENTITY" = 'Y' THEN 'true'
			ELSE 'false'
		END AS "IDENTITY",
		CASE
			WHEN CO."NULLS" = 'Y' THEN 'true'
			ELSE 'false'
		END AS "NULL",
		CO."COLTYPE",
		CO."LENGTH",
		CO."DEFAULT"
	FROM SYSIBM.SYSCOLUMNS AS CO LEFT JOIN SYSIBM.SQLPRIMARYKEYS AS KC
		ON CO."TBNAME" = KC."TABLE_NAME"
		AND CO."NAME" = KC."COLUMN_NAME"
	WHERE CO."TBNAME" = <cfqueryparam cfsqltype="cf_sql_varchar" scale="128" value="PhoneNumber" />
</cfquery>

<cfdump var="#test#" />