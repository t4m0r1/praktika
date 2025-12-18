--1
CREATE TABLE Projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(255) NOT NULL
);


CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(255) NOT NULL
);


CREATE TABLE Project_Assignments (
    project_id INT NOT NULL,
    employee_id INT NOT NULL,
    PRIMARY KEY (project_id, employee_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);
--2
CREATE TABLE Clients (
    client_id INT PRIMARY KEY,
    client_name VARCHAR(255) NOT NULL,
    client_email VARCHAR(255) NOT NULL
);

CREATE TABLE Equipment (
    equipment_id INT PRIMARY KEY,
    equipment_name VARCHAR(255) NOT NULL
);

CREATE TABLE EquipmentRentals (
    client_id INT,
    equipment_id INT,
    rental_date DATE NOT NULL,
    PRIMARY KEY (client_id, equipment_id), 
    FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    FOREIGN KEY (equipment_id) REFERENCES Equipment(equipment_id)
);
--3

CREATE TABLE Studentss (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(255) NOT NULL
);

CREATE TABLE Coursess (
    course_id INT PRIMARY KEY,
    course_professor VARCHAR(255) NOT NULL
);

CREATE TABLE Grades (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    assignment_name VARCHAR(255) NOT NULL,
    grade INT NOT NULL,
    PRIMARY KEY (student_id, course_id, assignment_name),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);