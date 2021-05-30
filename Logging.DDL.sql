-- Author: Qulle 2021-05-19
-- Github: github.com/qulle/mssql-automatic-logging
-- Editor: vscode

-- Create database if not exist
IF NOT EXISTS(SELECT * FROM [sys].[databases] WHERE [name] = 'TRIGGER_BASED_LOGGING_001')
    CREATE DATABASE [TRIGGER_BASED_LOGGING_001];

GO

-- Select the target database
USE [TRIGGER_BASED_LOGGING_001];

GO

-- Clean old tables and triggers
DROP TABLE   IF EXISTS [users];
DROP TABLE   IF EXISTS [users_logging];
DROP TRIGGER IF EXISTS [tr_user_logging];

GO

-- Create users table
CREATE TABLE [users] (
    PRIMARY KEY ([id]),
    [id]             BIGINT IDENTITY(1, 1),
    [username]       NVARCHAR(64)  NOT NULL UNIQUE,
    [email]          NVARCHAR(128) NOT NULL UNIQUE,
    [full_name]      NVARCHAR(128) NOT NULL,
    [password]       NVARCHAR(256) NOT NULL
);

-- Create users_logging table
CREATE TABLE [users_logging] (
    PRIMARY KEY ([id]),
    [id]             BIGINT IDENTITY(1, 1),
    [event_type]     VARCHAR(6)    NOT NULL,
    [timestamp]      DATETIME      NOT NULL,
    [user_id]        BIGINT        NOT NULL,
    [old_username]   NVARCHAR(64)      NULL,
    [new_username]   NVARCHAR(64)      NULL,
    [old_email]      NVARCHAR(128)     NULL,
    [new_email]      NVARCHAR(128)     NULL,
    [old_password]   NVARCHAR(256)     NULL,
    [new_password]   NVARCHAR(256)     NULL
);

GO

-- Create trigger that will do the logging
CREATE TRIGGER [tr_user_logging]
            ON [users]
         AFTER INSERT, UPDATE, DELETE
            AS
         BEGIN
                DECLARE @timestamp AS DATETIME = getdate();
                DECLARE @action CHAR(6)

                SET @action = CASE
                    WHEN EXISTS(SELECT * FROM [inserted]) AND EXISTS(SELECT * FROM [deleted])
                        THEN 'Update'
                    WHEN EXISTS(SELECT * FROM [inserted])
                        THEN 'Insert'
                    WHEN EXISTS(SELECT * FROM [deleted])
                        THEN 'Delete'
                    ELSE NULL
                END

                IF @action = 'Delete'
                    INSERT INTO [users_logging] ([event_type], [timestamp], [user_id], [old_username], [old_email], [old_password])
                         SELECT @action, @timestamp, [id], [username], [email], [password]
                           FROM [deleted];
 
                IF @action = 'Insert'
                    INSERT INTO [users_logging] ([event_type], [timestamp], [user_id], [new_username], [new_email], [new_password])
                         SELECT @action, @timestamp, [id], [username], [email], [password]
                           FROM [inserted];
 
                IF @action = 'Update'
                    INSERT INTO [users_logging] ([event_type], [timestamp], [user_id], [old_username], [new_username], [old_email], [new_email], [old_password], [new_password])
                         SELECT @action, @timestamp, [id],
                                [username], (SELECT [username]  FROM [inserted] WHERE [username] <> [deleted].[username]),
                                [email],    (SELECT [email]     FROM [inserted] WHERE [email]    <> [deleted].[email]),
                                [password], (SELECT [password]  FROM [inserted] WHERE [password] <> [deleted].[password])
                           FROM [deleted];
           END
GO