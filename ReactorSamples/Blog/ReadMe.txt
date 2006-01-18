
To get this sample to work you will need to create the database using a create script.  When this document 
was written the options were:

MSSQL Create Database.sql	- For Microsoft SQL
MySQL Create Database.sql	- For MySQL

After you've created the database create a DSN named ReactorBlog.  If you need to change the name of the
DSN update the reactor.xml in the config folder file and set the dsn value to your new DSN.  For example, change

<dsn value="FooBarBlog" />

To 

<dsn value="MyBlog" />

Also, you will need to update the type value to the correct type.  Options are (currently) mysql or mssql.
(mysql4 is not supported yet.) Here's an example:

<type value="mysql" />

The blog sample application uses the Model-Glue framework.  If you don't already have this installed you will need to download
it from http://www.model-glue.com/index.cfm.  Extract it and create a ColdFusion mapping named "/ModelGlue" to the core ModelGlue folder.

Also, in the /Config/Beans directory there are some configuration files you can tweak to make the blog behave as you want.   

--------------------------------------------------------------------------------------------------------------

If you want to deploy this blog as an actual application somewhere, presumably not under "/reactorsamples/blog", then
you should follow these instructions.

Make sure that you have ModelGlue in a mapping named /ModelGlue.  Reactor should be in a mapping named /Reactor.

Here are the steps I follow to deply the blog to a different location:

1) Copy all the files from /ReactorSamples/Blog/ to your target directory.

2) Run the correct SQL file to create the database.  Be sure to change the db name from ReactorBlog to whatever you need.
	(Tip: Make sure that the SQL function getAverageRating is created correctly - at least one user had issues with this on mysql.)
	
3) Create a coldfusion datasource for the database.

4) Create a mapping to the blog's data directory.  You can call this whatever you want.  I tend to call mine something like /BlogNameData
where blogname is the name of the blog.

5) (Optional) Create a Verity collection to index your entries.  I tend to call mine something like BlogNameCollection where blogname is
the name of the Blog. 

6) Use a tool like dreamweaver or cfeclipse and Find and Replace all instances of "ReactorSamples.Blog." with the correct location.  For
example, if your placed the blog under "/foobar", you would replace "ReactorSamples.Blog." with "foobar." everywhere.  (I hate this step. 
There's got to be a better way!)  Roughly 24 changes should be made.

7) Open the ModelGlue.xml and Reactor.xml files and change all instances of "/ReactorSamples/blog" to the correct location.  For
example, if your placed the blog under "/foobar", you would replace "/ReactorSamples/blog" with "/foobar" everywhere.  (I also hate this step,
but it's less offensive than the last step.)  Roughly 5 changes should be made.  All of these are in the ModelGlue.xml and the config/beans/blogConfig.xml files

8) Open the /config/beans/blogConfig.xml file.  Review the settings in here and make changes as needed.  In particular, change these: blogTitle,
blogDescription, authorEmailAddress, authorName, pingUrlArray, blogSearchCollection (set this to empty for no search or the name of the collection
created in step 5).
	(note: if you placed your blog in your web root the /config path will be //config.  fix this so that it's /config) 

9) Open the /config/reactor.xml file.  Change the dsn to the one created in step 3.  Change the type to either mssql or mysql (as needed).
Change the mapping to the mapping created in step 4.  Set the mode to production.
	(note: the first time you run the site, as you work though the site, Reactor will be generating base objects and will go slow.  Once created
	the site will speed up.)
	
10) Open the /config/ModelGlue.xml file.  Change to reload setting to false.

11) Once you're comfortable that there are no issues on the blog change the showFriendlyErrors config setting to true.

The default login is admin/admin.

Other things you can do.  If you want to implement a captcha on your blog to prevent blog spam, buy a license for the Captcha component from
alagad.com and put the set useCaptcha to true and the captchaKey to the license key in the blogConfig.xml file.

Do you think I should write a java app (or something) to do all this for you?
Do you have any ideas on improving this?  

Send an email to the reactor mailing list: reactor@doughughes.net