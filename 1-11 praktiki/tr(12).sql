
DROP TABLE IF EXISTS order_history;
DROP TABLE IF EXISTS productss;

CREATE TABLE productss (
    product_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0)
);

CREATE TABLE order_history (
    log_id SERIAL PRIMARY KEY,
    product_id INT,
    quantity_changed INT,
    notes VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO productss (product_id, name, quantity) VALUES
(1, 'Ноутбук', 20),
(2, 'Смартфон', 50);

SELECT * FROM productss;

select * FROM order_history;