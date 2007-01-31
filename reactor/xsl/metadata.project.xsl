<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">
&lt;cfcomponent hint="I am the base Metadata object for the <xsl:value-of select="object/@alias"/> object.  I am generated.  DO NOT EDIT ME (but feel free to delete me)."
	extends="reactor.base.abstractMetadata" &gt;
	
	&lt;cfset variables.signature = "<xsl:value-of select="object/@signature" />" &gt;
	
	&lt;cfset variables.metadata.name = "<xsl:value-of select="object/@name" />" /&gt;
	&lt;cfset variables.metadata.alias = "<xsl:value-of select="object/@alias" />" /&gt;
	&lt;cfset variables.metadata.type = "<xsl:value-of select="object/@type" />" /&gt;
	&lt;cfset variables.metadata.database = "<xsl:value-of select="object/@database" />" /&gt;
		
	&lt;!--- Has One ---&gt;
	&lt;cfset variables.metadata.hasOne = ArrayNew(1) /&gt;
	<xsl:for-each select="object/hasOne">
		<xsl:variable name="hasOneIndex" select="position()" />
		&lt;cfset variables.metadata.hasOne[<xsl:value-of select="$hasOneIndex" />] = StructNew() /&gt;
		&lt;cfset variables.metadata.hasOne[<xsl:value-of select="$hasOneIndex" />].name = "<xsl:value-of select="@name" />" /&gt;
		&lt;cfset variables.metadata.hasOne[<xsl:value-of select="$hasOneIndex" />].alias = "<xsl:value-of select="@alias" />" /&gt;
		&lt;cfset variables.metadata.hasOne[<xsl:value-of select="$hasOneIndex" />].type = "hasOne" /&gt;
		&lt;cfset variables.metadata.hasOne[<xsl:value-of select="$hasOneIndex" />].sharedKey = "<xsl:value-of select="@sharedKey" />" /&gt;
		&lt;cfset variables.metadata.hasOne[<xsl:value-of select="$hasOneIndex" />].relate = ArrayNew(1) /&gt;
		
		<xsl:for-each select="relate">
			&lt;cfset variables.metadata.hasOne[<xsl:value-of select="$hasOneIndex" />].relate[<xsl:value-of select="position()" />] = StructNew() /&gt;
			&lt;cfset variables.metadata.hasOne[<xsl:value-of select="$hasOneIndex" />].relate[<xsl:value-of select="position()" />].from = "<xsl:value-of select="@from" />" /&gt;
			&lt;cfset variables.metadata.hasOne[<xsl:value-of select="$hasOneIndex" />].relate[<xsl:value-of select="position()" />].to = "<xsl:value-of select="@to" />" /&gt;
		</xsl:for-each>
	</xsl:for-each>
	
	&lt;!--- Has Many ---&gt;
	&lt;cfset variables.metadata.hasMany = ArrayNew(1) /&gt;
	<xsl:for-each select="object/hasMany">
		<xsl:variable name="hasOneIndex" select="position()" />
		&lt;cfset variables.metadata.hasMany[<xsl:value-of select="$hasOneIndex" />] = StructNew() /&gt;
		&lt;cfset variables.metadata.hasMany[<xsl:value-of select="$hasOneIndex" />].name = "<xsl:value-of select="@name" />" /&gt;
		&lt;cfset variables.metadata.hasMany[<xsl:value-of select="$hasOneIndex" />].alias = "<xsl:value-of select="@alias" />" /&gt;
		&lt;cfset variables.metadata.hasMany[<xsl:value-of select="$hasOneIndex" />].type = "hasMany" /&gt;
		
		<xsl:choose>
			<xsl:when test="count(relate) &gt; 0">
				&lt;cfset variables.metadata.hasMany[<xsl:value-of select="$hasOneIndex" />].relate = ArrayNew(1) /&gt;
			
				<xsl:for-each select="relate">
					&lt;cfset variables.metadata.hasMany[<xsl:value-of select="$hasOneIndex" />].relate[<xsl:value-of select="position()" />] = StructNew() /&gt;
					&lt;cfset variables.metadata.hasMany[<xsl:value-of select="$hasOneIndex" />].relate[<xsl:value-of select="position()" />].from = "<xsl:value-of select="@from" />" /&gt;
					&lt;cfset variables.metadata.hasMany[<xsl:value-of select="$hasOneIndex" />].relate[<xsl:value-of select="position()" />].to = "<xsl:value-of select="@to" />" /&gt;
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="count(link) &gt; 0">
				&lt;cfset variables.metadata.hasMany[<xsl:value-of select="$hasOneIndex" />].link = ArrayNew(1) />
				<xsl:for-each select="link">
					&lt;cfset variables.metadata.hasMany[<xsl:value-of select="$hasOneIndex" />].link[<xsl:value-of select="position()" />] = "<xsl:value-of select="@name" />" /&gt;
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>		
	</xsl:for-each>
	
	&lt;!--- Fields ---&gt;
	&lt;cfset variables.metadata.fields = ArrayNew(1) /&gt;
	<xsl:for-each select="object/fields/field">
		&lt;cfset variables.metadata.fields[<xsl:value-of select="position()" />] = StructNew() /&gt;
		&lt;cfset variables.metadata.fields[<xsl:value-of select="position()" />]["name"] = "<xsl:value-of select="@name" />" /&gt;
		&lt;cfset variables.metadata.fields[<xsl:value-of select="position()" />]["alias"] = "<xsl:value-of select="@alias" />" /&gt;
		&lt;cfset variables.metadata.fields[<xsl:value-of select="position()" />]["primaryKey"] = "<xsl:value-of select="@primaryKey" />" /&gt;
		&lt;cfset variables.metadata.fields[<xsl:value-of select="position()" />]["identity"] = "<xsl:value-of select="@identity" />" /&gt;
		&lt;cfset variables.metadata.fields[<xsl:value-of select="position()" />]["nullable"] = "<xsl:value-of select="@nullable" />" /&gt;
		&lt;cfset variables.metadata.fields[<xsl:value-of select="position()" />]["dbDataType"] = "<xsl:value-of select="@dbDataType" />" /&gt;
		&lt;cfset variables.metadata.fields[<xsl:value-of select="position()" />]["cfDataType"] = "<xsl:value-of select="@cfDataType" />" /&gt;
		&lt;cfset variables.metadata.fields[<xsl:value-of select="position()" />]["cfSqlType"] = "<xsl:value-of select="@cfSqlType" />" /&gt;
		&lt;cfset variables.metadata.fields[<xsl:value-of select="position()" />]["length"] = "<xsl:value-of select="@length" />" /&gt;
		&lt;cfset variables.metadata.fields[<xsl:value-of select="position()" />]["scale"] = "<xsl:value-of select="@scale" />" /&gt;
		&lt;cfset variables.metadata.fields[<xsl:value-of select="position()" />]["default"] = "<xsl:value-of select="@default" />" /&gt;
		&lt;cfset variables.metadata.fields[<xsl:value-of select="position()" />]["object"] = "<xsl:value-of select="../../@name" />" /&gt;
		&lt;cfset variables.metadata.fields[<xsl:value-of select="position()" />]["sequence"] = "<xsl:value-of select="@sequence" />" /&gt;
		&lt;cfset variables.metadata.fields[<xsl:value-of select="position()" />]["readOnly"] = "<xsl:value-of select="@readOnly" />" /&gt;
	</xsl:for-each>
	
	
	&lt;!--- External Fields ---&gt;
	&lt;cfset variables.metadata.externalFields = ArrayNew(1) /&gt;
	<xsl:for-each select="object/fields/externalField">
		&lt;cfset variables.metadata.externalFields[<xsl:value-of select="position()" />] = StructNew() /&gt;
		&lt;cfset variables.metadata.externalFields[<xsl:value-of select="position()" />]["fieldAlias"] = "<xsl:value-of select="@fieldAlias" />" /&gt;
		&lt;cfset variables.metadata.externalFields[<xsl:value-of select="position()" />]["sourceAlias"] = "<xsl:value-of select="@sourceAlias" />" /&gt;
		&lt;cfset variables.metadata.externalFields[<xsl:value-of select="position()" />]["sourceName"] = "<xsl:value-of select="@sourceName" />" /&gt;
		&lt;cfset variables.metadata.externalFields[<xsl:value-of select="position()" />]["field"] = "<xsl:value-of select="@field" />" /&gt;
	</xsl:for-each>
	
&lt;/cfcomponent&gt;
	</xsl:template>
</xsl:stylesheet>