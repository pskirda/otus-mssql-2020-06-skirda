/*****
2. Выберите товары с минимальной ценой (подзапросом). 
Сделайте два варианта подзапроса. 
Вывести: ИД товара, наименование товара, цена.
*****/
--1 подзапрос
select
	si.StockItemID as ID
	,si.StockItemName as StockItem
	,si.UnitPrice	
from [WideWorldImporters].Warehouse.StockItems si
where si.UnitPrice = (SELECT MIN(UnitPrice)
					  from [WideWorldImporters].Warehouse.StockItems
					  )

--2 поздапрос
select
	si.StockItemID as ID
	,si.StockItemName as StockItem
	,si.UnitPrice	
from [WideWorldImporters].Warehouse.StockItems si
where si.UnitPrice = (SELECT TOP 1 UnitPrice as u
					  from [WideWorldImporters].Warehouse.StockItems
					  order by u
					  )

--With
WITH cte_minprice
as (SELECT MIN(UnitPrice) as m
	from [WideWorldImporters].Warehouse.StockItems
	)
select
	si.StockItemID as ID
	,si.StockItemName as StockItem
	,si.UnitPrice	
from [WideWorldImporters].Warehouse.StockItems si, cte_minprice
where si.UnitPrice = cte_minprice.m

