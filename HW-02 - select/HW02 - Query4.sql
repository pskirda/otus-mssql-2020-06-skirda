/*******
4. ������ ����������� (Purchasing.Suppliers), ������� ���� ��������� � ������ 2014 ���� 
� ��������� Air Freight ��� Refrigerated Air Freight (DeliveryMethodName).
�������:
* ������ �������� (DeliveryMethodName)
* ���� ��������
* ��� ����������
* ��� ����������� ���� ������������ ����� (ContactPerson)

�������: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.
******/
SELECT	[DeliveryMethodName] = dm.DeliveryMethodName
		,[OrderDate] = po.OrderDate
		,[SupplierName] = s.SupplierName
		,[ContactPerson] = p.FullName
		,po.ExpectedDeliveryDate
		
  FROM [WideWorldImporters].[Purchasing].[Suppliers] as s
  JOIN [WideWorldImporters].Application.DeliveryMethods as dm
  ON s.DeliveryMethodID = dm.DeliveryMethodID
  JOIN [WideWorldImporters].Purchasing.PurchaseOrders as po
  ON s.SupplierID = po.SupplierID
  JOIN [WideWorldImporters].Application.People as p
  ON po.ContactPersonID = p.PersonID
  where (dm.DeliveryMethodName in ('Air Freight' , 'Refrigerated Air Freight'))
		and po.ExpectedDeliveryDate between '20140101' and '20140131'