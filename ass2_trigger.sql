USE assignment2;
GO

--- Trigger 1
--- Update customer point and membership class
CREATE OR ALTER TRIGGER UpdateCustomerPointsAndMembershipClass
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


GO

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

        -- Nếu giỏ hàng trống (không có sản phẩm nào)
        IF @TotalAmount IS NULL OR @TotalAmount = 0
        BEGIN
            -- Đặt total_amount = 0
            UPDATE [order]
            SET total_amount = 0
            WHERE order_id = @OrderID;
        END
        ELSE
        BEGIN
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
(phone_number, email, registration_date, shipping_address, lname, fname)
VALUES -- Lấy ID của khách hàng vừa thêm và lưu vào bảng tạm
('0281234567', 'customer12227@example.com', GETDATE(), '456 Street B', 'Tran', 'B');

SELECT * FROM customer ; 

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
VALUES (1, dbo.fn_GetGlobalVar('OrderID2'), 600000, 2), 
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


--------- PROCEDURE
----- Create Order
CREATE OR ALTER PROCEDURE spCreateOrder
    @customerId INT,
    @employeeId INT,
    @deliveryId INT = NULL,
    @orderStatus NVARCHAR(50) = 'pending', -- Trạng thái mặc định là 'pending'
    @statusMessage NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Kiểm tra các giá trị NOT NULL
        IF @customerId IS NULL
        BEGIN
            SET @statusMessage = 'Error: CustomerID cannot be NULL.';
            RETURN;
        END

        IF @employeeId IS NULL
        BEGIN
            SET @statusMessage = 'Error: EmployeeID cannot be NULL.';
            RETURN;
        END

        -- Kiểm tra customerId có tồn tại
        IF NOT EXISTS (SELECT 1 FROM customer WHERE customer_id = @customerId)
        BEGIN
            SET @statusMessage = 'Error: CustomerID does not exist.';
            RETURN;
        END

        -- Kiểm tra employeeId có tồn tại
        IF NOT EXISTS (SELECT 1 FROM employee WHERE employee_id = @employeeId)
        BEGIN
            SET @statusMessage = 'Error: EmployeeID does not exist.';
            RETURN;
        END

        -- Kiểm tra deliveryId nếu được cung cấp
        IF @deliveryId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM delivery WHERE delivery_id = @deliveryId)
        BEGIN
            SET @statusMessage = 'Error: DeliveryID does not exist.';
            RETURN;
        END

        -- Kiểm tra trạng thái đơn hàng hợp lệ
        IF @orderStatus NOT IN ('pending', 'shipping', 'completed')
        BEGIN
            SET @statusMessage = 'Error: Invalid order status. Allowed values are pending, shipping, or completed.';
            RETURN;
        END

        -- Tạo đơn hàng mới
        INSERT INTO [order] (order_date, order_status, total_amount, employee_id, customer_id, delivery_id)
        VALUES (GETDATE(), @orderStatus, 0, @employeeId, @customerId, @deliveryId);

        -- Lấy orderId của đơn hàng vừa thêm
        DECLARE @orderId INT;
        SET @orderId = SCOPE_IDENTITY();

        SET @statusMessage = 'Success: Order created with OrderID = ' + CAST(@orderId AS NVARCHAR);
    END TRY
    BEGIN CATCH
        SET @statusMessage = 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;



