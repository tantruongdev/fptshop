USE assignment2;
GO


----- insert employee
CREATE OR ALTER PROCEDURE insert_employee
    @identity_card CHAR(12),
    @lname VARCHAR(40),
    @fname VARCHAR(15),
    @phone_number CHAR(10), 
    @dob DATE,
    @hire_date DATE,  
    @email VARCHAR(50) = NULL, 
    @supervisor_id INT = NULL,
    @supervise_date DATE = NULL,
    @store_id INT,
    @status_message VARCHAR(255) OUTPUT 
AS
BEGIN
    -- Kiểm tra độ dài của employee_id
    --IF LEN(@employee_id) <> 7
    --BEGIN
    --    PRINT 'Error: Employee ID must be exactly 7 characters.';
    --    SET @status_message = 'Error: Employee ID must be exactly 7 characters.';
    --    RETURN;
    --END
    -- Kiểm tra xem employee_id đã tồn tại trong bảng employee chưa
    --IF EXISTS (SELECT 1 FROM employee WHERE employee_id = @employee_id)
    --BEGIN
    --    PRINT 'Error: Employee ID already exists.';
    --    SET @status_message = 'Error: Employee ID already exists.';
    --    RETURN;
    --END

    -- Kiểm tra độ dài và định dạng của identity_card
    IF LEN(@identity_card) <> 12 OR @identity_card NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    BEGIN
        PRINT 'Error: Identity Card must be exactly 12 digits.';
        SET @status_message = 'Error: Identity Card must be exactly 12 digits.';
        RETURN;
    END
    -- Kiểm tra xem identity_card đã tồn tại trong bảng employee chưa
    IF EXISTS (SELECT 1 FROM employee WHERE identity_card = @identity_card)
    BEGIN
        PRINT 'Error: Identity Card already exists.';
        SET @status_message = 'Error: Identity Card already exists.';
        RETURN;
    END

    -- Kiểm tra độ dài của phone_number
    IF LEN(@phone_number) <> 10
    BEGIN
        PRINT 'Error: Phone number must be exactly 10 digits.';
        SET @status_message = 'Error: Phone number must be exactly 10 digits.';
        RETURN;
    END

    -- Kiểm tra xem phone_number có phải là số không
    IF @phone_number NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    BEGIN
        PRINT 'Error: Phone number must contain only digits.';
        SET @status_message = 'Error: Phone number must contain only digits.';
        RETURN;
    END

    -- Kiểm tra xem phone_number đã tồn tại trong bảng employee chưa
    IF EXISTS (SELECT 1 FROM employee WHERE phone_number = @phone_number)
    BEGIN
        PRINT 'Error: Phone number already exists.';
        SET @status_message = 'Error: Phone number already exists.';
        RETURN;
    END

    IF @dob IS NULL
    BEGIN
        PRINT 'Error: Date of Birth (DOB) is required!';
        SET @status_message = 'Error: Date of Birth (DOB) is required!';
        RETURN;
    END

    -- Kiểm tra tuổi nhân viên (>= 18)
    IF FLOOR(DATEDIFF(day, @dob, @hire_date) / 365.25) < 18
    BEGIN
        PRINT 'Error: Employee must be at least 18 years old to be hired!';
        SET @status_message = 'Error: Employee must be at least 18 years old to be hired!';
        RETURN;
    END

    -- Kiểm tra định dạng email
    IF @email IS NOT NULL AND @email NOT LIKE '%@%.%'
    BEGIN
        PRINT 'Error: Invalid email.';
        SET @status_message = 'Error: Invalid email.';
        RETURN;
    END
    -- Kiểm tra xem email đã tồn tại trong bảng employee chưa
    IF EXISTS (SELECT 1 FROM employee WHERE email = @email)
    BEGIN
        PRINT 'Error: Email already exists.';
        SET @status_message = 'Error: Email already exists.';
        RETURN;
    END

    -- Kiểm tra tính hợp lệ của supervisor_id nếu không phải NULL
    IF @supervisor_id IS NOT NULL 
    BEGIN
        --IF LEN(@supervisor_id) <> 7
        --BEGIN
        --    PRINT 'Error: Supervisor ID must be exactly 7 characters.';
        --    SET @status_message = 'Error: Supervisor ID must be exactly 7 characters.';
        --    RETURN;
        --END

        IF NOT EXISTS (SELECT 1 FROM employee WHERE employee_id = @supervisor_id)
        BEGIN
            PRINT 'Error: Supervisor ID does not exist in employee table.';
            SET @status_message = 'Error: Supervisor ID does not exist in employee table.';
            RETURN;
        END
    END

    -- Kiểm tra nếu supervise_date có giá trị thì nó phải >= hire_date
    IF @supervise_date IS NOT NULL AND @supervise_date < @hire_date
    BEGIN
        PRINT 'Error: Supervise date cannot be earlier than hire date.';
        SET @status_message = 'Error: Supervise date cannot be earlier than hire date.';
        RETURN;
    END

    -- Kiểm tra nếu store_id tồn tại
    IF NOT EXISTS (SELECT 1 FROM store WHERE store_id = @store_id)
    BEGIN
        PRINT 'Error: Store ID does not exist.';
        SET @status_message = 'Error: Store ID does not exist.';
        RETURN;
    END

    -- Thực hiện thêm dữ liệu vào bảng employee
    BEGIN TRY
        INSERT INTO employee (identity_card, lname, fname, phone_number, dob, hire_date, email, supervisor_id, supervise_date, store_id)
        VALUES ( @identity_card, @lname, @fname, @phone_number, @dob, @hire_date, @email, @supervisor_id, @supervise_date, @store_id);

        PRINT 'Data has been added successfully.';
        SET @status_message = 'Data has been added successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred while adding data.';
        SET @status_message = 'An error occurred while adding data.';
    END CATCH
