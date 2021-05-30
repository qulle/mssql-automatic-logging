-- Author: Qulle 2021-05-19
-- Github: github.com/qulle/mssql-automatic-logging
-- Editor: vscode

-- Select the target database
USE [TRIGGER_BASED_LOGGING_001];

GO

-- Populate table with data
INSERT INTO [users]([username], [email], [full_name], [password])
     VALUES ('alamoo01', 'alamoo01@hogwarts.org', 'Alasto, Moody',       '039ade0efb0bf8c832bc4aed16d86167be58565639f955ba610e56729bf01646'),
            ('remlup01', 'remlup01@hogwarts.org', 'Remus, Lupin',        '8bc1d53cc57c24b79bf7c260b1f3b29973caab7b8f501c33016b321ebfc274f1'),
            ('sirbla01', 'sirbla01@hogwarts.org', 'Sirius, Black',       'ed1a5a81b8121ad13a8796e7a7eb113f25d5b18b0a3831bae13d697ba5dae38b'),
            ('nymton01', 'nymton01@hogwarts.org', 'Nymphadora, Tonks',   '08b041935798fbf6fd6ff51099ffedb140a475889986d14f5559ff8e7fc571dd'),
            ('minmcg01', 'minmcg01@hogwarts.org', 'Minerva, McGonagall', '1666bb03f9809917be837c55606c3b1d19d2009f9aa0719b317881b2c8ba3aac');

GO

-- Since the trigger will check what values that differs between the inserted and deleted tables 
-- only the updated fields will be logged, making the log easier to read.

-- Update email
UPDATE [users]
   SET [email]    = 'madeye@hogwarts.org'
 WHERE [username] = 'alamoo01';

-- Update password
UPDATE [users]
   SET [password] = 'f6cf7f88816a2ec9b06d512d87224c0a7e04f4bc9b0acefbe837af735b4c78e9'
 WHERE [username] = 'minmcg01';

-- Update email and username
UPDATE [users]
   SET [email]    = 'animagus@hogwarts.org',
       [username] = 'animagus'
 WHERE [username] = 'sirbla01';

-- Delete user
DELETE FROM [users] 
      WHERE [username] = 'remlup01';

-- Display the users table and the log
SELECT * FROM [users];
SELECT * FROM [users_logging];