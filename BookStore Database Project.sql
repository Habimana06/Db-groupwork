   BookStore Database Project

Database Design & Programming with SQL

Overview
This document outlines the SQL scripts and steps required to create a MySQL database for a BookStore. The database includes tables for books, authors, customers, orders, and related entities, along with user management and security configurations.


SQL Script

1. Create the Database

 CREATE DATABASE BookStore;
 USE BookStore;


2. Create Tables

Lookup Tables

 -- Publisher
 CREATE TABLE publisher (
    publisher_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
 );

 -- Book Language
 CREATE TABLE book_language (
    language_id INT PRIMARY KEY AUTO_INCREMENT,
    language_name VARCHAR(50) NOT NULL
 );

 -- Country
 CREATE TABLE country (
    country_id INT PRIMARY KEY AUTO_INCREMENT,
    country_name VARCHAR(100) NOT NULL
 );

 -- Address Status
 CREATE TABLE address_status (
    address_status_id INT PRIMARY KEY AUTO_INCREMENT,
    status VARCHAR(20) NOT NULL
 );

 -- Shipping Method
 CREATE TABLE shipping_method (
    shipping_method_id INT PRIMARY KEY AUTO_INCREMENT,
    method_name VARCHAR(50) NOT NULL
 );

 -- Order Status
 CREATE TABLE order_status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_value VARCHAR(20) NOT NULL
 );


Core Tables
 -- Author
 CREATE TABLE author (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL
 );

 -- Book
 CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(13) UNIQUE,
    publisher_id INT,
    language_id INT,
    publication_date DATE,
    price DECIMAL(10,2),
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id)
 );

 -- Book-Author (Many-to-Many)
 CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
 );

 -- Customer
 CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20)
 );

 -- Address
 CREATE TABLE address (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    street VARCHAR(255),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
 );

 


-- Customer-Address Relationship
 CREATE TABLE customer_address (
    customer_address_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    address_id INT,
    address_status_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (address_status_id) REFERENCES address_status(address_status_id)
 );
-- Order
 CREATE TABLE cust_order (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    shipping_method_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(shipping_method_id)
);
-- Order Line Items
 CREATE TABLE order_line (
    order_line_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    book_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
 );










-- Order History
 CREATE TABLE order_history (
    order_history_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    status_id INT,
    status_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
   FOREIGN KEY (status_id) REFERENCES order_status(status_id)
 );



3. User Management


 -- Admin User (Full Access)
 CREATE USER 'bookstore_admin'@'localhost' IDENTIFIED BY 'SecureAdminPass123!';
 GRANT ALL PRIVILEGES ON BookStore.* TO 'bookstore_admin'@'localhost';

 -- Read-Only User (Reports)
 CREATE USER 'bookstore_read'@'localhost' IDENTIFIED BY 'ReadOnlyPass456!';
 GRANT SELECT ON BookStore.* TO 'bookstore_read'@'localhost';

 



-- Application User (Limited Access)
 CREATE USER 'bookstore_app'@'localhost' IDENTIFIED BY 'AppUserPass789!';
 GRANT SELECT, INSERT, UPDATE ON BookStore.* TO 'bookstore_app'@'localhost';

4. Example Queries


 -- Retrieve books with authors
 SELECT b.title, a.first_name, a.last_name
 FROM book b
 JOIN book_author ba ON b.book_id = ba.book_id
 JOIN author a ON ba.author_id = a.author_id;




 -- List customers with current addresses
 SELECT c.first_name, c.last_name, a.street, a.city, co.country_name
 FROM customer c
 JOIN customer_address ca ON c.customer_id = ca.customer_id
 JOIN address a ON ca.address_id = a.address_id
 JOIN country co ON a.country_id = co.country_id
 WHERE ca.address_status_id = (SELECT address_status_id FROM address_status WHERE status =     'current');



 -- View order history for a customer
 SELECT o.order_id, os.status_value, oh.status_date
 FROM cust_order o
 JOIN order_history oh ON o.order_id = oh.order_id
 JOIN order_status os ON oh.status_id = os.status_id
 WHERE o.customer_id = 1;

-- data samples
--publisher table values
INSERT INTO publisher (name) VALUES
('Penguin Random House'),
('HarperCollins'),
('Simon & Schuster'),
('Hachette Book Group'),
('Macmillan Publishers'),
('Scholastic Inc.'),
('Oxford University Press'),
('Cambridge University Press'),
('Pearson Education'),
('Wiley'),
('Cengage Learning'),
('Springer Nature'),
('Elsevier'),
('McGraw-Hill Education'),
('Thomson Reuters'),
('SAGE Publications'),
('Taylor & Francis'),
('Bloomsbury Publishing'),
('Zondervan'),
('Hay House'),
('Chronicle Books'),
('Tor Books'),
('Little, Brown and Company'),
('Vintage Books'),
('Anchor Books'),
('Farrar, Straus and Giroux'),
('Grove Atlantic'),
('DK Publishing'),
('Workman Publishing'),
('Abrams Books'),
('Candlewick Press'),
('Quirk Books'),
('No Starch Press'),
('MIT Press'),
('New Harbinger Publications'),
('Sourcebooks'),
('Lion Hudson'),
('Baker Publishing Group'),
('Barbour Publishing'),
('Random House Kids');

