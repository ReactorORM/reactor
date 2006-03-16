--drop sequence "Category_categoryId" ;
--drop sequence "Comment_commentID" ;
--drop sequence "EntryCategory_entryCategoryId" ;
--drop sequence "Entry_entryId" ;
--drop sequence "Subscriber_subscriberId" ;
--drop sequence "User_userId" ;

-- Tables

--drop TABLE "Subscriber";
--drop TABLE "User";
--drop TABLE "Category";
--drop TABLE "Entry";
--drop TABLE "EntryCategory";
--drop TABLE "Comment";

-- be sure to create users/etc as needed

-- Sequences 

create sequence "Category_categoryId" ;
create sequence "Comment_commentId" ;
create sequence "EntryCategory_entryCategoryId" ;
create sequence "Entry_entryId" ;
create sequence "Subscriber_subscriberId" ;
create sequence "User_userId" ;

-- Tables

CREATE TABLE "Subscriber"
(
  "subscriberId"  NUMBER                          NOT NULL,
  "fullName"      VARCHAR2(50 BYTE)               NOT NULL,
  PRIMARY KEY
 ("subscriberId")
);


CREATE TABLE "User"
(
  "userId"        NUMBER                          NOT NULL,
  "username"      VARCHAR2(20 BYTE)               NOT NULL,
  "password"      VARCHAR2(20 BYTE)               NOT NULL,
  "firstName"     VARCHAR2(20 BYTE)               NOT NULL,
  "lastName"      VARCHAR2(20 BYTE)               NOT NULL,
  "emailAddress"  VARCHAR2(50 BYTE)               NOT NULL,
  PRIMARY KEY
 ("userId")
);


CREATE TABLE "Category"
(
  "categoryId"  NUMBER                            NOT NULL,
  "name"        VARCHAR2(50 BYTE)                 NOT NULL,
  PRIMARY KEY
 ("categoryId")
);


CREATE TABLE "Entry"
(
  "entryId"          NUMBER                       NOT NULL,
  "title"            VARCHAR2(200 BYTE)           NOT NULL,
  "preview"          VARCHAR2(1000 BYTE),
  "article"          CLOB                         NOT NULL,
  "publicationDate"  DATE                         NOT NULL,
  "postedByUserId"   NUMBER                       NOT NULL,
  "disableComments"  NUMBER		                  NOT NULL,
  "views"            NUMBER                       NOT NULL,
  "totalRating"		 NUMBER                       NOT NULL,
  "timesRated" 	   	 NUMBER                       NOT NULL,
  PRIMARY KEY
 ("entryId"),
  CONSTRAINT FK_ENTRY_USER 
 FOREIGN KEY ("postedByUserId") 
 REFERENCES "User" ("userId")
);


CREATE TABLE "EntryCategory"
(
  "entryCategoryId"  NUMBER                       NOT NULL,
  "entryId"          NUMBER                       NOT NULL,
  "categoryId"       NUMBER                       NOT NULL,
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
  "commentId"     NUMBER                          NOT NULL,
  "entryId"       NUMBER                          NOT NULL,
  "name"          VARCHAR2(50 BYTE)               NOT NULL,
  "emailAddress"  VARCHAR2(50 BYTE),
  "comment"     CLOB                            NOT NULL,
  "posted"        DATE                            NOT NULL,
  "subscribe"  	NUMBER                 NOT NULL,
  PRIMARY KEY
 ("commentId"),
  CONSTRAINT FK_COMMENTS_ENTRY 
 FOREIGN KEY ("entryId") 
 REFERENCES "Entry" ("entryId")
);

INSERT INTO "User"
(
  "userId",
  "username",
  "password",
  "firstName",
  "lastName",
  "emailAddress"
)
VALUES
(
  "User_userId".nextval,
  'admin',
  'admin',
  'Admin',
  'User',
  'admin@example.com'
);

COMMIT;

 

-- ----------------------------------------------------------------------
-- EOF