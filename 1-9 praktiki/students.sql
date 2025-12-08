CREATE TABLE Students (
    student_id SERIAL PRIMARY KEY, -- Уникальный идентификатор студента
    full_name VARCHAR(255) NOT NULL, -- Полное имя студента
    email VARCHAR(255) UNIQUE NOT NULL, -- Электронная почта студента (должна быть уникальной)
    start_year INT -- Год поступления студента
);

CREATE TABLE Courses (
    course_id SERIAL PRIMARY KEY, -- Уникальный идентификатор курса
    course_name VARCHAR(255) NOT NULL, -- Название курса
    credits INT CHECK (credits > 0) -- Количество зачетных единиц курса (должно быть больше 0)
);

CREATE TABLE Enrollments (
    student_id INT REFERENCES Students(student_id) ON DELETE CASCADE, -- Ссылка на ID студента (внешний ключ)
    course_id INT REFERENCES Courses(course_id) ON DELETE CASCADE, -- Ссылка на ID курса (внешний ключ)
    grade CHAR(1), -- Оценка студента за курс (например, 'A', 'B', 'C')
    PRIMARY KEY (student_id, course_id)
);
INSERT INTO Students VALUES (DEFAULT, 'Алексей Смирнов', 'smirnov@mail.ru', 2021);
INSERT INTO Students VALUES (DEFAULT, 'Елена Кузнецова', 'elenaK@mail.ru', 2022);
INSERT INTO Students VALUES (DEFAULT, 'Дмитрий Новиков', 'dmitryN@mail.ru', 2021);
INSERT INTO Students VALUES (DEFAULT, 'Ольга Морозова', 'morozova@mail.ru', 2023);

INSERT INTO Courses VALUES (DEFAULT, 'Введение в программирование', 5);
INSERT INTO Courses VALUES (DEFAULT, 'Базы данных', 4);
INSERT INTO Courses VALUES (DEFAULT, 'Веб-технологии', 4);

INSERT INTO Enrollments VALUES (1, 2, 'A');
INSERT INTO Enrollments VALUES (2, 2, 'B');
INSERT INTO Enrollments VALUES (2, 3, 'A');
INSERT INTO Enrollments VALUES (3, 1);
INSERT INTO Enrollments VALUES (3, 2);
INSERT INTO Enrollments VALUES (3, 3);

UPDATE Students
SET email = 'elena.kuznetsova@newmail.com'
WHERE full_name = 'Елена Кузнецова';
UPDATE Enrollments 
SET grade = 'A' 
WHERE student_id = 3 AND course_id = 1;

DELETE FROM Students
WHERE email = 'morozova@mail.ru';

SELECT full_name FROM Students;
SELECT * FROM Courses;
SELECT * FROM Students WHERE start_year = 2021;
SELECT * FROM Courses WHERE credits > 4;
SELECT * FROM Students WHERE email LIKE 'elena.kuznetsova@newmail.com';
SELECT * FROM Students WHERE full_name LIKE 'Дмитрий';
SELECT * FROM Enrollments WHERE grade IS NULL;
SELECT * FROM Courses ORDER BY course_name;
SELECT * FROM Students ORDER BY start_year ASC, full_name ASC;
SELECT * FROM Students ORDER BY start_year DESC LIMIT 2;