END;

-- Example execution for inserting employee
DECLARE @status_message VARCHAR(255);
EXEC insert_employee 
   
    @identity_card = '143411189012',
    @lname = 'Doe',
    @fname = 'John',
    @phone_number = '0917654321',
    @dob = '1990-01-01',
    @hire_date = '2020-01-01',
    @email = 'johndoe@example.com',
    @store_id = '1',
    @status_message = @status_message OUTPUT;

-- Print the status message
--PRINT @status_message;

-- Delete employee
CREATE OR ALTER PROCEDURE delete_employee
    @employee_id INT,
    @status_message VARCHAR(255) OUTPUT
AS
BEGIN
    -- Kiểm tra xem employee_id có tồn tại trong bảng Employee không
    IF NOT EXISTS (SELECT 1 FROM employee WHERE employee_id = @employee_id)
    BEGIN
        PRINT 'Error: Employee ID does not exist.';
        SET @status_message = 'Error: Employee ID does not exist.';
        RETURN;
    END
	 IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @employee_id AND is_deleted <> 1)
    BEGIN
        PRINT 'Error: Employee ID does not exist or is already deleted.';
        SET @status_message = 'Error: Employee ID does not exist or is already deleted.';
		RETURN;
    END

    -- Check if the employee has linked data in other tables
    IF EXISTS (SELECT 1 FROM [Order] WHERE employee_id = @employee_id)
    BEGIN
        PRINT 'Error: Cannot delete this employee because there is linked data in the Orders table.'
        SET @status_message = 'Error: Cannot delete this employee because there is linked data in the Orders table.'
		RETURN
    END

    IF EXISTS (SELECT 1 FROM goods_delivery_note WHERE employee_id = @employee_id)
    BEGIN
        PRINT 'Error: Cannot delete this employee because there is linked data in the GoodsDeliveryNote table.'
        SET @status_message = 'Error: Cannot delete this employee because there is linked data in the GoodsDeliveryNote table.'
		RETURN
    END

    IF EXISTS (SELECT 1 FROM product_line_managed_by_employee WHERE employee_id = @employee_id)
    BEGIN
        PRINT 'Error: Cannot delete this employee because there is linked data in the ProductLineManagedByEmployee table.'
         SET @status_message = 'Error: Cannot delete this employee because there is linked data in the ProductLineManagedByEmployee table.'
		RETURN
    END


    -- Xóa nhân viên
    BEGIN TRY
        UPDATE employee 
		SET is_deleted = 1
		WHERE employee_id = @employee_id;

        PRINT 'Employee deleted successfully.';
        SET @status_message = 'Employee deleted successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred while deleting the employee.';
        SET @status_message = 'An error occurred while deleting the employee.';
    END CATCH
END;

