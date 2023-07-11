-- Project name: Project2ofirofri
-- Submit date:
-- Name: Ofir Ofri

use master
use AdventureWorks2019

--1
SELECT p.Productid, p.name, p.Color, p.ListPrice, p.Size
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail sod ON p.Productid = sod.Productid
WHERE sod.SalesOrderID IS NULL
order by p.ProductID

--2
SELECT sc.CustomerID, COALESCE(pp.lastName, 'unknown') as Last_Name, COALESCE(pp.FirstName, 'unknown') as First_Name
FROM Sales.SalesOrderHeader soh
right join Sales.Customer sc on sc.CustomerID = soh.CustomerID
left join Person.Person pp on sc.CustomerID = pp.BusinessEntityID
where soh.CustomerID is null
order by sc.CustomerID

--3
select top 10 soh.CustomerID,pp.FirstName,pp.LastName ,count(soh.SalesOrderNumber) as total_orders
from person.Person pp
join Sales.SalesOrderHeader soh on pp.BusinessEntityID = soh.CustomerID
GROUP BY soh.CustomerID,pp.FirstName,pp.LastName
order by count(soh.SalesOrderNumber) desc

--4
select pp.FirstName,  pp.LastName, e.JobTitle, e.HireDate, COUNT(*) OVER (PARTITION BY e.JobTitle)
from HumanResources.Employee e
join Person.Person pp on pp.BusinessEntityID = e.BusinessEntityID
GROUP BY pp.FirstName,  pp.LastName, e.JobTitle, e.HireDate
order by e.JobTitle

--5
SELECT s.SalesOrderID, s.CustomerID, p.FirstName, p.LastName, s.OrderDate, t.PreviousOrder
FROM (
    SELECT SalesOrderID, CustomerID, OrderDate,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC, SalesOrderID DESC) AS Orn,
        LEAD(OrderDate, 1) OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS PreviousOrder
    FROM sales.salesorderheader
) AS t
JOIN sales.salesorderheader s ON t.SalesOrderID = s.SalesOrderID
JOIN sales.customer c ON t.CustomerID = c.CustomerID
JOIN person.person p ON c.PersonID = p.BusinessEntityID
WHERE t.Orn = 1
ORDER BY t.CustomerID

--6
SELECT [year], SalesOrderID, pp.LastName, pp.FirstName, FORMAT(Total, 'c', 'en-US') AS Total
FROM (
    SELECT *,
        RANK() OVER (PARTITION BY [year] ORDER BY Total DESC) AS Rnk
    FROM (
        SELECT DISTINCT od.SalesOrderID, oh.CustomerID, YEAR(oh.OrderDate) AS [year],
            SUM(od.LineTotal) OVER (PARTITION BY YEAR(oh.OrderDate), od.SalesOrderID) AS Total
        FROM sales.salesorderdetail od
        JOIN sales.salesorderheader oh ON od.SalesOrderID = oh.SalesOrderID
    ) AS s
) AS ct
LEFT JOIN sales.Customer sc ON ct.CustomerID = sc.CustomerID
LEFT JOIN person.person pp ON pp.BusinessEntityID = sc.PersonID
WHERE Rnk = 1
ORDER BY [year]

--7
select * from(select datepart(yy,orderdate) as year, datepart(mm,orderdate) as Month, SalesOrderID
from sales.salesorderheader) Sct
PIVOT (count(salesorderid) FOR Year in ([2011],[2012],[2013],[2014])) as pvt
order by month

--8
SELECT YEAR(OrderDate) AS Year, 
       CASE WHEN GROUPING(MONTH(OrderDate)) = 1 THEN 'grand_total' ELSE CAST(MONTH(OrderDate) AS VARCHAR(20)) END AS Month,
       SUM(SubTotal) AS Sum_Price,
       SUM(SUM(SubTotal)) OVER (PARTITION BY YEAR(OrderDate) ORDER BY MONTH(OrderDate)) AS Money
FROM Sales.SalesOrderHeader
GROUP BY ROLLUP(YEAR(OrderDate), MONTH(OrderDate))
ORDER BY Year, MONTH(OrderDate)

--9
with Cte1 as
( select he.BusinessEntityID as EmployeeID, pp.firstname+' '+pp.lastname as 'F_Name',
  he.HireDate,datediff(mm,he.HireDate,getdate())  as Seniority
  from [Person].[Person] pp join [HumanResources].[Employee] he on he.BusinessEntityID=pp.BusinessEntityID),
Cte2 as
( select hd.name as DepartmentName, heh.businessentityid
  from [HumanResources].[EmployeeDepartmentHistory] heh join [HumanResources].[Department] hd
  on hd.DepartmentID=heh.DepartmentID
  where heh.enddate is null)
 
 select DepartmentName,EmployeeID, F_Name, HireDate, Seniority, 
 Lead(F_Name,1)over(partition by DepartmentName order by HireDate desc) as PreviousEmpName,
 Lead(HireDate,1)over(partition by DepartmentName order by HireDate desc) as PreviousEmpHDate,
 datediff(dd,Lead(HireDate,1)over(partition by DepartmentName order by HireDate desc),HireDate) as DiffDays
 from Cte2 join Cte1 on cte1.EmployeeID=Cte2.BusinessEntityID

 --10
 SELECT he.HireDate, heh.DepartmentID, 
       STRING_AGG(CONCAT(he.BusinessEntityID, ' ', pp.LastName, ' ', pp.FirstName), ', ') AS Employees_Info
FROM [HumanResources].[Employee] he
JOIN [HumanResources].[EmployeeDepartmentHistory] heh ON heh.BusinessEntityID = he.BusinessEntityID
JOIN [Person].[Person] pp ON pp.BusinessEntityID = he.BusinessEntityID
WHERE heh.EndDate IS NULL
GROUP BY he.HireDate, heh.DepartmentID
ORDER BY he.HireDate;