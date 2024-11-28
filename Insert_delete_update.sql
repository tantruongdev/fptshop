USE ASSIGNMENT
GO

----- insert employee
CREATE OR ALTER PROCEDURE InsertEmployee
    @EmployeeID CHAR(7),
    @IdentityCard CHAR(12),
    @Lname VARCHAR(40),
    @Fname VARCHAR(15),
    @PhoneNumber CHAR(10), 
	@DOB DATE,
    @HireDate DATE,  
    @Email VARCHAR(50) = NULL, 
    @SupervisorID CHAR(7) = NULL,
	@SuperviseDate	Date = NULL,
    @StoreID CHAR(7),
	@StatusMessage VARCHAR(50) OUTPUT 
AS
BEGIN
    -- Kiểm tra độ dài của EmployeeID
    IF LEN(@EmployeeID) <> 7
    BEGIN
        PRINT 'Error: Employee ID must be exactly 7 characters.';
		SET @StatusMessage = 'Error: Employee ID must be exactly 7 characters.';
        RETURN;
    END
	-- Kiểm tra xem EmployeeID đã tồn tại trong bảng Employee chưa
	IF EXISTS (SELECT 1 FROM Employee WHERE EmployeeID = @EmployeeID)
	BEGIN
		PRINT 'Error: Employee ID already exists.';
		SET @StatusMessage = 'Error: Employee ID already exists.';
		RETURN;
	END



    -- Kiểm tra độ dài và định dạng của IdentityCard
    IF LEN(@IdentityCard) <> 12 OR @IdentityCard NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    BEGIN
        PRINT 'Error: Identity Card must be exactly 12 digits.';
        SET @StatusMessage = 'Error: Identity Card must be exactly 12 digits.';
		RETURN;
    END
	-- Kiểm tra xem IdentityCard đã tồn tại trong bảng Employee chưa
	IF EXISTS (SELECT 1 FROM Employee WHERE IdentityCard = @IdentityCard)
	BEGIN
		PRINT 'Error: Identity Card already exists.';
		SET @StatusMessage = 'Error: Identity Card already exists.';
		RETURN;
	END


		-- Kiểm tra độ dài của PhoneNumber
		IF LEN(@PhoneNumber) <> 10
		BEGIN
			PRINT 'Error: Phone number must be exactly 10 digits.';
			 SET @StatusMessage = 'Error: Phone number must be exactly 10 digits.';
			RETURN;
		END

		-- Kiểm tra xem PhoneNumber có phải là số không
		IF @PhoneNumber NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
		BEGIN
			PRINT 'Error: Phone number must contain only digits.';
			Set @StatusMessage =  'Error: Phone number must contain only digits.';
		RETURN;
		END

		-- Kiểm tra xem PhoneNumber đã tồn tại trong bảng Employee chưa
		IF EXISTS (SELECT 1 FROM Employee WHERE PhoneNumber = @PhoneNumber)
		BEGIN
			PRINT 'Error: Phone Number already exists.';
			Set @StatusMessage = 'Error: Phone number must contain only digits.';
			RETURN;
		END
	
	 IF @DOB IS NULL
        BEGIN
            PRINT 'Error: Date of Birth (DOB) is required!';
			Set @StatusMessage = 'Error: Date of Birth (DOB) is required!';
            RETURN;
        END


	 -- Kiểm tra tuổi nhân viên (>= 18)
        IF FLOOR(DATEDIFF(day, @DOB, @HireDate) / 365.25) < 18
        BEGIN
           PRINT 'Error: Employee must be at least 18 years old to be hired!';
            Set @StatusMessage = 'Error: Employee must be at least 18 years old to be hired!';
			RETURN;
        END

    -- Kiểm tra định dạng email
    IF @Email IS NOT NULL AND @Email NOT LIKE '%@%.%'
    BEGIN
        PRINT 'Error: Invalid email.';
		Set @StatusMessage = 'Error: Invalid email.';
        RETURN;
    END
	-- Kiểm tra xem email đã tồn tại trong bảng Employee chưa
	IF EXISTS (SELECT 1 FROM Employee WHERE email = @email)
	BEGIN
		PRINT 'Error: email already exists.';
		Set @StatusMessage = 'Error: email already exists.';
		RETURN;
	END



	  -- Kiểm tra tính hợp lệ của SupervisorID nếu không phải NULL
    IF @SupervisorID IS NOT NULL 
    BEGIN
        IF LEN(@SupervisorID) <> 7
        BEGIN
            PRINT 'Error: Supervisor ID must be exactly 7 characters.';
			Set @StatusMessage = 'Error: Supervisor ID must be exactly 7 characters.';
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Employee WHERE EmployeeID = @SupervisorID)
        BEGIN
            PRINT 'Error: Supervisor ID does not exist in Employee table.';
			Set @StatusMessage =  'Error: Supervisor ID does not exist in Employee table.';
		   RETURN;
        END
    END


	   -- Kiểm tra nếu SuperviseDate có giá trị thì nó phải >= HireDate
    IF @SuperviseDate IS NOT NULL AND @SuperviseDate < @HireDate
    BEGIN
        PRINT 'Error: Supervise date cannot be earlier than hire date.';
        Set @StatusMessage = 'Error: Supervise date cannot be earlier than hire date.';
		RETURN;
    END


    -- Kiểm tra nếu StoreID tồn tại
    IF NOT EXISTS (SELECT 1 FROM Store WHERE StoreID = @StoreID)
    BEGIN
        PRINT 'Error: Store ID does not exist.';
        Set @StatusMessage = 'Error: Store ID does not exist.';
		RETURN;
    END


    -- Thực hiện thêm dữ liệu vào bảng Employee
    BEGIN TRY
        INSERT INTO Employee (EmployeeID, IdentityCard, Lname, Fname, PhoneNumber,DOB, HireDate, Email, SupervisorID,SuperviseDate, StoreID)
        VALUES (@EmployeeID, @IdentityCard, @Lname, @Fname, @PhoneNumber,@DOB, @HireDate, @Email, @SupervisorID,@SuperviseDate, @StoreID);

        PRINT 'Data has been added successfully.';
		 Set @StatusMessage = 'Data has been added successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred while adding data.';
		 Set @StatusMessage = 'An error occurred while adding data.';
    END CATCH
