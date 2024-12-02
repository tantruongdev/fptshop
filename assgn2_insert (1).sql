USE assignment2;
GO

-- Insert bảng MembershipClass
ALTER TABLE Customer 
NOCHECK CONSTRAINT fk_membership_class_customer;

INSERT INTO membership_class (name, discount_percent, minimum_no_point)  
VALUES 
    ('Normal', 2, 5),
    ('Silver', 5, 10),
    ('Gold', 10, 15),
    ('Diamond', 15, 20);

ALTER TABLE customer 
CHECK CONSTRAINT fk_membership_class_customer;

-- Insert bảng Customer
INSERT INTO customer (phone_number, email, registration_date, shipping_address, lname, fname, total_points, membership_class_id) 
VALUES 
    ('0333333444', 'nguyenvannam@gmail.com', '2024-11-01', 'KP6, Tan Lap Street, Dong Hoa, Di An, Binh Duong', 'Nguyen', 'Nam', 45, 2),
    ('0333333445', 'nguyenvannam1@gmail.com', '2024-11-02', 'KP6, Tan Lap Street, Dong Hoa, Di An, Binh Duong', 'Le', 'Bao', 20, 1),
    ('0333333446', 'nguyenvannam2@gmail.com', '2024-10-03', 'KP6, Tan Lap Street, Dong Hoa, Di An, Binh Duong', 'Bui', 'Lan', 30, 3),
    ('0333333447', 'nguyenvannam3@gmail.com', '2023-12-04', 'KP6, Tan Lap Street, Dong Hoa, Di An, Binh Duong', 'Nguyen', 'Hoa', 10, 2),
    ('0333333448', 'nguyenvannam4@gmail.com', '2022-11-01', 'KP6, Tan Lap Street, Dong Hoa, Di An, Binh Duong', 'Tran', 'Nguyen', 60, 3),
    ('0333333449', 'nguyenvannam5@gmail.com', '2021-11-05', 'KP6, Tan Lap Street, Dong Hoa, Di An, Binh Duong', 'Nguyen', 'Thanh', 55, 4);

-- Insert bảng Cart
INSERT INTO cart (customer_id, total_amount, created_date) 
VALUES 
    (5, 1500000, '2024-11-03'),
    (2, 350000, '2024-11-03'),
    (3, 2500000, '2024-11-04'),
    (4, 6239000, '2024-11-06');

-- Insert bảng Store
INSERT INTO store (number_of_employees, area, store_name, address) 
VALUES 
    (4, 100.00, 'Phone Store', 'Ta Quang Buu Street, Dong Hoa, Di An, Binh Duong'),
    (4, 200.00, 'Duy Apple', '123 Le Quyen Street, District 8, TPHCM'),
    (1, 300.00, 'Tech Store', '123 Ly Thuong Kiet, District 10, TPHCM');

-- Insert bảng Promotion
INSERT INTO promotion (type, name, start_date, end_date) 
VALUES 
    ('Sale 10% Headphone', 'Merry Christmas', '2023-12-20', '2023-12-26'),
    ('Sale 10% Earphone', 'Happy New Year', '2023-12-30', '2024-01-15'),
    ('Sale 10% Laptop', 'Back to School', '2024-07-05', '2024-08-15');

-- Insert bảng CategoryType
INSERT INTO category_type(name) 
VALUES 
    ('Device'),
    ('Accessory');

