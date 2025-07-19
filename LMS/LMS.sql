CREATE DATABASE LMS;
USE LMS;

-- Students
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    department VARCHAR(50),
    gender CHAR(1) DEFAULT 'M'
);

INSERT INTO students (name, email, department, gender) VALUES
('Aarav Sharma', 'aarav.sharma@example.com', 'CSE', 'M'),
('Priya Mehta', 'priya.mehta@example.com', 'ECE', 'F'),
('Rahul Nair', 'rahul.nair@example.com', 'ME', 'M'),
('Sneha Iyer', 'sneha.iyer@example.com', 'IT', 'F'),
('Karan Patel', 'karan.patel@example.com', 'CIVIL', 'M');


-- Books
CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    available_copies INT DEFAULT 1
);

INSERT INTO books (title, author, category, available_copies) VALUES
('Operating System Concepts', 'Silberschatz', 'Education', 2),
('Digital Logic Design', 'Morris Mano', 'Education', 4),
('Let Us C', 'Yashavant Kanetkar', 'Programming', 3),
('Wings of Fire', 'A.P.J. Abdul Kalam', 'Biography', 5),
('Clean Architecture', 'Robert C. Martin', 'Programming', 4);


-- Librarians
CREATE TABLE librarians (
    librarian_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    experience_years INT DEFAULT 0
);

INSERT INTO librarians (name, experience_years) VALUES
('Sunita Desai', 12),
('Ramesh Menon', 9),
('Geeta Pandey', 5),
('Vijay Kumar', 7),
('Asha Rani', 4);



-- Borrow Records
CREATE TABLE borrow (
    borrow_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    book_id INT,
    librarian_id INT,
    borrow_date DATE DEFAULT "2025-07-02",
    return_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (librarian_id) REFERENCES librarians(librarian_id)
);

INSERT INTO borrow (student_id, book_id, librarian_id, borrow_date, return_date) VALUES
(1, 3, 1, '2025-06-01', '2025-06-10'),
(2, 5, 2, '2025-06-02', '2025-06-12'),
(3, 1, 3, '2025-06-03', '2025-06-13'),
(4, 2, 4, '2025-06-04', '2025-06-14'),
(5, 4, 5, '2025-06-05', '2025-06-15');




-- Crud Operations
-- Add
INSERT INTO students (name, email, department, gender) VALUES ('John Doe', 'john@example.com', 'MECH', 'M');

-- Update
UPDATE books SET available_copies = available_copies - 1 WHERE book_id = 1;

-- Delete
DELETE FROM borrow WHERE borrow_id = 1;

-- View
SELECT * FROM students;


-- Join Queries
-- a. Show which student borrowed which book
SELECT students.name, books.title
FROM borrow 
INNER JOIN students ON borrow.student_id = students.student_id 
INNER JOIN books ON borrow.book_id = books.book_id;


-- b. List all books borrowed with librarian name
SELECT books.title, librarians.name AS librarian
FROM borrow
INNER JOIN books ON borrow.book_id = books.book_id
INNER JOIN librarians ON borrow.librarian_id = librarians.librarian_id;


-- c. Borrow history of a student
SELECT students.name, books.title, borrow.borrow_date, borrow.return_date
FROM borrow
INNER JOIN books on borrow.book_id = books.book_id
INNER JOIN students on borrow.student_id = students.student_id
WHERE borrow.student_id = 1;

-- Aggregate Queries
-- a. Count total books borrowed by each student
SELECT students.name, count(borrow.book_id) AS total_books
FROM borrow
INNER JOIN students on borrow.student_id = students.student_id
GROUP BY borrow.student_id;

-- b. Most borrowed book
SELECT books.title, COUNT(*) AS times_borrowed
FROM borrow
JOIN books ON borrow.book_id = books.book_id
GROUP BY borrow.book_id
ORDER BY times_borrowed DESC;

-- c. Average experience of librarians
SELECT AVG(experience_years) AS avg_experience FROM librarians;

-- d. Total number of students
SELECT COUNT(*) AS total_students FROM students;

-- e. Min & Max borrow dates for a book
SELECT MIN(borrow_date) AS earliest, MAX(borrow_date) AS latest
FROM borrow
WHERE book_id = 1;
