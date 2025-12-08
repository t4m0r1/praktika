CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL
);

CREATE TABLE product (
    product_id INT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    price INT NOT NULL
);

CREATE TABLE orders ( 
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE product_in_order(
    product_id INT, 
    order_id INT,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)

)