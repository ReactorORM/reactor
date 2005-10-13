CREATE TABLE [dbo].[Country] (
	[countryId] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
--GO

CREATE TABLE [dbo].[UserType] (
	[userTypeId] [int] IDENTITY (1, 1) NOT NULL ,
	[type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
--GO

CREATE TABLE [dbo].[StateProv] (
	[stateProvId] [int] IDENTITY (1, 1) NOT NULL ,
	[code] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[countryId] [int] NOT NULL 
) ON [PRIMARY]
--GO

CREATE TABLE [dbo].[User] (
	[userId] [int] IDENTITY (1, 1) NOT NULL ,
	[username] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[password] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[firstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[lastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[userTypeId] [int] NOT NULL ,
	[dateCreated] [datetime] NOT NULL 
) ON [PRIMARY]
--GO

CREATE TABLE [dbo].[Address] (
	[addressId] [int] IDENTITY (1, 1) NOT NULL ,
	[street1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[street2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[city] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[stateProvId] [int] NULL ,
	[countryId] [int] NOT NULL ,
	[postalCode] [int] NOT NULL 
) ON [PRIMARY]
--GO

CREATE TABLE [dbo].[Administrator] (
	[administratorId] [int] NOT NULL ,
	[manager] [bit] NOT NULL 
) ON [PRIMARY]
--GO

CREATE TABLE [dbo].[Company] (
	[companyId] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[phone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[dateCreated] [datetime] NOT NULL ,
	[mailingAddressId] [int] NOT NULL ,
	[billingAddressId] [int] NOT NULL 
) ON [PRIMARY]
--GO

CREATE TABLE [dbo].[Customer] (
	[customerId] [int] NOT NULL ,
	[mailingAddressId] [int] NOT NULL ,
	[billingAddressId] [int] NOT NULL 
) ON [PRIMARY]
--GO

CREATE TABLE [dbo].[Invoice] (
	[invoiceId] [int] IDENTITY (1, 1) NOT NULL ,
	[customerId] [int] NOT NULL ,
	[dueDate] [datetime] NOT NULL 
) ON [PRIMARY]
--GO

CREATE TABLE [dbo].[Merchant] (
	[merchantId] [int] NOT NULL ,
	[companyId] [int] NOT NULL ,
	[title] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
--GO

CREATE TABLE [dbo].[Product] (
	[productId] [int] IDENTITY (1, 1) NOT NULL ,
	[createdByMerchantId] [int] NOT NULL ,
	[companyId] [int] NOT NULL ,
	[name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[price] [money] NOT NULL ,
	[inventory] [int] NOT NULL ,
	[dateCreated] [datetime] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
--GO

CREATE TABLE [dbo].[InvoiceProduct] (
	[invoiceId] [int] NOT NULL ,
	[productId] [int] NULL 
) ON [PRIMARY]
--GO

ALTER TABLE [dbo].[Country] WITH NOCHECK ADD 
	CONSTRAINT [PK_Country] PRIMARY KEY  CLUSTERED 
	(
		[countryId]
	)  ON [PRIMARY] 
--GO

ALTER TABLE [dbo].[UserType] WITH NOCHECK ADD 
	CONSTRAINT [PK_UserType] PRIMARY KEY  CLUSTERED 
	(
		[userTypeId]
	)  ON [PRIMARY] 
--GO

ALTER TABLE [dbo].[StateProv] WITH NOCHECK ADD 
	CONSTRAINT [PK_StateProv] PRIMARY KEY  CLUSTERED 
	(
		[stateProvId]
	)  ON [PRIMARY] 
--GO

ALTER TABLE [dbo].[User] WITH NOCHECK ADD 
	CONSTRAINT [PK_User] PRIMARY KEY  CLUSTERED 
	(
		[userId]
	)  ON [PRIMARY] 
--GO

ALTER TABLE [dbo].[Address] WITH NOCHECK ADD 
	CONSTRAINT [PK_Address] PRIMARY KEY  CLUSTERED 
	(
		[addressId]
	)  ON [PRIMARY] 
--GO

ALTER TABLE [dbo].[Administrator] WITH NOCHECK ADD 
	CONSTRAINT [PK_Administrator] PRIMARY KEY  CLUSTERED 
	(
		[administratorId]
	)  ON [PRIMARY] 
--GO

ALTER TABLE [dbo].[Company] WITH NOCHECK ADD 
	CONSTRAINT [PK_Company] PRIMARY KEY  CLUSTERED 
	(
		[companyId]
	)  ON [PRIMARY] 
--GO

ALTER TABLE [dbo].[Customer] WITH NOCHECK ADD 
	CONSTRAINT [PK_Customer] PRIMARY KEY  CLUSTERED 
	(
		[customerId]
	)  ON [PRIMARY] 
--GO

ALTER TABLE [dbo].[Invoice] WITH NOCHECK ADD 
	CONSTRAINT [PK_Invoices] PRIMARY KEY  CLUSTERED 
	(
		[invoiceId]
	)  ON [PRIMARY] 
--GO

ALTER TABLE [dbo].[Merchant] WITH NOCHECK ADD 
	CONSTRAINT [PK_Merchant] PRIMARY KEY  CLUSTERED 
	(
		[merchantId]
	)  ON [PRIMARY] 
--GO

ALTER TABLE [dbo].[Product] WITH NOCHECK ADD 
	CONSTRAINT [PK_Products] PRIMARY KEY  CLUSTERED 
	(
		[productId]
	)  ON [PRIMARY] 
--GO

ALTER TABLE [dbo].[User] ADD 
	CONSTRAINT [DF_User_dateCreated] DEFAULT (getdate()) FOR [dateCreated]
--GO

ALTER TABLE [dbo].[Administrator] ADD 
	CONSTRAINT [DF_Administrator_manager] DEFAULT (0) FOR [manager]
--GO

ALTER TABLE [dbo].[Company] ADD 
	CONSTRAINT [DF_Company_dateCreated] DEFAULT (getdate()) FOR [dateCreated]
--GO

ALTER TABLE [dbo].[Product] ADD 
	CONSTRAINT [DF_Products_inventory] DEFAULT (0) FOR [inventory],
	CONSTRAINT [DF_Products_dateCreated] DEFAULT (getdate()) FOR [dateCreated]
--GO

ALTER TABLE [dbo].[StateProv] ADD 
	CONSTRAINT [FK_StateProv_Country] FOREIGN KEY 
	(
		[countryId]
	) REFERENCES [dbo].[Country] (
		[countryId]
	)
--GO

ALTER TABLE [dbo].[User] ADD 
	CONSTRAINT [FK_User_UserType] FOREIGN KEY 
	(
		[userTypeId]
	) REFERENCES [dbo].[UserType] (
		[userTypeId]
	)
--GO

ALTER TABLE [dbo].[Address] ADD 
	CONSTRAINT [FK_Address_Country] FOREIGN KEY 
	(
		[countryId]
	) REFERENCES [dbo].[Country] (
		[countryId]
	),
	CONSTRAINT [FK_Address_StateProv] FOREIGN KEY 
	(
		[stateProvId]
	) REFERENCES [dbo].[StateProv] (
		[stateProvId]
	)
--GO

ALTER TABLE [dbo].[Administrator] ADD 
	CONSTRAINT [FK_Administrator_User] FOREIGN KEY 
	(
		[administratorId]
	) REFERENCES [dbo].[User] (
		[userId]
	)
--GO

ALTER TABLE [dbo].[Company] ADD 
	CONSTRAINT [FK_Company_Address] FOREIGN KEY 
	(
		[mailingAddressId]
	) REFERENCES [dbo].[Address] (
		[addressId]
	),
	CONSTRAINT [FK_Company_Address1] FOREIGN KEY 
	(
		[billingAddressId]
	) REFERENCES [dbo].[Address] (
		[addressId]
	)
--GO

ALTER TABLE [dbo].[Customer] ADD 
	CONSTRAINT [FK_Customer_Address] FOREIGN KEY 
	(
		[mailingAddressId]
	) REFERENCES [dbo].[Address] (
		[addressId]
	),
	CONSTRAINT [FK_Customer_Address1] FOREIGN KEY 
	(
		[billingAddressId]
	) REFERENCES [dbo].[Address] (
		[addressId]
	),
	CONSTRAINT [FK_Customer_User] FOREIGN KEY 
	(
		[customerId]
	) REFERENCES [dbo].[User] (
		[userId]
	)
--GO

ALTER TABLE [dbo].[Invoice] ADD 
	CONSTRAINT [FK_Invoices_Customer] FOREIGN KEY 
	(
		[customerId]
	) REFERENCES [dbo].[Customer] (
		[customerId]
	)
--GO

ALTER TABLE [dbo].[Merchant] ADD 
	CONSTRAINT [FK_Merchant_Company] FOREIGN KEY 
	(
		[companyId]
	) REFERENCES [dbo].[Company] (
		[companyId]
	),
	CONSTRAINT [FK_Merchant_User] FOREIGN KEY 
	(
		[merchantId]
	) REFERENCES [dbo].[User] (
		[userId]
	)
--GO

ALTER TABLE [dbo].[Product] ADD 
	CONSTRAINT [FK_Products_Company] FOREIGN KEY 
	(
		[companyId]
	) REFERENCES [dbo].[Company] (
		[companyId]
	),
	CONSTRAINT [FK_Products_Merchant] FOREIGN KEY 
	(
		[createdByMerchantId]
	) REFERENCES [dbo].[Merchant] (
		[merchantId]
	)
--GO

ALTER TABLE [dbo].[InvoiceProduct] ADD 
	CONSTRAINT [FK_InvoiceProducts_Invoices] FOREIGN KEY 
	(
		[invoiceId]
	) REFERENCES [dbo].[Invoice] (
		[invoiceId]
	),
	CONSTRAINT [FK_InvoiceProducts_Products] FOREIGN KEY 
	(
		[productId]
	) REFERENCES [dbo].[Product] (
		[productId]
	)
--GO

