
To get this sample to work you will need to create the database using a create script.  When this document 
was written the options were:

MSSQL Create Database.sql	- For Microsoft SQL
MySQL Create Database.sql	- For MySQL (4 or 5, I think)
Oracle Create Database.sql	- For Oracle
Postgres Create Database.sql	- For PostgreSQL
SQLAnywhere Create Database.sql	- For Adaptive Sql Anywhere

After you've created the database create a DSN and change the name of the
DSN in the reactor.xml file to the dsn you created.  For example, change

<dsn value="ContactManager" />

Also, you will need to update the type value to the correct type.  See the docs for valid options. Here's an example:

<type value="mssql" />

Lastly, create a mapping named "/ContactManagerData" pointing to the "/ReactorSamples/ContactManager/Data" directory.  If you want
to use a name other than "/ContactManagerData" then be sure to update the reactor.xml file and set the mapping setting correctly.  IE:

<mapping value="/SomeOtherMappingName" />

Note for DB2 and Oracle users:  The scripts are created assuming an administrative account.  So in DB2 the schema is NULLID.  In Oracle
it's system.  If you have problems you should look in the dbms-specific custom metadata files and update these to be correct.