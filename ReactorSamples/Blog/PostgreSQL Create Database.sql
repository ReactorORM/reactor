-- Postgres Create Database

-- The tables below could be created using the serial data type.  However, 
-- because reactorblog is supposed to work across multiple systems I run into
-- a problem with Oracle support.  Specifically, oracle's sequences are limited to 
-- shorter names than postgres'.  So, I've decided to just go ahead and specify my
-- sequence names and use those as the defaults for the columns that would otherwise
-- typically be serial.

create sequence "category_categoryid" ;
create sequence "comment_commentid" ;
create sequence "entrycategory_entrycategoryid" ;
create sequence "entry_entryid" ;
create sequence "subscriber_subscriberid" ;
create sequence "user_userid" ;

CREATE TABLE "Category" (
  "categoryId" integer DEFAULT nextval('category_categoryid') NOT NULL,
  "name" VARCHAR(50) NOT NULL,
  PRIMARY KEY ("categoryId")
);

CREATE TABLE "Comment" (
  "commentId" integer DEFAULT nextval('comment_commentid') NOT NULL,
  "entryId" INT NOT NULL,
  "name" VARCHAR(50) NOT NULL,
  "emailAddress" VARCHAR(50) NULL,
  "comment" TEXT NOT NULL,
  "posted" TIMESTAMP NOT NULL,
  "subscribe" BOOLEAN NOT NULL DEFAULT true,
  PRIMARY KEY ("commentId")
);

CREATE TABLE "Entry" (
  "entryId" integer DEFAULT nextval('entry_entryid') NOT NULL,
  "title" VARCHAR(200) NOT NULL,
  "preview" VARCHAR(1000) NULL,
  "article" TEXT NOT NULL,
  "publicationDate" TIMESTAMP NOT NULL,
  "postedByUserId" INT NOT NULL,
  "disableComments" INT2 NOT NULL,
  "views" INT NOT NULL,
  "totalRating" INT NOT NULL,
  "timesRated" INT NOT NULL,
  PRIMARY KEY ("entryId")
);

CREATE TABLE "EntryCategory" (
  "entryCategoryId" integer DEFAULT nextval('entrycategory_entrycategoryid') NOT NULL,
  "entryId" INT NOT NULL,
  "categoryId" INT NOT NULL,
  PRIMARY KEY ("entryCategoryId")
);

CREATE TABLE "Subscriber" (
  "subscriberId" integer DEFAULT nextval('subscriber_subscriberid') NOT NULL,
  "fullName" VARCHAR(50) NOT NULL,
  PRIMARY KEY ("subscriberId")
);

CREATE TABLE "User" (
  "userId" integer DEFAULT nextval('user_userid') NOT NULL,
  "username" VARCHAR(20) NOT NULL,
  "password" VARCHAR(20) NOT NULL,
  "firstName" VARCHAR(20) NOT NULL,
  "lastName" VARCHAR(20) NOT NULL,
  "emailAddress" VARCHAR(50) NOT NULL,
  PRIMARY KEY ("userId")
);

--- add foreign keys


ALTER TABLE "Comment" ADD CONSTRAINT "FK_Comment_Entry" FOREIGN KEY ("entryId") REFERENCES "Entry" ("entryId");
ALTER TABLE "Entry" ADD CONSTRAINT "FK_Entry_User" FOREIGN KEY ("postedByUserId") REFERENCES "User" ("userId");
ALTER TABLE "EntryCategory" ADD CONSTRAINT "FK_EntryCategory_Entry" FOREIGN KEY ("entryId") REFERENCES "Entry" ("entryId");
ALTER TABLE "EntryCategory" ADD CONSTRAINT "FK_EntryCategory_Category" FOREIGN KEY ("categoryId") REFERENCES "Category" ("categoryId");


--- add data

INSERT INTO "User"
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

