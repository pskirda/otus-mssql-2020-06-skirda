/*****
2. �������� ������ � ����������� ����� (�����������). 
�������� ��� �������� ����������. 
�������: �� ������, ������������ ������, ����.
*****/
--1 ���������
select
	si.StockItemID as ID
	,si.StockItemName as StockItem
	,si.UnitPrice	
from [WideWorldImporters].Warehouse.StockItems si
where si.UnitPrice = (SELECT MIN(UnitPrice)
					  from [WideWorldImporters].Warehouse.StockItems
					  )

--2 ���������
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