END;




EXEC InsertEmployee 
    @EmployeeID = 'E123456',
    @IdentityCard = '123411189012',
    @Lname = 'Doe',
    @Fname = 'John',
    @PhoneNumber = '0987654321',
    @DOB = '1990-01-01',
    @HireDate = '2020-01-01',
    @Email = 'johndoe@example.com',
    --@SupervisorID = 'E654321',
    --@SuperviseDate = '2020-01-01',
    @StoreID = '1111111';


-- Gọi thủ tục để thêm nhân viên mới
EXEC InsertEmployee 
    @EmployeeID = 'E012087',
    @IdentityCard = '133568946725',
    @Lname = 'Dang Quynh',
    @Fname = 'Quynh',
	@PhoneNumber = '01164567811', ----yêu cầu bắt buộc nhập số điện thoại
	@DOB = '2002-05-01',
    @HireDate = '2023-05-15',
    @StoreID = '1111111';

	EXEC InsertEmployee 
    @EmployeeID = 'E000187',
    @IdentityCard = '123111146725',
    @Lname = 'Dang',
    @Fname = 'Quynh',
	@PhoneNumber = '01234567891', ----yêu cầu bắt buộc nhập số điện thoại
	@DOB = '2002-05-01',
    @HireDate = '2023-05-15',
    @StoreID = '1111111';

EXEC DeleteEmp @EmployeeID = 'E000087';

SELECT * FROM Employee;


---------------------
-- delete employee
------------------
CREATE OR ALTER PROCEDURE DeleteEmployee
    @EmployeeID CHAR(7),
	@StatusMessage VARCHAR(50) OUTPUT 
