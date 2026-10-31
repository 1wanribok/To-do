-- Run this whole script in SQL Server Management Studio (SSMS)
IF DB_ID('TeamBoardDB') IS NULL CREATE DATABASE TeamBoardDB;
GO
USE TeamBoardDB;
GO
DROP TABLE IF EXISTS Tasks; DROP TABLE IF EXISTS Projects; DROP TABLE IF EXISTS Members;
GO
CREATE TABLE Members (
    MemberId INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email    NVARCHAR(150) NOT NULL,
    Role     NVARCHAR(50)  NOT NULL
);
CREATE TABLE Projects (
    ProjectId   INT IDENTITY(1,1) PRIMARY KEY,
    Name        NVARCHAR(120) NOT NULL,
    Description NVARCHAR(400) NULL,
    DueDate     DATE NULL
);
CREATE TABLE Tasks (
    TaskId     INT IDENTITY(1,1) PRIMARY KEY,
    ProjectId  INT NOT NULL REFERENCES Projects(ProjectId) ON DELETE CASCADE,
    AssignedTo INT NULL     REFERENCES Members(MemberId)   ON DELETE SET NULL,
    Title      NVARCHAR(200) NOT NULL,
    Status     NVARCHAR(20)  NOT NULL DEFAULT 'To Do'   CHECK (Status   IN ('To Do','In Progress','Done')),
    Priority   NVARCHAR(10)  NOT NULL DEFAULT 'Medium'  CHECK (Priority IN ('Low','Medium','High')),
    DueDate    DATE NULL
);
GO
INSERT INTO Members (FullName,Email,Role) VALUES
 ('Asha Patil','asha@team.com','Manager'),
 ('Rohan Deshmukh','rohan@team.com','Developer'),
 ('Neha Kulkarni','neha@team.com','Designer'),
 ('Vikram Joshi','vikram@team.com','Tester');
INSERT INTO Projects (Name,Description,DueDate) VALUES
 ('Website Redesign','New look for the company website',DATEADD(day,30,CAST(GETDATE() AS date))),
 ('Mobile App v2','Second release of the customer app',DATEADD(day,60,CAST(GETDATE() AS date)));
INSERT INTO Tasks (ProjectId,AssignedTo,Title,Status,Priority,DueDate) VALUES
 (1,3,'Design home page mockup','Done','High',DATEADD(day,-2,CAST(GETDATE() AS date))),
 (1,2,'Build navigation menu','In Progress','Medium',CAST(GETDATE() AS date)),
 (1,2,'Connect contact form to database','To Do','High',DATEADD(day,3,CAST(GETDATE() AS date))),
 (1,4,'Test on mobile browsers','To Do','Low',DATEADD(day,7,CAST(GETDATE() AS date))),
 (2,1,'Write release plan','In Progress','Medium',CAST(GETDATE() AS date)),
 (2,2,'Add push notifications','To Do','High',DATEADD(day,14,CAST(GETDATE() AS date))),
 (2,3,'Update app icons','Done','Low',DATEADD(day,-5,CAST(GETDATE() AS date)));
GO
