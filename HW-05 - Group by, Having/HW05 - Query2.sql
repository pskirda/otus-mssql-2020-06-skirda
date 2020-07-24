/***

2. Отобразить все месяцы, где общая сумма продаж превысила 10 000

Вывести:
* Год продажи
* Месяц продажи
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
Having SUM(il.UnitPrice) > 250000
Order by [Year], [Month]