
# Normalization Process for Airbnb-like Database Design

## Objective
To ensure the database schema is optimized for data integrity and minimal redundancy, we apply normalization principles up to the Third Normal Form (3NF).

---

## Step 1: First Normal Form (1NF)

**Definition:**  
A table is in 1NF if:
- It contains only atomic (indivisible) values.
- Each record is unique.

**Application:**  
All entities (User, Property, Booking, Payment) have atomic attributes:
- `User`: name, email, password
- `Property`: title, description, location
- `Booking`: start_date, end_date, status
- `Payment`: amount, payment_date, method

No repeating groups or arrays are present.

---

## Step 2: Second Normal Form (2NF)

**Definition:**  
A table is in 2NF if:
- It is in 1NF.
- All non-key attributes are fully functionally dependent on the entire primary key.

**Application:**  
Each table has a single-column primary key:
- `User`: user_id
- `Property`: property_id
- `Booking`: booking_id
- `Payment`: payment_id

No partial dependencies exist since no composite keys are used.

---

## Step 3: Third Normal Form (3NF)

**Definition:**  
A table is in 3NF if:
- It is in 2NF.
- No transitive dependencies exist (non-key attributes do not depend on other non-key attributes).

**Application:**  
All attributes depend only on the primary key:
- In `Booking`, `status` depends only on `booking_id`.
- In `Payment`, `status` and `method` depend only on `payment_id`.

No derived or calculated fields are stored, and no transitive dependencies are present.

---

## Example of Normalization

### Unnormalized Booking Table:
| booking_id | user_name | property_title | start_date | end_date |
|------------|-----------|----------------|------------|----------|

### Normalized:
- `User` table: user_id, name
- `Property` table: property_id, title
- `Booking` table: booking_id, user_id, property_id, start_date, end_date

---

## Conclusion

The database schema adheres to 3NF, ensuring:
- Elimination of redundancy
- Improved data integrity
- Efficient query performance

This normalization supports scalability and maintainability for the Airbnb-like application.
