-- KJ CORP — Database Design & Implementation (MySQL 8.0)
-- Author: Jose Ayon Wu (UNF Canada)
-- Description: Normalized schema with integrity constraints + reporting queries
-- Context: Designed for KJ CORP, a retail and distribution company.
-- Notes:
--  - Anonymized data used for demonstration (no real identifiers).
--  - Compatible with MySQL 8.0.

-- Create the database
DROP DATABASE IF EXISTS KJCorpDB;
CREATE DATABASE IF NOT EXISTS KJCorpDB;
USE KJCorpDB;

-- Table: Company
CREATE TABLE IF NOT EXISTS Company (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    tax_id VARCHAR(11) UNIQUE NOT NULL,
    foundation_date	DATE
);

-- Table: Suppliers
CREATE TABLE IF NOT EXISTS Suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(100),
    phone VARCHAR(50),
    email VARCHAR(100),
    country VARCHAR(100),
    FOREIGN KEY (company_id) REFERENCES Company(company_id) ON DELETE CASCADE
);

-- Table: Categories
CREATE TABLE IF NOT EXISTS Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Table: Products
CREATE TABLE IF NOT EXISTS Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT,
    category_id INT,
    name VARCHAR(100) NOT NULL,
    brand VARCHAR(100) NOT NULL,
    model VARCHAR(100),
    weight DECIMAL(10,2),
    height DECIMAL(10,2),
    width DECIMAL(10,2),
    depth DECIMAL(10,2),
    voltage DECIMAL(10,2),
    amperage DECIMAL(10,2),
    watts DECIMAL(10,2),
    color VARCHAR(50),
    material VARCHAR(50),
    cable_thickness DECIMAL(10,2),
    terminals VARCHAR(100),
    price DECIMAL(10,2) NOT NULL,
    ean VARCHAR(13) UNIQUE NOT NULL,
    supplier_id INT,
    FOREIGN KEY (company_id) REFERENCES Company(company_id) ON DELETE CASCADE,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE SET NULL,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE SET NULL
);

-- Table: Inventory
CREATE TABLE IF NOT EXISTS Inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    stock INT NOT NULL,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
);

-- Table: Customers
CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT,
    document_type ENUM('DNI', 'RUC') NOT NULL,
    document_number VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    district VARCHAR(100),
    province VARCHAR(100),
    country VARCHAR(100),
    contact_name VARCHAR(255),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(50),
    FOREIGN KEY (company_id) REFERENCES Company(company_id) ON DELETE CASCADE
);

-- Table: Sales
CREATE TABLE IF NOT EXISTS Sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT,
    customer_id INT,
    sale_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    payment_status ENUM('pending', 'partial', 'complete') DEFAULT 'pending',
    FOREIGN KEY (company_id) REFERENCES Company(company_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

-- Table: Sales_Details
CREATE TABLE IF NOT EXISTS Sales_Details (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (sale_id) REFERENCES Sales(sale_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
);

-- Table: Payments
CREATE TABLE IF NOT EXISTS Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_id INT,
    amount_paid DECIMAL(10,2) NULL,
    payment_method VARCHAR(50) NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sale_id) REFERENCES Sales(sale_id) ON DELETE CASCADE
);

-- Table: Employees
CREATE TABLE IF NOT EXISTS Employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT,
    name VARCHAR(255) NOT NULL,
    position VARCHAR(100),
    salary DECIMAL(10,2),
    hire_date DATE,
    FOREIGN KEY (company_id) REFERENCES Company(company_id) ON DELETE CASCADE
);

-- Insert data into Company
INSERT INTO Company (name, tax_id) VALUES
('KJ CORP SAC', '99999999999')
ON DUPLICATE KEY UPDATE name = VALUES(name), tax_id = VALUES(tax_id);

-- Insert data into Suppliers
INSERT INTO Suppliers (company_id, name, address, phone, email, country) VALUES
(1, 'Solar Supplier S.A.', 'Av. Energy 123, Lima', '987654321', 'contact@solarsa.com', 'Peru'),
(1, 'Global Security', 'Calle Locks 456, Lima', '923456789', 'sales@globalsecurity.com', 'Peru'),
(1, 'SolarTech Inc.', '123 Solar Ave, Lima', '987654321', 'info@solartech.com', 'Peru'),
(1, 'EcoPower Solutions', '456 Green St, Arequipa', '912345678', 'sales@ecopower.com', 'Peru'),
(1, 'SecureLock Co.', '789 Security Blvd, Trujillo', '923456789', 'support@securelock.com', 'Peru'),
(1, 'Hardware World', '321 Tool Rd, Chiclayo', '934567890', 'contact@hardwareworld.com', 'Peru'),
(1, 'Bath Essentials', '654 Bath St, Piura', '945678901', 'info@bathessentials.com', 'Peru'),
(1, 'Energy Plus', '987 Power Ave, Cusco', '956789012', 'sales@energyplus.com', 'Peru'),
(1, 'Global Electronics', '111 Tech Rd, Iquitos', '967890123', 'support@globalelectronics.com', 'Peru'),
(1, 'Home Improvement Inc.', '222 Home St, Huancayo', '978901234', 'info@homeimprovement.com', 'Peru');

-- Insert data into Categories
INSERT INTO Categories (name) VALUES
('Solar Energy'),
('Security'),
('Hardware'),
('Bathroom');

-- Insert data into Products
INSERT INTO Products (company_id, category_id, name, brand, model, weight, height, width, depth, voltage, amperage, watts, color, material, cable_thickness, terminals, price, ean, supplier_id) VALUES
(1, 1, 'Solar Panel 100W', 'Apollo', 'AP100W', 12.5, 120.0, 54.0, 3.5, 18.0, 5.5, 100, 'Black', 'Silicon', NULL, NULL, 150.00, '1234567890123', 1),
(1, 2, 'Digital Lock', 'FortLock', 'FL-D123', 2.0, 15.0, 7.5, 3.0, NULL, NULL, NULL, 'Silver', 'Stainless Steel', NULL, NULL, 250.00, '9876543210987', 2),
(1, 1, 'Solar Panel 200W', 'Apollo', 'AP200W', 15.0, 150.0, 60.0, 4.0, 24.0, 8.3, 200, 'Black', 'Silicon', NULL, NULL, 250.00, '1234567890124', 1),
(1, 1, 'Solar Inverter 5000W', 'SunPower', 'SP5000', 10.0, 30.0, 20.0, 15.0, 220.0, 22.7, 5000, 'Gray', 'Aluminum', NULL, NULL, 1200.00, '1234567890125', 1),
(1, 2, 'Smart Lock Pro', 'FortLock', 'FL-S123', 1.5, 10.0, 5.0, 2.5, NULL, NULL, NULL, 'Silver', 'Stainless Steel', NULL, NULL, 300.00, '1234567890126', 3),
(1, 2, 'Security Camera 4K', 'SecureCam', 'SC4K', 2.5, 20.0, 15.0, 10.0, NULL, NULL, NULL, 'Black', 'Plastic', NULL, NULL, 150.00, '1234567890127', 3),
(1, 3, 'Drill Machine 800W', 'ToolMaster', 'TM800', 3.0, 25.0, 10.0, 8.0, NULL, NULL, NULL, 'Blue', 'Metal', NULL, NULL, 80.00, '1234567890128', 4),
(1, 3, 'Hammer Drill 1000W', 'ToolMaster', 'TM1000', 4.0, 30.0, 12.0, 10.0, NULL, NULL, NULL, 'Red', 'Metal', NULL, NULL, 120.00, '1234567890129', 4),
(1, 4, 'Shower Set Chrome', 'BathElegance', 'BE-SC', 2.0, 15.0, 10.0, 5.0, NULL, NULL, NULL, 'Chrome', 'Brass', NULL, NULL, 50.00, '1234567890130', 5),
(1, 4, 'Faucet Modern', 'BathElegance', 'BE-FM', 1.5, 12.0, 8.0, 4.0, NULL, NULL, NULL, 'Silver', 'Stainless Steel', NULL, NULL, 70.00, '1234567890131', 5),
(1, 1, 'Solar Battery 100Ah', 'EcoPower', 'EP100', 25.0, 20.0, 15.0, 10.0, 12.0, 8.3, NULL, 'White', 'Plastic', NULL, NULL, 300.00, '1234567890132', 2),
(1, 1, 'Solar Panel 300W', 'Apollo', 'AP300W', 18.0, 180.0, 70.0, 5.0, 36.0, 8.3, 300, 'Black', 'Silicon', NULL, NULL, 350.00, '1234567890133', 1),
(1, 2, 'Biometric Lock', 'FortLock', 'FL-B123', 2.0, 12.0, 6.0, 3.0, NULL, NULL, NULL, 'Black', 'Metal', NULL, NULL, 400.00, '1234567890134', 3),
(1, 2, 'Wireless Alarm System', 'SecureCam', 'SC-WA', 3.0, 25.0, 20.0, 15.0, NULL, NULL, NULL, 'White', 'Plastic', NULL, NULL, 200.00, '1234567890135', 3),
(1, 3, 'Circular Saw 1500W', 'ToolMaster', 'TM1500', 5.0, 35.0, 15.0, 12.0, NULL, NULL, NULL, 'Green', 'Metal', NULL, NULL, 150.00, '1234567890136', 4),
(1, 3, 'Angle Grinder 1200W', 'ToolMaster', 'TM1200', 4.5, 30.0, 12.0, 10.0, NULL, NULL, NULL, 'Yellow', 'Metal', NULL, NULL, 130.00, '1234567890137', 4),
(1, 4, 'Bathtub Faucet', 'BathElegance', 'BE-BF', 2.5, 18.0, 10.0, 6.0, NULL, NULL, NULL, 'Gold', 'Brass', NULL, NULL, 90.00, '1234567890138', 5),
(1, 4, 'Shower Head Rain', 'BathElegance', 'BE-SR', 1.0, 10.0, 8.0, 4.0, NULL, NULL, NULL, 'Chrome', 'Stainless Steel', NULL, NULL, 60.00, '1234567890139', 5),
(1, 1, 'Solar Charge Controller', 'EcoPower', 'EP-SCC', 1.0, 10.0, 8.0, 4.0, 12.0, 10.0, NULL, 'Black', 'Plastic', NULL, NULL, 100.00, '1234567890140', 2),
(1, 1, 'Solar Panel 400W', 'Apollo', 'AP400W', 20.0, 200.0, 80.0, 6.0, 48.0, 8.3, 400, 'Black', 'Silicon', NULL, NULL, 450.00, '1234567890141', 1),
(1, 2, 'Keyless Entry Lock', 'FortLock', 'FL-K123', 1.8, 11.0, 5.5, 3.0, NULL, NULL, NULL, 'Silver', 'Metal', NULL, NULL, 350.00, '1234567890142', 3),
(1, 2, 'Surveillance Camera', 'SecureCam', 'SC-SC', 2.0, 18.0, 12.0, 8.0, NULL, NULL, NULL, 'Black', 'Plastic', NULL, NULL, 180.00, '1234567890143', 3),
(1, 3, 'Jigsaw 800W', 'ToolMaster', 'TM800J', 3.5, 28.0, 10.0, 8.0, NULL, NULL, NULL, 'Blue', 'Metal', NULL, NULL, 90.00, '1234567890144', 4),
(1, 3, 'Impact Wrench', 'ToolMaster', 'TM-IW', 4.0, 30.0, 12.0, 10.0, NULL, NULL, NULL, 'Red', 'Metal', NULL, NULL, 140.00, '1234567890145', 4),
(1, 4, 'Towel Rack Chrome', 'BathElegance', 'BE-TR', 1.5, 15.0, 5.0, 3.0, NULL, NULL, NULL, 'Chrome', 'Stainless Steel', NULL, NULL, 40.00, '1234567890146', 5);

