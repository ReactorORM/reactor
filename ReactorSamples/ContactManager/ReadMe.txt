
To get this sample to work you will need to create the database using a create script.  When this document 
was written the options were:

MSSQL Create Database.sql	- For Microsoft SQL
MySQL Create Database.sql	- For MySQL (4 or 5, I think)

After you've created the database create a DSN named ContactManager.  If you need to change the name of the
DSN update the reactor.xml file and set the dsn value to your new DSN.  For example, change

<dsn value="ContactManager" />

To 

<dsn value="SomeOtherDsn" />

Also, you will need to update the type value to the correct type.  Options are (currently) mysql or mssql.  Here's an example:

<type value="mssql" />

Lastly, create a mapping named "/ContactManagerData" pointing to the "/ReactorSamples/ContactManager/Data" directory.  If you want
to use a name other than "/ContactManagerData" then be sure to update the reactor.xml file and set the mapping setting correctly.  IE:

<mapping value="/SomeOtherMappingName" />