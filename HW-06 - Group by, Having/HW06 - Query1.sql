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