/******
6. Все ид и имена клиентов и их контактные телефоны, которые покупали товар 
Chocolate frogs 250g. Имя товара смотреть в Warehouse.StockItems.
******/
select 
		[ID] = o.CustomerID
		,[Name] = p.FullName
		,[Phone] = p.PhoneNumber
from WideWorldImporters.Sales.OrderLines ol
join WideWorldImporters.Sales.Orders o
on o.OrderID = ol.OrderID
join WideWorldImporters.Warehouse.StockItems si
on ol.StockItemID = si.StockItemID
Join WideWorldImporters.Application.People p
on o.CustomerID = p.PersonID
where StockItemName = 'Chocolate frogs 250g'
order by ID