CREATE DATABASE project_database;
USE project_database;

CREATE TABLE Employee (
    SL_ID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    Surname VARCHAR(255),
    Salary DECIMAL,
    Bonus DECIMAL
);

CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    Surname VARCHAR(255)
);

CREATE TABLE Building (
    Building_ID INT PRIMARY KEY,
    Name VARCHAR(255),
    ZIP_Code INT,
    City VARCHAR(255),
    District VARCHAR(255)
);

CREATE TABLE Room (
    Room_ID INT PRIMARY KEY,
    Building_ID INT,
    RoomSize DECIMAL,
    EquippedFor VARCHAR(255),
    FOREIGN KEY (Building_ID) REFERENCES Building(Building_ID)
);

CREATE TABLE Course (
    Course_ID INT PRIMARY KEY,
    Title VARCHAR(255),
    Price DECIMAL,
    StartingTime TIME,
    FinishingTime TIME,
    Building_ID INT,
    Room_ID INT,
    FOREIGN KEY (Building_ID) REFERENCES Building(Building_ID),
    FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID)
);

CREATE TABLE ForChildren (
    Course_ID INT PRIMARY KEY,
    LatestPickUpTime TIME,
    MinimumAge INT,
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID)
);

CREATE TABLE ForAdults (
    Course_ID INT PRIMARY KEY,
    PreviousKnowledge VARCHAR(255),
    RequiredEquipment VARCHAR(255),
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID)
);

CREATE TABLE Instructor (
    SL_ID INT PRIMARY KEY,
    Qualifications VARCHAR(255),
    MailAddress VARCHAR(255),
    FOREIGN KEY (SL_ID) REFERENCES Employee(SL_ID)
);

CREATE TABLE Housekeeper (
    SL_ID INT PRIMARY KEY,
    PhoneNumber VARCHAR(255),
    WorkShiftBegin TIME,
    WorkShiftEnd TIME,
    FOREIGN KEY (SL_ID) REFERENCES Employee(SL_ID)
);

CREATE TABLE Participate (
    Customer_ID INT,
    Course_ID INT,
    PRIMARY KEY (Customer_ID, Course_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID)
);

CREATE TABLE Supervise (
    SL_ID INT,
    Course_ID INT,
    PRIMARY KEY (SL_ID, Course_ID),
    FOREIGN KEY (SL_ID) REFERENCES Instructor(SL_ID),
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID)
);

CREATE TABLE Books (
    Course_ID INT,
    Room_ID INT,
    PRIMARY KEY (Course_ID, Room_ID),
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID),
    FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID)
);

CREATE TABLE ResponsibleFor (
    SL_ID INT,
    Building_ID INT,
    PRIMARY KEY (SL_ID, Building_ID),
    FOREIGN KEY (SL_ID) REFERENCES Housekeeper(SL_ID),
    FOREIGN KEY (Building_ID) REFERENCES Building(Building_ID)
);

CREATE TABLE LocatedIn (
    ZIP_Code INT,
    City VARCHAR(255),
    PRIMARY KEY (ZIP_Code, City)
);
