--- Trigger 1
--- Update customer point and membership class
CREATE TRIGGER UpdateCustomerPointsAndMembershipClass
ON [order]
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @CustomerID INT;
    DECLARE @OrderAmount DECIMAL(10, 2);
    DECLARE @PointsEarned INT;
    DECLARE @TotalPoints INT;
    DECLARE @NewMembershipClassID INT;

    -- Lặp qua từng đơn hàng bị ảnh hưởng bởi cập nhật
    DECLARE order_cursor CURSOR FOR
    SELECT customer_id, total_amount
    FROM inserted
    WHERE order_status = 'completed';

    OPEN order_cursor;

    FETCH NEXT FROM order_cursor INTO @CustomerID, @OrderAmount;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Tính điểm tích lũy dựa trên tổng giá trị đơn hàng
        IF @OrderAmount BETWEEN 100000 AND 1000000
            SET @PointsEarned = 1;
        ELSE IF @OrderAmount BETWEEN 1000000 AND 5000000
            SET @PointsEarned = 2;
        ELSE IF @OrderAmount > 5000000
            SET @PointsEarned = 3;
        ELSE
            SET @PointsEarned = 0;

        -- Cập nhật điểm tích lũy cho khách hàng
        IF @CustomerID IS NOT NULL
        BEGIN
            UPDATE customer
            SET total_points = total_points + @PointsEarned
            WHERE customer_id = @CustomerID;

            -- Lấy tổng điểm mới
            SELECT @TotalPoints = total_points
            FROM customer
            WHERE customer_id = @CustomerID;

            -- Xác định MembershipClassID dựa trên TotalPoints từ bảng membership_class
            SELECT TOP 1 @NewMembershipClassID = id
            FROM membership_class
            WHERE @TotalPoints >= minimum_no_point
            ORDER BY minimum_no_point DESC; -- Lấy loại thành viên cao nhất mà khách hàng đạt được

            -- Cập nhật membership_class_id nếu có thay đổi
            UPDATE customer
            SET membership_class_id = @NewMembershipClassID
            WHERE customer_id = @CustomerID;
        END

        FETCH NEXT FROM order_cursor INTO @CustomerID, @OrderAmount;
    END;

    CLOSE order_cursor;
    DEALLOCATE order_cursor;
END;



--- Trigger 2
--- Update Order Total Amount
CREATE OR ALTER TRIGGER UpdateOrderTotalAmount
ON order_includes_product_line
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @OrderID INT;
    DECLARE @TotalAmount DECIMAL(10, 2);
    DECLARE @MembershipDiscount DECIMAL(10, 2);
    DECLARE @CustomerID INT;

    -- Lấy OrderID từ các hàng bị ảnh hưởng
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        SELECT TOP 1 @OrderID = order_id FROM inserted;
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
    BEGIN
        SELECT TOP 1 @OrderID = order_id FROM deleted;
    END

    -- Lấy CustomerID từ Order để tính giảm giá
    SELECT @CustomerID = customer_id
    FROM [order]
    WHERE order_id = @OrderID;

    -- Cập nhật TotalAmount cho Order
    IF @OrderID IS NOT NULL
    BEGIN
        -- Tính tổng giá trị đơn hàng trước giảm giá
        SELECT @TotalAmount = SUM(price * quantity)
        FROM order_includes_product_line
        WHERE order_id = @OrderID;

        -- Lấy phần trăm giảm giá từ membership_class
        SELECT @MembershipDiscount = discount_percent
        FROM membership_class
        JOIN customer ON membership_class.id = customer.membership_class_id
        WHERE customer.customer_id = @CustomerID;

        -- Cập nhật TotalAmount sau khi áp dụng giảm giá
        UPDATE [order]
        SET total_amount = @TotalAmount - (@TotalAmount * @MembershipDiscount / 100)
        WHERE order_id = @OrderID;
    END
END;



------- TEST ---------
---- Test Trigger -----
---- Test Trigger -----
-- Thêm khách hàng mới

-- Kiểm tra nếu bảng tồn tại thì xóa trước
IF OBJECT_ID('dbo.GlobalVars', 'U') IS NOT NULL
    DROP TABLE dbo.GlobalVars;

-- Tạo bảng toàn cục
CREATE TABLE dbo.GlobalVars (
    VariableName NVARCHAR(50) PRIMARY KEY, -- Tên biến (khóa chính)
    Value INT                              -- Giá trị của biến
);

-- Thủ tục lưu giá trị vào bảng tạm
CREATE OR ALTER PROCEDURE sp_SetGlobalVar
    @Name NVARCHAR(50), -- Tên biến
    @Value INT          -- Giá trị của biến
AS
BEGIN
    -- Kiểm tra nếu biến đã tồn tại
    IF EXISTS (SELECT 1 FROM dbo.GlobalVars WHERE VariableName = @Name)
    BEGIN
        -- Cập nhật giá trị nếu biến đã tồn tại
        UPDATE dbo.GlobalVars
        SET Value = @Value
        WHERE VariableName = @Name;
    END
    ELSE
    BEGIN
        -- Thêm biến mới nếu chưa tồn tại
        INSERT INTO dbo.GlobalVars (VariableName, Value)
        VALUES (@Name, @Value);
    END
END;


-- Hàm lấy giá trị từ bảng tạm
CREATE OR ALTER FUNCTION fn_GetGlobalVar(@Name NVARCHAR(50))
RETURNS INT
AS
BEGIN
    DECLARE @Value INT;
    -- Lấy giá trị từ bảng GlobalVars
    SELECT @Value = Value
    FROM dbo.GlobalVars
    WHERE VariableName = @Name;

    -- Trả về giá trị
    RETURN @Value;
