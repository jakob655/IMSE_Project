CREATE DATABASE IF NOT EXISTS project_database;
USE project_database;

CREATE TABLE IF NOT EXISTS Employee (
    SL_ID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    Surname VARCHAR(255),
    Salary DECIMAL,
    Bonus DECIMAL
);

CREATE TABLE IF NOT EXISTS Customer (
    Customer_ID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    Surname VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Building (
    Building_ID INT PRIMARY KEY,
    Name VARCHAR(255),
    City VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Room (
    Room_ID INT PRIMARY KEY,
    Building_ID INT,
    RoomSize DECIMAL,
    FOREIGN KEY (Building_ID) REFERENCES Building(Building_ID)
);

CREATE TABLE IF NOT EXISTS Course (
    Course_ID INT PRIMARY KEY,
    Price DECIMAL,
    StartingTime TIME,
    FinishingTime TIME,
    Building_ID INT,
    Room_ID INT,
    FOREIGN KEY (Building_ID) REFERENCES Building(Building_ID),
    FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID)
);

CREATE TABLE IF NOT EXISTS ForChildren (
    Course_ID INT PRIMARY KEY,
    LatestPickUpTime TIME,
    MinimumAge INT,
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID)
);

CREATE TABLE IF NOT EXISTS ForAdults (
    Course_ID INT PRIMARY KEY,
    PreviousKnowledge VARCHAR(255),
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID)
);

CREATE TABLE IF NOT EXISTS Instructor (
    SL_ID INT PRIMARY KEY,
    Qualifications VARCHAR(255),
    MailAddress VARCHAR(255),
    FOREIGN KEY (SL_ID) REFERENCES Employee(SL_ID)
);

CREATE TABLE IF NOT EXISTS Housekeeper (
    SL_ID INT PRIMARY KEY,
    PhoneNumber VARCHAR(255),
    FOREIGN KEY (SL_ID) REFERENCES Employee(SL_ID)
);

CREATE TABLE IF NOT EXISTS Participate (
    Customer_ID INT,
    Course_ID INT,
    PRIMARY KEY (Customer_ID, Course_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID)
);

CREATE TABLE IF NOT EXISTS Supervise (
    SL_ID INT,
    Course_ID INT,
    PRIMARY KEY (SL_ID, Course_ID),
    FOREIGN KEY (SL_ID) REFERENCES Instructor(SL_ID),
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID)
);

CREATE TABLE IF NOT EXISTS Books (
    Course_ID INT,
    Room_ID INT,
    PRIMARY KEY (Course_ID, Room_ID),
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID),
    FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID)
);

CREATE TABLE IF NOT EXISTS ResponsibleFor (
    SL_ID INT,
    Building_ID INT,
    PRIMARY KEY (SL_ID, Building_ID),
    FOREIGN KEY (SL_ID) REFERENCES Housekeeper(SL_ID),
    FOREIGN KEY (Building_ID) REFERENCES Building(Building_ID)
)