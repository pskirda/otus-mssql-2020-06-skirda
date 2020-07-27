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