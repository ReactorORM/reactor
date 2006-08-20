-- Tables
drop TABLE "Subscriber";
drop TABLE "User";
drop TABLE "Category";
drop TABLE "Entry";
drop TABLE "EntryCategory";
drop TABLE "Comment";

-- be sure to create users/etc as needed
-- Tables

CREATE TABLE "Subscriber"
(
  "subscriberId"  INT not null  default autoincrement   ,
  "fullName"      varchar(50)               NOT NULL,
  PRIMARY KEY
 ("subscriberId")
);


CREATE TABLE "User"
(
  "userId"        INT not null  default autoincrement  ,
  "username"      varchar(20)               NOT NULL,
  "password"      varchar(20)               NOT NULL,
  "firstName"     varchar(20)               NOT NULL,
  "lastName"      varchar(20)               NOT NULL,
  "emailAddress"  varchar(50)               NOT NULL,
  PRIMARY KEY
 ("userId")
);


CREATE TABLE "Category"
(
  "categoryId"  INT not null  default autoincrement        ,
  "name"        varchar(50)                 NOT NULL,
  PRIMARY KEY
 ("categoryId")
);


CREATE TABLE "Entry"
(
  "entryId"         INT not null  default autoincrement  ,
  "title"            varchar(200)           NOT NULL,
  "preview"          varchar(1000),
  "article"          long varchar                         NOT NULL,
  "publicationDate"  DATE                         NOT NULL,
  "postedByUserId"  int                       NOT NULL,
  "disableComments"  numeric		                  NOT NULL,
  "views"           numeric                       NOT NULL,
  "totalRating"		 numeric                       NOT NULL,
  "timesRated" 	   	 numeric                       NOT NULL,
  PRIMARY KEY
 ("entryId"),
  CONSTRAINT FK_ENTRY_USER 
 FOREIGN KEY ("postedByUserId") 
 REFERENCES "User" ("userId")
);


CREATE TABLE "EntryCategory"
(
  "entryCategoryId"  INT not null  default autoincrement   ,
  "entryId"         int                       NOT NULL,
  "categoryId"      int                       NOT NULL,
  PRIMARY KEY
 ("entryCategoryId"),
  CONSTRAINT FK_ENTRYCATEGORY_ENTRY 
 FOREIGN KEY ("entryId") 
 REFERENCES "Entry" ("entryId"),
  CONSTRAINT FK_ENTRYCATEGORY_CATEGORY 
 FOREIGN KEY ("categoryId") 
 REFERENCES "Category" ("categoryId")
);


CREATE TABLE "Comment"
(
  "commentId"    INT not null  default autoincrement  ,
  "entryId"      int                          NOT NULL,
  "name"          varchar(50)               NOT NULL,
  "emailAddress"  varchar(50),
  "comment"     long varchar                            NOT NULL,
  "posted"        DATE                            NOT NULL,
  "subscribe"   numeric                 NOT NULL,
  PRIMARY KEY
 ("commentId"),
  CONSTRAINT FK_COMMENTS_ENTRY 
 FOREIGN KEY ("entryId") 
 REFERENCES "Entry" ("entryId")
);

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

COMMIT;

 

-- ----------------------------------------------------------------------
-- EOF