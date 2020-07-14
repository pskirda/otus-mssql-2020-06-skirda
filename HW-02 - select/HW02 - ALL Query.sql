/***** ��� ������� � �����*****/

/****** 
1. ��� ������, � �������� ������� ���� "urgent" ��� �������� ���������� � "Animal"
�������: Warehouse.StockItems.
******/
SELECT [StockItemID]
      ,[StockItemName]
FROM [WideWorldImporters].[Warehouse].[StockItems]
where StockItemName like '%urgent%' or StockItemName like 'Animal%' 

/****** 
2. ����������� (Suppliers), � ������� �� ���� ������� �� ������ ������ (PurchaseOrders). ������� ����� JOIN, � ����������� ������� ������� �� �����.
�������: Purchasing.Suppliers, Purchasing.PurchaseOrders.  
******/
SELECT s.[SupplierID]
      ,[SupplierName]
      ,po.PurchaseOrderID
	  ,po.OrderDate

  FROM [WideWorldImporters].[Purchasing].[Suppliers] as s
Left JOIN [WideWorldImporters].[Purchasing].[PurchaseOrders] as po
	   ON s.SupplierCategoryID = po.SupplierID
where po.PurchaseOrderID is Null

  /****** 
3. ������ (Orders) � ����� ������ ����� 100$ ���� ����������� ������ ������ ����� 20 ���� � �������������� ����� ������������ ����� ������ (PickingCompletedWhen).
�������:
* OrderID
* ���� ������ � ������� ��.��.����
* �������� ������, � ������� ���� �������
* ����� ��������, � �������� ��������� �������
* ����� ����, � ������� ��������� ���� ������� (������ ����� �� 4 ������)
* ��� ��������� (Customer)
�������� ������� ����� ������� � ������������ ��������, ��������� ������ 1000 � ��������� ��������� 100 �������. ���������� ������ ���� �� ������ ��������, ����� ����, ���� ������ (����� �� �����������).
�������: Sales.Orders, Sales.OrderLines, Sales.Customers.
******/
SELECT o.[OrderID]
	  ,[Date] = FORMAT(o.OrderDate, N'dd.MM.yyyy')
	  ,[MONTH] = datename(m, o.OrderDate)
	  ,[Quarter] = datename(Q, o.OrderDate)
	  ,[Third] = CEILING(CAST(MONTH(o.OrderDate) AS float)/4)
      , CustomerName = (
		select c.CustomerName
		from [WideWorldImporters].[Sales].[Customers] as c
		where o.CustomerID = c.CustomerID
	  )
FROM [WideWorldImporters].[Sales].[Orders] as o
JOIN [WideWorldImporters].[Sales].OrderLines as ol
  ON o.OrderID = ol.OrderID
where (ol.UnitPrice > 100 or ol.Quantity > 20) and ol.PickingCompletedWhen is not null
order by [Quarter], [Third], [Date] 
Offset 1000 Row
fetch next 100 rows only

/*******
4. ������ ����������� (Purchasing.Suppliers), ������� ���� ��������� � ������ 2014 ���� 
� ��������� Air Freight ��� Refrigerated Air Freight (DeliveryMethodName).
�������:
* ������ �������� (DeliveryMethodName)
* ���� ��������
* ��� ����������
* ��� ����������� ���� ������������ ����� (ContactPerson)

�������: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.
******/
SELECT	dm.DeliveryMethodName as DeliveryMethodName
		,po.OrderDate as OrderDate
		,s.SupplierName as SupplierName
		,p.FullName as ContactPerson
		,po.ExpectedDeliveryDate
FROM [WideWorldImporters].[Purchasing].[Suppliers] as s
JOIN [WideWorldImporters].Application.DeliveryMethods as dm
  ON s.DeliveryMethodID = dm.DeliveryMethodID
JOIN [WideWorldImporters].Purchasing.PurchaseOrders as po
  ON s.SupplierID = po.SupplierID
JOIN [WideWorldImporters].Application.People as p
  ON po.ContactPersonID = p.PersonID
where (dm.DeliveryMethodName in ('Air Freight' , 'Refrigerated Air Freight'))
	 and po.ExpectedDeliveryDate between '20140101' and '20140131'

/*******
5. ������ ��������� ������ (�� ����) � ������ ������� � ������ ����������, ������� ������� ����� (SalespersonPerson).
*******/
select TOP 10
		o.OrderID
		,p.FullName as Customer
		,[Sales Person] = (
			select p.FullName
			from WideWorldImporters.Application.People p
			where p.PersonID = o.SalespersonPersonID
		)
from [WideWorldImporters].Sales.Orders o
JOIN WideWorldImporters.Application.People p
  on o.CustomerID = p.PersonID
where p.FullName is not null
order by OrderDate desc 

/******
6. ��� �� � ����� �������� � �� ���������� ��������, ������� �������� ����� 
Chocolate frogs 250g. ��� ������ �������� � Warehouse.StockItems.
******/
select 
		o.CustomerID as ID
		,p.FullName as Name
		,p.PhoneNumber as Phone
from WideWorldImporters.Sales.OrderLines ol
join WideWorldImporters.Sales.Orders o
on o.OrderID = ol.OrderID
join WideWorldImporters.Warehouse.StockItems si
on ol.StockItemID = si.StockItemID
Join WideWorldImporters.Application.People p
on o.CustomerID = p.PersonID
where StockItemName = 'Chocolate frogs 250g'
order by ID
