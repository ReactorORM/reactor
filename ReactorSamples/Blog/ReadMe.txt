
To get this sample to work you will need to create the database using a create script.  When this document 
was written the options were:

MSSQL Create Database.sql	- For Microsoft SQL
MySQL Create Database.sql	- For MySQL

After you've created the database create a DSN named ReactorBlog.  If you need to change the name of the
DSN update the reactor.xml in the config folder file and set the dsn value to your new DSN.  For example, change

<dsn value="ReactorBlog" />

To 

<dsn value="MyBlog" />

Also, you will need to update the type value to the correct type.  Options are (currently) mysql or mssql.  Here's an example:

<type value="mssql" />

The blog sample application uses the Model-Glue framework.  If you don't already have this installed you will need to download
it from http://www.model-glue.com/index.cfm.  Extract it and create a ColdFusion mapping named "/ModelGlue" to the core ModelGlue folder.

Don't forget to create the /ReactorSamples mapping to the ReactorSamples directory!

Also, in the /Config/Beans directory there are a couple configuration files you can tweak to make the blog behave as you want.   

--------------------------------------------------------------------------------------------------------------


If you want to deploy this blog as an actual application somewhere, presumably not under "/reactorsamples/blog" then
you should follow these instructions.

First though, please keep in mind that /ReactorSamples/Blog/ and ReactorSamples.Blog are all over the place in this sample.  
I'm clueless (at the moment) on how to work arround this.  So, here are the steps I follow to deply the blog to a different location:

1) Copy all the files from /ReactorSamples/Blog/ to your target directory.

2) Open the /data directory.  For your DBMS, go under each of the five directories (record, to, dao, etc) and make sure that all the files
in the "base" directory is empty.  (This should be true already.)

3) Run the correct SQL file to create the database.  (Tip: Make sure that the SQL function getAverageRating is created correctly.)

4) Create a coldfusion datasource for the database.

5) Create a mapping to the data directory.  You can call this whatever you want.



