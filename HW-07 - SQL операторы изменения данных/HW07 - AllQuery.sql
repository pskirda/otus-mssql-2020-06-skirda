/***
1. Довставлять в базу 5 записей используя insert в таблицу Customers или Suppliers
***/

USE WideWorldImporters

insert into Purchasing.Suppliers
	  ([SupplierID]
      ,[SupplierName]
      ,[SupplierCategoryID]
      ,[PrimaryContactPersonID]
      ,[AlternateContactPersonID]
      ,[DeliveryMethodID]
      ,[DeliveryCityID]
      ,[PostalCityID]
      ,[SupplierReference]
      ,[BankAccountName]
      ,[BankAccountBranch]
      ,[BankAccountCode]
      ,[BankAccountNumber]
      ,[BankInternationalCode]
      ,[PaymentDays]
      ,[InternalComments]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[WebsiteURL]
      ,[DeliveryAddressLine1]
      ,[DeliveryAddressLine2]
      ,[DeliveryPostalCode]
      ,[DeliveryLocation]
      ,[PostalAddressLine1]
      ,[PostalAddressLine2]
      ,[PostalPostalCode]
      ,[LastEditedBy]
		)
--OUTPUT Purchasing.Supplier
values (
		next value for Sequences.SupplierID
		,'Additional Supplier1'
		,2
		,21
		,22
		,NULL  --DeliveryMethodID
		,38171
		,38171
		,NULL  --SupplierReference
		,'Test BankAccountName'
		,'Test BankAccountBranch'
		,NULL  --BankAccountCode
		,NULL  --BankAccountNumber
		,NULL  --BankInternationalNumber
		,30
		,'Test Internal Comment'
		,'(347) 555-0100'
		,'(347) 555-0101'
		,'http://test.website.ru'
		,'Level test'
		,'450000 Ufa, Lenina St 1'
		,'450000'
		,NULL  --координаты какие то
		,'PO Box 7777'
		,'Ufa'
		,'450000'
		,1
		)
		,(
		next value for Sequences.SupplierID
		,'Additional Supplier2'
		,2
		,21
		,22
		,NULL  --DeliveryMethodID
		,38171
		,38171
		,NULL  --SupplierReference
		,'Test BankAccountName'
		,'Test BankAccountBranch'
		,NULL  --BankAccountCode
		,NULL  --BankAccountNumber
		,NULL  --BankInternationalNumber
		,30
		,'Test Internal Comment'
		,'(347) 555-0100'
		,'(347) 555-0101'
		,'http://test.website.ru'
		,'Level test'
		,'450000 Ufa, Lenina St 1'
		,'450000'
		,NULL  --координаты какие то
		,'PO Box 7777'
		,'Ufa'
		,'450000'
		,1
		)
		,(
		next value for Sequences.SupplierID
		,'Additional Supplier3'
		,2
		,21
		,22
		,NULL  --DeliveryMethodID
		,38171
		,38171
		,NULL  --SupplierReference
		,'Test BankAccountName'
		,'Test BankAccountBranch'
		,NULL  --BankAccountCode
		,NULL  --BankAccountNumber
		,NULL  --BankInternationalNumber
		,30
		,'Test Internal Comment'
		,'(347) 555-0100'
		,'(347) 555-0101'
		,'http://test.website.ru'
		,'Level test'
		,'450000 Ufa, Lenina St 1'
		,'450000'
		,NULL  --координаты какие то
		,'PO Box 7777'
		,'Ufa'
		,'450000'
		,1
		)
		,(
		next value for Sequences.SupplierID
		,'Additional Supplier4'
		,2
		,21
		,22
		,NULL  --DeliveryMethodID
		,38171
		,38171
		,NULL  --SupplierReference
		,'Test BankAccountName'
		,'Test BankAccountBranch'
		,NULL  --BankAccountCode
		,NULL  --BankAccountNumber
		,NULL  --BankInternationalNumber
		,30
		,'Test Internal Comment'
		,'(347) 555-0100'
		,'(347) 555-0101'
		,'http://test.website.ru'
		,'Level test'
		,'450000 Ufa, Lenina St 1'
		,'450000'
		,NULL  --координаты какие то
		,'PO Box 7777'
		,'Ufa'
		,'450000'
		,1
		)
		,(
		next value for Sequences.SupplierID
		,'Additional Supplier5'
		,2
		,21
		,22
		,NULL  --DeliveryMethodID
		,38171
		,38171
		,NULL  --SupplierReference
		,'Test BankAccountName'
		,'Test BankAccountBranch'
		,NULL  --BankAccountCode
		,NULL  --BankAccountNumber
		,NULL  --BankInternationalNumber
		,30
		,'Test Internal Comment'
		,'(347) 555-0100'
		,'(347) 555-0101'
		,'http://test.website.ru'
		,'Level test'
		,'450000 Ufa, Lenina St 1'
		,'450000'
		,NULL  --координаты какие то
		,'PO Box 7777'
		,'Ufa'
		,'450000'
		,1
		)
		
GO
Select * from Purchasing.Suppliers

