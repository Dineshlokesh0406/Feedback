# Feedback Management System

This is an Eclipse Dynamic Web Project for Apache Tomcat 9, Java 17, and MySQL.

## Setup after cloning

1. Install JDK 17, Apache Tomcat 9, and MySQL.
2. In Eclipse, import the folder as an existing project.
3. Add a Tomcat 9 runtime in `Window > Preferences > Server > Runtime Environments`.
4. Run `schema.sql` in MySQL to create the `feedback_db` database and the default admin user.
5. Confirm the MySQL credentials in `src/main/java/fms/DBConnection.java`.
   The default values are:

   ```text
   URL: jdbc:mysql://localhost:3306/feedback_db
   username: root
   password: password
   ```

   You can also override them in Tomcat VM arguments:

   ```text
   -Ddb.url=jdbc:mysql://localhost:3306/feedback_db
   -Ddb.username=root
   -Ddb.password=your_mysql_password
   ```

6. Clean and rebuild the project, then run it on Tomcat.

Default admin login:

```text
username: admin@fms.com
password: admin123
```

If Eclipse shows errors like `String cannot be resolved to a type` or `Object cannot be resolved`, check that the project is using JDK 17 in `Project > Properties > Java Build Path`.
