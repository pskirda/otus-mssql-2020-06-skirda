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




