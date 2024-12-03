IF EXISTS (SELECT * FROM sys.databases WHERE name = 'assignment2')
BEGIN 
    DROP DATABASE assignment2;
END
CREATE DATABASE assignment2;
GO
USE assignment2;
GO

SET DATEFORMAT dmy;
GO

CREATE TABLE membership_class (
	id						INT				IDENTITY(1,1) PRIMARY KEY,
	name					VARCHAR(30)		UNIQUE NOT NULL,
	discount_percent		SMALLINT		UNIQUE NOT NULL CHECK (discount_percent > 0 AND discount_percent < 100),
	minimum_no_point		INT				UNIQUE NOT NULL
);

CREATE TABLE customer (
	customer_id				INT				IDENTITY(1,1) PRIMARY KEY,
	phone_number			CHAR(10)		UNIQUE NOT NULL,
	email					VARCHAR(50)		UNIQUE,
	registration_date		DATE			NOT NULL DEFAULT '2000-01-01',
	shipping_address		VARCHAR(100),
	lname					VARCHAR(40)		NOT NULL,
	fname					VARCHAR(15)		NOT NULL,
	total_points			INT				NOT NULL DEFAULT 0,
	membership_class_id		INT				NOT NULL,
	is_deleted				BIT				NOT NULL DEFAULT 0,
	CONSTRAINT fk_membership_class_customer
		FOREIGN KEY (membership_class_id) REFERENCES membership_class(id)
);

