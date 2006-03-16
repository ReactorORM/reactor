DROP TABLE "NULLID"."Category";
DROP TABLE "NULLID"."Comment";
DROP TABLE "NULLID"."Entry";
DROP TABLE "NULLID"."EntryCategory";
DROP TABLE "NULLID"."Subscriber";
DROP TABLE "NULLID"."User";


CREATE TABLE "NULLID"."Category" (
	"categoryId" INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH +1 INCREMENT BY +1) ,
	"name" VARCHAR(50) NOT NULL 
);

ALTER TABLE "NULLID"."Category" 
	ADD PRIMARY KEY ("categoryId");

CREATE TABLE "NULLID"."Comment" (
	"commentId" INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH +1 INCREMENT BY +1) ,
	"entryId" INTEGER NOT NULL ,
	"name" VARCHAR(50) NOT NULL ,
	"emailAddress" VARCHAR(50) ,
	"comment" CLOB NOT NULL ,
	"posted" TIMESTAMP NOT NULL WITH DEFAULT current timestamp ,
	"subscribe" SMALLINT NOT NULL WITH DEFAULT 1
);

ALTER TABLE "NULLID"."Comment" 
	ADD PRIMARY KEY ("commentId");

CREATE TABLE "NULLID"."Entry" (
	"entryId" INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH +1 INCREMENT BY +1) ,
	"title" VARCHAR(200) NOT NULL ,
	"preview" VARCHAR(1000)  ,
	"article" CLOB NOT NULL ,
	"publicationDate" TIMESTAMP NOT NULL WITH DEFAULT current timestamp ,
	"postedByUserId" INTEGER NOT NULL ,
	"disableComments" SMALLINT NOT NULL WITH DEFAULT 0 ,
	"views" INTEGER NOT NULL WITH DEFAULT 0 ,
	"totalRating" INTEGER NOT NULL,
	"timesRated" INTEGER NOT NULL
);

ALTER TABLE "NULLID"."Entry" 
	ADD PRIMARY KEY ("entryId");

CREATE TABLE "NULLID"."EntryCategory" (
	"entryCategoryId" INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH +1 INCREMENT BY +1) ,
	"entryId" INTEGER NOT NULL ,
	"categoryId" INTEGER NOT NULL 
);

ALTER TABLE "NULLID"."EntryCategory" 
	ADD PRIMARY KEY ("entryCategoryId");

CREATE TABLE "NULLID"."Subscriber" (
	"subscriberId" INTEGER NOT NULL ,
	"fullName" VARCHAR(50) NOT NULL 
);

ALTER TABLE "NULLID"."Subscriber" 
	ADD PRIMARY KEY ("subscriberId");

CREATE TABLE "NULLID"."User" (
	"userId" INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH +1 INCREMENT BY +1) ,
	"username" VARCHAR(20) NOT NULL ,
	"password" VARCHAR(20) NOT NULL ,
	"firstName" VARCHAR(20) NOT NULL ,
	"lastName" VARCHAR(20) NOT NULL ,
	"emailAddress" VARCHAR(50) NOT NULL 
);

ALTER TABLE "NULLID"."User" 
	ADD PRIMARY KEY ("userId");


ALTER TABLE "NULLID"."Comment"
	ADD CONSTRAINT "FK_Comments_Entry" FOREIGN KEY ("entryId")
	REFERENCES "NULLID"."Entry" ("entryId")
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
	ENFORCED
	ENABLE QUERY OPTIMIZATION;


ALTER TABLE "NULLID"."Entry"
	ADD CONSTRAINT "FK_Entry_User" FOREIGN KEY ("postedByUserId")
	REFERENCES "NULLID"."User" ("userId")
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
	ENFORCED
	ENABLE QUERY OPTIMIZATION;


ALTER TABLE "NULLID"."EntryCategory"
	ADD CONSTRAINT "FK_EntCat_Cat" FOREIGN KEY ("categoryId")
	REFERENCES "NULLID"."Category" ("categoryId")
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
	ENFORCED
	ENABLE QUERY OPTIMIZATION;

ALTER TABLE "NULLID"."EntryCategory"
	ADD CONSTRAINT "FK_EntCat_Cat2" FOREIGN KEY ("entryId")
	REFERENCES "NULLID"."Entry" ("entryId")
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
	ENFORCED
	ENABLE QUERY OPTIMIZATION;


INSERT INTO "NULLID"."User"
(
	"username",
	"password",
	"firstName",
	"lastName",
	"emailAddress"
)
VALUES
(
	'admin',
	'admin',
	'Admin',
	'User',
	'admin@example.com'
);

