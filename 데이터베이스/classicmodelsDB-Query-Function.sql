/* SQL "CompanyDB" database query exercises */

USE classicmodels;

SELECT COUNT(*) FROM customers;		/* 122개 투플 */
SELECT COUNT(*) FROM employees;		/* 23개 투플 */
SELECT COUNT(*) FROM offices;		/* 7개 투플 */
SELECT COUNT(*) FROM orderdetails;	/* 2996개 투플 */
SELECT COUNT(*) FROM orders;		/* 326개 투플 */
SELECT COUNT(*) FROM payments;		/* 273개 투플 */
SELECT COUNT(*) FROM productlines;	/* 7개 투플 */
SELECT COUNT(*) FROM products;		/* 110개 투플 */


-------------------------------------------
-- 1. WITH ROLLUP과 GROUPING() 함수
-------------------------------------------

-- WITH ROLLUP 절을 위한 샘플 테이블 생성

CREATE TABLE sales AS
SELECT	productLine, YEAR(orderDate) orderYear, quantityOrdered * priceEach orderValue
FROM	orderDetails INNER JOIN orders USING (orderNumber)
        INNER JOIN products USING (productCode)
GROUP 	BY productLine, YEAR(orderDate);

SELECT	* FROM sales;

------------------------------

-- Q1: UNION ALL을 이용한 통계 보고용 테이블의 생성

SELECT	productline, SUM(orderValue) totalOrderValue
FROM	sales
GROUP	BY productline 
UNION ALL
SELECT	NULL, SUM(orderValue) totalOrderValue
FROM	sales;

SELECT	productline, orderYear, SUM(orderValue) totalOrderValue
FROM	sales
GROUP	BY productline, orderYear 
UNION ALL
SELECT	productline, NULL, SUM(orderValue) totalOrderValue
FROM	sales
GROUP	BY productline 
UNION ALL
SELECT	NULL, NULL, SUM(orderValue) totalOrderValue
FROM	sales
ORDER 	BY productline ASC;

------------------------------

-- Q2: WITH ROLLUP을 이용한 통계 보고용 테이블의 생성

/* 2개 grouping set에 데해 소계/총계를 구함: (productline), () */
SELECT	productLine, SUM(orderValue) totalOrderValue
FROM	sales
GROUP	BY productline WITH ROLLUP;

/* 3개 grouping set에 데해 소계/총계를 구함: (productline, orderYear), (productline), () */
SELECT	productLine, orderYear, SUM(orderValue) totalOrderValue
FROM	sales
GROUP	BY productline, orderYear WITH ROLLUP;

/* grouping column list의 컬럼 순서가 바뀌면, 결과가 달라짐. */
SELECT	orderYear, productLine, SUM(orderValue) totalOrderValue
FROM	sales
GROUP	BY orderYear, productline WITH ROLLUP;

------------------------------

-- Q3: WITH ROLLUP과 GROUPING() 함수를 이용한 통계 보고용 테이블의 생성

SELECT	orderYear, productLine, SUM(orderValue) totalOrderValue, 
		GROUPING(orderYear), GROUPING(productLine)
FROM	sales
GROUP	BY orderYear, productline WITH ROLLUP;

/* CASE 문을 사용하여, NULL 값을 의미있는 레이블로 대체함. */
SELECT	CASE	GROUPING(orderYear)
				WHEN 1 THEN 'All Years'
                ELSE orderYear
		END AS orderYear,
		CASE	GROUPING(productLine)
				WHEN 1 THEN 'All Product Lines'
                ELSE productLine
		END AS productLine,
		SUM(orderValue) totalOrderValue
FROM	sales
GROUP	BY orderYear, productline WITH ROLLUP;

/* IF 문을 사용하여, NULL 값을 의미있는 레이블로 대체함. */
SELECT	IF (GROUPING(orderYear), 'All Years', orderYear) AS orderYear,
		IF (GROUPING(productLine), 'All Product Lines', productLine) AS productLine,
		SUM(orderValue) totalOrderValue
FROM	sales
GROUP	BY orderYear, productline WITH ROLLUP;


-------------------------------------------
-- 2. Window Functions
-------------------------------------------

-- Window 함수를 위한 샘플 테이블 생성

DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
	sales_employee	VARCHAR(50) NOT NULL,
	fiscal_year		INT NOT NULL,
	sale			DECIMAL(14,2) NOT NULL,
	PRIMARY KEY(sales_employee, fiscal_year)
);
 
INSERT INTO sales (sales_employee, fiscal_year, sale) VALUES
	('Bob',2016,100),
	('Bob',2017,150),
    ('Bob',2018,200),
    ('Alice',2016,150),
    ('Alice',2017,100),
    ('Alice',2018,200),
    ('John',2016,200),
    ('John',2017,150),
    ('John',2018,250);
 
SELECT * FROM sales;


-- Aggregate function + GROUP BY 절과 Window 함수 + PARTITION BY 절

SELECT	fiscal_year, SUM(sale)
FROM	sales
GROUP	BY fiscal_year;

SELECT	fiscal_year, sales_employee, sale, 
		SUM(sale) OVER (PARTITION BY fiscal_year) total_sales
FROM	sales;

-- PARTITION BY가 생략되어도 ()는 꼭 사용해야 함.

SELECT	fiscal_year, sales_employee, sale, 
		SUM(sale) OVER () total_sales
FROM	sales;

-------------------------------------------
-- 2.1 Window Functions : 파티션 내 순위(RANK) 관련 함수
-------------------------------------------

-- RANK() 함수

SELECT	sales_employee, fiscal_year, sale,
		RANK() OVER (PARTITION BY fiscal_year ORDER BY sale DESC) sales_rank
FROM	sales;

WITH order_values AS (
	SELECT	orderNumber, YEAR(orderDate) order_year, 
			quantityOrdered*priceEach AS order_value,
            RANK() OVER (
					PARTITION BY YEAR(orderDate)
					ORDER BY quantityOrdered*priceEach DESC
			) order_value_rank
    FROM	orders INNER JOIN orderDetails USING (orderNumber)
)
SELECT	* 
FROM	order_values
WHERE	order_value_rank <=3;


-- DENSE_RANK() 함수

SELECT	sales_employee, fiscal_year, sale,
		DENSE_RANK() OVER (
				PARTITION BY fiscal_year
				ORDER BY sale DESC
		) sales_rank
FROM	sales;


-- ROW_NUMBER() 함수

/* 테이블의 각 줄에 일련번호를 붙임 */
SELECT	ROW_NUMBER() OVER (ORDER BY sale DESC) row_num,
		sales_employee, fiscal_year, sale
FROM	sales;

/* 각 그룹의 top-N 줄을 찾음 */
WITH inventory AS (
	SELECT	productLine, productName, quantityInStock,
			ROW_NUMBER() OVER (
					PARTITION BY productLine 
					ORDER BY quantityInStock DESC
			) row_num
    FROM	products
)
SELECT	productLine, productName, quantityInStock
FROM	inventory
WHERE	row_num <= 3;

/* 테이블 출력 시 pagination에 사용. */
SELECT	*
FROM	(SELECT productName,  msrp,
				row_number() OVER (order by msrp) AS row_num
		 FROM products
		) t
WHERE	row_num BETWEEN 11 AND 20;


-------------------------------------------
-- 2.2 Window Functions : 파티션 내 행 순서 관련 함수
-------------------------------------------

CREATE TABLE overtime (
    employee_name 	VARCHAR(50) NOT NULL,
    department 		VARCHAR(50) NOT NULL,
    hours 			INT NOT NULL,
    PRIMARY KEY (employee_name , department)
);

INSERT INTO overtime(employee_name, department, hours) VALUES
	('Diane Murphy','Accounting',37),
	('Mary Patterson','Accounting',74),
	('Jeff Firrelli','Accounting',40),
	('William Patterson','Finance',58),
	('Gerard Bondur','Finance',47),
	('Anthony Bow','Finance',66),
	('Leslie Jennings','IT',90),
	('Leslie Thompson','IT',88),
	('Julie Firrelli','Sales',81),
	('Steve Patterson','Sales',29),
	('Foon Yue Tseng','Sales',65),
	('George Vanauf','Marketing',89),
	('Loui Bondur','Marketing',49),
	('Gerard Hernandez','Marketing',66),
	('Pamela Castillo','SCM',96),
	('Larry Bott','SCM',100),
	('Barry Jones','SCM',65);


-- FIRST_VALUE() 함수 