AS
BEGIN
	 -- Kiểm tra độ dài của EmployeeID
    IF LEN(@EmployeeID) <> 7
    BEGIN
        PRINT 'Error: Employee ID must be exactly 7 characters.';
        SET @StatusMessage = 'Error: Employee ID must be exactly 7 characters.';
		RETURN;
    END
	-- Kiểm tra xem EmployeeID có tồn tại trong bảng Employee hay không
    IF NOT EXISTS (SELECT 1 FROM Employee WHERE EmployeeID = @EmployeeID AND IsDeleted <> 1)
    BEGIN
        PRINT 'Error: Employee ID does not exist or is already deleted.';
        SET @StatusMessage = 'Error: Employee ID does not exist or is already deleted.';
		RETURN;
    END

    -- Check if the employee has linked data in other tables
    IF EXISTS (SELECT 1 FROM [Order] WHERE EmployeeID = @EmployeeID)
    BEGIN
        PRINT 'Error: Cannot delete this employee because there is linked data in the Orders table.'
        SET @StatusMessage = 'Error: Cannot delete this employee because there is linked data in the Orders table.'
		RETURN
    END

    IF EXISTS (SELECT 1 FROM GoodsDeliveryNote WHERE EmployeeID = @EmployeeID)
    BEGIN
        PRINT 'Error: Cannot delete this employee because there is linked data in the GoodsDeliveryNote table.'
        SET @StatusMessage = 'Error: Cannot delete this employee because there is linked data in the GoodsDeliveryNote table.'
		RETURN
    END

    IF EXISTS (SELECT 1 FROM ProductLineManagedByEmployee WHERE EmployeeID = @EmployeeID)
    BEGIN
        PRINT 'Error: Cannot delete this employee because there is linked data in the ProductLineManagedByEmployee table.'
         SET @StatusMessage = 'Error: Cannot delete this employee because there is linked data in the ProductLineManagedByEmployee table.'
		RETURN
    END

    -- Delete employee
    --DELETE FROM Employee WHERE EmployeeID = @EmployeeID
	UPDATE Employee
	SET IsDeleted = 1
	WHERE EmployeeID = @EmployeeID;

    PRINT 'Employee has been deleted successfully.'
	 SET @StatusMessage = 'Employee has been deleted successfully.'
END

-- Errror
DECLARE @StatusMessage NVARCHAR(50); -- Khai báo biến nhận kết quả

EXEC DeleteEmployee 
    @EmployeeID = 'E001080',
     @StatusMessage =  @StatusMessage OUTPUT; 



EXEC DeleteEmployee @EmployeeID = 'E000001';


SELECT * FROM Employee;

--------------------
--reactiveEmployee
CREATE PROCEDURE ReactiveEmployee
    @EmployeeID CHAR(7),
	@StatusMessage VARCHAR(50) OUTPUT 
AS
BEGIN
    -- Kiểm tra nếu user đang Inactive
    IF EXISTS (SELECT 1 FROM Employee WHERE EmployeeID = @EmployeeID AND IsDeleted = 1)
    BEGIN
        -- Kích hoạt lại user
        UPDATE Employee
        SET IsDeleted = 0
        WHERE EmployeeID = @EmployeeID;

        -- Gán kết quả trả về
        SET @StatusMessage = 'Employee has been activated successfully.';
    END
    ELSE
    BEGIN
        -- Gán kết quả nếu user không tồn tại hoặc không phải Inactive
        SET @StatusMessage = 'Employee not found or already active.';
    END
END;
--------------------

EXEC ReactiveEmployee @EmployeeID = 'E112221';
------------------------------
--updateEmployee
----------------------------
CREATE OR ALTER PROCEDURE UpdateEmployee
    @EmployeeID CHAR(7),
    @IdentityCard CHAR(12) = NULL, 
    @Lname VARCHAR(40) = NULL,
    @Fname VARCHAR(15)= NULL, 
    @PhoneNumber CHAR(10)= NULL,   
	@DOB DATE =NULL,
    @HireDate DATE = NULL, 
    @Email VARCHAR(50) = NULL, 
    @SupervisorID CHAR(7) = NULL,
	@SuperviseDate	Date = NULL,
    @StoreID CHAR(7) = NULL,
	@StatusMessage VARCHAR(50) OUTPUT 
