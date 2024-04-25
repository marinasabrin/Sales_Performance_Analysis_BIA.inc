--Sale Projection for Each Office

Declare @Office VARCHAR(16);
Set @Office = 'Lismore';

Select fs.Sale_Date_Key, dd.Date_ID, do.Office_Location, Sum(fs.Item_Sub_Total) as Total_sale
 From DimDate as dd inner join FactSales as fs on (dd.Date_Key = fs.Sale_Date_Key) 
inner join DimOffice as do on (fs.Office_Key = do.Office_Key)
Where do.Office_Location = @Office
Group by fs.Sale_Date_Key, dd.Date_ID, do.Office_Location
Order by dd.Date_ID asc

--Three most popular item per office 

Declare @Office2 VARCHAR(16);
Set @Office2 = 'Lismore';

select TOP (3) Date_Year, Office_Location, Item_Description, sum(Item_Quantity) as Total_Item   
From FactSales
join DimItemPrice on FactSales.ItemPrice_Key = DimItemPrice.ItemPrice_Key
join DimOffice on DimOffice.Office_Key = FactSales.Office_Key
join DimDate on DimDate.Date_Key = FactSales.Sale_Date_Key
Where DimOffice.Office_Location = @Office2
Group by DimOffice.Office_Location, DimItemPrice.Item_Description, DimDate.Date_Year
Order by Total_Item desc

--Three least popular item per office 

Declare @Office3 VARCHAR(16);
Set @Office3 = 'Lismore';

select TOP (3) Date_Year, Office_Location, Item_Description, sum(Item_Quantity) as Total_Item   
From FactSales
join DimItemPrice on FactSales.ItemPrice_Key = DimItemPrice.ItemPrice_Key
join DimOffice on DimOffice.Office_Key = FactSales.Office_Key
join DimDate on DimDate.Date_Key = FactSales.Sale_Date_Key
Where DimOffice.Office_Location = @Office3
Group by DimOffice.Office_Location, DimItemPrice.Item_Description, DimDate.Date_Year
Order by Total_Item asc

--Three worst performing items from company

select TOP (3) Date_Year, Item_Description, sum(Item_Quantity) as Total_Item   
From FactSales
join DimItemPrice on FactSales.ItemPrice_Key = DimItemPrice.ItemPrice_Key
join DimDate on DimDate.Date_Key = FactSales.Sale_Date_Key
Group by DimItemPrice.Item_Description, DimDate.Date_Year
Order by Total_Item asc

--Office Performance

Select dd.Date_Year, do.Office_Location, COUNT( distinct fs.Staff_Key) as Active_Staff, 
Sum(fs.Item_Sub_Total) as Total_Sale,
COUNT( distinct fs.Customer_Key) as Customer_Interactions, Sum(fs.Item_Quantity) as Total_Sold_Items,
(sum(fs.Item_Sub_Total)/COUNT( distinct fs.Staff_Key)) as Sale_RatioBy_Staff
From DimDate as dd inner join FactSales as fs on (dd.Date_Key = fs.Sale_Date_Key) 
inner join DimOffice as do on (fs.Office_Key = do.Office_Key)
Group by do.Office_Location, dd.Date_Year
Order by Office_Location asc
