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