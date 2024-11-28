# FPT SHOP RESTful API using Spring Boot

This project is a RESTful API for the FPT SHOP system, built with Spring Boot. It provides functionalities such as creating, updating, deleting, and querying data from an SQL Server database.

## How to Run the Project

## 1. Clone the Project from Git

Clone this repository to your local machine using the following command:

```bash
git clone <https://github.com/tantruongdev/fptshop>
```

## 2. Set Up the Database

- Run the `BTL_CreateTable.sql` and `Insert_delete_update.sql` scripts to create tables and insert initial data in SQL Server.
- Create a new SQL Server user:
  - **Username**: `Username`
  - **Password**: `Username`
- Ensure this user has full access to the created database.

## 3. Configure Application Properties

In `src/main/resources/application.properties`, set the following:

```properties
spring.datasource.url=jdbc:sqlserver://localhost:1433;databaseName=your_database_name
spring.datasource.username=Username
spring.datasource.password=Password
spring.jpa.hibernate.ddl-auto=update
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.SQLServerDialect
```

## 4. Run the Application
- Open the project in Visual Studio Code (VSC).

- Install the Java Extension Pack and Spring Boot Extension Pack in VSC.

- Press F5 or use the terminal to run the app:

```bash
mvn spring-boot:run
```

The application will start on port 8080 by default.

## Prerequisites
- Java 17
- Visual Studio Code (VSC)
- SQL Server