CREATE OR ALTER PROCEDURE spAddProductToOrder
    @orderId INT,
    @productLineId INT,
    @price DECIMAL(10, 2),
    @quantity INT,
    @statusMessage NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Kiểm tra giá trị NULL hoặc không hợp lệ
        IF @orderId IS NULL
        BEGIN
            SET @statusMessage = 'Error: OrderID cannot be NULL.';
            RETURN;
        END

        IF @productLineId IS NULL
        BEGIN
            SET @statusMessage = 'Error: ProductLineID cannot be NULL.';
            RETURN;
        END

        IF @price IS NULL OR @price <= 0
        BEGIN
            SET @statusMessage = 'Error: Invalid price. It must be greater than 0.';
            RETURN;
        END

        IF @quantity IS NULL OR @quantity = 0
        BEGIN
            SET @statusMessage = 'Error: Quantity cannot be NULL or zero.';
            RETURN;
        END

        -- Kiểm tra orderId có tồn tại
        IF NOT EXISTS (SELECT 1 FROM [order] WHERE order_id = @orderId)
        BEGIN
            SET @statusMessage = 'Error: OrderID does not exist.';
            RETURN;
        END

        -- Kiểm tra productLineId có tồn tại
        IF NOT EXISTS (SELECT 1 FROM product_line WHERE id = @productLineId)
        BEGIN
            SET @statusMessage = 'Error: ProductLineID does not exist.';
            RETURN;
        END

        -- Kiểm tra sản phẩm đã tồn tại trong đơn hàng hay chưa
        IF EXISTS (SELECT 1 FROM order_includes_product_line WHERE order_id = @orderId AND product_line_id = @productLineId)
        BEGIN
            -- Nếu đã tồn tại, cập nhật số lượng
            UPDATE order_includes_product_line
            SET quantity = quantity + @quantity
            WHERE order_id = @orderId AND product_line_id = @productLineId;

            SET @statusMessage = 'Success: Quantity updated for ProductLineID = ' + CAST(@productLineId AS NVARCHAR) + ' in OrderID = ' + CAST(@orderId AS NVARCHAR);
        END
        ELSE
        BEGIN
            -- Nếu chưa tồn tại, thêm sản phẩm mới
            INSERT INTO order_includes_product_line (product_line_id, order_id, price, quantity)
            VALUES (@productLineId, @orderId, @price, @quantity);

            SET @statusMessage = 'Success: Product added to OrderID = ' + CAST(@orderId AS NVARCHAR);
        END
    END TRY
    BEGIN CATCH
        SET @statusMessage = 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;


DECLARE @statusMessage NVARCHAR(255);
EXEC spAddProductToOrder @orderId = 15, @productLineId = 1, @price = 500000, @quantity = 3, @statusMessage = @statusMessage OUTPUT;
PRINT @statusMessage;

--- remove product from order
CREATE OR ALTER PROCEDURE spRemoveProductFromOrder
    @orderId INT,
    @productLineId INT,
    @statusMessage NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Kiểm tra giá trị NULL
        IF @orderId IS NULL
        BEGIN
            SET @statusMessage = 'Error: OrderID cannot be NULL.';
            RETURN;
        END

        IF @productLineId IS NULL
        BEGIN
            SET @statusMessage = 'Error: ProductLineID cannot be NULL.';
            RETURN;
        END

        -- Kiểm tra orderId có tồn tại
        IF NOT EXISTS (SELECT 1 FROM [order] WHERE order_id = @orderId)
        BEGIN
            SET @statusMessage = 'Error: OrderID does not exist.';
            RETURN;
        END

        -- Kiểm tra productLineId có trong đơn hàng
        IF NOT EXISTS (SELECT 1 FROM order_includes_product_line WHERE order_id = @orderId AND product_line_id = @productLineId)
        BEGIN
            SET @statusMessage = 'Error: ProductLineID does not exist in the specified OrderID.';
            RETURN;
        END

        -- Xóa sản phẩm khỏi đơn hàng
        DELETE FROM order_includes_product_line
        WHERE order_id = @orderId AND product_line_id = @productLineId;

        SET @statusMessage = 'Success: Product removed from OrderID = ' + CAST(@orderId AS NVARCHAR);
    END TRY
    BEGIN CATCH
        SET @statusMessage = 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;


