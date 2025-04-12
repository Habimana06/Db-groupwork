
# BookStore Database Project

## Overview

This project presents the design and implementation of a **MySQL relational database** for a bookstore system. It includes SQL scripts to manage books, authors, customers, orders, and other related entities, along with user roles for secure access.

---

## Tools & Technologies

- **MySQL** – For database creation and querying  
- **Draw.io** – For creating the Entity Relationship Diagram (ERD)

---

## Project Structure

```plaintext
BookStore/
│
├── create_database.sql         # Script to create the BookStore database
├── tables.sql                  # Script to create all tables
├── users.sql                   # User roles and permission setup
├── queries.sql                 # Example queries for testing and analytics
├── ERD.png                     # Entity Relationship Diagram 
└── README.md                   # This file
```

---

##  Features

- A comprehensive schema to manage:
  - Books and their authors
  - Customers and multiple address support
  - Orders, order history, and shipping
  - Status tracking for both orders and addresses
- Proper normalization using lookup tables
- User roles with limited and full access
- Sample queries to test database functionality

---

## Tables Created

### Lookup Tables
- `publisher`
- `book_language`
- `country`
- `address_status`
- `shipping_method`
- `order_status`

### Core Tables
- `author`
- `book`
- `book_author` (many-to-many relationship)
- `customer`
- `address`
- `customer_address` (with status)
- `cust_order`
- `order_line`
- `order_history`

---

##  User Management

Three users are created with distinct permissions:

```sql
-- Admin: Full access
CREATE USER 'bookstore_admin'@'localhost' IDENTIFIED BY 'SecureAdminPass123!';
GRANT ALL PRIVILEGES ON BookStore.* TO 'bookstore_admin'@'localhost';

-- Read-Only: Reporting access
CREATE USER 'bookstore_read'@'localhost' IDENTIFIED BY 'ReadOnlyPass456!';
GRANT SELECT ON BookStore.* TO 'bookstore_read'@'localhost';

-- Application: Limited data manipulation
CREATE USER 'bookstore_app'@'localhost' IDENTIFIED BY 'AppUserPass789!';
GRANT SELECT, INSERT, UPDATE ON BookStore.* TO 'bookstore_app'@'localhost';
```

---

## Example SQL Queries

###  Retrieve Books with Their Authors

```sql
SELECT b.title, a.first_name, a.last_name
FROM book b
JOIN book_author ba ON b.book_id = ba.book_id
JOIN author a ON ba.author_id = a.author_id;
```

### List Customers with Current Addresses

```sql
SELECT c.first_name, c.last_name, a.street, a.city, co.country_name
FROM customer c
JOIN customer_address ca ON c.customer_id = ca.customer_id
JOIN address a ON ca.address_id = a.address_id
JOIN country co ON a.country_id = co.country_id
WHERE ca.address_status_id = (
  SELECT address_status_id FROM address_status WHERE status = 'current'
);
```

###  View Order History for a Customer

```sql
SELECT o.order_id, os.status_value, oh.status_date
FROM cust_order o
JOIN order_history oh ON o.order_id = oh.order_id
JOIN order_status os ON oh.status_id = os.status_id
WHERE o.customer_id = 1;
```

---

## ERD (Entity Relationship Diagram)

```markdown
![Image](https://github.com/user-attachments/assets/6b7e2424-726f-4566-a700-3794da0f9ca6)
```

---

##  How to Use

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/bookstore-database.git
   cd bookstore-database
   ```

2. Run SQL scripts in order:
   - `create_database.sql`
   - `tables.sql`
   - `users.sql`
   - (Optional) `queries.sql` for testing

3. Connect using one of the user accounts based on your role.

---

##  Contributors

- `Ntaganira Habimana Happy` – Group Leader  
-`Olusanmi Pamilerin Kehinde` – Member 
-` Broad odhiambo` – Member  


---