-- Insert data into Inventory
INSERT INTO Inventory (product_id, stock) VALUES
(1, 100), -- Solar Panel 100W
(2, 50), -- Digital Lock
(3, 50),   -- Solar Panel 200W
(4, 30),   -- Solar Inverter 5000W
(5, 100),  -- Smart Lock Pro
(6, 80),   -- Security Camera 4K
(7, 120),  -- Drill Machine 800W
(8, 90),   -- Hammer Drill 1000W
(9, 60),   -- Shower Set Chrome
(10, 70),  -- Faucet Modern
(11, 40),  -- Solar Battery 100Ah
(12, 50),  -- Solar Panel 300W
(13, 30),  -- Biometric Lock
(14, 60),  -- Wireless Alarm System
(15, 80),  -- Circular Saw 1500W
(16, 70),  -- Angle Grinder 1200W
(17, 50),  -- Bathtub Faucet
(18, 60),  -- Shower Head Rain
(19, 40),  -- Solar Charge Controller
(20, 30),  -- Solar Panel 400W
(21, 50),  -- Keyless Entry Lock
(22, 60),  -- Surveillance Camera
(23, 70),  -- Jigsaw 800W
(24, 80),  -- Impact Wrench
(25, 50);  -- Towel Rack Chrome

-- Insert data into Customers
INSERT INTO Customers (company_id, document_type, document_number, name, address, district, province, country, contact_name, contact_email, contact_phone) VALUES
(1, 'DNI', '10345678', 'Maria Gonzalez', 'Calle Primavera 123, Lima', 'Miraflores', 'Lima', 'Peru', 'Maria Gonzalez', 'maria@example.com', '987654321'),
(1, 'RUC', '21567890124', 'Tienda ABC', 'Av. Libertad 456, Arequipa', 'Yanahuara', 'Arequipa', 'Peru', 'Carlos Ruiz', 'carlos@abc.com', '912345678'),
(1, 'DNI', '87654321', 'Juan Perez', 'Calle Sol 789, Trujillo', 'Trujillo', 'La Libertad', 'Peru', 'Juan Perez', 'juan@example.com', '923456789'),
(1, 'RUC', '20567890125', 'Ferreteria XYZ', 'Av. Industrial 321, Chiclayo', 'Chiclayo', 'Lambayeque', 'Peru', 'Ana Lopez', 'ana@xyz.com', '934567890'),
(1, 'DNI', '23456781', 'Pedro Sanchez', 'Calle Luna 654, Piura', 'Piura', 'Piura', 'Peru', 'Pedro Sanchez', 'pedro@example.com', '945678901'),
(1, 'RUC', '20567890126', 'ElectroHome', 'Av. Tecnologia 987, Cusco', 'Cusco', 'Cusco', 'Peru', 'Luisa Fernandez', 'luisa@electrohome.com', '956789012'),
(1, 'DNI', '34561230', 'Laura Torres', 'Calle Estrella 111, Iquitos', 'Iquitos', 'Loreto', 'Peru', 'Laura Torres', 'laura@example.com', '967890123'),
(1, 'RUC', '20567890127', 'ConstruMax', 'Av. Constructores 222, Huancayo', 'Huancayo', 'Junin', 'Peru', 'Roberto Diaz', 'roberto@construmax.com', '978901234'),
(1, 'DNI', '45618901', 'Sofia Ramirez', 'Calle Arcoiris 333, Tacna', 'Tacna', 'Tacna', 'Peru', 'Sofia Ramirez', 'sofia@example.com', '989012345'),
(1, 'RUC', '20567890128', 'BathWorld', 'Av. San Martin 444, Puno', 'Puno', 'Puno', 'Peru', 'Jorge Morales', 'jorge@bathworld.com', '990123456'),
(1, 'DNI', '56189012', 'Carlos Mendoza', 'Calle Rio 555, Lima', 'San Isidro', 'Lima', 'Peru', 'Carlos Mendoza', 'carlos@example.com', '991234567'),
(1, 'RUC', '20567890129', 'TechStore', 'Av. Innovacion 666, Arequipa', 'Cayma', 'Arequipa', 'Peru', 'Ana Silva', 'ana@techstore.com', '992345678'),
(1, 'DNI', '67890813', 'Luis Torres', 'Calle Mar 777, Trujillo', 'Trujillo', 'La Libertad', 'Peru', 'Luis Torres', 'luis@example.com', '993456789'),
(1, 'RUC', '20567890130', 'HomeCenter', 'Av. Hogar 888, Chiclayo', 'Chiclayo', 'Lambayeque', 'Peru', 'Maria Fernandez', 'maria@homecenter.com', '994567890'),
(1, 'DNI', '78901664', 'Jorge Ramirez', 'Calle Sol 999, Piura', 'Piura', 'Piura', 'Peru', 'Jorge Ramirez', 'jorge@example.com', '995678901'),
(1, 'RUC', '20567890131', 'ElectroMax', 'Av. Electricidad 101, Cusco', 'Cusco', 'Cusco', 'Peru', 'Sofia Gomez', 'sofia@electromax.com', '996789012'),
(1, 'DNI', '89872345', 'Pedro Castro', 'Calle Luna 202, Iquitos', 'Iquitos', 'Loreto', 'Peru', 'Pedro Castro', 'pedro@example.com', '997890123'),
(1, 'RUC', '20567890132', 'ConstruHome', 'Av. Construccion 303, Huancayo', 'Huancayo', 'Junin', 'Peru', 'Luis Ramirez', 'luis@construhome.com', '998901234'),
(1, 'DNI', '90128756', 'Ana Silva', 'Calle Arcoiris 404, Tacna', 'Tacna', 'Tacna', 'Peru', 'Ana Silva', 'ana@example.com', '999012345'),
(1, 'RUC', '20567890133', 'BathPlus', 'Av. San Martin 505, Puno', 'Puno', 'Puno', 'Peru', 'Jorge Morales', 'jorge@bathplus.com', '990123456'),
(1, 'DNI', '01230987', 'Carlos Gomez', 'Calle Rio 606, Lima', 'San Isidro', 'Lima', 'Peru', 'Carlos Gomez', 'carlos@example.com', '991234567'),
(1, 'RUC', '20567890134', 'TechPlus', 'Av. Innovacion 707, Arequipa', 'Cayma', 'Arequipa', 'Peru', 'Ana Silva', 'ana@techplus.com', '992345678'),
(1, 'DNI', '12344432', 'Luis Fernandez', 'Calle Mar 808, Trujillo', 'Trujillo', 'La Libertad', 'Peru', 'Luis Fernandez', 'luis@example.com', '993456789'),
(1, 'RUC', '20567890135', 'HomePlus', 'Av. Hogar 909, Chiclayo', 'Chiclayo', 'Lambayeque', 'Peru', 'Maria Fernandez', 'maria@homeplus.com', '994567890'),
(1, 'DNI', '23458642', 'Jorge Castro', 'Calle Sol 101, Piura', 'Piura', 'Piura', 'Peru', 'Jorge Castro', 'jorge@example.com', '995678901'),
(1, 'RUC', '20567890136', 'ElectroPlus', 'Av. Electricidad 202, Cusco', 'Cusco', 'Cusco', 'Peru', 'Sofia Gomez', 'sofia@electroplus.com', '996789012'),
(1, 'DNI', '34002340', 'Pedro Ramirez', 'Calle Luna 303, Iquitos', 'Iquitos', 'Loreto', 'Peru', 'Pedro Ramirez', 'pedro@example.com', '997890123'),
(1, 'RUC', '20567890137', 'ConstruPlus', 'Av. Construccion 404, Huancayo', 'Huancayo', 'Junin', 'Peru', 'Luis Ramirez', 'luis@construplus.com', '998901234'),
(1, 'DNI', '45678901', 'Ana Gomez', 'Calle Arcoiris 505, Tacna', 'Tacna', 'Tacna', 'Peru', 'Ana Gomez', 'ana@example.com', '999012345'),
(1, 'RUC', '20567890138', 'BathMax', 'Av. San Martin 606, Puno', 'Puno', 'Puno', 'Peru', 'Jorge Morales', 'jorge@bathmax.com', '990123456'),
(1, 'DNI', '56789012', 'Carlos Fernandez', 'Calle Rio 707, Lima', 'San Isidro', 'Lima', 'Peru', 'Carlos Fernandez', 'carlos@example.com', '991234567'),
(1, 'RUC', '20567890139', 'TechMax', 'Av. Innovacion 808, Arequipa', 'Cayma', 'Arequipa', 'Peru', 'Ana Silva', 'ana@techmax.com', '992345678'),
(1, 'DNI', '67890123', 'Luis Gomez', 'Calle Mar 909, Trujillo', 'Trujillo', 'La Libertad', 'Peru', 'Luis Gomez', 'luis@example.com', '993456789'),
(1, 'RUC', '20567890140', 'HomeMax', 'Av. Hogar 101, Chiclayo', 'Chiclayo', 'Lambayeque', 'Peru', 'Maria Fernandez', 'maria@homemax.com', '994567890'),
(1, 'DNI', '78901234', 'Jorge Fernandez', 'Calle Sol 202, Piura', 'Piura', 'Piura', 'Peru', 'Jorge Fernandez', 'jorge@example.com', '995678901'),
(1, 'RUC', '20567890141', 'ElectroMax', 'Av. Electricidad 303, Cusco', 'Cusco', 'Cusco', 'Peru', 'Sofia Gomez', 'sofia@electromax.com', '996789012'),
(1, 'DNI', '89012345', 'Pedro Gomez', 'Calle Luna 404, Iquitos', 'Iquitos', 'Loreto', 'Peru', 'Pedro Gomez', 'pedro@example.com', '997890123'),
(1, 'RUC', '20567890142', 'ConstruMax', 'Av. Construccion 505, Huancayo', 'Huancayo', 'Junin', 'Peru', 'Luis Ramirez', 'luis@construmax.com', '998901234'),
(1, 'DNI', '90123456', 'Ana Fernandez', 'Calle Arcoiris 606, Tacna', 'Tacna', 'Tacna', 'Peru', 'Ana Fernandez', 'ana@example.com', '999012345'),
(1, 'RUC', '20567890143', 'BathPlus', 'Av. San Martin 707, Puno', 'Puno', 'Puno', 'Peru', 'Jorge Morales', 'jorge@bathplus.com', '990123456'),
(1, 'DNI', '01234567', 'Carlos Ramirez', 'Calle Rio 808, Lima', 'San Isidro', 'Lima', 'Peru', 'Carlos Ramirez', 'carlos@example.com', '991234567'),
(1, 'RUC', '20567890144', 'TechHome', 'Av. Innovacion 909, Arequipa', 'Cayma', 'Arequipa', 'Peru', 'Ana Silva', 'ana@techhome.com', '992345678'),
(1, 'DNI', '12345678', 'Luis Castro', 'Calle Mar 101, Trujillo', 'Trujillo', 'La Libertad', 'Peru', 'Luis Castro', 'luis@example.com', '993456789'),
(1, 'RUC', '20567890145', 'HomeTech', 'Av. Hogar 202, Chiclayo', 'Chiclayo', 'Lambayeque', 'Peru', 'Maria Fernandez', 'maria@hometech.com', '994567890'),
(1, 'DNI', '23456789', 'Jorge Gomez', 'Calle Sol 303, Piura', 'Piura', 'Piura', 'Peru', 'Jorge Gomez', 'jorge@example.com', '995678901'),
(1, 'RUC', '20567890146', 'ElectroTech', 'Av. Electricidad 404, Cusco', 'Cusco', 'Cusco', 'Peru', 'Sofia Gomez', 'sofia@electrotech.com', '996789012'),
(1, 'DNI', '34567890', 'Pedro Fernandez', 'Calle Luna 505, Iquitos', 'Iquitos', 'Loreto', 'Peru', 'Pedro Fernandez', 'pedro@example.com', '997890123'),
(1, 'RUC', '20567890147', 'ConstruTech', 'Av. Construccion 606, Huancayo', 'Huancayo', 'Junin', 'Peru', 'Luis Ramirez', 'luis@construtech.com', '998901234'),
(1, 'DNI', '45118901', 'Ana Ramirez', 'Calle Arcoiris 707, Tacna', 'Tacna', 'Tacna', 'Peru', 'Ana Ramirez', 'ana@example.com', '999012345'),
(1, 'RUC', '20567890148', 'BathTech', 'Av. San Martin 808, Puno', 'Puno', 'Puno', 'Peru', 'Jorge Morales', 'jorge@bathtech.com', '990123456'),
(1, 'DNI', '56781112', 'Carlos Castro', 'Calle Rio 909, Lima', 'San Isidro', 'Lima', 'Peru', 'Carlos Castro', 'carlos@example.com', '991234567'),
(1, 'RUC', '20567890149', 'TechWorld', 'Av. Innovacion 101, Arequipa', 'Cayma', 'Arequipa', 'Peru', 'Ana Silva', 'ana@techworld.com', '992345678'),
(1, 'DNI', '67822123', 'Luis Ramirez', 'Calle Mar 202, Trujillo', 'Trujillo', 'La Libertad', 'Peru', 'Luis Ramirez', 'luis@example.com', '993456789'),
(1, 'RUC', '20567890150', 'HomeWorld', 'Av. Hogar 303, Chiclayo', 'Chiclayo', 'Lambayeque', 'Peru', 'Maria Fernandez', 'maria@homeworld.com', '994567890'),
(1, 'DNI', '78905234', 'Jorge Castro', 'Calle Sol 404, Piura', 'Piura', 'Piura', 'Peru', 'Jorge Castro', 'jorge@example.com', '995678901'),
(1, 'RUC', '20567890151', 'ElectroWorld', 'Av. Electricidad 505, Cusco', 'Cusco', 'Cusco', 'Peru', 'Sofia Gomez', 'sofia@electroworld.com', '996789012'),
(1, 'DNI', '89075345', 'Pedro Ramirez', 'Calle Luna 606, Iquitos', 'Iquitos', 'Loreto', 'Peru', 'Pedro Ramirez', 'pedro@example.com', '997890123'),
(1, 'RUC', '20567890152', 'ConstruWorld', 'Av. Construccion 707, Huancayo', 'Huancayo', 'Junin', 'Peru', 'Luis Ramirez', 'luis@construworld.com', '998901234'),
(1, 'DNI', '90123451', 'Ana Castro', 'Calle Arcoiris 808, Tacna', 'Tacna', 'Tacna', 'Peru', 'Ana Castro', 'ana@example.com', '999012345'),
(1, 'RUC', '20567890153', 'BathWorld', 'Av. San Martin 909, Puno', 'Puno', 'Puno', 'Peru', 'Jorge Morales', 'jorge@bathworld.com', '990123456'),
(1, 'DNI', '01975167', 'Carlos Ramirez', 'Calle Rio 101, Lima', 'San Isidro', 'Lima', 'Peru', 'Carlos Ramirez', 'carlos@example.com', '991234567'),
(1, 'RUC', '20567890154', 'TechGlobal', 'Av. Innovacion 202, Arequipa', 'Cayma', 'Arequipa', 'Peru', 'Ana Silva', 'ana@techglobal.com', '992345678'),
(1, 'DNI', '12321278', 'Luis Castro', 'Calle Mar 303, Trujillo', 'Trujillo', 'La Libertad', 'Peru', 'Luis Castro', 'luis@example.com', '993456789'),
(1, 'RUC', '20567890155', 'HomeGlobal', 'Av. Hogar 404, Chiclayo', 'Chiclayo', 'Lambayeque', 'Peru', 'Maria Fernandez', 'maria@homeglobal.com', '994567890'),
(1, 'DNI', '23498089', 'Jorge Ramirez', 'Calle Sol 505, Piura', 'Piura', 'Piura', 'Peru', 'Jorge Ramirez', 'jorge@example.com', '995678901'),
(1, 'RUC', '20567890156', 'ElectroGlobal', 'Av. Electricidad 606, Cusco', 'Cusco', 'Cusco', 'Peru', 'Sofia Gomez', 'sofia@electroglobal.com', '996789012'),
(1, 'DNI', '34111290', 'Pedro Castro', 'Calle Luna 707, Iquitos', 'Iquitos', 'Loreto', 'Peru', 'Pedro Castro', 'pedro@example.com', '997890123'),
(1, 'RUC', '20567810157', 'ConstruGlobal', 'Av. Construccion 808, Huancayo', 'Huancayo', 'Junin', 'Peru', 'Luis Ramirez', 'luis@construglobal.com', '998901234'),
(1, 'DNI', '45178901', 'Ana Ramirez', 'Calle Arcoiris 909, Tacna', 'Tacna', 'Tacna', 'Peru', 'Ana Ramirez', 'ana@example.com', '999012345'),
(1, 'RUC', '20567890158', 'BathGlobal', 'Av. San Martin 101, Puno', 'Puno', 'Puno', 'Peru', 'Jorge Morales', 'jorge@bathglobal.com', '990123456'),
(1, 'DNI', '56783012', 'Carlos Castro', 'Calle Rio 202, Lima', 'San Isidro', 'Lima', 'Peru', 'Carlos Castro', 'carlos@example.com', '991234567'),
(1, 'RUC', '20567890159', 'TechUniverse', 'Av. Innovacion 303, Arequipa', 'Cayma', 'Arequipa', 'Peru', 'Ana Silva', 'ana@techuniverse.com', '992345678'),
(1, 'DNI', '67110123', 'Luis Ramirez', 'Calle Mar 404, Trujillo', 'Trujillo', 'La Libertad', 'Peru', 'Luis Ramirez', 'luis@example.com', '993456789'),
(1, 'RUC', '20567890160', 'HomeUniverse', 'Av. Hogar 505, Chiclayo', 'Chiclayo', 'Lambayeque', 'Peru', 'Maria Fernandez', 'maria@homeuniverse.com', '994567890'),
(1, 'DNI', '78932534', 'Jorge Castro', 'Calle Sol 606, Piura', 'Piura', 'Piura', 'Peru', 'Jorge Castro', 'jorge@example.com', '995678901'),
(1, 'RUC', '20567890161', 'ElectroUniverse', 'Av. Electricidad 707, Cusco', 'Cusco', 'Cusco', 'Peru', 'Sofia Gomez', 'sofia@electrouniverse.com', '996789012'),
(1, 'DNI', '89022345', 'Pedro Ramirez', 'Calle Luna 808, Iquitos', 'Iquitos', 'Loreto', 'Peru', 'Pedro Ramirez', 'pedro@example.com', '997890123'),
(1, 'RUC', '20567890162', 'ConstruUniverse', 'Av. Construccion 909, Huancayo', 'Huancayo', 'Junin', 'Peru', 'Luis Ramirez', 'luis@construuniverse.com', '998901234');

