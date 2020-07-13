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
