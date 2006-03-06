IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'ReactorBlog')
	DROP DATABASE [ReactorBlog]
GO

CREATE DATABASE [ReactorBlog]
GO

use [ReactorBlog]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_EntryCategory_Category]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[EntryCategory] DROP CONSTRAINT FK_EntryCategory_Category
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Comments_Entry]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Comment] DROP CONSTRAINT FK_Comments_Entry
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_EntryCategory_Entry]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[EntryCategory] DROP CONSTRAINT FK_EntryCategory_Entry
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Entry_User]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Entry] DROP CONSTRAINT FK_Entry_User
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Category]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Category]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Comment]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Comment]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Entry]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Entry]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EntryCategory]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[EntryCategory]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Subscriber]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Subscriber]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[User]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[User]
GO

CREATE TABLE [dbo].[Category] (
	[categoryId] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Comment] (
	[commentID] [int] IDENTITY (1, 1) NOT NULL ,
	[entryId] [int] NOT NULL ,
	[name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[emailAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[posted] [datetime] NOT NULL ,
	[subscribe] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Entry] (
	[entryId] [int] IDENTITY (1, 1) NOT NULL ,
	[title] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[preview] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[article] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[publicationDate] [datetime] NOT NULL ,
	[postedByUserId] [int] NOT NULL ,
	[disableComments] [bit] NOT NULL ,
	[views] [int] NOT NULL,
	[totalRating] [int] NOT NULL,
	[timesRated] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[EntryCategory] (
	[entryCategoryId] [int] IDENTITY (1, 1) NOT NULL ,
	[entryId] [int] NOT NULL ,
	[categoryId] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Subscriber] (
	[subscriberId] [int] NOT NULL ,
	[fullName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[User] (
	[userId] [int] IDENTITY (1, 1) NOT NULL ,
	[username] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[password] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[firstName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[lastName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[emailAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Category] WITH NOCHECK ADD 
	CONSTRAINT [PK_Category] PRIMARY KEY  CLUSTERED 
	(
		[categoryId]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Comment] WITH NOCHECK ADD 
	CONSTRAINT [PK_Comments] PRIMARY KEY  CLUSTERED 
	(
		[commentID]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Entry] WITH NOCHECK ADD 
	CONSTRAINT [PK_Entry] PRIMARY KEY  CLUSTERED 
	(
		[entryId]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[EntryCategory] WITH NOCHECK ADD 
	CONSTRAINT [PK_EntryCategory] PRIMARY KEY  CLUSTERED 
	(
		[entryCategoryId]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Subscriber] WITH NOCHECK ADD 
	CONSTRAINT [PK_Subscribers] PRIMARY KEY  CLUSTERED 
	(
		[subscriberId]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[User] WITH NOCHECK ADD 
	CONSTRAINT [PK_Author] PRIMARY KEY  CLUSTERED 
	(
		[userId]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Comment] ADD 
	CONSTRAINT [DF_Comments_posted] DEFAULT (getdate()) FOR [posted],
	CONSTRAINT [DF_Comments_subscribe] DEFAULT (1) FOR [subscribe]
GO

ALTER TABLE [dbo].[Entry] ADD 
	CONSTRAINT [DF_Entry_publicationDate] DEFAULT (getdate()) FOR [publicationDate],
	CONSTRAINT [DF_Entry_disableComments] DEFAULT (0) FOR [disableComments],
	CONSTRAINT [DF_Entry_views] DEFAULT (0) FOR [views]
GO

ALTER TABLE [dbo].[Comment] ADD 
	CONSTRAINT [FK_Comments_Entry] FOREIGN KEY 
	(
		[entryId]
	) REFERENCES [dbo].[Entry] (
		[entryId]
	)
GO

ALTER TABLE [dbo].[Entry] ADD 
	CONSTRAINT [FK_Entry_User] FOREIGN KEY 
	(
		[postedByUserId]
	) REFERENCES [dbo].[User] (
		[userId]
	)
GO

ALTER TABLE [dbo].[EntryCategory] ADD 
	CONSTRAINT [FK_EntryCategory_Category] FOREIGN KEY 
	(
		[categoryId]
	) REFERENCES [dbo].[Category] (
		[categoryId]
	),
	CONSTRAINT [FK_EntryCategory_Entry] FOREIGN KEY 
	(
		[entryId]
	) REFERENCES [dbo].[Entry] (
		[entryId]
	)
GO

DECLARE @bErrors as bit

BEGIN TRANSACTION
SET @bErrors = 0

CREATE NONCLUSTERED INDEX [Entry5] ON [dbo].[Entry] ([publicationDate] DESC, [entryId] ASC, [title] ASC )
IF( @@error <> 0 ) SET @bErrors = 1

IF( @bErrors = 0 )
  COMMIT TRANSACTION
ELSE
  ROLLBACK TRANSACTION

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

INSERT INTO [User]
(
	[userName],
	[password],
	[firstName],
	[lastName],
	[emailAddress]
)
VALUES
(
	'admin',
	'admin',
	'Admin',
	'User',
	'admin@example.com'
)

