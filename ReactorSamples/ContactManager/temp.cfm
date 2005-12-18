<cfset CountryGw = Application.Reactor.createGateway("Country") />
<cfset countries = CountryGw.getAll() />

<cfoutput query="countries">
	INSERT INTO [Country]
	(
		abberviation,
		name,
		sortOrder
	)
	VALUES
	(
		'#abbreviation#',
		'#name#',
		'#sortOrder#'
	)
	
</cfoutput>