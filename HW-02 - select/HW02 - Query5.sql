/*******
5. ������ ��������� ������ (�� ����) � ������ ������� � ������ ����������, ������� ������� ����� (SalespersonPerson).
*******/
select TOP 10
		o.OrderID
		,[Customer] = p.FullName
		,[Sales Person] = (
			select p.FullName
			from WideWorldImporters.Application.People p
			where p.PersonID = o.SalespersonPersonID
		)
from [WideWorldImporters].Sales.Orders o
JOIN WideWorldImporters.Application.People p
on o.CustomerID = p.PersonID
where p.FullName is not null
order by OrderDate desc 