
# Airbnb Database Schema

This schema defines the structure of a relational database for an Airbnb-like application. It includes tables for users, properties, bookings, payments, locations, and property types.

## Tables and Relationships

### User
Stores user information including name, email, and password. Each user can list multiple properties and make multiple bookings.

### PropertyType
Defines types of properties (e.g., apartment, house, villa). Used to categorize properties.

### Location
Stores location details including city, state, country, and postal code. Each property is associated with one location.

### Property
Represents a property listed by a user. Includes details like title, description, price, and maximum guests. Linked to a user, property type, and location.

### Booking
Represents a booking made by a user for a property. Includes check-in/check-out dates, number of guests, and total price.

### Payment
Stores payment details for a booking including amount, method, and status.

## Indexes
Indexes are created on frequently queried columns such as:
- `User.email` for quick user lookup
- `Property.location_id` for location-based searches
- `Booking.check_in`, `Booking.check_out` for date-based queries

## Constraints
- Primary keys ensure unique identification of records.
- Foreign keys enforce referential integrity between related tables.
- Unique constraints on email and property type name prevent duplicates.

