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