-- Insert bảng ProductLine
INSERT INTO product_line(name, brand, is_used, stock_status, price, description, category, color, promotion_id, discount_percentage, category_type_id) 
VALUES 
    ('Iphone 12', 'Apple', 0, 1, 11000000, 'iPhone 12 ra mắt với vai trò mở ra một kỷ nguyên hoàn toàn mới.', 'device', 'Black', NULL, 5, 1),
    ('Iphone 12', 'Apple', 0, 1, 11000000, 'iPhone 12 ra mắt với vai trò mở ra một kỷ nguyên hoàn toàn mới.', 'device', 'White', NULL, 5, 1),
    ('Iphone 12', 'Apple', 0, 1, 11000000, 'iPhone 12 ra mắt với vai trò mở ra một kỷ nguyên hoàn toàn mới.', 'device', 'DarkBlue', NULL, 5, 1),
    ('Galaxy Z Fold6', 'Samsung', 0, 1, 41990000, 'Galaxy Z Fold6 với màn hình gập vượt trội.', 'device', 'White', NULL, NULL, 1),
    ('Galaxy Z Fold6', 'Samsung', 0, 1, 41990000, 'Galaxy Z Fold6 với màn hình gập vượt trội.', 'device', 'Grey', NULL, NULL, 1),
    ('Tai nghe Bluetooth Edifier W800BT Pro', 'Edifier', 0, 1, 1080000, 'Tai nghe chụp tai với âm thanh vượt trội.', 'accessory', 'Black', NULL, 10, 2),
    ('Tai nghe Bluetooth Edifier W800BT Pro', 'Edifier', 0, 1, 1080000, 'Tai nghe chụp tai với âm thanh vượt trội.', 'accessory', 'White', NULL, 10, 2);

-- Insert bảng Device
INSERT INTO device (id, ram, operator_system, battery_capacity, weight, camera, storage, screen_size, display_resolution) 
VALUES 
    (1, '4GB', 'iOS', '2815 mAh', '164 g', '12 MP', '256GB', '6.1 inches', '1170 x 2532 pixels'),
    (2, '4GB', 'iOS', '2815 mAh', '164 g', '12 MP', '256GB', '6.1 inches', '1170 x 2532 pixels'),
    (3, '4GB', 'iOS', '2815 mAh', '164 g', '12 MP', '256GB', '6.1 inches', '1170 x 2532 pixels'),
    (4, '12GB', 'Android', '4400 mAh', '239 g', '50 MP', '256GB', '7.6 inches', '2160 x 1856 pixels'),
    (5, '12GB', 'Android', '4400 mAh', '239 g', '50 MP', '256GB', '7.6 inches', '2160 x 1856 pixels');

-- Insert bảng Accessory
INSERT INTO accessory (id, battery_capacity) 
VALUES 
    (6,'45 hours'),
    (7,'45 hours');

-- Insert bảng Delivery
INSERT INTO delivery (shipping_provider, delivery_status, actual_delivery_date, estimated_delivery_date, shipping_address, lname, fname) 
VALUES 
    ('Viettel Post', 'completed', '2023-11-08', '2023-11-08', '345 Pham Van Dong Street, Thu Duc, HCMC', 'Tran', 'Nguyen'),
    ('Viettel Post', 'completed', '2023-01-13', '2023-01-14', '31A Pham Van Dong Street, Thu Duc, HCMC', 'Le', 'Bao'),
    ('Viettel Post', 'completed', '2023-12-05', '2023-12-04', '123 Pham Van Dong Street, Thu Duc, HCMC', 'Nguyen', 'Hoa'),
    ('Viettel Post', 'completed', '2024-11-03', '2024-11-03', '123 Pham Van Dong Street, Thu Duc, HCMC', 'Nguyen', 'Hoa');

-- Insert bảng Employee
INSERT INTO employee (identity_card, lname, fname, phone_number, dob, hire_date, email, supervisor_id, supervise_date, store_id) 
VALUES 
    ('123456789012', 'Nguyen', 'Anh', '0912345678', '1990-01-15', '2023-11-09', 'anh.nguyen@example.com', NULL, NULL, 1),
    ('123456789123', 'Nguyen', 'Khoa', '0912343210', '1992-04-25', '2023-04-09', 'khoa.nguyen@example.com', NULL, NULL, 1),
    ('123456745612', 'Nguyen', 'Phi', '0912344567', '1988-03-12', '2022-12-09', 'phi.nguyen@example.com', NULL, NULL, 1),
    ('321456745612', 'Le', 'Phi', '0912344156', '1993-07-19', '2021-11-09', 'phi.le@example.com', NULL, NULL, 1);

