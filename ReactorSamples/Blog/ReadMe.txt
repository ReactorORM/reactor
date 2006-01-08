
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
I'm clueless (at the moment) on how to work arround this. I've added instructions on how to change these throughout.

Also, make sure that you have ModelGlue in a mapping named /ModelGlue.  Reactor should be in a mapping named /Reactor.

Here are the steps I follow to deply the blog to a different location:

1) Copy all the files from /ReactorSamples/Blog/ to your target directory.

2) Open the /data directory.  For your DBMS, go under each of the five directories (record, to, dao, etc) and make sure that all the files
in the "base" directory is empty.  (This should be true already.)

3) Run the correct SQL file to create the database.  Be sure to change the db name from ReactorBlog to whatever you need.
	(Tip: Make sure that the SQL function getAverageRating is created correctly - at least one user had issues with this on mysql.)
	
4) Create a coldfusion datasource for the database.

5) Create a mapping to the blog's data directory.  You can call this whatever you want.  I tend to call mine something like /BlogNameData
where blogname is the name of the blog.

6) (Optional) Create a Verity collection to index your entries.  I tend to call mine something like BlogNameCollection where blogname is
the name of the blog. 

7) Use a tool like dreamweaver or cfeclipse and Find and Replace all instances of "ReactorSamples.blog." with the correct location.  For
example, if your placed the blog under "/foobar", you would replace "ReactorSamples.blog." with "foobar." everywhere.  (I hate this step. 
There's got to be a better way!)  Roughly 25 changes should be made.
	(note: be sure to make sure the find and replace is not case sensitive)

8) Use a tool like dreamweaver or cfeclipse and Find and Replace all instances of "/ReactorSamples/blog" with the correct location.  For
example, if your placed the blog under "/foobar", you would replace "/ReactorSamples/blog" with "/foobar" everywhere.  (I hate this step too. 
There's got to be a better way!)  Roughly 5 changes should be made.
	(note: be sure to make sure the find and replace is not case sensitive)

9) Use a tool like dreamweaver or cfeclipse and Find and Replace all instances of "ReactorBlogData." with the correct location based on the data
mapping created in step 5.  For example, if your set the mapping to "/foobarData", you would replace "ReactorBlogData." with "foobarData." everywhere.
(I *really* hate this step! There's got to be a better way!)  Roughly 5 changes should be made.
	(note: be sure to make sure the find and replace is not case sensitive)

10) Open the /config/beans/blogConfig.xml file.  Review the settings in here and make changes as needed.  In particular, change these: blogTitle,
blogDescription, authorEmailAddress, authorName, pingUrlArray, blogSearchCollection (set this to empty for no search or the name of the collection
created in step 6).

11) Open the /config/reactor.xml file.  Change the dsn to the one created in step 4.  Change the type to either mssql or mysql (as needed).
Change the mapping to the mapping created in step 5.  Set the mode to production.
	(note: the first time you run the site, as you work though the site, Reactor will be generating base objects and will go slow.  Once created
	the site will speed up.)
	
12) Open the /config/ModelGlue.xml file.  Change to reload setting to false.

13) Once you're comfortable that there are no issues on the blog change the showFriendlyErrors config setting to true.

The default login is admin/admin.

Other things you can do.  If you want to implement a captcha on your blog to prevent blog spam, buy a license for the Captcha component from
alagad.com and put the set useCaptcha to true and the captchaKey to the license key in the blogConfig.xml file.

Do you think I should write a java app (or something) to do all this for you?
Do you have any ideas on improving this?  

Send an email to reactor@doughughes.net