SELECT	employee_name, hours, 
		FIRST_VALUE(employee_name) OVER (ORDER BY hours) least_over_time
FROM	overtime;

SELECT	employee_name, department, hours,
		FIRST_VALUE(employee_name) OVER (
				PARTITION BY department
				ORDER BY hours
		) least_over_time
FROM	overtime;


-- LAST_VALUE() 함수

SELECT	employee_name, hours,
		LAST_VALUE(employee_name) OVER (
				ORDER BY hours
				RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
		) highest_overtime_employee
FROM	overtime;

SELECT	employee_name, department, hours,
		LAST_VALUE(employee_name) OVER (
				PARTITION BY department
				ORDER BY hours
				RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
		) most_overtime_employee
FROM	overtime;


-- NTH_VALUE() 함수 (MySQL에서만 제공)

SELECT	employee_name, hours,
		NTH_VALUE(employee_name,3) OVER (
				ORDER BY hours
				RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
		) highest_overtime_employee
FROM	overtime;


-- LAG() 함수

WITH productline_sales AS (
    SELECT	productline, YEAR(orderDate) order_year,
			ROUND(SUM(quantityOrdered * priceEach),0) order_value
    FROM 	orders INNER JOIN orderdetails USING (orderNumber)
			INNER JOIN products USING (productCode)
    GROUP	BY productline, order_year
)
SELECT	productline, order_year, order_value,
		LAG(order_value, 1) OVER (
				PARTITION BY productLine
				ORDER BY order_year
		) prev_year_order_value
FROM	productline_sales;


-- LEAD() 함수

SELECT	customerName, orderDate,
		LEAD(orderDate,1) OVER (
				PARTITION BY customerNumber
				ORDER BY orderDate 
		) nextOrderDate
FROM	orders INNER JOIN customers USING (customerNumber);


-------------------------------------------
-- 2.3 Window Functions : 파티션 내 비율 관련 함수
-------------------------------------------

-- PERCENT_RANK() 함수

CREATE TABLE productLineSales AS
SELECT	productLine, YEAR(orderDate) orderYear, quantityOrdered * priceEach orderValue
FROM	orderDetails INNER JOIN orders USING (orderNumber)
        INNER JOIN products USING (productCode)
GROUP	BY productLine, YEAR(orderDate);

SELECT	* FROM productLineSales;

WITH temp AS (
	SELECT	productLine, SUM(orderValue) orderValue
    FROM	productLineSales
    GROUP	BY productLine
)
SELECT	productLine,  orderValue,
		ROUND(PERCENT_RANK() OVER (ORDER BY orderValue), 2) percentile_rank
FROM	temp;

SELECT	productLine, orderYear, orderValue,
		ROUND(PERCENT_RANK() OVER (
					PARTITION BY orderYear
					ORDER BY orderValue
		), 2) percentile_rank
FROM	productLineSales;


-- CUME_DIST() 함수

CREATE TABLE scores (
    name 	VARCHAR(20) PRIMARY KEY,
    score 	INT NOT NULL
);
 
INSERT INTO scores (name, score) VALUES
	('Smith',81),
	('Jones',55),
	('Williams',55),
	('Taylor',62),
	('Brown',62),
	('Davies',84),
	('Evans',87),
	('Wilson',72),
	('Thomas',72),
	('Johnson',100);

SELECT	name, score,
		ROW_NUMBER() OVER (ORDER BY score) row_num,
		CUME_DIST() OVER (ORDER BY score) cume_dist_val
FROM	scores;


-- NTILE() 함수

WITH productline_sales AS (
    SELECT 	productline, year(orderDate) order_year,
			ROUND(SUM(quantityOrdered * priceEach),0) order_value
    FROM 	orders INNER JOIN orderdetails USING (orderNumber)
			INNER JOIN products USING (productCode)
    GROUP 	BY productline, order_year
)
SELECT	productline, order_year, order_value,
		NTILE(3) OVER (
				PARTITION BY order_year
				ORDER BY order_value DESC
		) product_line_group
FROM	productline_sales;


-------------------------------------------
-- 3. Date & Time Functions
-------------------------------------------

-------------------------------------------
-- 3.1 SYSDATE()와 NOW() 함수
-------------------------------------------

-- 컨텍스트에 따른 포멧

