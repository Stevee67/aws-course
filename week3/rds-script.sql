CREATE DATABASE sshysh_test;
CREATE TABLE Table1 (
    UserId SERIAL PRIMARY KEY,
    FirstName varchar(255),
    LastName varchar(255)
);
INSERT INTO Table1 (FirstName, LastName)
VALUES ('Stepan', 'Shysh');
SELECT * FROM Table1;