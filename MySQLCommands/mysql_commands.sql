-- Create a new database
CREATE DATABASE mydb;

-- Use the database
USE mydb;

-- Create a user table
CREATE TABLE user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL
);

-- Insert sample data
INSERT INTO user (name, email) VALUES ('Alice', 'alice@example.com');
INSERT INTO user (name, email) VALUES ('Bob', 'bob@example.com');