--- update order status
CREATE OR ALTER PROCEDURE spUpdateOrderStatus
    @orderId INT,
    @orderStatus NVARCHAR(50),
    @statusMessage NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Kiểm tra giá trị NULL
        IF @orderId IS NULL
        BEGIN
            SET @statusMessage = 'Error: OrderID cannot be NULL.';
            RETURN;
        END

        IF @orderStatus IS NULL
        BEGIN
            SET @statusMessage = 'Error: OrderStatus cannot be NULL.';
            RETURN;
        END

        -- Kiểm tra trạng thái hợp lệ
        IF @orderStatus NOT IN ('pending', 'shipping', 'completed')
        BEGIN
            SET @statusMessage = 'Error: Invalid order status. Allowed values are pending, shipping, or completed.';
            RETURN;
        END

        -- Kiểm tra orderId có tồn tại
        IF NOT EXISTS (SELECT 1 FROM [order] WHERE order_id = @orderId)
        BEGIN
            SET @statusMessage = 'Error: OrderID does not exist.';
            RETURN;
        END

        -- Lấy trạng thái hiện tại của đơn hàng
        DECLARE @currentStatus NVARCHAR(50);
        SELECT @currentStatus = order_status
        FROM [order]
        WHERE order_id = @orderId;

        -- Kiểm tra nếu trạng thái mới trùng với trạng thái hiện tại
        IF @currentStatus = @orderStatus
        BEGIN
            SET @statusMessage = 'Warning: The new status is the same as the current status. Update skipped.';
            RETURN;
        END

        -- Cập nhật trạng thái đơn hàng
        UPDATE [order]
        SET order_status = @orderStatus
        WHERE order_id = @orderId;

        SET @statusMessage = 'Success: OrderID = ' + CAST(@orderId AS NVARCHAR) + ' updated to status: ' + @orderStatus;
    END TRY
    BEGIN CATCH
        SET @statusMessage = 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;


--- delete an order
CREATE OR ALTER PROCEDURE spDeleteOrder
    @orderId INT,
    @statusMessage NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Kiểm tra xem orderId có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM [order] WHERE order_id = @orderId)
        BEGIN
            SET @statusMessage = 'Error: OrderID does not exist.';
            RETURN;
        END

        -- Kiểm tra xem order có đang trong trạng thái shipping hay completed, không thể xóa khi đang giao hàng hoặc đã hoàn thành
        DECLARE @orderStatus NVARCHAR(20);
        SELECT @orderStatus = order_status
        FROM [order]
        WHERE order_id = @orderId;

        IF @orderStatus IN ('shipping', 'completed')
        BEGIN
            SET @statusMessage = 'Error: Order is in shipping or completed status and cannot be deleted.';
            RETURN;
        END

        ---- Xóa các sản phẩm trong order trước khi xóa order
        --DELETE FROM order_includes_product_line WHERE order_id = @orderId;

        -- Xóa order
        DELETE FROM [order] WHERE order_id = @orderId;

        SET @statusMessage = 'Success: OrderID ' + CAST(@orderId AS NVARCHAR) + ' has been deleted successfully.';
    END TRY
    BEGIN CATCH
        -- Bắt lỗi và trả về thông báo lỗi
        SET @statusMessage = 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;


DECLARE @statusMessage NVARCHAR(255);
EXEC spCreateOrder @customerId = 17, @employeeId = 2, @deliveryId = NULL, @statusMessage = @statusMessage OUTPUT;
PRINT @statusMessage;


DECLARE @statusMessage NVARCHAR(255);
EXEC spAddProductToOrder @orderId = 14, @productLineId = 1, @price = 500000, @quantity = 2, @statusMessage = @statusMessage OUTPUT;
PRINT @statusMessage;


DECLARE @statusMessage NVARCHAR(255);
EXEC spRemoveProductFromOrder @orderId = 14, @productLineId = 1, @statusMessage = @statusMessage OUTPUT;
PRINT @statusMessage;


DECLARE @statusMessage NVARCHAR(255);
EXEC spUpdateOrderStatus @orderId = 14, @orderStatus = 'pending', @statusMessage = @statusMessage OUTPUT;
PRINT @statusMessage; -- Output: Warning: The new status is the same as the current status. Update skipped.


DECLARE @statusMessage NVARCHAR(255);
EXEC spUpdateOrderStatus @orderId = 14, @orderStatus = 'completed', @statusMessage = @statusMessage OUTPUT;
PRINT @statusMessage; -- Output: Success: OrderID = 101 updated to status: completed.


