/******
1. Выберите сотрудников (Application.People), которые являются продажниками (IsSalesPerson), 
и не сделали ни одной продажи 04 июля 2015 года. Вывести ИД сотрудника и его полное имя. 
Продажи смотреть в таблице Sales.Invoices.
*****/
--Подзапрос
select
	p.PersonID as [ID]
	,p.FullName as [FullName]
from [WideWorldImporters].Application.People p
where p.IsSalesperson = 1
and p.PersonID NOT IN (select SalespersonPersonID
							from [WideWorldImporters].Sales.Invoices
							where InvoiceDate = '20150704')
--With
WITH cte_salers
as (select SalespersonPersonID
		from [WideWorldImporters].Sales.Invoices
		where InvoiceDate = '20150704'
	)
select TOP 100 
	p.PersonID as [ID]
	,p.FullName as [FullName]
from [WideWorldImporters].Application.People p
left join cte_salers 
	   on p.PersonID = cte_salers.SalespersonPersonID
where p.IsSalesperson = 1
and cte_salers.SalespersonPersonID is null

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



/****
3. Выберите информацию по клиентам, которые перевели компании пять максимальных платежей из Sales.CustomerTransactions. 
Представьте несколько способов (в том числе с CTE).
****/

--WITH
WITH cte_topFive
as (
 select
	CustomerID
	,MAX(TransactionAmount) as MaxAmmount
 from WideWorldImporters.Sales.CustomerTransactions
 group by CustomerID
)
 select top 5
	p.PersonID as ID
	,p.FullName as FullName
	,cte_topFive.MaxAmmount as MaxAmmount
 from [WideWorldImporters].Application.People p, cte_topFive
 where p.PersonID = cte_topFive.CustomerID
 order by MaxAmmount desc

 --Подзапрос
 select top 5
	p.PersonID as ID
	,p.FullName
	,(select
		MAX(TransactionAmount) as MaxAmmount
	 from WideWorldImporters.Sales.CustomerTransactions
	 where CustomerID = p.PersonID
	) as MaxAmoount
 from [WideWorldImporters].Application.People p
 order by MaxAmoount desc

 --JOIN
  select top 5
	ct.CustomerID as ID
	,p.FullName as FullName
	,MAX(TransactionAmount) as MaxAmmount
 from WideWorldImporters.Sales.CustomerTransactions ct
 join [WideWorldImporters].Application.People p
   on ct.CustomerID = p.PersonID
 group by ct.CustomerID, p.FullName 
 order by MaxAmmount desc

/****** 
4. Выберите города (ид и название), в которые были доставлены товары, 
входящие в тройку самых дорогих товаров, а также имя сотрудника, 
который осуществлял упаковку заказов (PackedByPersonID).
******/

with cte_orderGoods
as (
	select OrderID
	from [WideWorldImporters].Sales.OrderLines ol
	where ol.StockItemID in (
		select top 3
			si.StockItemID as ID
		from [WideWorldImporters].Warehouse.StockItems si
		order by si.UnitPrice desc
	)
)
select
	cit.CityID
	,cit.CityName
	,(select p.FullName
	from [WideWorldImporters].Application.People p
	where p.PersonID = o.PickedByPersonID
	) as PackedPersonName
from [WideWorldImporters].Sales.Orders o
join [WideWorldImporters].Sales.Customers cus
  on o.CustomerID = cus.CustomerID
join [WideWorldImporters].Application.Cities cit
  on cus.DeliveryCityID = cit.CityID
where o.OrderID in (select * from cte_orderGoods)