-- Example execution of delete_employee
--- Error
DECLARE @status_message1 VARCHAR(50);
EXEC delete_employee 
    @employee_id = '22',
	@status_message = @status_message1 OUTPUT;

--- Success
DECLARE @status_message1 VARCHAR(50);
EXEC delete_employee 
    @employee_id = 4,
	@status_message =  @status_message1 OUTPUT;



--- reactive Employee
CREATE OR ALTER PROCEDURE reactive_employee
    @employee_id CHAR(7),
	@status_message VARCHAR(255) OUTPUT 
AS
BEGIN
    -- Kiểm tra nếu user đang Inactive
    IF EXISTS (SELECT 1 FROM Employee WHERE employee_id = @employee_id AND is_deleted = 1)
    BEGIN
        -- Kích hoạt lại user
        UPDATE Employee
        SET is_deleted = 0
        WHERE employee_id = @employee_id;

        -- Gán kết quả trả về
        SET @status_message = 'Employee has been activated successfully.';
    END
    ELSE
    BEGIN
        -- Gán kết quả nếu user không tồn tại hoặc không phải Inactive
        SET @status_message = 'Employee not found or already active.';
    END
END;
--------------------
DECLARE @status_message VARCHAR(255);
EXEC reactive_employee @employee_id = 6, @status_message = @status_message OUTPUT;

-----------
-- Update employee
CREATE OR ALTER PROCEDURE update_employee
    @employee_id INT,
	@identity_card CHAR(12) = NULL, 
    @lname VARCHAR(40) = NULL,
    @fname VARCHAR(15) = NULL,
    @phone_number CHAR(10) = NULL,
    @dob DATE = NULL,
    @hire_date DATE = NULL,
    @email VARCHAR(50) = NULL,
    @supervisor_id INT = NULL,
    @supervise_date DATE = NULL,
    @store_id INT = NULL,
	@is_deleted BIT = 0,
    @status_message VARCHAR(255) OUTPUT
