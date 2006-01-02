

<cfdocument format="#viewstate.getValue('print')#">
	<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<link rel="stylesheet" href="scripts/styles/print.css" />
	</head>
	<body>
	<cfif viewCollection.exists("body")>
		<cfoutput>#viewCollection.getView("body")#</cfoutput>
	</cfif>
	</body>
	</html>
</cfdocument>