SELECT 	NOW();			/* 컨텍스트가 스트링 : ‘YYYY-MM-DD HH:MM:SS’ 포멧 */

SELECT 	NOW() + 0;		/* 컨텍스트가 술자 : YYYYMMDDHHDDSS.uuuuuu 포멧 */


-- 차이점 1

SELECT	SYSDATE(), NOW();

SELECT	SYSDATE(), SLEEP(5), SYSDATE();

SELECT	NOW(), SLEEP(5), NOW();


-- 차이점 2

CREATE TABLE tests (
    id 	INT AUTO_INCREMENT PRIMARY KEY,
    t 	DATETIME UNIQUE
);
 
INSERT INTO tests(t) 
WITH RECURSIVE times(t) AS ( 
	SELECT	NOW() - INTERVAL 1 MONTH AS t
		UNION ALL 
    SELECT	t + INTERVAL 1 HOUR
    FROM	times
    WHERE	t < NOW() 
)
SELECT	t
FROM	times;

SELECT  * FROM times;

SELECT	id, t						/* SYSDATE()의 경우, 인덱스의 지원이 없으므로 매우 느림 */
FROM	tests
WHERE	t >= SYSDATE() - INTERVAL 1 DAY;

EXPLAIN										
SELECT	id, t
FROM	tests
WHERE	t >= SYSDATE() - INTERVAL 1 DAY;

SELECT	id, t						/* NOW()의 경우, 인덱스 지원으로 빠르게 수행됨 */
FROM	tests
WHERE	t >= NOW() - INTERVAL 1 DAY;

EXPLAIN										
SELECT	id, t
FROM	tests
WHERE	t >= NOW() - INTERVAL 1 DAY;


-------------------------------------------
-- 3.2 TIMESTAMP(), DATE(), TIME() 함수
-------------------------------------------

SELECT 	TIMESTAMP(NOW()) AS CurrentTimestamp;

SELECT	DATE(NOW()) AS CurrentDate,
		YEAR(NOW()) AS Year,
 		MONTH(NOW()) AS Month,
		DAY(NOW()) AS Day,
		MONTHNAME(NOW()) AS MonthName,
        DAYNAME(NOW()) AS DayName,
        WEEKDAY(NOW()) AS WeekIndex;
        
SELECT	TIME(NOW()) AS CurrentTime,
		HOUR(NOW()) AS Hour,
        MINUTE(NOW()) AS Minute,
        SECOND(NOW()) AS Second;


-------------------------------------------
-- 3.3 DATEDIFF(), TIMEDIFF(), TIMESTAMPDIFF() 함수
-------------------------------------------

-- DATEDIFF() 함수

SELECT	orderNumber, DATEDIFF(requiredDate, shippedDate) daysLeft
FROM	orders
ORDER 	BY daysLeft DESC;


-- TIMEDIFF() 함수

SELECT	TIMEDIFF('2009-01-01 00:00:00', '2009-03-01 00:00:00') diff;	/* -838, 범위 에러 */
SHOW WARNINGS;


-- TIMESTAMPDIFF() 함수

SELECT	TIMESTAMPDIFF(HOUR, '2009-01-01 00:00:00', '2009-03-01 00:00:00') diff;		/* 1416 */
SHOW WARNINGS;

SELECT TIMESTAMPDIFF(MINUTE, '2010-01-01 10:00:00', '2010-01-01 10:45:59') result;	/* 45 */
SELECT TIMESTAMPDIFF(SECOND, '2010-01-01 10:00:00', '2010-01-01 10:45:59') result;	/* 2759 */

CREATE TABLE persons (
    id 				INT AUTO_INCREMENT PRIMARY KEY,
    full_name 		VARCHAR(255) NOT NULL,
    date_of_birth 	DATE NOT NULL
);

INSERT INTO persons(full_name, date_of_birth) VALUES
	('John Doe', '1990-01-01'),
    ('David Taylor', '1989-06-06'),
    ('Peter Drucker', '1985-03-02'),
    ('Lily Smith', '1992-05-05'),
    ('Mary William', '1995-12-01');
    
SELECT	id, full_name, date_of_birth,
		TIMESTAMPDIFF(YEAR, date_of_birth, DATE(NOW())) age
FROM	persons;


-------------------------------------------
-- 3.4 DATE_ADD() 및 DATE_SUB() 함수
-------------------------------------------