AS
BEGIN
    -- Kiểm tra xem employee_id có tồn tại trong bảng Employee không
    IF NOT EXISTS (SELECT 1 FROM employee WHERE employee_id = @employee_id)
    BEGIN
        PRINT 'Error: Employee ID does not exist.';
        SET @status_message = 'Error: Employee ID does not exist.';
        RETURN;
    END

	-- Kiểm tra Identity Card
    IF @identity_card IS NOT NULL
    BEGIN
        IF LEN(@identity_card) <> 12 OR @identity_card NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
        BEGIN
            PRINT 'Error: Identity Card must be exactly 12 digits.';
            RETURN;
        END
        IF EXISTS (SELECT 1 FROM employee WHERE identity_card = @identity_card AND employee_id <> @employee_id)
        BEGIN
            PRINT 'Error: Identity Card already exists.';
            RETURN;
        END
    END

		 -- Kiểm tra họ
	IF @lname IS NOT NULL AND @lname LIKE '%[^a-zA-Z ]%'
	BEGIN
		PRINT 'Last name contains invalid characters (e.g., numbers or symbols).';
		RETURN;
	END

	-- Kiểm tra tên
	IF @fname IS NOT NULL AND @fname LIKE '%[^a-zA-Z ]%'
	BEGIN
		PRINT 'First name contains invalid characters (e.g., numbers or symbols).';
		RETURN;
	END

    -- Kiểm tra nếu phone_number có giá trị thì phải có độ dài là 10 ký tự
    IF @phone_number IS NOT NULL AND LEN(@phone_number) <> 10
    BEGIN
        PRINT 'Error: Phone number must be exactly 10 digits.';
        SET @status_message = 'Error: Phone number must be exactly 10 digits.';
        RETURN;
    END

    -- Kiểm tra nếu phone_number có giá trị thì phải chỉ chứa các chữ số
    IF @phone_number IS NOT NULL AND @phone_number NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    BEGIN
        PRINT 'Error: Phone number must contain only digits.';
        SET @status_message = 'Error: Phone number must contain only digits.';
        RETURN;
    END

    -- Kiểm tra định dạng email
    IF @email IS NOT NULL AND @email NOT LIKE '%@%.%'
    BEGIN
        PRINT 'Error: Invalid email format.';
        SET @status_message = 'Error: Invalid email format.';
        RETURN;
    END

    -- Kiểm tra xem email đã tồn tại trong bảng Employee chưa
    IF @email IS NOT NULL AND EXISTS (SELECT 1 FROM employee WHERE email = @email AND employee_id != @employee_id)
    BEGIN
        PRINT 'Error: Email already exists.';
        SET @status_message = 'Error: Email already exists.';
        RETURN;
    END

    -- Kiểm tra tính hợp lệ của supervisor_id nếu không phải NULL
    IF @supervisor_id IS NOT NULL 
    BEGIN
        --IF LEN(@supervisor_id) <> 7
        --BEGIN
        --    PRINT 'Error: Supervisor ID must be exactly 7 characters.';
        --    SET @status_message = 'Error: Supervisor ID must be exactly 7 characters.';
        --    RETURN;
        --END

        IF NOT EXISTS (SELECT 1 FROM employee WHERE employee_id = @supervisor_id)
        BEGIN
            PRINT 'Error: Supervisor ID does not exist in Employee table.';
            SET @status_message = 'Error: Supervisor ID does not exist in Employee table.';
            RETURN;
        END
    END

    -- Kiểm tra nếu supervise_date có giá trị thì nó phải >= hire_date
    IF @supervise_date IS NOT NULL AND @supervise_date < @hire_date
    BEGIN
        PRINT 'Error: Supervise date cannot be earlier than hire date.';
        SET @status_message = 'Error: Supervise date cannot be earlier than hire date.';
        RETURN;
    END

    -- Kiểm tra nếu store_id tồn tại
    IF @store_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM store WHERE store_id = @store_id)
    BEGIN
        PRINT 'Error: Store ID does not exist.';
        SET @status_message = 'Error: Store ID does not exist.';
        RETURN;
    END

    -- Cập nhật thông tin nhân viên
    BEGIN TRY
      -- Cập nhật thông tin nhân viên
		UPDATE Employee
		SET identity_card = COALESCE(@identity_card, identity_card),
			lname = COALESCE(@lname, lname),
			fname = COALESCE(@fname, fname),
			phone_number = COALESCE(@phone_number, phone_number),
			dob = COALESCE(@dob, dob),
			hire_date = COALESCE(@hire_date, hire_date),
			email = COALESCE(@email, email),
			supervisor_id = COALESCE(@supervisor_id, supervisor_id),
			supervise_date = COALESCE(@supervise_date, supervise_date),
			store_id = COALESCE(@store_id, store_id),
			is_deleted = COALESCE(@is_deleted, is_deleted)
		WHERE employee_id = @employee_id;

        PRINT 'Employee updated successfully.';
        SET @status_message = 'Employee updated successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred while updating the employee.';
        SET @status_message = 'An error occurred while updating the employee.';
    END CATCH
END;

-- Example execution of update_employee
	DECLARE @status_message VARCHAR(50);
	EXEC update_employee 
		@employee_id = 3,
		@lname = 'Smith',
		@fname = 'Jane',
		@phone_number = '0912245378',
		@email = 'janesmith1@example.com',
		@store_id = 1,
		@supervisor_id = 1,
	
		@status_message = @status_message OUT;


--------------
-- Get employee by ID
CREATE OR ALTER PROCEDURE get_employee_by_id
    @employee_id INT
AS
BEGIN
    -- Kiểm tra xem employee_id có tồn tại trong bảng Employee không
    IF NOT EXISTS (SELECT 1 FROM employee WHERE employee_id = @employee_id)
    BEGIN
        PRINT 'Error: Employee ID does not exist.';
        RETURN;
    END

    -- Lấy thông tin chi tiết nhân viên với các bảng liên quan
    SELECT
      employee_id,
		identity_card,
        lname,
        fname,
        phone_number,
        dob,
        hire_date,
        email,
        supervisor_id,
        supervise_date,
        store_id,
		is_deleted
	FROM employee as e
    WHERE e.employee_id = @employee_id;
END;


-- Example execution of get_employee_by_id
EXEC get_employee_by_id @employee_id = '1';


-- Get all employees
CREATE OR ALTER PROCEDURE get_all_employees
AS
BEGIN
    -- Lấy thông tin tất cả nhân viên
    SELECT
        employee_id,
		identity_card,
        lname,
        fname,
        phone_number,
        dob,
        hire_date,
        email,
        supervisor_id,
        supervise_date,
        store_id,
		is_deleted
    FROM employee;
END;

-- Example execution of get_all_employees
EXEC get_all_employees;