AS
BEGIN

	IF @IdentityCard IS NOT NULL
    BEGIN
        IF LEN(@IdentityCard) <> 12 OR @IdentityCard NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
        BEGIN
            PRINT 'Error: Identity Card must be exactly 12 digits.';
			SET @StatusMessage =   'Error: Identity Card must be exactly 12 digits.';
		   RETURN;
        END

        -- Kiểm tra xem IdentityCard đã tồn tại trong bảng Employee chưa (nếu có)
        IF EXISTS (SELECT 1 FROM Employee WHERE IdentityCard = @IdentityCard AND EmployeeID <> @EmployeeID)
        BEGIN
            PRINT 'Error: Identity Card already exists.';
            SET @StatusMessage = 'Error: Identity Card already exists.';
			RETURN;
        END
    END


	IF @PhoneNumber IS NOT NULL
    BEGIN
        IF LEN(@PhoneNumber) <> 10 OR @PhoneNumber NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
        BEGIN
            PRINT 'Error: Phone number must be exactly 10 digits.';
            SET @StatusMessage = 'Error: Phone number must be exactly 10 digits.';
			RETURN;
        END

        -- Kiểm tra xem PhoneNumber đã tồn tại trong bảng Employee chưa
        IF EXISTS (SELECT 1 FROM Employee WHERE PhoneNumber = @PhoneNumber AND EmployeeID <> @EmployeeID)
        BEGIN
            PRINT 'Error: Phone Number already exists.';
             SET @StatusMessage = 'Error: Phone Number already exists.';
			RETURN;
        END
    END

	 -- Kiểm tra tuổi nhân viên (>= 18)
        IF FLOOR(DATEDIFF(day, @DOB, @HireDate) / 365.25) < 18
        BEGIN
           PRINT 'Error: Employee must be at least 18 years old to be hired!';
           SET @StatusMessage = 'Error: Employee must be at least 18 years old to be hired!';
		   RETURN;
        END


  -- Kiểm tra định dạng email (nếu không NULL)
    IF @Email IS NOT NULL
    BEGIN
        IF @Email NOT LIKE '%@%.%' -- Kiểm tra email có chứa '@' và '.' 
        BEGIN
            PRINT 'Error: Invalid email.';
             SET @StatusMessage = 'Error: Invalid email.';
			RETURN;
        END

        -- Kiểm tra xem email đã tồn tại trong bảng Employee chưa (nếu có)
        IF EXISTS (SELECT 1 FROM Employee WHERE Email = @Email AND EmployeeID <> @EmployeeID)
        BEGIN
            PRINT 'Error: Email already exists.';
             SET @StatusMessage = 'Error: Email already exists.';
		   RETURN;
        END
    END


	  -- Kiểm tra tính hợp lệ của SupervisorID nếu không phải NULL
    IF @SupervisorID IS NOT NULL 
    BEGIN
        IF LEN(@SupervisorID) <> 7
        BEGIN
            PRINT 'Error: Supervisor ID must be exactly 7 characters.';
            SET @StatusMessage = 'Error: Supervisor ID must be exactly 7 characters.';
			RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Employee WHERE EmployeeID = @SupervisorID)
        BEGIN
            PRINT 'Error: Supervisor ID does not exist in Employee table.';
           SET @StatusMessage = 'Error: Supervisor ID does not exist in Employee table.';
		   RETURN;
        END
    END


	   -- Kiểm tra nếu SuperviseDate có giá trị thì nó phải >= HireDate
    IF @SuperviseDate IS NOT NULL AND @SuperviseDate < @HireDate
    BEGIN
        PRINT 'Error: Supervise date cannot be earlier than hire date.';
         SET @StatusMessage = 'Error: Supervise date cannot be earlier than hire date.';
		RETURN;
    END


  -- Kiểm tra nếu StoreID tồn tại trong bảng Store
	IF @StoreID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Store WHERE StoreID = @StoreID)
	BEGIN
		PRINT 'Error: Store ID does not exist.';
		SET @StatusMessage = 'Error: Store ID does not exist.';
		RETURN;
	END

    -- Cập nhật thông tin nhân viên
    UPDATE Employee
    SET IdentityCard = COALESCE(@IdentityCard, IdentityCard),
        Lname = COALESCE(@Lname, Lname),
        Fname = COALESCE(@Fname, Fname),
        PhoneNumber = COALESCE(@PhoneNumber, PhoneNumber),
        HireDate = COALESCE(@HireDate, HireDate),
        Email = COALESCE(@Email, Email),
        SupervisorID = COALESCE(@SupervisorID, SupervisorID),
        SuperviseDate = COALESCE(@SuperviseDate, SuperviseDate),
        StoreID = COALESCE(@StoreID, StoreID)
    WHERE EmployeeID = @EmployeeID

    PRINT 'Data has been updated successfully.'
	SET @StatusMessage =  'Data has been updated successfully.';
