-- Postgres Create Database



CREATE TABLE "Category" (
  "categoryId" serial NOT NULL,
  "name" VARCHAR(50) NOT NULL,
  PRIMARY KEY ("categoryId")
);

CREATE TABLE "Comment" (
  "commentID" serial NOT NULL,
  "entryId" INT NOT NULL,
  "name" VARCHAR(50) NOT NULL,
  "emailAddress" VARCHAR(50) NULL,
  "comment" TEXT NOT NULL,
  "posted" TIMESTAMP NOT NULL,
  "subscribe" BOOLEAN NOT NULL DEFAULT true,
  PRIMARY KEY ("commentID")
);

CREATE TABLE "Entry" (
  "entryId" serial NOT NULL,
  "title" VARCHAR(200) NOT NULL,
  "preview" VARCHAR(1000) NULL,
  "article" TEXT NOT NULL,
  "publicationDate" TIMESTAMP NOT NULL,
  "postedByUserId" INT NOT NULL,
  "disableComments" BOOLEAN NOT NULL,
  "views" INT NOT NULL,
  "totalRating" INT NOT NULL,
  "timesRated" INT NOT NULL
  PRIMARY KEY ("entryId")
);

CREATE TABLE "EntryCategory" (
  "entryCategoryId" serial NOT NULL,
  "entryId" INT NOT NULL,
  "categoryId" INT NOT NULL,
  PRIMARY KEY ("entryCategoryId")
);

CREATE TABLE "Subscriber" (
  "subscriberId" serial NOT NULL,
  "fullName" VARCHAR(50) NOT NULL,
  PRIMARY KEY ("subscriberId")
);

CREATE TABLE "User" (
  "userId" serial NOT NULL,
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

