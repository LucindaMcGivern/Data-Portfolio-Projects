-- Sales incentive: Give bonus to employees who made the 5 largest sales 
-- Identify employees who made 5 largest sales  
-- Identify 5 largest orders 

SELECT LastName, FirstName, Orders.OrderID, sum(Quantity * Price) as SalesAmt
FROM employees
    inner join orders
        on employees.employeeID = orders.employeeid 
    inner join orderDetails
        on orders.orderid = orderdetails.orderid
    inner join products
        on orderdetails.productid = products.productid
group by orders.orderid
having orders.orderid in (10372, 10424, 10417, 10324, 10351)
order by salesamt desc
