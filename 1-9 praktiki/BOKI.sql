CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL
);

CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    published_year INT,
    author_id INT 
);

ALTER TABLE books ADD COLUMN genre VARCHAR(100);

ALTER TABLE books ADD CONSTRAINT published_year CHECK (published_year <= 2025);

ALTER TABLE books DROP COLUMN author_id INT;

CREATE TABLE books_authors (
    book_id INT,
    author_id INT,
    published_year INT CHECK (published_year<=2025),
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);