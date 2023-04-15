# Music Streaming Application

## Instructions to Run

- NOTE: Enable Database Output (View -> Database Output) in SQLDeveloper to view the data returned by SQL queries

### Scripts and their Functionalities (in Order of Execution)

1. SUPER ADMIN script
   - This script is run by the SUPER ADMIN  
   - It is used to create the Application Admin (APP_ADMIN), and grant them the sufficient grants and permissions to create roles and users

2. APP ADMIN - Tables
   - This script is run by the APP_ADMIN
   - It is used to create all the tables

3. APP ADMIN - Insert , update , delete Package
   - This script is run by the APP_ADMIN
  - It is used to create all the packages

4. APP_ADMIN - Insert values
   - This script is run by the APP_ADMIN
   - It is used to insert values into all the tables

5. APP ADMIN Views
   - This script is run by the APP_ADMIN
   - It is used to create all the views and display them

6. APP_ADMIN Roles and Users
   - This script is run by the APP_ADMIN
   - It is used to create the two user roles (ARTIST_ROLE & USER_ROLE), and create the respective artists and users

7. APP ADMIN Script for deletion testing
   - This script is run by the APP_ADMIN
   - It is used to display the reports and demo the delete procedures
  
8. Taylor
   - This script is run by the artist Taylor 
   - It is used to execute the artist actions

9. USER JOHN
    - This script is run by the user John
    - It is used to execute the user actions

