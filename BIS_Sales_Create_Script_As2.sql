/* 
create table for the Data Sales Data Mart 
Creates a database named BIAInc

*/ 

USE master;  
GO  
IF DB_ID (N'BIAInc') IS NOT NULL --Check if it already exists, if so drop, otherwise create
DROP DATABASE BIAInc;
GO
CREATE DATABASE BIAInc;  
GO  

USE [BIAInc]
GO

DROP TABLE IF EXISTS FactSales;	--Need to drop FactTable before dropping other tables, 
						
DROP TABLE IF EXISTS DimOffice;
DROP TABLE IF EXISTS DimStaff;
DROP TABLE IF EXISTS DimItemPrice;
DROP TABLE IF EXISTS DimCustomer;
DROP TABLE IF EXISTS DimItem;
DROP TABLE IF EXISTS DimDate;

GO


CREATE TABLE DimCustomer (
	Customer_Key int identity not null,					-- Surrogate key for Dimension Table
	CustomerID nvarchar(4) not null,					-- customer natural key
	Customer_First_Name nvarchar(50) null,
	Customer_Surname nvarchar(50) null,					-- note not null may not always be true	
 Primary Key (Customer_Key)
 )

  CREATE TABLE DimOffice (
	Office_Key int identity not null,				-- Surrogate key for Dimension Table	
	Office_ID int not null,						-- staff natural key identifer
	Office_Location nvarchar(50) null

	Primary Key (Office_Key)
)


  CREATE TABLE DimStaff (
	Staff_Key int identity not null,				-- Surrogate key for Dimension Table	
	Staff_ID nvarchar(4) null,						-- staff natural key identifer
	Staff_First_Name	nvarchar(20) null,				
	Staff_Surname		nvarchar(20) null,
	
	Primary Key (Staff_Key)
	
)


  CREATE TABLE DimDate (
	Date_Key int identity not null,
	Date_ID date not null,							--This will be the datekey and the actual date								
	Date_Month int	null,					
	Date_Quarter int null,
	Date_Year int null,

 Primary Key (Date_Key)
 )

 CREATE TABLE DimItemPrice (					
	ItemPrice_Key int identity not null,					--Surrogate dimension table key
	ItemPrice	decimal(5,2)	not null,					
	Item_ID	nvarchar(5)	null,					
	Item_Description nvarchar(30) null, 
	ItemActive_Flag bit, -- Shows if item is sold for original price by displaying either 'True' or 'False' 

 Primary Key (ItemPrice_Key),
 
 )



 CREATE TABLE FactSales (
	Sale_Key int identity not null,							--Surrogate Sale Fact Key
	Reciept_ID nvarchar(255) null,			--Natural Sale Transaction Key
	Sale_Date_Key int null,							--will use a Date Dimension later
	Customer_Key int null,
	Staff_Key int null,
	Office_Key int null, 
	Reciept_Transaction_Row_ID int null,
	ItemPrice_Key Int null,
	Item_Quantity int null,
	Item_Sub_Total float null,
	Reciept_Total_Sale_Amount float  null, 
	Reciept_Discount_Sale_Amount float null,
	
Primary Key (Sale_Key),	
 FOREIGN KEY (ItemPrice_Key) REFERENCES DimItemPrice (ItemPrice_Key),
 FOREIGN KEY (Sale_Date_Key)  REFERENCES DimDate (Date_Key),
 FOREIGN KEY (Customer_Key) REFERENCES DimCustomer (Customer_Key),
 FOREIGN KEY (Staff_Key) REFERENCES DimStaff (Staff_Key),
 FOREIGN KEY (Office_Key) REFERENCES DimOffice (Office_Key)
 )							

 GO

