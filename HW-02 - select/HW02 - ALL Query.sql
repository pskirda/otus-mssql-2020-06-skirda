/***** ��� ������� � �����*****/

/****** 
1. ��� ������, � �������� ������� ���� "urgent" ��� �������� ���������� � "Animal"
�������: Warehouse.StockItems.
******/
SELECT [StockItemID]
      ,[StockItemName]
FROM [WideWorldImporters].[Warehouse].[StockItems]
WHERE StockItemName like '%urgent%' or StockItemName like 'Animal%' 

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
WHERE po.PurchaseOrderID is Null

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
WHERE (ol.UnitPrice > 100 or ol.Quantity > 20) and ol.PickingCompletedWhen is not null
ORDER BY [Quarter], [Third], [Date] 
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
WHERE (dm.DeliveryMethodName in ('Air Freight' , 'Refrigerated Air Freight'))
	 and po.ExpectedDeliveryDate between '20140101' and '20140131'

/*******
5. ������ ��������� ������ (�� ����) � ������ ������� � ������ ����������, ������� ������� ����� (SalespersonPerson).
*******/
SELECT TOP 10
		o.OrderID
		,p.FullName as Customer
		,[Sales Person] = (
			SELECT p.FullName
			FROM WideWorldImporters.Application.People p
			WHERE p.PersonID = o.SalespersonPersonID
		)
FROM [WideWorldImporters].Sales.Orders o
JOIN WideWorldImporters.Application.People p
  ON o.CustomerID = p.PersonID
WHERE p.FullName is not null
ORDER BY OrderDate DESC 

/******
6. ��� �� � ����� �������� � �� ���������� ��������, ������� �������� ����� 
Chocolate frogs 250g. ��� ������ �������� � Warehouse.StockItems.
******/
SELECT 
		o.CustomerID as ID
		,p.FullName as Name
		,p.PhoneNumber as Phone
FROM WideWorldImporters.Sales.OrderLines ol
JOIN WideWorldImporters.Sales.Orders o
ON o.OrderID = ol.OrderID
JOIN WideWorldImporters.Warehouse.StockItems si
ON ol.StockItemID = si.StockItemID
JOIN WideWorldImporters.Application.People p
ON o.CustomerID = p.PersonID
WHERE StockItemName = 'Chocolate frogs 250g'
ORDER BY ID