CREATE TABLE cart (
	cart_id					INT				IDENTITY(1,1) PRIMARY KEY,
	customer_id				INT				UNIQUE NOT NULL,
	total_amount				DECIMAL(10,2)	NOT NULL DEFAULT 0,
	created_date				DATE,
	CONSTRAINT fk_customer_id_cart
		FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE store (
	store_id				INT				IDENTITY(1,1) PRIMARY KEY,
	number_of_employees		INT				NOT NULL DEFAULT 0,
	area						DECIMAL(15,2),
	store_name				VARCHAR(50),
	address					VARCHAR(150)	UNIQUE NOT NULL
);

CREATE TABLE promotion (
	promotion_id			INT				IDENTITY(1,1) PRIMARY KEY,
	type					VARCHAR(20),
	name					VARCHAR(70)		NOT NULL,
	start_date				DATE			NOT NULL,
	end_date				DATE			NOT NULL
);

CREATE TABLE category_type (
	category_type_id		INT				IDENTITY(1,1) PRIMARY KEY,
	name					VARCHAR(30)		UNIQUE NOT NULL
);

CREATE TABLE product_line (
	id						INT				IDENTITY(1,1) PRIMARY KEY,
	name					VARCHAR(100)	NOT NULL,
	brand					VARCHAR(50)		NOT NULL,
	is_used					BIT				NOT NULL,
	stock_status			BIT				NOT NULL,
	price					DECIMAL(15,2)	NOT NULL,
	description			    TEXT,
	category				VARCHAR(15)			CHECK (category IN ('device', 'accessory')),
	color					VARCHAR(15),
	promotion_id			INT,
	discount_percentage	SMALLINT		CHECK (discount_percentage > 0 AND discount_percentage < 100),
	category_type_id		INT				NOT NULL,
	CONSTRAINT fk_promotion_id_product_line
		FOREIGN KEY (promotion_id) REFERENCES promotion(promotion_id),
	CONSTRAINT fk_category_type_id_product_line
		FOREIGN KEY (category_type_id) REFERENCES category_type(category_type_id)
);

CREATE TABLE device (
	id						INT PRIMARY KEY,
	ram						VARCHAR(15),
	operator_system			VARCHAR(20),
	battery_capacity			VARCHAR(30),
	weight					VARCHAR(15),
	camera					VARCHAR(50),
	storage					VARCHAR(15),
	screen_size				VARCHAR(30),
	display_resolution		VARCHAR(30),
	CONSTRAINT fk_id_device
		FOREIGN KEY (id) REFERENCES product_line(id)
);

CREATE TABLE accessory (
	id						INT	 PRIMARY KEY,
	battery_capacity			VARCHAR(30),
	CONSTRAINT fk_id_accessory
		FOREIGN KEY (id) REFERENCES product_line(id)
);

CREATE TABLE delivery (
	delivery_id				INT				IDENTITY(1,1) PRIMARY KEY,
	shipping_provider		VARCHAR(30),
	delivery_status			VARCHAR(20)		NOT NULL DEFAULT 'shipping' CHECK (delivery_status IN ('shipping', 'completed')),
	actual_delivery_date		DATE,
	estimated_delivery_date	DATE,
	shipping_address			VARCHAR(100),
	lname					VARCHAR(40)		NOT NULL,
	fname					VARCHAR(15)		NOT NULL
);

CREATE TABLE employee (
	employee_id				INT				IDENTITY(1,1) PRIMARY KEY,
	identity_card			CHAR(12)		UNIQUE NOT NULL,
	lname					VARCHAR(40)		NOT NULL,
	fname					VARCHAR(15)		NOT NULL,
	phone_number			CHAR(10)		UNIQUE,
	dob						DATE			NOT NULL CHECK (dob <= GETDATE()),
	hire_date				DATE			NOT NULL DEFAULT CONVERT(DATE, '2000-01-01'),
	email					VARCHAR(50),
	supervisor_id			INT,
	supervise_date			DATE,
	store_id					INT				NOT NULL,
	is_deleted				BIT				NOT NULL DEFAULT 0,
	CONSTRAINT fk_supervisor_id_employee
		FOREIGN KEY (supervisor_id) REFERENCES employee(employee_id),
	CONSTRAINT fk_store_id_employee
		FOREIGN KEY (store_id) REFERENCES store(store_id)
);

CREATE TABLE [order](
	order_id				INT				IDENTITY(1,1) PRIMARY KEY,
	order_date			DATE,
	order_status			VARCHAR(20)		NOT NULL DEFAULT 'pending' CHECK (order_status IN ('pending', 'shipping', 'completed')),
	total_amount			DECIMAL(10,2)	NOT NULL DEFAULT 0,
	employee_id			INT,
	customer_id			INT				NOT NULL,
	delivery_id			INT,
	CONSTRAINT fk_employee_id_order
		FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
	CONSTRAINT fk_customer_id_order
		FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
	CONSTRAINT fk_delivery_id_order
		FOREIGN KEY (delivery_id) REFERENCES delivery(delivery_id)
);

CREATE TABLE payment (
	order_id			INT		PRIMARY KEY,
	payment_date		DATE,
	payment_status		VARCHAR(20)		NOT NULL DEFAULT 'pending' CHECK (payment_status IN ('pending', 'completed')),
	method				VARCHAR(30),
	CONSTRAINT fk_order_id_payment
		FOREIGN KEY (order_id) REFERENCES [order](order_id)
);

CREATE TABLE goods_delivery_note (
	id						INT				IDENTITY(1,1) PRIMARY KEY,
	date					DATE,
	order_id				INT				UNIQUE NOT NULL,
	employee_id			INT,
	CONSTRAINT fk_order_id_goods_delivery_note
		FOREIGN KEY (order_id) REFERENCES [order](order_id),
	CONSTRAINT fk_employee_id_goods_delivery_note
		FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE TABLE [product] (
	serial					INT				IDENTITY(1,1) PRIMARY KEY,
	store_id				INT				NOT NULL,
	device_id				INT				NOT NULL,
	note_id					INT,
	CONSTRAINT fk_store_id_product
		FOREIGN KEY (store_id) REFERENCES store(store_id),
	CONSTRAINT fk_device_id_product
		FOREIGN KEY (device_id) REFERENCES device(id),
	CONSTRAINT fk_note_id_product
		FOREIGN KEY (note_id) REFERENCES goods_delivery_note(id)
);

CREATE TABLE review (
	product_line_id		INT,
	customer_id			INT,	
	[index]					INT,
	review_date			DATE,
	approval_status		VARCHAR(20)		NOT NULL DEFAULT 'pending' CHECK (approval_status IN ('pending', 'accepted', 'rejected')),
	review_text			TEXT,
	rating					SMALLINT		NOT NULL CHECK (rating >= 1 AND rating <= 5),
	CONSTRAINT pk_review
		PRIMARY KEY (product_line_id, customer_id, [index]),
	CONSTRAINT fk_product_id_review
		FOREIGN KEY (product_line_id) REFERENCES product_line(id),
	CONSTRAINT fk_customer_id_review
		FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE special_feature (
	device_id				INT,
	special_feature		VARCHAR(75),
	CONSTRAINT pk_special_feature
		PRIMARY KEY (device_id, special_feature),
	CONSTRAINT fk_device_id_special_feature
		FOREIGN KEY (device_id) REFERENCES device(id)
);

CREATE TABLE connections (
	accessory_id			INT,
	[connection]			VARCHAR(30),
	CONSTRAINT pk_connections
		PRIMARY KEY (accessory_id, [connection]),
	CONSTRAINT fk_accessory_id_connections
		FOREIGN KEY (accessory_id) REFERENCES accessory(id)
);

CREATE TABLE images (
	product_line_id		INT ,
	[image]				VARCHAR(50),
	CONSTRAINT pk_images
		PRIMARY KEY (product_line_id, [image]),
	CONSTRAINT fk_product_line_id_images
		FOREIGN KEY (product_line_id) REFERENCES product_line(id)
);

CREATE TABLE cart_includes_product_line (
	product_line_id		INT ,
	customer_id			INT,
	price					DECIMAL(15,2)	NOT NULL,
	quantity				INT				NOT NULL,
	CONSTRAINT pk_cart_includes_product_line
		PRIMARY KEY (product_line_id, customer_id),
	CONSTRAINT fk_product_line_id_cart_includes_product_line
		FOREIGN KEY (product_line_id) REFERENCES product_line(id),
	CONSTRAINT fk_customer_id_cart_includes_product_line
		FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE order_includes_product_line (
	product_line_id		INT,
	order_id				INT,
	price					DECIMAL(15,2)	NOT NULL,
	quantity				INT				NOT NULL,
	CONSTRAINT pk_order_includes_product_line
		PRIMARY KEY (product_line_id, order_id),
	CONSTRAINT fk_product_line_id_order_includes_product_line
		FOREIGN KEY (product_line_id) REFERENCES product_line(id),
	CONSTRAINT fk_order_id_order_includes_product_line
		FOREIGN KEY (order_id) REFERENCES [order](order_id)
);

ALTER TABLE order_includes_product_line
DROP CONSTRAINT fk_order_id_order_includes_product_line;


ALTER TABLE order_includes_product_line
ADD CONSTRAINT fk_order_id_order_includes_product_line
FOREIGN KEY (order_id) REFERENCES [order](order_id)
ON DELETE CASCADE;

CREATE TABLE product_line_managed_by_employee (
	product_line_id		INT,
	employee_id			INT,
	CONSTRAINT pk_product_line_managed_by_employee
		PRIMARY KEY (product_line_id, employee_id),
	CONSTRAINT fk_product_line_id_product_line_managed_by_employee
		FOREIGN KEY (product_line_id) REFERENCES product_line(id),
	CONSTRAINT fk_employee_id_product_line_managed_by_employee
		FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE TABLE accessory_in_store (
	accessory_id			INT,
	store_id				INT,
	stock_quantity			INT			NOT NULL,
	CONSTRAINT pk_accessory_in_store
		PRIMARY KEY (accessory_id, store_id),
	CONSTRAINT fk_accessory_id_accessory_in_store
		FOREIGN KEY (accessory_id) REFERENCES accessory(id),
	CONSTRAINT fk_store_id_accessory_in_store
		FOREIGN KEY (store_id) REFERENCES store(store_id)
);
