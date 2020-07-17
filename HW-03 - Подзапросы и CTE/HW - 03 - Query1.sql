/******
1. �������� ����������� (Application.People), ������� �������� ������������ (IsSalesPerson), 
� �� ������� �� ����� ������� 04 ���� 2015 ����. ������� �� ���������� � ��� ������ ���. 
������� �������� � ������� Sales.Invoices.
*****/
--���������
select
	p.PersonID as [ID]
	,p.FullName as [FullName]
from [WideWorldImporters].Application.People p
where p.IsSalesperson = 1
and p.PersonID NOT IN (select SalespersonPersonID
							from [WideWorldImporters].Sales.Invoices
							where InvoiceDate = '20150704')
--With
WITH cte_salers
as (select SalespersonPersonID
		from [WideWorldImporters].Sales.Invoices
		where InvoiceDate = '20150704'
	)
select TOP 100 
	p.PersonID as [ID]
	,p.FullName as [FullName]
from [WideWorldImporters].Application.People p
left join cte_salers 
	   on p.PersonID = cte_salers.SalespersonPersonID
where p.IsSalesperson = 1
and cte_salers.SalespersonPersonID is null