END




EXEC InsertEmployee 
    @EmployeeID = 'E000095',
    @IdentityCard = '123568946752',
    @Lname = 'Dang',
    @Fname = 'Quynh',
    @PhoneNumber = '0327545862',
	@DOB = '2003-01-5',
    @HireDate = '2023-05-15',
    @Email = 'quynh@example.com',
    @SupervisorID = 'E000002',
    @StoreID = '1111112'

EXEC UpdateEmployee 
    @EmployeeID = 'E000095',  
      @StoreID = '1111113'

SELECT * FROM Employee;


--- get employees
CREATE OR ALTER PROCEDURE GetAllEmployees
AS
BEGIN
    SELECT [EmployeeID],
           [IdentityCard],
           [Lname],
           [Fname],
           [PhoneNumber],
           [DOB],
           [HireDate],
           [Email],
           [SupervisorID],
           [SuperviseDate],
		   [IsDeleted],
           [StoreID]
		  
    FROM [ASSIGNMENT].[dbo].[Employee];
END;

EXEC GetAllEmployees;

--- get employee by id

CREATE OR ALTER PROCEDURE GetEmployeeByID
    @EmployeeID CHAR(7)
AS
BEGIN
    SELECT [EmployeeID],
           [IdentityCard],
           [Lname],
           [Fname],
           [PhoneNumber],
           [DOB],
           [HireDate],
           [Email],
           [SupervisorID],
           [SuperviseDate],
		   [IsDeleted],
           [StoreID]
		   
    FROM [ASSIGNMENT].[dbo].[Employee]
    WHERE [EmployeeID] = @EmployeeID;
END;

EXEC GetEmployeeByID @EmployeeID = 'E000008';



---thêm điều kiện mới của Huy không thêm nữa nếu đã có
ALTER TABLE Employee
ADD DOB DATE NOT NULL DEFAULT '2000-01-01';
ALTER TABLE Employee
ADD CONSTRAINT CHK_DOB CHECK (DOB <= CONVERT(DATE, GETDATE()));
SELECT * FROM Employee;
INSERT INTO Employee (
    EmployeeID, 
    IdentityCard, 
    Lname, 
    Fname, 
    PhoneNumber, 
    HireDate, 
    Email, 
    SupervisorID, 
    SuperviseDate, 
    StoreID
) 
VALUES (
    'E000025',           -- EmployeeID (Primary Key)
    '123456789125',      -- IdentityCard (Unique, Not Null)
    'Nguyen',            -- Last Name
    'Minh',              -- First Name
    '0987654321',        -- PhoneNumber (Unique)
    GETDATE(),           -- HireDate (Default or current date)
    'minh.nguyen@example.com', -- Email
    NULL,                -- SupervisorID (No supervisor for now)
    NULL,                -- SuperviseDate (No date set)
    '1111113'             -- StoreID (Must exist in Store table)
);


ALTER TABLE Employee
ADD CONSTRAINT CHK_HireDate CHECK (HireDate <= CONVERT(DATE, GETDATE()));
INSERT INTO Employee (EmployeeID, IdentityCard, Lname, Fname, PhoneNumber, HireDate, StoreID)
VALUES ('E000026', '123456789156', 'Tran', 'Anh', '0987654322', '2023-11-01', '1111112');

ALTER TABLE Employee
ADD CONSTRAINT CHK_AgeAtHire CHECK (
    FLOOR(DATEDIFF(day, DOB, HireDate) / 365.25) >= 18
);

ALTER TABLE Employee
ADD CONSTRAINT CHK_SuperviseDate CHECK (
    SuperviseDate >= HireDate
);

ALTER TABLE Employee
ADD CONSTRAINT CHK_EmailFormat CHECK (
    Email LIKE '%@%.%'
);