-- Insert data into Sales
INSERT INTO Sales (company_id, customer_id, total, payment_status) VALUES
(1, 1, 500.00, 'complete'),  -- Customer: Maria Gonzalez
(1, 2, 1200.00, 'pending'),  -- Customer: Tienda ABC
(1, 3, 300.00, 'complete'),  -- Customer: Juan Perez
(1, 4, 750.00, 'partial'),   -- Customer: Ferreteria XYZ
(1, 5, 450.00, 'complete'),  -- Customer: Pedro Sanchez
(1, 6, 900.00, 'pending'),   -- Customer: ElectroHome
(1, 7, 600.00, 'complete'),  -- Customer: Laura Torres
(1, 8, 1500.00, 'partial'),  -- Customer: ConstruMax
(1, 9, 350.00, 'complete'),  -- Customer: Sofia Ramirez
(1, 10, 800.00, 'pending'),  -- Customer: BathWorld
(1, 11, 400.00, 'complete'), -- Customer: Carlos Mendoza
(1, 12, 950.00, 'pending'),  -- Customer: TechStore
(1, 13, 550.00, 'complete'), -- Customer: Luis Torres
(1, 14, 700.00, 'partial'),  -- Customer: HomeCenter
(1, 15, 850.00, 'complete'), -- Customer: Jorge Ramirez
(1, 16, 300.00, 'pending'),  -- Customer: ElectroMax
(1, 17, 1200.00, 'complete'),-- Customer: Pedro Castro
(1, 18, 450.00, 'partial'),  -- Customer: ConstruHome
(1, 19, 600.00, 'complete'), -- Customer: Ana Silva
(1, 20, 900.00, 'pending'),  -- Customer: BathPlus
(1, 21, 350.00, 'complete'), -- Customer: Carlos Gomez
(1, 22, 800.00, 'pending'),  -- Customer: TechPlus
(1, 23, 500.00, 'complete'), -- Customer: Luis Fernandez
(1, 24, 1200.00, 'partial'),-- Customer: HomePlus
(1, 25, 300.00, 'complete'), -- Customer: Jorge Castro
(1, 26, 750.00, 'pending'),  -- Customer: ElectroPlus
(1, 27, 450.00, 'complete'), -- Customer: Pedro Ramirez
(1, 28, 900.00, 'partial'),  -- Customer: ConstruPlus
(1, 29, 600.00, 'complete'), -- Customer: Ana Gomez
(1, 30, 1500.00, 'pending'), -- Customer: BathMax
(1, 31, 400.00, 'complete'), -- Customer: Carlos Fernandez
(1, 32, 950.00, 'pending'),  -- Customer: TechMax
(1, 33, 550.00, 'complete'), -- Customer: Luis Gomez
(1, 34, 700.00, 'partial'),  -- Customer: HomeMax
(1, 35, 850.00, 'complete'), -- Customer: Jorge Fernandez
(1, 36, 300.00, 'pending'),  -- Customer: ElectroMax
(1, 37, 1200.00, 'complete'),-- Customer: Pedro Gomez
(1, 38, 450.00, 'partial'),  -- Customer: ConstruMax
(1, 39, 600.00, 'complete'), -- Customer: Ana Fernandez
(1, 40, 900.00, 'pending'),  -- Customer: BathPlus
(1, 41, 350.00, 'complete'), -- Customer: Carlos Ramirez
(1, 42, 800.00, 'pending'),  -- Customer: TechHome
(1, 43, 500.00, 'complete'), -- Customer: Luis Castro
(1, 44, 1200.00, 'partial'),-- Customer: HomeTech
(1, 45, 300.00, 'complete'), -- Customer: Jorge Gomez
(1, 46, 750.00, 'pending'),  -- Customer: ElectroTech
(1, 47, 450.00, 'complete'), -- Customer: Pedro Fernandez
(1, 48, 900.00, 'partial'),  -- Customer: ConstruTech
(1, 49, 600.00, 'complete'), -- Customer: Ana Ramirez
(1, 50, 1500.00, 'pending'), -- Customer: BathTech
(1, 51, 400.00, 'complete'), -- Customer: Carlos Castro
(1, 52, 950.00, 'pending'),  -- Customer: TechWorld
(1, 53, 550.00, 'complete'), -- Customer: Luis Ramirez
(1, 54, 700.00, 'partial'),  -- Customer: HomeWorld
(1, 55, 850.00, 'complete'), -- Customer: Jorge Castro
(1, 56, 300.00, 'pending'),  -- Customer: ElectroWorld
(1, 57, 1200.00, 'complete'),-- Customer: Pedro Ramirez
(1, 58, 450.00, 'partial'),  -- Customer: ConstruWorld
(1, 59, 600.00, 'complete'), -- Customer: Ana Castro
(1, 60, 900.00, 'pending'),  -- Customer: BathWorld
(1, 61, 350.00, 'complete'), -- Customer: Carlos Ramirez
(1, 62, 800.00, 'pending'),  -- Customer: TechGlobal
(1, 63, 500.00, 'complete'), -- Customer: Luis Castro
(1, 64, 1200.00, 'partial'),-- Customer: HomeGlobal
(1, 65, 300.00, 'complete'), -- Customer: Jorge Ramirez
(1, 66, 750.00, 'pending'),  -- Customer: ElectroGlobal
(1, 67, 450.00, 'complete'), -- Customer: Pedro Castro
(1, 68, 900.00, 'partial'),  -- Customer: ConstruGlobal
(1, 69, 600.00, 'complete'), -- Customer: Ana Ramirez
(1, 70, 1500.00, 'pending'), -- Customer: BathGlobal
(1, 71, 400.00, 'complete'), -- Customer: Carlos Castro
(1, 72, 950.00, 'pending'),  -- Customer: TechUniverse
(1, 73, 550.00, 'complete'), -- Customer: Luis Ramirez
(1, 74, 700.00, 'partial'),  -- Customer: HomeUniverse
(1, 75, 850.00, 'complete'), -- Customer: Jorge Castro
(1, 76, 300.00, 'pending'),  -- Customer: ElectroUniverse
(1, 77, 1200.00, 'complete'),-- Customer: Pedro Ramirez
(1, 78, 450.00, 'partial'),  -- Customer: ConstruUniverse
(1, 1, 600.00, 'complete'),  -- Customer: Maria Gonzalez
(1, 2, 900.00, 'pending'),   -- Customer: Tienda ABC
(1, 3, 350.00, 'complete'),  -- Customer: Juan Perez
(1, 4, 800.00, 'pending'),   -- Customer: Ferreteria XYZ
(1, 5, 500.00, 'complete'),  -- Customer: Pedro Sanchez
(1, 6, 1200.00, 'partial'),  -- Customer: ElectroHome
(1, 7, 300.00, 'complete'),  -- Customer: Laura Torres
(1, 8, 750.00, 'pending'),   -- Customer: ConstruMax
(1, 9, 450.00, 'complete'),  -- Customer: Sofia Ramirez
(1, 10, 900.00, 'partial'),  -- Customer: BathWorld
(1, 11, 600.00, 'complete'), -- Customer: Carlos Mendoza
(1, 12, 1500.00, 'pending'), -- Customer: TechStore
(1, 13, 400.00, 'complete'), -- Customer: Luis Torres
(1, 14, 950.00, 'pending'),  -- Customer: HomeCenter
(1, 15, 550.00, 'complete'), -- Customer: Jorge Ramirez
(1, 16, 700.00, 'partial'),  -- Customer: ElectroMax
(1, 17, 850.00, 'complete'), -- Customer: Pedro Castro
(1, 18, 300.00, 'pending'),  -- Customer: ConstruHome
(1, 19, 1200.00, 'complete'),-- Customer: Ana Silva
(1, 20, 450.00, 'partial'),  -- Customer: BathPlus
(1, 21, 600.00, 'complete'), -- Customer: Carlos Gomez
(1, 22, 900.00, 'pending'),  -- Customer: TechPlus
(1, 23, 350.00, 'complete'), -- Customer: Luis Fernandez
(1, 24, 800.00, 'pending'),  -- Customer: HomePlus
(1, 25, 500.00, 'complete'), -- Customer: Jorge Castro
(1, 26, 1200.00, 'partial'),-- Customer: ElectroPlus
(1, 27, 300.00, 'complete'), -- Customer: Pedro Ramirez
(1, 28, 750.00, 'pending'),  -- Customer: ConstruPlus
(1, 29, 450.00, 'complete'), -- Customer: Ana Gomez
(1, 30, 900.00, 'partial'),  -- Customer: BathMax
(1, 31, 600.00, 'complete'), -- Customer: Carlos Fernandez
(1, 32, 1500.00, 'pending'), -- Customer: TechMax}
(1, 33, 400.00, 'complete'), -- Customer: Luis Gomez
(1, 34, 950.00, 'pending'),  -- Customer: HomeMax
(1, 35, 550.00, 'complete'), -- Customer: Jorge Fernandez
(1, 36, 700.00, 'partial'),  -- Customer: ElectroMax
(1, 37, 850.00, 'complete'), -- Customer: Pedro Gomez
(1, 38, 300.00, 'pending'),  -- Customer: ConstruMax
(1, 39, 1200.00, 'complete'),-- Customer: Ana Fernandez
(1, 40, 450.00, 'partial'),  -- Customer: BathPlus
(1, 41, 600.00, 'complete'), -- Customer: Carlos Ramirez
(1, 42, 900.00, 'pending'), -- Customer: TechHome
(1, 43, 350.00, 'complete'), -- Customer: Luis Castro
(1, 44, 800.00, 'pending'),  -- Customer: HomeTech
(1, 45, 500.00, 'complete'), -- Customer: Jorge Gomez
(1, 46, 1200.00, 'partial'),-- Customer: ElectroTech
(1, 47, 300.00, 'complete'), -- Customer: Pedro Fernandez
(1, 48, 750.00, 'pending'),  -- Customer: ConstruTech
(1, 49, 450.00, 'complete'), -- Customer: Ana Ramirez
(1, 50, 900.00, 'partial'),  -- Customer: BathTech
(1, 51, 600.00, 'complete'), -- Customer: Carlos Castro
(1, 52, 1500.00, 'pending'), -- Customer: TechWorld
(1, 53, 400.00, 'complete'), -- Customer: Luis Ramirez
(1, 54, 950.00, 'pending'),  -- Customer: HomeWorld
(1, 55, 550.00, 'complete'), -- Customer: Jorge Castro
(1, 56, 700.00, 'partial'),  -- Customer: ElectroWorld
(1, 57, 850.00, 'complete'), -- Customer: Pedro Ramirez
(1, 58, 300.00, 'pending'),  -- Customer: ConstruWorld
(1, 59, 1200.00, 'complete'),-- Customer: Ana Castro
(1, 60, 450.00, 'partial');  -- Customer: BathWorld


INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(1, 1, 2, 150.00, 300.00),  -- Solar Panel 100W
(1, 3, 1, 300.00, 300.00);   -- Smart Lock Pro

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(2, 4, 1, 1200.00, 1200.00), -- Solar Inverter 5000W
(2, 5, 2, 150.00, 300.00),   -- Security Camera 4K
(2, 7, 1, 80.00, 80.00);     -- Drill Machine 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(3, 2, 1, 250.00, 250.00),   -- Cerradura Digital
(3, 6, 1, 250.00, 250.00);   -- Shower Set Chrome

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(4, 8, 1, 120.00, 120.00),   -- Hammer Drill 1000W
(4, 9, 2, 50.00, 100.00),    -- Faucet Modern
(4, 10, 1, 70.00, 70.00);    -- Solar Battery 100Ah

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(5, 11, 1, 300.00, 300.00),  -- Solar Panel 300W
(5, 12, 1, 350.00, 350.00);  -- Biometric Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(6, 13, 1, 400.00, 400.00),  -- Wireless Alarm System
(6, 14, 1, 200.00, 200.00),  -- Circular Saw 1500W
(6, 15, 1, 150.00, 150.00);  -- Angle Grinder 1200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(7, 16, 1, 130.00, 130.00),  -- Bathtub Faucet
(7, 17, 1, 90.00, 90.00);    -- Shower Head Rain

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(8, 18, 1, 60.00, 60.00),    -- Solar Charge Controller
(8, 19, 1, 100.00, 100.00),  -- Solar Panel 400W
(8, 20, 1, 450.00, 450.00);  -- Keyless Entry Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(9, 21, 1, 350.00, 350.00),  -- Surveillance Camera
(9, 22, 1, 180.00, 180.00);  -- Jigsaw 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(10, 23, 1, 90.00, 90.00),   -- Impact Wrench
(10, 24, 1, 140.00, 140.00), -- Towel Rack Chrome
(10, 25, 1, 40.00, 40.00);   -- Solar Panel 200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(11, 1, 1, 150.00, 150.00),  -- Solar Panel 100W
(11, 3, 1, 300.00, 300.00);  -- Smart Lock Pro

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(12, 4, 1, 1200.00, 1200.00), -- Solar Inverter 5000W
(12, 5, 1, 150.00, 150.00),   -- Security Camera 4K
(12, 7, 1, 80.00, 80.00);     -- Drill Machine 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(13, 2, 1, 250.00, 250.00),   -- Cerradura Digital
(13, 6, 1, 250.00, 250.00);   -- Shower Set Chrome

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(14, 8, 1, 120.00, 120.00),   -- Hammer Drill 1000W
(14, 9, 1, 50.00, 50.00),     -- Faucet Modern
(14, 10, 1, 70.00, 70.00);    -- Solar Battery 100Ah

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(15, 11, 1, 300.00, 300.00),  -- Solar Panel 300W
(15, 12, 1, 350.00, 350.00);  -- Biometric Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(16, 13, 1, 400.00, 400.00),  -- Wireless Alarm System
(16, 14, 1, 200.00, 200.00),  -- Circular Saw 1500W
(16, 15, 1, 150.00, 150.00);  -- Angle Grinder 1200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(17, 16, 1, 130.00, 130.00),  -- Bathtub Faucet
(17, 17, 1, 90.00, 90.00);    -- Shower Head Rain

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(18, 18, 1, 60.00, 60.00),    -- Solar Charge Controller
(18, 19, 1, 100.00, 100.00),  -- Solar Panel 400W
(18, 20, 1, 450.00, 450.00);  -- Keyless Entry Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(19, 21, 1, 350.00, 350.00),  -- Surveillance Camera
(19, 22, 1, 180.00, 180.00);  -- Jigsaw 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(20, 23, 1, 90.00, 90.00),   -- Impact Wrench
(20, 24, 1, 140.00, 140.00), -- Towel Rack Chrome
(20, 25, 1, 40.00, 40.00);   -- Solar Panel 200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(21, 1, 2, 150.00, 300.00),  -- Solar Panel 100W
(21, 3, 1, 300.00, 300.00);  -- Smart Lock Pro

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(22, 4, 1, 1200.00, 1200.00), -- Solar Inverter 5000W
(22, 5, 2, 150.00, 300.00),   -- Security Camera 4K
(22, 7, 1, 80.00, 80.00);     -- Drill Machine 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(23, 2, 1, 250.00, 250.00),   -- Cerradura Digital
(23, 6, 1, 250.00, 250.00);   -- Shower Set Chrome

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(24, 8, 1, 120.00, 120.00),   -- Hammer Drill 1000W
(24, 9, 2, 50.00, 100.00),    -- Faucet Modern
(24, 10, 1, 70.00, 70.00);    -- Solar Battery 100Ah

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(25, 11, 1, 300.00, 300.00),  -- Solar Panel 300W
(25, 12, 1, 350.00, 350.00);  -- Biometric Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(26, 13, 1, 400.00, 400.00),  -- Wireless Alarm System
(26, 14, 1, 200.00, 200.00),  -- Circular Saw 1500W
(26, 15, 1, 150.00, 150.00);  -- Angle Grinder 1200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(27, 16, 1, 130.00, 130.00),  -- Bathtub Faucet
(27, 17, 1, 90.00, 90.00);    -- Shower Head Rain

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(28, 18, 1, 60.00, 60.00),    -- Solar Charge Controller
(28, 19, 1, 100.00, 100.00),  -- Solar Panel 400W
(28, 20, 1, 450.00, 450.00);  -- Keyless Entry Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(29, 21, 1, 350.00, 350.00),  -- Surveillance Camera
(29, 22, 1, 180.00, 180.00);  -- Jigsaw 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(30, 23, 1, 90.00, 90.00),   -- Impact Wrench
(30, 24, 1, 140.00, 140.00), -- Towel Rack Chrome
(30, 25, 1, 40.00, 40.00);   -- Solar Panel 200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(31, 1, 1, 150.00, 150.00),  -- Solar Panel 100W
(31, 3, 1, 300.00, 300.00);  -- Smart Lock Pro

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(32, 4, 1, 1200.00, 1200.00), -- Solar Inverter 5000W
(32, 5, 1, 150.00, 150.00),   -- Security Camera 4K
(32, 7, 1, 80.00, 80.00);     -- Drill Machine 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(33, 2, 1, 250.00, 250.00),   -- Cerradura Digital
(33, 6, 1, 250.00, 250.00);   -- Shower Set Chrome

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(34, 8, 1, 120.00, 120.00),   -- Hammer Drill 1000W
(34, 9, 1, 50.00, 50.00),     -- Faucet Modern
(34, 10, 1, 70.00, 70.00);    -- Solar Battery 100Ah

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(35, 11, 1, 300.00, 300.00),  -- Solar Panel 300W
(35, 12, 1, 350.00, 350.00);  -- Biometric Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(36, 13, 1, 400.00, 400.00),  -- Wireless Alarm System
(36, 14, 1, 200.00, 200.00),  -- Circular Saw 1500W
(36, 15, 1, 150.00, 150.00);  -- Angle Grinder 1200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(37, 16, 1, 130.00, 130.00),  -- Bathtub Faucet
(37, 17, 1, 90.00, 90.00);    -- Shower Head Rain

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(38, 18, 1, 60.00, 60.00),    -- Solar Charge Controller
(38, 19, 1, 100.00, 100.00),  -- Solar Panel 400W
(38, 20, 1, 450.00, 450.00);  -- Keyless Entry Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(39, 21, 1, 350.00, 350.00),  -- Surveillance Camera
(39, 22, 1, 180.00, 180.00);  -- Jigsaw 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(40, 23, 1, 90.00, 90.00),   -- Impact Wrench
(40, 24, 1, 140.00, 140.00), -- Towel Rack Chrome
(40, 25, 1, 40.00, 40.00);   -- Solar Panel 200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(41, 1, 2, 150.00, 300.00),  -- Solar Panel 100W
(41, 3, 1, 300.00, 300.00);  -- Smart Lock Pro

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(42, 4, 1, 1200.00, 1200.00), -- Solar Inverter 5000W
(42, 5, 2, 150.00, 300.00),   -- Security Camera 4K
(42, 7, 1, 80.00, 80.00);     -- Drill Machine 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(43, 2, 1, 250.00, 250.00),   -- Cerradura Digital
(43, 6, 1, 250.00, 250.00);   -- Shower Set Chrome

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(44, 8, 1, 120.00, 120.00),   -- Hammer Drill 1000W
(44, 9, 2, 50.00, 100.00),    -- Faucet Modern
(44, 10, 1, 70.00, 70.00);    -- Solar Battery 100Ah

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(45, 11, 1, 300.00, 300.00),  -- Solar Panel 300W
(45, 12, 1, 350.00, 350.00);  -- Biometric Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(46, 13, 1, 400.00, 400.00),  -- Wireless Alarm System
(46, 14, 1, 200.00, 200.00),  -- Circular Saw 1500W
(46, 15, 1, 150.00, 150.00);  -- Angle Grinder 1200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(47, 16, 1, 130.00, 130.00),  -- Bathtub Faucet
(47, 17, 1, 90.00, 90.00);    -- Shower Head Rain

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(48, 18, 1, 60.00, 60.00),    -- Solar Charge Controller
(48, 19, 1, 100.00, 100.00),  -- Solar Panel 400W
(48, 20, 1, 450.00, 450.00);  -- Keyless Entry Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(49, 21, 1, 350.00, 350.00),  -- Surveillance Camera
(49, 22, 1, 180.00, 180.00);  -- Jigsaw 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(50, 23, 1, 90.00, 90.00),   -- Impact Wrench
(50, 24, 1, 140.00, 140.00), -- Towel Rack Chrome
(50, 25, 1, 40.00, 40.00);   -- Solar Panel 200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(51, 1, 1, 150.00, 150.00),  -- Solar Panel 100W
(51, 3, 1, 300.00, 300.00);  -- Smart Lock Pro

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(52, 4, 1, 1200.00, 1200.00), -- Solar Inverter 5000W
(52, 5, 1, 150.00, 150.00),   -- Security Camera 4K
(52, 7, 1, 80.00, 80.00);     -- Drill Machine 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(53, 2, 1, 250.00, 250.00),   -- Cerradura Digital
(53, 6, 1, 250.00, 250.00);   -- Shower Set Chrome

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(54, 8, 1, 120.00, 120.00),   -- Hammer Drill 1000W
(54, 9, 1, 50.00, 50.00),     -- Faucet Modern
(54, 10, 1, 70.00, 70.00);    -- Solar Battery 100Ah

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(55, 11, 1, 300.00, 300.00),  -- Solar Panel 300W
(55, 12, 1, 350.00, 350.00);  -- Biometric Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(56, 13, 1, 400.00, 400.00),  -- Wireless Alarm System
(56, 14, 1, 200.00, 200.00),  -- Circular Saw 1500W
(56, 15, 1, 150.00, 150.00);  -- Angle Grinder 1200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(57, 16, 1, 130.00, 130.00),  -- Bathtub Faucet
(57, 17, 1, 90.00, 90.00);    -- Shower Head Rain

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(58, 18, 1, 60.00, 60.00),    -- Solar Charge Controller
(58, 19, 1, 100.00, 100.00),  -- Solar Panel 400W
(58, 20, 1, 450.00, 450.00);  -- Keyless Entry Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(59, 21, 1, 350.00, 350.00),  -- Surveillance Camera
(59, 22, 1, 180.00, 180.00);  -- Jigsaw 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(60, 23, 1, 90.00, 90.00),   -- Impact Wrench
(60, 24, 1, 140.00, 140.00), -- Towel Rack Chrome
(60, 25, 1, 40.00, 40.00);   -- Solar Panel 200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(61, 1, 2, 150.00, 300.00),  -- Solar Panel 100W
(61, 3, 1, 300.00, 300.00);  -- Smart Lock Pro

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(62, 4, 1, 1200.00, 1200.00), -- Solar Inverter 5000W
(62, 5, 2, 150.00, 300.00),   -- Security Camera 4K
(62, 7, 1, 80.00, 80.00);     -- Drill Machine 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(63, 2, 1, 250.00, 250.00),   -- Cerradura Digital
(63, 6, 1, 250.00, 250.00);   -- Shower Set Chrome

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(64, 8, 1, 120.00, 120.00),   -- Hammer Drill 1000W
(64, 9, 2, 50.00, 100.00),    -- Faucet Modern
(64, 10, 1, 70.00, 70.00);    -- Solar Battery 100Ah

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(65, 11, 1, 300.00, 300.00),  -- Solar Panel 300W
(65, 12, 1, 350.00, 350.00);  -- Biometric Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(66, 13, 1, 400.00, 400.00),  -- Wireless Alarm System
(66, 14, 1, 200.00, 200.00),  -- Circular Saw 1500W
(66, 15, 1, 150.00, 150.00);  -- Angle Grinder 1200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(67, 16, 1, 130.00, 130.00),  -- Bathtub Faucet
(67, 17, 1, 90.00, 90.00);    -- Shower Head Rain

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(68, 18, 1, 60.00, 60.00),    -- Solar Charge Controller
(68, 19, 1, 100.00, 100.00),  -- Solar Panel 400W
(68, 20, 1, 450.00, 450.00);  -- Keyless Entry Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(69, 21, 1, 350.00, 350.00),  -- Surveillance Camera
(69, 22, 1, 180.00, 180.00);  -- Jigsaw 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(70, 23, 1, 90.00, 90.00),   -- Impact Wrench
(70, 24, 1, 140.00, 140.00), -- Towel Rack Chrome
(70, 25, 1, 40.00, 40.00);   -- Solar Panel 200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(71, 1, 1, 150.00, 150.00),  -- Solar Panel 100W
(71, 3, 1, 300.00, 300.00);  -- Smart Lock Pro

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(72, 4, 1, 1200.00, 1200.00), -- Solar Inverter 5000W
(72, 5, 1, 150.00, 150.00),   -- Security Camera 4K
(72, 7, 1, 80.00, 80.00);     -- Drill Machine 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(73, 2, 1, 250.00, 250.00),   -- Cerradura Digital
(73, 6, 1, 250.00, 250.00);   -- Shower Set Chrome

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(74, 8, 1, 120.00, 120.00),   -- Hammer Drill 1000W
(74, 9, 1, 50.00, 50.00),     -- Faucet Modern
(74, 10, 1, 70.00, 70.00);    -- Solar Battery 100Ah

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(75, 11, 1, 300.00, 300.00),  -- Solar Panel 300W
(75, 12, 1, 350.00, 350.00);  -- Biometric Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(76, 13, 1, 400.00, 400.00),  -- Wireless Alarm System
(76, 14, 1, 200.00, 200.00),  -- Circular Saw 1500W
(76, 15, 1, 150.00, 150.00);  -- Angle Grinder 1200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(77, 16, 1, 130.00, 130.00),  -- Bathtub Faucet
(77, 17, 1, 90.00, 90.00);    -- Shower Head Rain

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(78, 18, 1, 60.00, 60.00),    -- Solar Charge Controller
(78, 19, 1, 100.00, 100.00),  -- Solar Panel 400W
(78, 20, 1, 450.00, 450.00);  -- Keyless Entry Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(79, 21, 1, 350.00, 350.00),  -- Surveillance Camera
(79, 22, 1, 180.00, 180.00);  -- Jigsaw 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(80, 23, 1, 90.00, 90.00),   -- Impact Wrench
(80, 24, 1, 140.00, 140.00), -- Towel Rack Chrome
(80, 25, 1, 40.00, 40.00);   -- Solar Panel 200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(81, 1, 2, 150.00, 300.00),  -- Solar Panel 100W
(81, 3, 1, 300.00, 300.00);  -- Smart Lock Pro

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(82, 4, 1, 1200.00, 1200.00), -- Solar Inverter 5000W
(82, 5, 2, 150.00, 300.00),   -- Security Camera 4K
(82, 7, 1, 80.00, 80.00);     -- Drill Machine 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(83, 2, 1, 250.00, 250.00),   -- Cerradura Digital
(83, 6, 1, 250.00, 250.00);   -- Shower Set Chrome

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(84, 8, 1, 120.00, 120.00),   -- Hammer Drill 1000W
(84, 9, 2, 50.00, 100.00),    -- Faucet Modern
(84, 10, 1, 70.00, 70.00);    -- Solar Battery 100Ah

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(85, 11, 1, 300.00, 300.00),  -- Solar Panel 300W
(85, 12, 1, 350.00, 350.00);  -- Biometric Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(86, 13, 1, 400.00, 400.00),  -- Wireless Alarm System
(86, 14, 1, 200.00, 200.00),  -- Circular Saw 1500W
(86, 15, 1, 150.00, 150.00);  -- Angle Grinder 1200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(87, 16, 1, 130.00, 130.00),  -- Bathtub Faucet
(87, 17, 1, 90.00, 90.00);    -- Shower Head Rain

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(88, 18, 1, 60.00, 60.00),    -- Solar Charge Controller
(88, 19, 1, 100.00, 100.00),  -- Solar Panel 400W
(88, 20, 1, 450.00, 450.00);  -- Keyless Entry Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(89, 21, 1, 350.00, 350.00),  -- Surveillance Camera
(89, 22, 1, 180.00, 180.00);  -- Jigsaw 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(90, 23, 1, 90.00, 90.00),   -- Impact Wrench
(90, 24, 1, 140.00, 140.00), -- Towel Rack Chrome
(90, 25, 1, 40.00, 40.00);   -- Solar Panel 200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(91, 1, 1, 150.00, 150.00),  -- Solar Panel 100W
(91, 3, 1, 300.00, 300.00);  -- Smart Lock Pro

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(92, 4, 1, 1200.00, 1200.00), -- Solar Inverter 5000W
(92, 5, 1, 150.00, 150.00),   -- Security Camera 4K
(92, 7, 1, 80.00, 80.00);     -- Drill Machine 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(93, 2, 1, 250.00, 250.00),   -- Cerradura Digital
(93, 6, 1, 250.00, 250.00);   -- Shower Set Chrome

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(94, 8, 1, 120.00, 120.00),   -- Hammer Drill 1000W
(94, 9, 1, 50.00, 50.00),     -- Faucet Modern
(94, 10, 1, 70.00, 70.00);    -- Solar Battery 100Ah

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(95, 11, 1, 300.00, 300.00),  -- Solar Panel 300W
(95, 12, 1, 350.00, 350.00);  -- Biometric Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(96, 13, 1, 400.00, 400.00),  -- Wireless Alarm System
(96, 14, 1, 200.00, 200.00),  -- Circular Saw 1500W
(96, 15, 1, 150.00, 150.00);  -- Angle Grinder 1200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(97, 16, 1, 130.00, 130.00),  -- Bathtub Faucet
(97, 17, 1, 90.00, 90.00);    -- Shower Head Rain

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(98, 18, 1, 60.00, 60.00),    -- Solar Charge Controller
(98, 19, 1, 100.00, 100.00),  -- Solar Panel 400W
(98, 20, 1, 450.00, 450.00);  -- Keyless Entry Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(99, 21, 1, 350.00, 350.00),  -- Surveillance Camera
(99, 22, 1, 180.00, 180.00);  -- Jigsaw 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(100, 23, 1, 90.00, 90.00),   -- Impact Wrench
(100, 24, 1, 140.00, 140.00), -- Towel Rack Chrome
(100, 25, 1, 40.00, 40.00);   -- Solar Panel 200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(101, 1, 2, 150.00, 300.00),  -- Solar Panel 100W
(101, 3, 1, 300.00, 300.00);  -- Smart Lock Pro

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(102, 4, 1, 1200.00, 1200.00), -- Solar Inverter 5000W
(102, 5, 2, 150.00, 300.00),   -- Security Camera 4K
(102, 7, 1, 80.00, 80.00);     -- Drill Machine 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(103, 2, 1, 250.00, 250.00),   -- Cerradura Digital
(103, 6, 1, 250.00, 250.00);   -- Shower Set Chrome

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(104, 8, 1, 120.00, 120.00),   -- Hammer Drill 1000W
(104, 9, 2, 50.00, 100.00),    -- Faucet Modern
(104, 10, 1, 70.00, 70.00);    -- Solar Battery 100Ah

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(105, 11, 1, 300.00, 300.00),  -- Solar Panel 300W
(105, 12, 1, 350.00, 350.00);  -- Biometric Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(106, 13, 1, 400.00, 400.00),  -- Wireless Alarm System
(106, 14, 1, 200.00, 200.00),  -- Circular Saw 1500W
(106, 15, 1, 150.00, 150.00);  -- Angle Grinder 1200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(107, 16, 1, 130.00, 130.00),  -- Bathtub Faucet
(107, 17, 1, 90.00, 90.00);    -- Shower Head Rain

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(108, 18, 1, 60.00, 60.00),    -- Solar Charge Controller
(108, 19, 1, 100.00, 100.00),  -- Solar Panel 400W
(108, 20, 1, 450.00, 450.00);  -- Keyless Entry Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(109, 21, 1, 350.00, 350.00),  -- Surveillance Camera
(109, 22, 1, 180.00, 180.00);  -- Jigsaw 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(110, 23, 1, 90.00, 90.00),   -- Impact Wrench
(110, 24, 1, 140.00, 140.00), -- Towel Rack Chrome
(110, 25, 1, 40.00, 40.00);   -- Solar Panel 200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(111, 1, 1, 150.00, 150.00),  -- Solar Panel 100W
(111, 3, 1, 300.00, 300.00);  -- Smart Lock Pro

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(112, 4, 1, 1200.00, 1200.00), -- Solar Inverter 5000W
(112, 5, 1, 150.00, 150.00),   -- Security Camera 4K
(112, 7, 1, 80.00, 80.00);     -- Drill Machine 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(113, 2, 1, 250.00, 250.00),   -- Cerradura Digital
(113, 6, 1, 250.00, 250.00);   -- Shower Set Chrome

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(114, 8, 1, 120.00, 120.00),   -- Hammer Drill 1000W
(114, 9, 1, 50.00, 50.00),     -- Faucet Modern
(114, 10, 1, 70.00, 70.00);    -- Solar Battery 100Ah

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(115, 11, 1, 300.00, 300.00),  -- Solar Panel 300W
(115, 12, 1, 350.00, 350.00);  -- Biometric Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(116, 13, 1, 400.00, 400.00),  -- Wireless Alarm System
(116, 14, 1, 200.00, 200.00),  -- Circular Saw 1500W
(116, 15, 1, 150.00, 150.00);  -- Angle Grinder 1200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(117, 16, 1, 130.00, 130.00),  -- Bathtub Faucet
(117, 17, 1, 90.00, 90.00);    -- Shower Head Rain

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(118, 18, 1, 60.00, 60.00),    -- Solar Charge Controller
(118, 19, 1, 100.00, 100.00),  -- Solar Panel 400W
(118, 20, 1, 450.00, 450.00);  -- Keyless Entry Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(119, 21, 1, 350.00, 350.00),  -- Surveillance Camera
(119, 22, 1, 180.00, 180.00);  -- Jigsaw 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(120, 23, 1, 90.00, 90.00),   -- Impact Wrench
(120, 24, 1, 140.00, 140.00), -- Towel Rack Chrome
(120, 25, 1, 40.00, 40.00);   -- Solar Panel 200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(121, 1, 2, 150.00, 300.00),  -- Solar Panel 100W
(121, 3, 1, 300.00, 300.00);  -- Smart Lock Pro

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(122, 4, 1, 1200.00, 1200.00), -- Solar Inverter 5000W
(122, 5, 2, 150.00, 300.00),   -- Security Camera 4K
(122, 7, 1, 80.00, 80.00);     -- Drill Machine 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(123, 2, 1, 250.00, 250.00),   -- Cerradura Digital
(123, 6, 1, 250.00, 250.00);   -- Shower Set Chrome

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(124, 8, 1, 120.00, 120.00),   -- Hammer Drill 1000W
(124, 9, 2, 50.00, 100.00),    -- Faucet Modern
(124, 10, 1, 70.00, 70.00);    -- Solar Battery 100Ah

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(125, 11, 1, 300.00, 300.00),  -- Solar Panel 300W
(125, 12, 1, 350.00, 350.00);  -- Biometric Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(126, 13, 1, 400.00, 400.00),  -- Wireless Alarm System
(126, 14, 1, 200.00, 200.00),  -- Circular Saw 1500W
(126, 15, 1, 150.00, 150.00);  -- Angle Grinder 1200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(127, 16, 1, 130.00, 130.00),  -- Bathtub Faucet
(127, 17, 1, 90.00, 90.00);    -- Shower Head Rain

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(128, 18, 1, 60.00, 60.00),    -- Solar Charge Controller
(128, 19, 1, 100.00, 100.00),  -- Solar Panel 400W
(128, 20, 1, 450.00, 450.00);  -- Keyless Entry Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(129, 21, 1, 350.00, 350.00),  -- Surveillance Camera
(129, 22, 1, 180.00, 180.00);  -- Jigsaw 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(130, 23, 1, 90.00, 90.00),   -- Impact Wrench
(130, 24, 1, 140.00, 140.00), -- Towel Rack Chrome
(130, 25, 1, 40.00, 40.00);   -- Solar Panel 200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(131, 1, 1, 150.00, 150.00),  -- Solar Panel 100W
(131, 3, 1, 300.00, 300.00);  -- Smart Lock Pro

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(132, 4, 1, 1200.00, 1200.00), -- Solar Inverter 5000W
(132, 5, 1, 150.00, 150.00),   -- Security Camera 4K
(132, 7, 1, 80.00, 80.00);     -- Drill Machine 800W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(133, 2, 1, 250.00, 250.00),   -- Cerradura Digital
(133, 6, 1, 250.00, 250.00);   -- Shower Set Chrome

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(134, 8, 1, 120.00, 120.00),   -- Hammer Drill 1000W
(134, 9, 1, 50.00, 50.00),     -- Faucet Modern
(134, 10, 1, 70.00, 70.00);    -- Solar Battery 100Ah

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(135, 11, 1, 300.00, 300.00),  -- Solar Panel 300W
(135, 12, 1, 350.00, 350.00);  -- Biometric Lock

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(136, 13, 1, 400.00, 400.00),  -- Wireless Alarm System
(136, 14, 1, 200.00, 200.00),  -- Circular Saw 1500W
(136, 15, 1, 150.00, 150.00);  -- Angle Grinder 1200W

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(137, 16, 1, 130.00, 130.00),  -- Bathtub Faucet
(137, 17, 1, 90.00, 90.00);    -- Shower Head Rain

