# Emergency Blood and Donor Allocation System

## Completion status

The project includes the seven-table MySQL database, sample data, constraints, views, indexes, triggers, stored procedure, Flask backend, responsive frontend, database-backed login, two roles, and end-to-end browser testing.

## Role-based access

`Admin` users can register hospitals and manage the operational workflow. `Hospital` users can create requests, find compatible donors, allocate donors, and update allocation status. Accounts are stored in `App_Users` and passwords are stored as hashes.

Run `07_users.sql` after the existing database scripts, then create accounts using the password-hash helper in `README.md`.

## Evidence already available

The supplied PDF contains the Chen ER diagram, entity/relationship legend, seven-table relational schema, DDL/DML execution evidence, index/view evidence, and database screenshots. The Flask dashboard screenshots demonstrate the application workflow.

## Scope note

The supplied course template mentions Next.js and a NoSQL/vector database, while this project request explicitly specifies Flask and MySQL. The delivered implementation follows the project request and its existing database structure.
