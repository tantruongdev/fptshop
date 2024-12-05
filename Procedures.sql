USE ASSIGNMENT2
GO
SET DATEFORMAT dmy;
GO

--procedure1
CREATE OR ALTER PROCEDURE SearchEmployeesForStore
    @StoreName NVARCHAR(100) = NULL,         
    @EmployeeName NVARCHAR(100) = NULL, 
    @Phone NVARCHAR(20) = NULL,       
    @Email NVARCHAR(100) = NULL,      
    @SortOption INT = NULL            -- 1: asc hire_date, 2: desc hire_date)
AS
BEGIN
    IF @SortOption IS NOT NULL AND @SortOption NOT IN (1, 2)
    BEGIN
        RAISERROR ('Invalid sort option. Must be 1 (ASC) or 2 (DESC).', 16, 1);
        RETURN;
    END;

    SELECT e.*
    FROM Employee e
    JOIN Store s ON e.store_id = s.store_id
    WHERE 
		(@StoreName IS NULL OR s.store_name LIKE '%' + @StoreName + '%')

          AND (@EmployeeName IS NULL OR e.fname = @EmployeeName)
          AND (@Phone IS NULL OR e.phone_number LIKE '%' + @Phone + '%')
          AND (@Email IS NULL OR e.email LIKE '%' + @Email + '%')
    ORDER BY 
        CASE 
            WHEN @SortOption = 1 THEN e.hire_date 
            ELSE NULL
        END ASC,
        CASE
            WHEN @SortOption = 2 THEN e.hire_date 
            ELSE NULL
        END DESC;
END;

--test thủ tục
UPDATE employee 
SET store_id = 2
WHERE employee_id = 2;

SELECT * FROM employee;

EXEC SearchEmployeesForStore
    @StoreName = 'Phone Store',
    @EmployeeName = 'Phi',
    @SortOption = 2;

EXEC SearchEmployeesForStore
    @StoreName = 'Phone Store',

    @SortOption = 2;

EXEC SearchEmployeesForStore
    @StoreName = 'Phone Store',
    @EmployeeName = 'Phi';

EXEC SearchEmployeesForStore
    @StoreName = 'e';

EXEC SearchEmployeesForStore;

--procedure 2
CREATE OR ALTER PROCEDURE GetTopSellingProducts
    @MinQuantitySold INT,
    @Date DATE
AS
BEGIN
    SELECT 
        p.id AS ProductLineID,
        p.name AS ProductName,
        p.brand AS Brand,
        SUM(oip.quantity) AS TotalQuantitySold
    FROM 
        product_line p
    INNER JOIN 
        order_includes_product_line oip ON p.id = oip.product_line_id
    INNER JOIN 
        [order] o ON oip.order_id = o.order_id
    WHERE 
        p.stock_status = 1  -- Active stock
        AND CAST(o.order_date AS DATE) = @Date -- Filter by date
    GROUP BY 
        p.id, p.name, p.brand
    HAVING 
        SUM(oip.quantity) > @MinQuantitySold -- Filter by minimum quantity sold
    ORDER BY 
        TotalQuantitySold DESC;
END;

-- test thủ tục
EXEC GetTopSellingProducts @MinQuantitySold = 1, @Date = '2023-11-08';

--procedure 3 (optional)
CREATE OR ALTER PROCEDURE GetCustomerOrders
    @StartDate DATE = NULL,
    @EndDate DATE = NULL
AS
BEGIN
    -- Gán giá trị mặc định nếu các tham số không được cung cấp
    SET @StartDate = ISNULL(@StartDate, (SELECT MIN(order_date) FROM [order]));
    SET @EndDate = ISNULL(@EndDate, GETDATE());

    SELECT 
        o.order_id AS OrderID,
        o.order_date AS OrderDate,
        o.order_status AS OrderStatus,
        o.total_amount AS TotalAmount,
        c.customer_id AS CustomerID,
        c.lname AS CustomerLastName,
        c.fname AS CustomerFirstName
    FROM 
        [order] o
    JOIN 
        customer c ON o.customer_id = c.customer_id
    WHERE 
        o.order_date BETWEEN @StartDate AND @EndDate
    ORDER BY 
        o.order_date DESC;
END;
GO


-- test thủ tục
EXEC GetCustomerOrders @StartDate = '2023-01-01', @EndDate = '2024-01-01';
EXEC GetCustomerOrders @StartDate = '2023-01-01';
EXEC GetCustomerOrders  @EndDate = '2024-01-01';
EXEC GetCustomerOrders  ;