END;


-- Testcase 1 ---
-- Thêm khách hàng mới
INSERT INTO customer 
(phone_number, email, registration_date, shipping_address, lname, fname, total_points, membership_class_id)
VALUES 
('0987651005', 'customer1005@example.com', GETDATE(), '456 Street B', 'Tran', 'B', 5, 1);

-- Lấy ID của khách hàng vừa thêm và lưu vào bảng tạm
DECLARE @CustomerID INT;

-- Lấy ID của khách hàng vừa thêm
SET @CustomerID = SCOPE_IDENTITY();

-- Lưu ID này vào bảng GlobalVars
EXEC sp_SetGlobalVar 'CustomerID', @CustomerID;

PRINT 'CustomerID: ' + CAST(dbo.fn_GetGlobalVar('CustomerID') AS NVARCHAR);
-- Thêm đơn hàng 1
INSERT INTO [order] (order_date, order_status, total_amount, employee_id, customer_id, delivery_id)
VALUES (GETDATE(), 'pending', 0, 1, dbo.fn_GetGlobalVar('CustomerID'), NULL);

-- Lấy ID của đơn hàng vừa thêm và lưu vào bảng tạm
DECLARE @OrderId INT;
SET @OrderId = SCOPE_IDENTITY();

EXEC sp_SetGlobalVar 'OrderID1', @OrderId;
PRINT 'OrderID1: ' + CAST(dbo.fn_GetGlobalVar('OrderID1') AS NVARCHAR);

-- Thêm sản phẩm vào đơn hàng 1
INSERT INTO order_includes_product_line (product_line_id, order_id, price, quantity) 
VALUES (1, dbo.fn_GetGlobalVar('OrderID1'), 5000000, 2), 
       (2, dbo.fn_GetGlobalVar('OrderID1'), 150000, 1);

-- Cập nhật trạng thái đơn hàng 1
UPDATE [order] 
SET order_status = 'completed'
WHERE order_id = dbo.fn_GetGlobalVar('OrderID1');

-- Kiểm tra điểm và hạng thành viên khách hàng
SELECT * 
FROM customer
WHERE customer_id = dbo.fn_GetGlobalVar('CustomerID');

-- Testcase 2 ---
-- Thêm đơn hàng 2
INSERT INTO [order] (order_date, order_status, total_amount, employee_id, customer_id, delivery_id)
VALUES (GETDATE(), 'pending', 0, 1, dbo.fn_GetGlobalVar('CustomerID'), NULL);

-- Lấy ID của đơn hàng vừa thêm và lưu vào bảng tạm
DECLARE @OrderId2 INT;
SET @OrderId2 = SCOPE_IDENTITY();
EXEC sp_SetGlobalVar 'OrderID2', @OrderId2;

-- Thêm sản phẩm vào đơn hàng 2
INSERT INTO order_includes_product_line (product_line_id, order_id, price, quantity) 
VALUES (1, dbo.fn_GetGlobalVar('OrderID2'), 5000000, 2), 
       (2, dbo.fn_GetGlobalVar('OrderID2'), 150000, 1);

-- Cập nhật trạng thái đơn hàng 2
UPDATE [order] 
SET order_status = 'completed'
WHERE order_id = dbo.fn_GetGlobalVar('OrderID2');

-- Kiểm tra điểm và hạng thành viên khách hàng
SELECT * 
FROM customer
WHERE customer_id = dbo.fn_GetGlobalVar('CustomerID');

-- Testcase 3 ---
-- Thêm đơn hàng 3
INSERT INTO [order] (order_date, order_status, total_amount, employee_id, customer_id, delivery_id)
VALUES (GETDATE(), 'pending', 0, 1, dbo.fn_GetGlobalVar('CustomerID'), NULL);

-- Lấy ID của đơn hàng vừa thêm và lưu vào bảng tạm
DECLARE @OrderId3 INT;
SET @OrderId3 = SCOPE_IDENTITY();
EXEC sp_SetGlobalVar 'OrderID3', @OrderId3;

-- Thêm sản phẩm vào đơn hàng 3
INSERT INTO order_includes_product_line (product_line_id, order_id, price, quantity) 
VALUES (1, dbo.fn_GetGlobalVar('OrderID3'), 5000000, 2), 
       (2, dbo.fn_GetGlobalVar('OrderID3'), 150000, 2);

-- Cập nhật trạng thái đơn hàng 3
UPDATE [order] 
SET order_status = 'completed'
WHERE order_id = dbo.fn_GetGlobalVar('OrderID3');

-- Kiểm tra thông tin đơn hàng
SELECT * 
FROM [order]
WHERE order_id = dbo.fn_GetGlobalVar('OrderID3');

-- Kiểm tra điểm và hạng thành viên khách hàng
SELECT * 
FROM customer
WHERE customer_id = dbo.fn_GetGlobalVar('CustomerID');

-- Testcase 4 ---
-- Xóa sản phẩm khỏi đơn hàng 3
DELETE FROM order_includes_product_line 
WHERE order_id = dbo.fn_GetGlobalVar('OrderID3') AND product_line_id = 1;

-- Kiểm tra lại đơn hàng
SELECT * 
FROM [order]
WHERE order_id = dbo.fn_GetGlobalVar('OrderID3');
