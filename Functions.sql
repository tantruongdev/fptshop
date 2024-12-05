USE ASSIGNMENT2
GO
--Function1 (Xử lý Throw)
CREATE OR ALTER FUNCTION CalculateTotalSales(@p_ProductLineID Int, @p_StartDate Date, @p_EndDate Date)
RETURNS INT
AS
BEGIN
   -- Gán giá trị mặc định nếu tham số không được cung cấp
    SET @p_StartDate = ISNULL(@p_StartDate, (SELECT MIN([order].order_date) FROM [order]));
    SET @p_EndDate = ISNULL(@p_EndDate, GETDATE());

	IF NOT EXISTS (SELECT 1 FROM product_line WHERE id = @p_ProductLineID)
	BEGIN
		--PRINT N'Invalid product line.';
		RETURN -1;
	END
	IF (@p_StartDate > @p_EndDate)
	BEGIN
		--PRINT N'The start date is after the end date.';
		RETURN -1;
	END
	DECLARE @v_TotalSales INT = 0;
	DECLARE @v_Quantity INT;
	DECLARE Temp CURSOR
	FOR SELECT O1.quantity
		FROM order_includes_product_line O1 JOIN [order] O2 ON O1.order_id = O2.order_id
		WHERE O1.product_line_id = @p_ProductLineID AND O2.order_date >= @p_StartDate AND O2.order_date <= @p_EndDate AND O2.order_status = 'Completed'
	OPEN Temp
	FETCH NEXT FROM Temp
	INTO @v_Quantity
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@v_Quantity > 0) 
			SET @v_TotalSales = @v_TotalSales + @v_Quantity
		FETCH NEXT FROM Temp
		INTO @v_Quantity
	END
	CLOSE Temp
	DEALLOCATE Temp
	RETURN @v_TotalSales;
END;

--Test Function 2
select dbo.CalculateTotalSales(1, '2023-01-01', '2023-12-31');
select dbo.CalculateTotalSales(1, '2023-01-01', NULL);
select dbo.CalculateTotalSales(1, NULL, '2023-12-31');
select dbo.CalculateTotalSales(1, NULL, NULL);
SELECT TOP 1 * FROM [order];


--Function2 (Xử lý Throw)
CREATE OR ALTER FUNCTION HighestOrderAmount(@p_number Int, @p_StartDate Date, @p_EndDate Date)
RETURNS @list TABLE (
	[Rank] Int, 
	CustomerID Int, 
	Lname Varchar(40), 
	Fname Varchar(15),
	TotalOrderAmount Decimal(11,2),
	NoPurchases Int,
	TotalPoints Int )
AS
BEGIN
  -- Gán giá trị mặc định nếu tham số không được cung cấp
    SET @p_StartDate = ISNULL(@p_StartDate, (SELECT MIN(order_date) FROM [order]));
    SET @p_EndDate = ISNULL(@p_EndDate, GETDATE());

	IF (@p_number < 1)
	BEGIN
		--PRINT N'Invalid number of customers.';
		RETURN;
	END
	IF (@p_StartDate > @p_EndDate)
	BEGIN
		--PRINT N'The start date is after the end date.';
		RETURN;
	END
	DECLARE @v_CustomerID Int;
	DECLARE @v_TotalOrderAmount Decimal(11,2);
	DECLARE @v_NoPurchases Int;
	DECLARE @v_TotalPoints Int;
	DECLARE Temp CURSOR
	FOR SELECT C.customer_id, SUM(O.total_amount) AS TotalOrderAmount, COUNT(*) AS NoPurchases, C.total_points
		FROM customer C JOIN [order] O ON C.customer_id = O.customer_id
		WHERE O.order_status = 'Completed' AND O.order_date >= @p_StartDate AND O.order_date <= @p_EndDate
		GROUP BY C.customer_id, C.total_points
		ORDER BY TotalOrderAmount DESC, NoPurchases DESC, C.total_points DESC;
	OPEN Temp;
	IF (@@CURSOR_ROWS < @p_number)
	BEGIN
		--PRINT N'The number of cursor records is not enough to display.'
		RETURN;
	END
	FETCH NEXT FROM Temp
	INTO @v_CustomerID, @v_TotalOrderAmount, @v_NoPurchases, @v_TotalPoints;
	DECLARE @i int = 1;
	WHILE @i <= @p_number AND @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @list
		SELECT @i, @v_CustomerID, Lname, Fname, @v_TotalOrderAmount, @v_NoPurchases, @v_TotalPoints
		FROM customer
		WHERE customer_id = @v_CustomerID;
		FETCH NEXT FROM Temp
		INTO @v_CustomerID, @v_TotalOrderAmount, @v_NoPurchases, @v_TotalPoints;
		SET @i = @i + 1;
	END
	CLOSE Temp;
	DEALLOCATE Temp;
	RETURN;
END;

--Test Function 2
select * from dbo.HighestOrderAmount(3, '2023-01-01', '2025-01-01');
select * from dbo.HighestOrderAmount(3, '2023-01-01', NULL);
select * from dbo.HighestOrderAmount(3, NULL, '2025-01-01');
select * from dbo.HighestOrderAmount(3, NULL, NULL);