-- Insert bảng [Order]
INSERT INTO [order] (order_date, order_status, total_amount, employee_id, customer_id, delivery_id) 
VALUES 
    ('2023-12-05', 'completed', 11000000, 1, 4, 1),
    ('2024-11-03', 'completed', 11000000, 2, 4, 4),
    ('2023-11-08', 'completed', 1080000, 1, 5, 2),
    ('2023-01-13', 'completed', 41990000, 2, 2, 3);

-- Insert bảng Payment
INSERT INTO payment (order_id, payment_date, payment_status, method) 
VALUES 
    (1, '2023-12-05', 'completed', 'COD'),
    (2, '2024-11-03', 'completed', 'COD'),
    (3, '2023-11-08', 'completed', 'Credit Card'),
    (4, '2023-01-13', 'completed', 'COD');

-- Insert bảng GoodsDeliveryNote
INSERT INTO goods_delivery_note(date, order_id, employee_id) 
VALUES 
    ('2023-12-04', 1, 1),
    ('2024-11-03', 2, 2),
    ('2023-11-08', 3, 1),
    ('2024-01-13', 4, 2);

-- Insert bảng Product
INSERT INTO product(store_id, device_id, note_id) 
VALUES 
    (1, 1, 1),
    (1, 2, 2),
    (1, 4, 3),
    (1, 5, 4);

-- Insert bảng Review
INSERT INTO review (product_line_id, customer_id, [index], review_date, approval_status, review_text, rating) 
VALUES 
    (1, 4, 1, '2023-12-15', 'accepted', 'Excellent', 5),
    (3, 5, 1, '2024-01-10', 'accepted', 'Good quality', 4),
    (6, 3, 1, '2024-02-20', 'pending', 'Average', 3);

-- Insert bảng SpecialFeature
INSERT INTO special_feature(device_id, special_feature	) 
VALUES 
    (1, 'Waterproof, Bluetooth, Wireless Charging, Fast Charging'),
    (2, 'Noise Cancelling, Bluetooth, USB Type-C'),
    (3, 'High Resolution Display, Fast Processor'),
    (4, 'Lightweight, Compact Design'),
    (5, 'Long Battery Life, Fast Charging');

-- Insert bảng Connections
INSERT INTO connections(accessory_id, [connection]) 
VALUES 
    (6, 'USB Type-C, Bluetooth'),
    (7, 'USB Type-C, Bluetooth');

-- Insert bảng Images
INSERT INTO Images (product_line_id, [image]) 
VALUES 
    (1, 'image1.jpg'),
    (2, 'image2.jpg'),
    (3, 'image3.png'),
    (4, 'image4.png'),
    (5, 'image5.jpg'),
    (6, 'image6.png'),
    (7, 'image7.png');

-- Insert bảng CartIncludesProductLine
INSERT INTO cart_includes_product_line(product_line_id, customer_id, price, quantity) 
VALUES 
    (6, 3, 1080000, 2),
    (2, 1, 11000000, 1);

-- Insert bảng OrderIncludesProductLine
INSERT INTO order_includes_product_line(product_line_id, order_id, price, quantity) 
VALUES 
    (1, 1, 11000000, 1),
	(1, 4, 11000000, 2),
    (2, 2, 11000000, 1),
    (6, 3, 1080000, 2);

-- Insert bảng ProductLineManagedByEmployee
INSERT INTO product_line_managed_by_employee(product_line_id, employee_id) 
VALUES 
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 2),
    (5, 1);

-- Insert bảng AccessoryInStore
INSERT INTO [dbo].[accessory_in_store] (accessory_id, store_id, stock_quantity) 
VALUES 
    (6, 1, 100),
    (7, 1, 150);



