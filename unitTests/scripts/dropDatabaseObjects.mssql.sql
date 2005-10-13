if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Address_Country]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Address] DROP CONSTRAINT FK_Address_Country
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_StateProv_Country]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[StateProv] DROP CONSTRAINT FK_StateProv_Country
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_User_UserType]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[User] DROP CONSTRAINT FK_User_UserType
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Address_StateProv]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Address] DROP CONSTRAINT FK_Address_StateProv
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Administrator_User]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Administrator] DROP CONSTRAINT FK_Administrator_User
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Customer_User]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Customer] DROP CONSTRAINT FK_Customer_User
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Merchant_User]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Merchant] DROP CONSTRAINT FK_Merchant_User
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Company_Address]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Company] DROP CONSTRAINT FK_Company_Address
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Company_Address1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Company] DROP CONSTRAINT FK_Company_Address1
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Customer_Address]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Customer] DROP CONSTRAINT FK_Customer_Address
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Customer_Address1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Customer] DROP CONSTRAINT FK_Customer_Address1
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Merchant_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Merchant] DROP CONSTRAINT FK_Merchant_Company
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Products_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Product] DROP CONSTRAINT FK_Products_Company
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Invoices_Customer]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Invoice] DROP CONSTRAINT FK_Invoices_Customer
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_InvoiceProducts_Invoices]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[InvoiceProduct] DROP CONSTRAINT FK_InvoiceProducts_Invoices
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Products_Merchant]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Product] DROP CONSTRAINT FK_Products_Merchant
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_InvoiceProducts_Products]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[InvoiceProduct] DROP CONSTRAINT FK_InvoiceProducts_Products
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[InvoiceProduct]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[InvoiceProduct]
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Product]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Product]
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Invoice]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Invoice]
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Merchant]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Merchant]
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Company]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Company]
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Customer]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Customer]
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Address]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Address]
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Administrator]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Administrator]
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[StateProv]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[StateProv]
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[User]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[User]
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Country]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Country]
--GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[UserType]
--GO