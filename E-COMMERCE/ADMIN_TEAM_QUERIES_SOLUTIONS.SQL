/*-----------------QUERIES TO FACILITATE THE ADMIN TEAM*/

4) Display the total number of customers based on gender who have placed individual orders of worth at least Rs.3000.
/*--------------4TH QUERY*/
SELECT COUNT(CUS_GENDER) AS NO_OF_CUSTOMERS,CUS_GENDER FROM _order,customer
WHERE ORD_AMOUNT>=3000 GROUP BY CUS_GENDER;

5) Display all the orders along with product name ordered by a customer having Customer_Id=2
/*---------------5TH QUERY*/
SELECT o.ORD_ID, p.PRO_NAME, o.ORD_AMOUNT, o.ORD_DATE
FROM _order o
JOIN supplier_pricing sp ON o.PRICING_ID = sp.PRICING_ID
JOIN product p ON sp.PRO_ID = p.PRO_ID
WHERE o.CUS_ID = 2;

6) Display the Supplier details who can supply more than one product.
/*--------------6th QEURY*/
SELECT s.*
FROM supplier s
JOIN supplier_pricing sp ON s.SUPP_ID = sp.SUPP_ID
GROUP BY s.SUPP_ID
HAVING COUNT(DISTINCT sp.PRO_ID) > 1;

7) Find the least expensive product from each category and print the table with category id, name, product name and price of the product
/*------------7TH QUERY*/
SELECT c.CAT_ID, c.CAT_NAME, p.PRO_NAME, MIN(sp.SUPP_PRICE) AS Least_Expensive_Price
FROM category c
JOIN product p ON c.CAT_ID = p.CAT_ID
JOIN supplier_pricing sp ON p.PRO_ID = sp.PRO_ID
GROUP BY c.CAT_ID, c.CAT_NAME, p.PRO_NAME;


8) Display the Id and Name of the Product ordered after “2021-10-05”.
/*-------------8th QUERY*/
SELECT o.ORD_ID, p.PRO_NAME
FROM _order o
JOIN supplier_pricing sp ON o.PRICING_ID = sp.PRICING_ID
JOIN product p ON sp.PRO_ID = p.PRO_ID
WHERE o.ORD_DATE > '2021-10-05';


9) Display customer name and gender whose names start or end with character 'A'.
/*--------------9TH QUERY*/
SELECT CUS_NAME, CUS_GENDER
FROM customer
WHERE CUS_NAME LIKE 'A%' OR CUS_NAME LIKE '%A';


10) Create a stored procedure to display supplier id, name, Rating(Average rating of all the products sold by every customer) and Type_of_Service. 
For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”,
If rating >2 print “Average Service” else print “Poor Service”. Note that there should be one rating per supplier.
/*---------------10TH QUERY*/
DELIMITER //

CREATE PROCEDURE GetSupplierRatingAndService()
BEGIN
    SELECT s.SUPP_ID, s.SUPP_NAME, AVG(r.RAT_RATSTARS) AS Average_Rating,
    CASE
        WHEN AVG(r.RAT_RATSTARS) = 5 THEN 'Excellent Service'
        WHEN AVG(r.RAT_RATSTARS) > 4 THEN 'Good Service'
        WHEN AVG(r.RAT_RATSTARS) > 2 THEN 'Average Service'
        ELSE 'Poor Service'
    END AS Type_of_Service
    FROM supplier s
    JOIN supplier_pricing sp ON s.SUPP_ID = sp.SUPP_ID
    JOIN product p ON sp.PRO_ID = p.PRO_ID
    LEFT JOIN rating r ON sp.PRICING_ID = r.ORD_ID
    GROUP BY s.SUPP_ID, s.SUPP_NAME;
END //

DELIMITER ;
/*---------------CALLING THE STORED PROCEDURE----------*/
CALL GetSupplierRatingAndService();
