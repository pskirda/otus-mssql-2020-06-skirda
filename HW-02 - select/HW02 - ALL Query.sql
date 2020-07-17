/***** Все запросы в одном*****/

/****** 
1. Все товары, в названии которых есть "urgent" или название начинается с "Animal"
Таблицы: Warehouse.StockItems.
******/
SELECT [StockItemID]
      ,[StockItemName]
FROM [WideWorldImporters].[Warehouse].[StockItems]
WHERE StockItemName like '%urgent%' or StockItemName like 'Animal%' 

/****** 
2. Поставщиков (Suppliers), у которых не было сделано ни одного заказа (PurchaseOrders). Сделать через JOIN, с подзапросом задание принято не будет.
Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders.  
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
3. Заказы (Orders) с ценой товара более 100$ либо количеством единиц товара более 20 штук и присутствующей датой комплектации всего заказа (PickingCompletedWhen).
Вывести:
* OrderID
* дату заказа в формате ДД.ММ.ГГГГ
* название месяца, в котором была продажа
* номер квартала, к которому относится продажа
* треть года, к которой относится дата продажи (каждая треть по 4 месяца)
* имя заказчика (Customer)
Добавьте вариант этого запроса с постраничной выборкой, пропустив первую 1000 и отобразив следующие 100 записей. Сортировка должна быть по номеру квартала, трети года, дате заказа (везде по возрастанию).
Таблицы: Sales.Orders, Sales.OrderLines, Sales.Customers.
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
4. Заказы поставщикам (Purchasing.Suppliers), которые были исполнены в январе 2014 года 
с доставкой Air Freight или Refrigerated Air Freight (DeliveryMethodName).
Вывести:
* способ доставки (DeliveryMethodName)
* дата доставки
* имя поставщика
* имя контактного лица принимавшего заказ (ContactPerson)

Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.
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
5. Десять последних продаж (по дате) с именем клиента и именем сотрудника, который оформил заказ (SalespersonPerson).
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
6. Все ид и имена клиентов и их контактные телефоны, которые покупали товар 
Chocolate frogs 250g. Имя товара смотреть в Warehouse.StockItems.
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
