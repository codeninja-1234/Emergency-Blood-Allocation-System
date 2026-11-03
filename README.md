# Emergency Blood & Donor Allocation System

## Project Overview

This project manages emergency blood requests, donor information, blood-group compatibility, donor allocations and notifications. It helps identify available donors compatible with hospital blood requirements.

## Database Information

- Database: blood_bank_db
- DBMS: MySQL
- Core tables: 7
- Normalization objective: 3NF/BCNF

## Database Tables

1. Hospitals – Stores hospital details and location information.
2. Donors – Stores donor information, blood groups and availability.
3. Emergency_Requests – Stores hospital blood requests and urgency levels.
4. Allocations – Records donor assignments against requests.
5. Blood_Matrix – Stores donor-recipient blood-group compatibility.
6. Donation_History – Maintains previous donation records.
7. Notifications – Stores notification details.

## Views

- View_Available_Donors
- View_Request_Details
- View_Allocation_Details

## Indexes

- idx_donor_match
- idx_request_status
- idx_allocation_request

## Triggers

- trg_after_allocation: Creates a notification after a new allocation.
- trg_donor_unavailable: Marks a donor unavailable when an allocation becomes Completed.

## Stored Procedure

sp_find_compatible_donors(p_request_id)

Finds available donors compatible with the blood group required by an emergency request, ordered by reliability.

Example:

    CALL sp_find_compatible_donors(1);

## SQL Files and Execution Order

1. database/01_schema.sql
2. database/02_sample_data.sql
3. database/04_views_indexes.sql
4. database/05_triggers.sql
5. database/06_procedures.sql
6. database/07_hardening.sql

Use database/03_queries.sql to test the SQL queries.

The files 04_database_objects.sql and 05_sample_data_backup.sql are backup files and are not part of the normal installation sequence.

Run 07_hardening.sql only once because it adds named constraints.

## Sample Data

| Table | Records |
|---|---:|
| Hospitals | 3 |
| Donors | 10 |
| Emergency_Requests | 4 |
| Allocations | 4 |
| Blood_Matrix | 64 |
| Donation_History | 4 |
| Notifications | 4 |

## Testing

The database has been tested for:

- Table creation and relationships
- Sample data insertion
- Blood-group compatibility
- SQL queries and joins
- Views and indexes
- Trigger execution
- Stored procedure execution
- Constraints and transaction rollback

## Project Scope

The database supports blood-group compatibility matching and donor availability tracking. It does not replace medical screening, clinical eligibility checks or crossmatching.

## Team Responsibilities

- Person 1: Database design, SQL implementation, database objects and testing.
- Person 2: Flask application, frontend/backend development and database integration.

