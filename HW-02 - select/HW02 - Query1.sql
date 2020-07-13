/****** 
1. Все товары, в названии которых есть "urgent" или название начинается с "Animal"
Таблицы: Warehouse.StockItems.
******/
SELECT [StockItemID]
      ,[StockItemName]
  FROM [WideWorldImporters].[Warehouse].[StockItems]
  where StockItemName like '%urgent%' or StockItemName like 'Animal%' 