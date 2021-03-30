CREATE DATABASE sshysh_test;
CREATE TABLE Table1 (
    UserId int NOT NULL AUTO_INCREMENT,
    FirstName varchar(255),
    LastName varchar(255)
);
INSERT INTO Table1 (FirstName, LastName)
VALUES ('Stepan', 'Shysh');
SELECT * FROM Table1;