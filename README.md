# Automatic logging using trigger MSSQL (T-SQL)
### Automatically log, insert, update and delete operations in a MSSQL-table without using any framework.

## Screenshot
![Screenshot of executed sql scripts](images/demo.png?raw=true "Screenshot of executed sql scripts")

## About the code
There are two files `Logging.DDL.sql` and `Logging.DML.sql`. 

Start by running the `Logging.DDL.sql`, the script will automatically create and use a database with the name `TRIGGER_BASED_LOGGING_001`. After that, run the script `Logging.DML.sql`, the script will populate the users table with data and display the result.

Since the trigger compare the content between the two built in temporary tables `inserted` and `deleted` only values that have been updated will be present in the logging table, making the log easier to read.

## SSMS
Connect to your local SQL instance, usually `.\SQLEXPRESS`, and open the DDL and DML scripts and execute them in that order using the New Query button. The result will be displayed after the second file is executed.

## SQLCMD
To run the scripts via sqlcmd enter the following commands \
DDL `sqlcmd -S .\SQLEXPRESS -i ./Logging.DDL.sql` \
DML `sqlcmd -S .\SQLEXPRESS -i ./Logging.DML.sql`

By default, without -E flag specified, sqlcmd uses the trusted connection option, the credentials of the current Windows user will be used.

The sqlcmd outputs the DML script in the cmd window. The output is kind of hard to read. In the next section a different cli tool is used that is inteded for interactive querys to be outputed to the cmd.

## MSSQL-CLI
The mssql-cli is an interactive command line query tool for SQL Server. This open source tool works cross-platform and are part of the dbcli community.
Follow the installation process [here](https://github.com/dbcli/mssql-cli#quick-start)

If you are using Windows (8 or 10) and have Python installed, run the command `python -m pip install mssql-cli` to install the mssql-cli.

To run the scripts via mssql-cli enter the following commands \
DDL `mssql-cli -E -S .\SQLEXPRESS -i ./Logging.DDL.sql` \
DML `mssql-cli -E -S .\SQLEXPRESS -i ./Logging.DML.sql`

By default the mssql-cli uses sa-user in mssql. To use the current Windows account, the -E flag is used. Apart from the -E flag the syntax is the same as for the sqlcmd.

Documentation for the mssql-cli tool can be found [here](https://github.com/dbcli/mssql-cli/blob/master/doc/usage_guide.md)

## Author
[Qulle](https://github.com/qulle/)