--book_language table values
INSERT INTO book_language (language_name) VALUES
('English'),
('Spanish'),
('French'),
('German'),
('Italian'),
('Portuguese'),
('Russian'),
('Chinese'),
('Japanese'),
('Korean'),
('Arabic'),
('Hindi'),
('Bengali'),
('Urdu'),
('Turkish'),
('Swahili'),
('Dutch'),
('Greek'),
('Hebrew'),
('Polish'),
('Czech'),
('Hungarian'),
('Romanian'),
('Thai'),
('Vietnamese'),
('Indonesian'),
('Malay'),
('Filipino'),
('Tamil'),
('Telugu'),
('Persian'),
('Ukrainian'),
('Serbian'),
('Croatian'),
('Slovak'),
('Finnish'),
('Norwegian'),
('Danish'),
('Swedish'),
('Zulu');

--country table values
INSERT INTO country (country_name) VALUES
('United States'),
('Canada'),
('United Kingdom'),
('Germany'),
('France'),
('Italy'),
('Spain'),
('Portugal'),
('Netherlands'),
('Belgium'),
('Switzerland'),
('Sweden'),
('Norway'),
('Denmark'),
('Finland'),
('Russia'),
('China'),
('Japan'),
('South Korea'),
('India'),
('Pakistan'),
('Bangladesh'),
('Sri Lanka'),
('Nepal'),
('Indonesia'),
('Malaysia'),
('Philippines'),
('Thailand'),
('Vietnam'),
('Australia'),
('New Zealand'),
('South Africa'),
('Nigeria'),
('Kenya'),
('Ghana'),
('Egypt'),
('Morocco'),
('Turkey'),
('Saudi Arabia'),
('United Arab Emirates'),
('Brazil'),
('Argentina'),
('Chile'),
('Mexico'),
('Colombia'),
('Peru'),
('Venezuela'),
('Ukraine'),
('Poland'),
('Greece'),
('Hungary');


--address status values
INSERT INTO address_status (status) VALUES
('Active'),
('Inactive'),
('Pending'),
('Verified'),
('Unverified'),
('Primary'),
('Secondary'),
('Temporary'),
('Permanent'),
('Archived'),
('Deleted'),
('Default');


--shipping method values
INSERT INTO shipping_method (method_name) VALUES
('Standard Shipping'),
('Express Shipping'),
('Overnight Shipping'),
('Two-Day Shipping'),
('Same Day Delivery'),
('International Shipping'),
('In-Store Pickup'),
('Curbside Pickup'),
('Freight Shipping'),
('Drone Delivery'),
('Local Courier'),
('Economy Shipping'),
('Next Flight Out'),
('Scheduled Delivery'),
('Weekend Delivery'),
('White Glove Delivery'),
('Postal Service'),
('Locker Pickup'),
('Digital Delivery'),
('Subscription Delivery');

--order_status table values
INSERT INTO order_status (status_value) VALUES
('Pending'),
('Processing'),
('Confirmed'),
('Shipped'),
('In Transit'),
('Out for Delivery'),
('Delivered'),
('Delayed'),
('Cancelled'),
('Returned'),
('Refunded'),
('Failed'),
('On Hold'),
('Backordered'),
('Awaiting Payment'),
('Payment Received'),
('Completed');


--author_table values
INSERT INTO author (first_name, last_name) VALUES
('George', 'Orwell'),
('Jane', 'Austen'),
('Mark', 'Twain'),
('J.K.', 'Rowling'),
('William', 'Shakespeare'),
('Chinua', 'Achebe'),
('Leo', 'Tolstoy'),
('Agatha', 'Christie'),
('F. Scott', 'Fitzgerald'),
('Ernest', 'Hemingway'),
('Virginia', 'Woolf'),
('Gabriel', 'García Márquez'),
('Haruki', 'Murakami'),
('Toni', 'Morrison'),
('Isabel', 'Allende'),
('James', 'Baldwin'),
('Ngũgĩ wa', 'Thiong’o'),
('C.S.', 'Lewis'),
('Stephen', 'King'),
('Maya', 'Angelou'),
('Dan', 'Brown'),
('Margaret', 'Atwood'),
('Khaled', 'Hosseini'),
('Roxane', 'Gay'),
('Yaa', 'Gyasi'),
('Chimamanda', 'Ngozi Adichie'),
('Elif', 'Shafak'),
('J.R.R.', 'Tolkien'),
('Albert', 'Camus'),
('Franz', 'Kafka'),
('Nadine', 'Gordimer'),
('Zadie', 'Smith'),
('Arthur', 'Conan Doyle');
