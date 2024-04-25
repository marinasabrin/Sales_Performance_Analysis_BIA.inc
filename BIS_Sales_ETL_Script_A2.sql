INSERT INTO DimDate 
(Date_ID, Date_Month, Date_Quarter, Date_Year)
SELECT distinct Cast(Ass2_RawData.[Sale Date] AS date), Datepart(month, Ass2_RawData.[Sale Date]), Datepart(quarter, Ass2_RawData.[Sale Date]), Datepart(year, Ass2_RawData.[Sale Date]) 
FROM Ass2_RawData


Insert into DimCustomer
(CustomerID, Customer_First_Name, Customer_Surname)
SELECT distinct Ass2_RawData.[Customer ID], Ass2_RawData.[Customer First name], Ass2_RawData.[Customer Surname]
	From Ass2_RawData
	ORDER BY [Customer Surname] ASC -- Thought it would be an efficient way to order the data. 

Insert into	DimOffice 
(Office_ID , Office_Location )
SELECT distinct Ass2_RawData.[Staff office], Ass2_RawData.[Office Location]
FROM Ass2_RawData ORDER BY [Staff office] ASC

Insert into DimStaff --There was a problem with this data 'Error = truncated value (fixed). 
 (Staff_ID, Staff_First_Name, Staff_Surname)
SELECT distinct  Ass2_RawData.[Staff ID],Ass2_RawData.[Staff First Name], Ass2_RawData.[Staff Surname]
FROM Ass2_RawData

Insert into DimItemPrice
(ItemPrice, Item_ID, Item_Description)
SELECT distinct Ass2_RawData.[Item Price], Ass2_RawData.[Item ID], Ass2_RawData.[Item Description]
	From Ass2_RawData


  Insert into FactSales
(Reciept_Id, Sale_Date_Key, Customer_Key, Staff_Key,Office_Key, Reciept_Transaction_Row_ID, ItemPrice_Key, Item_Quantity, Item_Sub_Total, Reciept_Total_Sale_Amount, Reciept_Discount_Sale_Amount)
  SELECT x.[Reciept Id], d.Date_Key, c.Customer_Key, s.Staff_Key,o.Office_Key, x.[Reciept Transaction Row ID], i.ItemPrice_Key, x.[Item Quantity], x.[Row Total], RT.Reciept_Total_Sale_Amount , null
  FROM Ass2_RawData x
  left join DimDate d
  on x.[Sale Date] = d.Date_ID
  left join DimCustomer c
  on x.[Customer ID] = c.CustomerID
  left join DimStaff s
  on x.[Staff ID] = s.Staff_ID
  left join DimOffice o
  on x.[Staff office] = o.Office_ID
  left join DimItemPrice i
  on x.[Item ID] = i.Item_ID
  and x.[Item Price]=i.ItemPrice
  left join (select [Reciept Id] R_ID , sum ([Row Total]) as Reciept_Total_Sale_Amount FROM Ass2_RawData group by [Reciept Id] ) RT
  ON X.[Reciept Id]=RT.R_ID
 -- The below automatically updates 'Reciept_Discount_Sale_Amount' if customer qualifies for an 5% discount: 
  UPDATE FactSales
  SET Reciept_Discount_Sale_Amount = (Reciept_Total_Sale_Amount /100*5)
  Where Reciept_Transaction_Row_ID =5 
  

 SELECT * FROM DimDate--365
 SELECT * FROM DimCustomer--600
 SELECT * FROM DimOffice--10
 SELECT * FROM DimStaff--200
 SELECT * FROM DimItemPrice--30
 SELECT * FROM FactSales--109677
 SELECT * FROM FactSales where Reciept_Discount_Sale_Amount is not null---discounted -11944