-- DATE_ADD() 함수

SELECT	DATE_ADD('1999-12-31 00:00:01', INTERVAL 1 DAY) result;
SELECT	DATE_ADD('1999-12-31 23:59:59', INTERVAL '1:1' MINUTE_SECOND) result;
SELECT	DATE_ADD('2000-01-01 00:00:00', INTERVAL '-1 5' DAY_HOUR) result;
SELECT	DATE_ADD('1999-12-31 23:59:59.000002', INTERVAL '1.999999' SECOND_MICROSECOND) result;

/* 자동 타입 변환 : DATE -> DATETIME */
SELECT	DATE_ADD('2000-01-01', INTERVAL 12 HOUR) result; 	/* 2000-01-01 12:00:00 */

/* 자동 날짜 변환 */
SELECT	DATE_ADD('2010-01-30', INTERVAL 1 MONTH) result;	/* 2010-02-28 */
SELECT	DATE_ADD('2012-01-30', INTERVAL 1 MONTH) result;	/* 2012-02-29 */


-- DATE_SUB() 함수

/* negative interval */
SELECT	DATE_SUB('2017-07-03',INTERVAL -1 DAY) result;		/* 2017-07-04 */

/* 잘 못된 첫번째 인자 */
SELECT DATE_SUB('2017-02-29', INTERVAL - 1 DAY) result;		/* NULL */


-------------------------------------------
-- 3.5 TIME_ADD() 및 TIME_SUB() 함수
-------------------------------------------


-------------------------------------------
-- 3.6 EXTRACT() 함수
-------------------------------------------

SELECT	EXTRACT(DAY FROM '2017-07-14 09:04:44') DAY;			/* 14 */
SELECT 	EXTRACT(DAY_HOUR FROM '2017-07-14 09:04:44') DAYHOUR;	/* 1409 */
SELECT 	EXTRACT(DAY_MICROSECOND FROM '2017-07-14 09:04:44') DAY_MS;	/* 14090444000000 */
SELECT EXTRACT(DAY_SECOND FROM '2017-07-14 09:04:44') DAY_S;		/* 14090444 */
SELECT EXTRACT(HOUR_SECOND FROM '2017-07-14 09:04:44') HOUR_S;		/* 90444 */
SELECT EXTRACT(MINUTE_SECOND FROM '2017-07-14 09:04:44') MINUTE_S;	/* 444 */
SELECT EXTRACT(WEEK FROM '2017-07-14 09:04:44') WEEK;				/* 28 */


-------------------------------------------
-- 3.7 DATE_FORMAT() 및 STR_TO_DATE() 함수
-------------------------------------------

-- DATE_FORMAT() 함수

SELECT	orderNumber,
		DATE_FORMAT(orderdate, '%Y-%m-%d') orderDate,
		DATE_FORMAT(requireddate, '%a %D %b %Y') requireddate,
		DATE_FORMAT(shippedDate, '%W %D %M %Y') shippedDate
FROM	orders;

/* shippeddate가 date 값이 아니라 string 값이므로, 순서가 스트링 순서로 나옴. 에러. */
SELECT	orderNumber, DATE_FORMAT(shippeddate, '%W %D %M %Y') shippeddate
FROM	orders
WHERE	shippeddate IS NOT NULL
ORDER	BY shippeddate;

/* shippeddate가 date 값이므로, 순서가 제대로 나옴. */
SELECT	orderNumber, DATE_FORMAT(shippeddate, '%W %D %M %Y') 'Shipped date'
FROM	orders
WHERE	shippeddate IS NOT NULL
ORDER	BY shippeddate;


-- GET_FORMAT() 함수

SELECT	DATE_FORMAT('2003-03-31', GET_FORMAT(DATE, 'ISO')) AS ISO,
		DATE_FORMAT('2003-03-31', GET_FORMAT(DATE, 'JIS')) AS JIS,
        DATE_FORMAT('2003-03-31', GET_FORMAT(DATE, 'USA')) AS USA,
        DATE_FORMAT('2003-03-31', GET_FORMAT(DATE, 'EUR')) AS EUR,
        DATE_FORMAT('2003-03-31', GET_FORMAT(DATE, 'INTERNAL')) AS INTERNAL;