INSERT INTO Sales_Details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(138, 18, 1, 60.00, 60.00),    -- Solar Charge Controller
(138, 19, 1, 100.00, 100.00),  -- Solar Panel 400W
(138, 20, 1, 450.00, 450.00);  -- Keyless Entry Lock



INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(1, 500.00, 'credit card', '2023-10-01 10:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(2, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(3, 300.00, 'transfer', '2023-10-02 11:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(4, 500.00, 'transfer', '2023-10-03 12:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(5, 450.00, 'debit card', '2023-10-04 13:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(6, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(7, 600.00, 'credit card', '2023-10-05 14:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(8, 1000.00, 'transfer', '2023-10-06 15:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(9, 350.00, 'credit card', '2023-10-07 16:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(10, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(11, 400.00, 'debit card', '2023-10-08 17:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(12, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(13, 550.00, 'transfer', '2023-10-09 18:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(14, 500.00, 'debit card', '2023-10-10 19:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(15, 850.00, 'credit card', '2023-10-11 20:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(16, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(17, 1200.00, 'debit card', '2023-10-12 21:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(18, 450.00, 'credit card', '2023-10-13 22:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(19, 600.00, 'transfer', '2023-10-14 23:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(20, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(21, 350.00, 'credit card', '2023-10-15 10:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(22, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(23, 500.00, 'debit card', '2023-10-16 11:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(24, 1200.00, 'credit card', '2023-10-17 12:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(25, 300.00, 'debit card', '2023-10-18 13:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(26, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(27, 450.00, 'transfer', '2023-10-19 14:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(28, 900.00, 'debit card', '2023-10-20 15:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(29, 600.00, 'credit card', '2023-10-21 16:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(30, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(31, 400.00, 'debit card', '2023-10-22 17:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(32, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(33, 550.00, 'credit card', '2023-10-23 18:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(34, 700.00, 'transfer', '2023-10-24 19:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(35, 850.00, 'credit card', '2023-10-25 20:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(36, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(37, 1200.00, 'debit card', '2023-10-26 21:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(38, 450.00, 'credit card', '2023-10-27 22:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(39, 600.00, 'debit card', '2023-10-28 23:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(40, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(41, 350.00, 'credit card', '2023-10-29 10:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(42, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(43, 500.00, 'transfer', '2023-10-30 11:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(44, 1200.00, 'credit card', '2023-10-31 12:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(45, 300.00, 'debit card', '2023-11-01 13:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(46, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(47, 450.00, 'credit card', '2023-11-02 14:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(48, 900.00, 'debit card', '2023-11-03 15:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(49, 600.00, 'credit card', '2023-11-04 16:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(50, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(51, 400.00, 'debit card', '2023-11-05 17:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(52, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(53, 550.00, 'credit card', '2023-11-06 18:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(54, 700.00, 'debit card', '2023-11-07 19:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(55, 850.00, 'credit card', '2023-11-08 20:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(56, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(57, 1200.00, 'trasnfer', '2023-11-09 21:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(58, 450.00, 'credit card', '2023-11-10 22:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(59, 600.00, 'debit card', '2023-11-11 23:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(60, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(61, 350.00, 'credit card', '2023-11-12 10:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(62, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(63, 500.00, 'debit card', '2023-11-13 11:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(64, 1200.00, 'credit card', '2023-11-14 12:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(65, 300.00, 'debit card', '2023-11-15 13:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(66, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(67, 450.00, 'credit card', '2023-11-16 14:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(68, 900.00, 'debit card', '2023-11-17 15:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(69, 600.00, 'credit card', '2023-11-18 16:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(70, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(71, 400.00, 'transfer', '2023-11-19 17:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(72, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(73, 550.00, 'credit card', '2023-11-20 18:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(74, 700.00, 'debit card', '2023-11-21 19:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(75, 850.00, 'credit card', '2023-11-22 20:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(76, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(77, 1200.00, 'debit card', '2023-11-23 21:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(78, 450.00, 'credit card', '2023-11-24 22:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(79, 600.00, 'debit card', '2023-11-25 23:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(80, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(81, 350.00, 'transfer', '2023-11-26 10:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(82, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(83, 500.00, 'transfer', '2023-11-27 11:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(84, 1200.00, 'credit card', '2023-11-28 12:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(85, 300.00, 'debit card', '2023-11-29 13:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(86, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(87, 450.00, 'credit card', '2023-11-30 14:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(88, 900.00, 'debit card', '2023-12-01 15:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(89, 600.00, 'credit card', '2023-12-02 16:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(90, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(91, 400.00, 'debit card', '2023-12-03 17:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(92, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(93, 550.00, 'credit card', '2023-12-04 18:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(94, 700.00, 'debit card', '2023-12-05 19:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(95, 850.00, 'credit card', '2023-12-06 20:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(96, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(97, 1200.00, 'debit card', '2023-12-07 21:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(98, 450.00, 'credit card', '2023-12-08 22:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(99, 600.00, 'transfer', '2023-12-09 23:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(100, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(101, 350.00, 'credit card', '2023-12-10 10:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(102, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(103, 500.00, 'debit card', '2023-12-11 11:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(104, 1200.00, 'credit card', '2023-12-12 12:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(105, 300.00, 'debit card', '2023-12-13 13:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(106, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(107, 450.00, 'transfer', '2023-12-14 14:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(108, 900.00, 'transfer', '2023-12-15 15:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(109, 600.00, 'credit card', '2023-12-16 16:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(110, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(111, 400.00, 'debit card', '2023-12-17 17:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(112, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(113, 550.00, 'credit card', '2023-12-18 18:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(114, 700.00, 'transfer', '2023-12-19 19:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(115, 850.00, 'credit card', '2023-12-20 20:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(116, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(117, 1200.00, 'debit card', '2023-12-21 21:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(118, 450.00, 'credit card', '2023-12-22 22:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(119, 600.00, 'debit card', '2023-12-23 23:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(120, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(121, 350.00, 'credit card', '2023-12-24 10:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(122, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(123, 500.00, 'debit card', '2023-12-25 11:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(124, 1200.00, 'credit card', '2023-12-26 12:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(125, 300.00, 'debit card', '2023-12-27 13:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(126, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(127, 450.00, 'transfer', '2023-12-28 14:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(128, 900.00, 'debit card', '2023-12-29 15:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(129, 600.00, 'credit card', '2023-12-30 16:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(130, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(131, 400.00, 'debit card', '2023-12-31 17:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(132, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(133, 550.00, 'credit card', '2024-01-01 18:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(134, 700.00, 'debit card', '2024-01-02 19:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(135, 850.00, 'credit card', '2024-01-03 20:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(136, 0.00, NULL, NULL);

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(137, 1200.00, 'transfer', '2024-01-04 21:00:00');

INSERT INTO Payments (sale_id, amount_paid, payment_method, payment_date) VALUES
(138, 450.00, 'credit card', '2024-01-05 22:00:00');

-- Insert data into Employees
INSERT INTO Employees (company_id, name, position, salary, hire_date) VALUES
(1, 'Ana Gomez', 'Sales Manager', 3000.00, '2020-01-15'),
(1, 'Luis Ramirez', 'Support Technician', 1500.00, '2021-05-10'),
(1, 'Carlos Mendoza', 'Sales Representative', 2000.00, '2022-03-15'),
(1, 'Ana Silva', 'Marketing Manager', 3500.00, '2021-07-10'),
(1, 'Luis Torres', 'IT Support', 1800.00, '2023-01-20'),
(1, 'Maria Fernandez', 'Accountant', 2500.00, '2020-11-05'),
(1, 'Jorge Ramirez', 'Warehouse Manager', 2200.00, '2022-09-12'),
(1, 'Sofia Gomez', 'Customer Support', 1500.00, '2023-05-01'),
(1, 'Pedro Castro', 'Logistics Coordinator', 2300.00, '2021-12-18');

/* ------------------------------------------------  Analysis  -------------------------------------------------- */

-- 1. Basic Queries

SELECT * FROM Products;
SELECT * FROM Employees;
SELECT * FROM Sales_Details;

-- 2. Complex Queries

-- Retrieve all products with their categories and suppliers
SELECT p.name AS Product, c.name AS Category, s.name AS Supplier
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
JOIN Suppliers s ON p.supplier_id = s.supplier_id;	

-- Retrieve total sales per customer

SELECT c.name AS Customer, SUM(s.total) AS Total_Sales
FROM Sales s
JOIN Customers c ON s.customer_id = c.customer_id
GROUP BY c.name;

-- Retrieve the most sold products
SELECT p.name AS Product, SUM(sd.quantity) AS Quantity_Sold
FROM Sales_Details sd
JOIN Products p ON sd.product_id = p.product_id
GROUP BY p.name
ORDER BY Quantity_Sold DESC;

-- Retrieve the average salary of employees
SELECT AVG(salary) AS Average_Salary
FROM Employees;

-- Retrieve the stock levels of products
SELECT p.name AS Product, i.stock AS Stock
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id;


-- 3. Queries for Machine Learning Datasets

-- Product Demand Forecasting

SELECT 
    p.name AS Product, 
    YEAR(s.sale_date) AS Year, 
    MONTH(s.sale_date) AS Month, 
    SUM(sd.quantity) AS Quantity_Sold
FROM 
    Sales_Details sd
JOIN 
    Products p ON sd.product_id = p.product_id
JOIN 
    Sales s ON sd.sale_id = s.sale_id
GROUP BY 
    p.name, YEAR(s.sale_date), MONTH(s.sale_date)
ORDER BY 
    Year, Month, Quantity_Sold DESC;

-- Customer Segmentation (K Means)

SELECT 
    c.name AS Customer, 
    COUNT(s.sale_id) AS Total_Transactions, 
    SUM(s.total) AS Total_Spent,
    max(sale_date) AS Last_Sale
FROM 
    Sales s
JOIN 
    Customers c ON s.customer_id = c.customer_id
GROUP BY 
    c.name
ORDER BY 
    Total_Spent DESC;


