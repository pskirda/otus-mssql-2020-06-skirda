/***** Все запросы в одном*****/

/****** 
1. Все товары, в названии которых есть "urgent" или название начинается с "Animal"
Таблицы: Warehouse.StockItems.
******/
SELECT [StockItemID]
      ,[StockItemName]
FROM [WideWorldImporters].[Warehouse].[StockItems]
where StockItemName like '%urgent%' or StockItemName like 'Animal%' 

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
where po.PurchaseOrderID is Null

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
where (ol.UnitPrice > 100 or ol.Quantity > 20) and ol.PickingCompletedWhen is not null
order by [Quarter], [Third], [Date] 
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
where (dm.DeliveryMethodName in ('Air Freight' , 'Refrigerated Air Freight'))
	 and po.ExpectedDeliveryDate between '20140101' and '20140131'

/*******
5. Десять последних продаж (по дате) с именем клиента и именем сотрудника, который оформил заказ (SalespersonPerson).
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
6. Все ид и имена клиентов и их контактные телефоны, которые покупали товар 
Chocolate frogs 250g. Имя товара смотреть в Warehouse.StockItems.
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