--Перенесем зафиксируем добавленные столбцы, что бы использовать в мерже
drop table if exists #tempSuppliers

select * into #tempSuppliers
from Purchasing.Suppliers
where SupplierName like '%Additional%'

select * from #tempSuppliers 


/***
2. удалите 1 запись из Customers, которая была вами добавлена
***/

--было добавленных значений
select count(*) as [Добавленных значений] from Purchasing.Suppliers
where SupplierName like '%Additional%'

--удаляем одно из добавленных значений
delete 
from Purchasing.Suppliers
where SupplierID in (Select top 2 SupplierID from Purchasing.Suppliers where SupplierName like '%Additional%')
--стало добавленных значений
select count(*) as [Добавленных значений] from Purchasing.Suppliers
where SupplierName like '%Additional%'
--или так
Select * from Purchasing.Suppliers where SupplierName like '%Additional%'

/***
3. изменить одну запись, из добавленных через UPDATE
***/

UPDATE Purchasing.Suppliers
SET
	SupplierName = 'Add ' + SupplierName
OUTPUT --можно выводить изменненые значения
	inserted.SupplierID
	,inserted.SupplierName as [NewName]
	,deleted.SupplierName as [OldName]
where SupplierID in (Select top 2 SupplierID from Purchasing.Suppliers where SupplierName like '%Additional%')

--а можно и потом глянуть изменения
Select * from Purchasing.Suppliers where SupplierName like '%Additional%'

/***
4. Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть
***/

MERGE Purchasing.Suppliers as Target
USING #tempSuppliers as Source
ON (target.SupplierID = Source.SupplierID)
When Matched
Then update set SupplierName = source.SupplierName
When not Matched 
Then insert ([SupplierID]
      ,[SupplierName]
      ,[SupplierCategoryID]
      ,[PrimaryContactPersonID]
      ,[AlternateContactPersonID]
      ,[DeliveryMethodID]
      ,[DeliveryCityID]
      ,[PostalCityID]
      ,[SupplierReference]
      ,[BankAccountName]
      ,[BankAccountBranch]
      ,[BankAccountCode]
      ,[BankAccountNumber]
      ,[BankInternationalCode]
      ,[PaymentDays]
      ,[InternalComments]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[WebsiteURL]
      ,[DeliveryAddressLine1]
      ,[DeliveryAddressLine2]
      ,[DeliveryPostalCode]
      ,[DeliveryLocation]
      ,[PostalAddressLine1]
      ,[PostalAddressLine2]
      ,[PostalPostalCode]
      ,[LastEditedBy]
	  )
	  Values ([SupplierID]
      ,[SupplierName]
      ,[SupplierCategoryID]
      ,[PrimaryContactPersonID]
      ,[AlternateContactPersonID]
      ,[DeliveryMethodID]
      ,[DeliveryCityID]
      ,[PostalCityID]
      ,[SupplierReference]
      ,[BankAccountName]
      ,[BankAccountBranch]
      ,[BankAccountCode]
      ,[BankAccountNumber]
      ,[BankInternationalCode]
      ,[PaymentDays]
      ,[InternalComments]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[WebsiteURL]
      ,[DeliveryAddressLine1]
      ,[DeliveryAddressLine2]
      ,[DeliveryPostalCode]
      ,[DeliveryLocation]
      ,[PostalAddressLine1]
      ,[PostalAddressLine2]
      ,[PostalPostalCode]
      ,[LastEditedBy]
	  )
OUTPUT $action, deleted.*, inserted.*;

select * from Purchasing.Suppliers

/***
5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert
***/
--Устанавливаем и настраиваем bcp и bulk
-- To allow advanced options to be changed.  
EXEC sp_configure 'show advanced options', 1;  
GO  
-- To update the currently configured value for advanced options.  
RECONFIGURE;  
GO  
-- To enable the feature.  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  
-- To update the currently configured value for this feature.  
RECONFIGURE;  
GO  

SELECT @@SERVERNAME--параметры моего сервера

--выгружаем копию таблицы в текстовый файл
exec master..xp_cmdshell '
bcp "[WideWorldImporters].Purchasing.Suppliers" 
out  "C:\Курсы\SQL\otus-mssql-2020-06-skirda\HW-07 - SQL операторы изменения данных\Suppliers.txt" 
-T -w -t"@eu&$1&" -S UFA-SKIRDAPA\SQL2017'

--создаем пустую таблицу нужной нам структуры

drop table if exists Purchasing.SuppliersBAK

select top 1 * into Purchasing.SuppliersBAK
from Purchasing.Suppliers

delete from Purchasing.SuppliersBAK
where SupplierID is not NULL

BULK INSERT [WideWorldImporters].Purchasing.SuppliersBAK	
				   FROM "C:\Курсы\SQL\otus-mssql-2020-06-skirda\HW-07 - SQL операторы изменения данных\Suppliers.txt"
				   WITH 
					 (
						BATCHSIZE = 1000, 
						DATAFILETYPE = 'widechar',
						FIELDTERMINATOR = '@eu&$1&',
						ROWTERMINATOR ='\n',
						KEEPNULLS,
						TABLOCK        
					  );