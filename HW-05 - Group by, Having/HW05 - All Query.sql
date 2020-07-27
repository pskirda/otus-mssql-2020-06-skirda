/***
1. ��������� ������� ���� ������, ����� ����� ������� �� �������

�������:
* ��� �������
* ����� �������
* ������� ���� �� ����� �� ���� �������
* ����� ����� ������

������� �������� � ������� Sales.Invoices � ��������� ��������.

***/
use [WideWorldImporters]

select
	YEAR(i.InvoiceDate) as [Year]
	,Month(i.InvoiceDate) as [Month]
	,format(AVG(il.UnitPrice), '0.00') as [AVG_price]
	,format(SUM(il.UnitPrice * il.Quantity), '# ### ##0.00') as [SUM]
	,format(SUM(il.Quantity), '# ### ##0.00') as [SUM_Quantity]
from Sales.Invoices i
join Sales.InvoiceLines il
  on i.InvoiceID = il.InvoiceID
Group by YEAR(i.InvoiceDate), MONTH(i.InvoiceDate)
Order by [Year], [Month]

/***

2. ���������� ��� ������, ��� ����� ����� ������ ��������� 10 000

�������:
* ��� �������
* ����� �������
* ����� ����� ������

������� �������� � ������� Sales.Invoices � ��������� ��������.

***/
use [WideWorldImporters]

select 
	YEAR(i.InvoiceDate) as [Year]
	,Month(i.InvoiceDate) as [Month]
	,format(SUM(il.Quantity * il.UnitPrice), '# ### ##0.00') as [SUM]
from Sales.Invoices i
join Sales.InvoiceLines il
  on i.InvoiceID = il.InvoiceID
Group by YEAR(i.InvoiceDate), MONTH(i.InvoiceDate)
Having SUM(il.Quantity) > 200000
Order by [Year], [Month]

/***

3. ������� ����� ������, ���� ������ ������� � ���������� ���������� �� �������, �� �������, ������� ������� ����� 50 �� � �����.
����������� ������ ���� �� ����, ������, ������.

�������:
* ��� �������
* ����� �������
* ������������ ������
* ����� ������
* ���� ������ �������
* ���������� ����������

������� �������� � ������� Sales.Invoices � ��������� ��������.

***/

use [WideWorldImporters]

select
	YEAR(i.InvoiceDate) as [Year]
	,Month(i.InvoiceDate) as [Month]
	,si.StockItemName as [StockItemName]
	,MIN(i.InvoiceDate) as [FirstSale]
	,format(SUM(il.UnitPrice * il.Quantity), '# ##0.00') as [MonthSUM]
	,Sum(il.Quantity) as [ItemQuantity]
from Sales.Invoices i
join Sales.InvoiceLines il
  on i.InvoiceID = il.InvoiceID
join Warehouse.StockItems si
  on si.StockItemID = il.StockItemID
Group by YEAR(i.InvoiceDate), MONTH(i.InvoiceDate), [StockItemName]
Having SUM(il.Quantity) < 50
Order by [Year], [Month], StockItemName

/****
4. �������� ����������� CTE sql ������ � ��������� �� ��������� ������� � ��������� ����������
****/
use [WideWorldImporters]

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

declare @table_var TABLE (ID int not null, [Name] nvarchar(100), [Title] nvarchar(50), [EmpLevel] int)

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
insert into @table_var 
select
	rm.EmployeeID
	,rm.Name
	,rm.Title
	,rm.EmployeeLevel
from Recurce_manager_CTE rm

select * from @table_var

drop table if exists #temp_table

Create TABLE #temp_table (ID int not null, [Name] nvarchar(100), [Title] nvarchar(50), [EmpLevel] int)

insert into #temp_table select * from @table_var

select * from #temp_table