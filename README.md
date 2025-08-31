
# Database Normalization: Airbnb Database Schema

## Objective
To ensure the Airbnb database schema adheres to the principles of **Third Normal Form (3NF)** by eliminating redundancy and ensuring data integrity.

---

## Normalization Overview

### First Normal Form (1NF)
- **Definition**: A table is in 1NF if it contains only atomic (indivisible) values and each record is unique.
- **Steps Taken**:
  - Removed repeating groups and ensured each column holds only one value.
  - Ensured each table has a primary key to uniquely identify records.

### Second Normal Form (2NF)
- **Definition**: A table is in 2NF if it is in 1NF and all non-key attributes are fully functionally dependent on the entire primary key.
- **Steps Taken**:
  - Identified composite keys and removed partial dependencies.
  - Separated user contact details into a separate table to avoid partial dependency on user ID.

### Third Normal Form (3NF)
- **Definition**: A table is in 3NF if it is in 2NF and all attributes are only dependent on the primary key (no transitive dependencies).
- **Steps Taken**:
  - Removed transitive dependencies by creating separate tables for related entities:
    - Created a `PaymentMethod` table to store payment type details instead of storing them in the `Booking` table.
    - Created a `Location` table to store city and country information instead of duplicating them in the `Property` table.
    - Created a `PropertyType` table to store types of properties (e.g., apartment, house).

---

## Example Adjustments

### Before Normalization

**Property Table**
| property_id | name         | city       | country    | type       | price |
|-------------|--------------|------------|------------|------------|-------|
| 1           | Cozy Loft    | New York   | USA        | Apartment  | 120   |
| 2           | Beach House  | Miami      | USA        | House      | 200   |
| 3           | City Studio  | Toronto    | Canada     | Studio     | 100   |

- Redundancy: Repeated city, country, and type values across multiple rows.

### After Normalization

**Property Table**
| property_id | name         | location_id | type_id | price |
|-------------|--------------|-------------|---------|-------|
| 1           | Cozy Loft    | 1           | 1       | 120   |
| 2           | Beach House  | 2           | 2       | 200   |
| 3           | City Studio  | 3           | 3       | 100   |

**Location Table**
| location_id | city       | country |
|-------------|------------|---------|
| 1           | New York   | USA     |
| 2           | Miami      | USA     |
| 3           | Toronto    | Canada  |

**PropertyType Table**
| type_id | type      |
|---------|-----------|
| 1       | Apartment |
| 2       | House     |
| 3       | Studio    |

- Normalized: Eliminated redundancy by referencing foreign keys to `Location` and `PropertyType` tables.
