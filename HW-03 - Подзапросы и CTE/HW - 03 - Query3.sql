/****
3. Выберите информацию по клиентам, которые перевели компании пять максимальных платежей из Sales.CustomerTransactions. 
Представьте несколько способов (в том числе с CTE).
****/

--WITH
WITH cte_topFive
as (
 select
	CustomerID
	,MAX(TransactionAmount) as MaxAmmount
 from WideWorldImporters.Sales.CustomerTransactions
 group by CustomerID
)
 select top 5
	p.PersonID as ID
	,p.FullName as FullName
	,cte_topFive.MaxAmmount as MaxAmmount
 from [WideWorldImporters].Application.People p, cte_topFive
 where p.PersonID = cte_topFive.CustomerID
 order by MaxAmmount desc

 --Подзапрос
 select top 5
	p.PersonID as ID
	,p.FullName
	,(select
		MAX(TransactionAmount) as MaxAmmount
	 from WideWorldImporters.Sales.CustomerTransactions
	 where CustomerID = p.PersonID
	) as MaxAmoount
 from [WideWorldImporters].Application.People p
 order by MaxAmoount desc

 --JOIN
  select top 5
	ct.CustomerID as ID
	,p.FullName as FullName
	,MAX(TransactionAmount) as MaxAmmount
 from WideWorldImporters.Sales.CustomerTransactions ct
 join [WideWorldImporters].Application.People p
   on ct.CustomerID = p.PersonID
 group by ct.CustomerID, p.FullName 
 order by MaxAmmount desc