SELECT	orderNumber,		
		DATE_FORMAT(orderdate, GET_FORMAT(DATE, 'ISO') ) orderDate,
		DATE_FORMAT(requireddate, GET_FORMAT(DATE,'USA') ) requireddate,
		DATE_FORMAT(shippedDate, GET_FORMAT(DATE,'EUR') ) shippedDate
FROM	orders;


-- STR_TO_DATE() 함수

SELECT	STR_TO_DATE('21,5,2013','%d,%m,%Y');		/* 2013-05-21 */
SELECT STR_TO_DATE('2013','%Y');					/* 2013-00-00 */
SELECT STR_TO_DATE('113005','%h%i%s');				/* 11:30:05 */
SELECT STR_TO_DATE('11','%h');						/* 11:00:00 */
SELECT STR_TO_DATE('20130101 1130','%Y%m%d %h%i') ;	/* 2013-01-01 11:30:00 */
SELECT STR_TO_DATE('21,5,2013 extra characters','%d,%m,%Y');	/* 2013-05-21 */


-------------------------------------------
-- 4. String Functions
-------------------------------------------

-------------------------------------------
-- 4.1 CONCAT() 함수
-------------------------------------------

SELECT	'MySQL' 'String' 'Concatenation';

SELECT	CONCAT('MySQL', 'CONCAT');
SELECT	CONCAT('MySQL', NULL, 'CONCAT');

SELECT	CONCAT(contactFirstName, ' ', contactLastName) AS fullname
FROM	customers;

SELECT	CONCAT_WS(', ', 'John', 'Doe', 'Junior');	
SELECT	CONCAT_WS(NULL, 'John', 'Doe', 'Junior');
SELECT	CONCAT_WS(', ', 'John', 'Doe', 'Junior', NULL); 

SELECT	CONCAT_WS(
			CHAR(13),		/* Carriage Return */
			CONCAT_WS(' ', contactLastName, contactFirstName),
			addressLine1,
            addressLine2,
            CONCAT_WS(' ', postalCode, city),
            country,
            CONCAT_WS(CHAR(13), '')
		) AS Customer_Address
FROM	customers;


-------------------------------------------
-- 4.2 INSTR() 함수
-------------------------------------------

SELECT	INSTR('MySQL Instring', 'MySQL');
SELECT	INSTR('MySQL Instring', 'mysql');
SELECT	INSTR('MySQL Instring', BINARY 'mysql');

------------------------------

SELECT	productName
FROM	products
WHERE	INSTR(productname, 'Car') > 0;

SELECT	productName
FROM	products
WHERE	productname like '%Car%';

------------------------------

CREATE INDEX idx_products_name ON products(productname);

EXPLAIN			
SELECT	productName						/* 인덱스 유무에 관계없이, 인덱스 사용하지 않음. */
FROM	products
WHERE	INSTR(productname, '1900') > 0;

EXPLAIN
SELECT	productName						/* 인덱스가 있으면, 인덱스를 사용함. */
FROM	products
WHERE	productname like '1900%';


-------------------------------------------
-- 4.3 SUBSTRING() 및 SUBSTRING_INDEX() 함수
-------------------------------------------

SELECT	SUBSTRING('MySQL Substring', 7);
SELECT	SUBSTRING('MySQL Substring', -9);
SELECT	SUBSTRING('MySQL Substring', 0);

SELECT	SUBSTRING('MySQL Substring', 1, 5);
SELECT	SUBSTRING('MySQL Substring', -15, 5);

SELECT	SUBSTRING_INDEX('Hello World', 'l', 1);
SELECT	SUBSTRING_INDEX('Hello World', 'l', 2);
SELECT	SUBSTRING_INDEX('Hello World', 'l', 3);

SELECT	SUBSTRING_INDEX('Hello World', 'l', -1);
SELECT	SUBSTRING_INDEX('Hello World', 'l', -2);
SELECT	SUBSTRING_INDEX('Hello World', 'l', -3);	

SELECT	SUBSTRING('MySQL Substring', INSTR('MySQL Substring', 'Substring') );


-------------------------------------------
-- 4.4 REPLACE() 함수
-------------------------------------------

SELECT	productName, productDescription 
FROM 	products
WHERE	productDescription like '%abuot%';

UPDATE	products 
SET	productDescription = REPLACE(productDescription, 'abuot', 'about');
