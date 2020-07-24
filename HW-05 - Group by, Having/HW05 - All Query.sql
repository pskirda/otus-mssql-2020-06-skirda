/***
1. Посчитать среднюю цену товара, общую сумму продажи по месяцам

Вывести:
* Год продажи
* Месяц продажи
* Средняя цена за месяц по всем товарам
* Общая сумма продаж

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.

***/
use [WideWorldImporters]

select
	YEAR(i.InvoiceDate) as [Year]
	,Month(i.InvoiceDate) as [Month]
	,format(AVG(il.UnitPrice), '0.00') as [AVG_price]
	,format(SUM(il.UnitPrice), '# ##0.00') as [SUM]
from Sales.Invoices i
join Sales.InvoiceLines il
  on i.InvoiceID = il.InvoiceID
Group by YEAR(i.InvoiceDate), MONTH(i.InvoiceDate)
Order by [Year], [Month]

/***

2. Отобразить все месяцы, где общая сумма продаж превысила 10 000

Вывести:
* Год продажи
* Месяц продажи
* Общая сумма продаж

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.

***/

select 
	YEAR(i.InvoiceDate) as [Year]
	,Month(i.InvoiceDate) as [Month]
	,format(AVG(il.UnitPrice), '0.00') as [AVG_price]
	,format(SUM(il.UnitPrice), '# ##0.00') as [SUM]
from Sales.Invoices i
join Sales.InvoiceLines il
  on i.InvoiceID = il.InvoiceID
Group by YEAR(i.InvoiceDate), MONTH(i.InvoiceDate)
Having SUM(il.UnitPrice) > 250000
Order by [Year], [Month]

/***

3. Вывести сумму продаж, дату первой продажи и количество проданного по месяцам, по товарам, продажи которых менее 50 ед в месяц.
Группировка должна быть по году, месяцу, товару.

Вывести:
* Год продажи
* Месяц продажи
* Наименование товара
* Сумма продаж
* Дата первой продажи
* Количество проданного

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.

***/

select
	YEAR(i.InvoiceDate) as [Year]
	,Month(i.InvoiceDate) as [Month]
	,si.StockItemName as [StockItemName]
	,MIN(i.InvoiceDate) as [FirstSale]
	,format(SUM(il.UnitPrice), '# ##0.00') as [MonthSUM]
	,Sum(il.Quantity) as [ItemQuantity]
from Sales.Invoices i
join Sales.InvoiceLines il
  on i.InvoiceID = il.InvoiceID
join Warehouse.StockItems si
  on si.StockItemID = il.StockItemID
Group by YEAR(i.InvoiceDate), MONTH(i.InvoiceDate), [StockItemName]
Having SUM(il.Quantity) > 4000
Order by [Year], [Month], StockItemName

/****
4. Написать рекурсивный CTE sql запрос и заполнить им временную таблицу и табличную переменную
****/
drop table if exists [WideWorldImporters].dbo.MyEmployees

CREATE TABLE dbo.MyEmployees
(
EmployeeID smallint NOT NULL,
FirstName nvarchar(30) NOT NULL,
LastName nvarchar(40) NOT NULL,
Title nvarchar(50) NOT NULL,
DeptID smallint NOT NULL,
ManagerID int NULL,
CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC)
);

INSERT INTO dbo.MyEmployees VALUES
(1, N'Ken', N'Sanchez', N'Chief Executive Officer',16,NULL)
,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1)
,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273)
,(275, N'Michael', N'Blythe', N'Sales Representative',3,274)
,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274)
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273)
,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285)
,(16, N'David',N'Bradley', N'Marketing Manager', 4, 273)
,(23, N'Mary', N'Gibson', N'Marketing Specialist', 4, 16);

;WITH Recurce_manager_CTE (EmployeeID, [Name], Title, EmployeeLevel, ManagerId)
AS 
(
	select 
		me.EmployeeID as ID
		,(select me.FirstName + ' ' + me.LastName) as [Name]
		,me.Title as Title
		,1 as EmployeLevel
		,me.ManagerID
	from dbo.MyEmployees me
	where me.ManagerID is null
	UNION ALL
	select 
		me.EmployeeID as ID
		,(select me.FirstName + ' ' + me.LastName) as [Name]
		,me.Title as Title
		,(select rm_CTE.EmployeeLevel + 1) as EmployeLevel
		,me.ManagerID
	from dbo.MyEmployees me
	JOIN Recurce_manager_CTE rm_CTE
	  on rm_CTE.EmployeeID = me.ManagerID
)

select
	rm.EmployeeID
	,rm.Name
	,rm.Title
	,rm.EmployeeLevel
from Recurce_manager_CTE rm