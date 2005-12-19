
To get this sample to work you will need to create the database using a create script.  When this document 
was written the options were:

MSSQL Create Database.sql	- For Microsoft SQL
MySQL Create Database.sql	- For MySQL

After you've created the database create a DSN named ContactManager.  If you need to change the name of the
DSN update the reactor.xml file and set the dsn value to your new DSN.  For example, change

<dsn value="ContactManager" />

To 

<dsn value="SomeOtherDsn" />

Also, you will need to update the type value to the correct type.  Options are (currently) mysql or mssql.  Here's an example:

<type value="mssql" />

Lastly, don't forget to create the /ReactorSamples mapping to the ReactorSamples directory.


