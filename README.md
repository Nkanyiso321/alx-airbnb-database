
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

- 
-- Create table for Users
CREATE TABLE User (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for Property Types
CREATE TABLE PropertyType (
    id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) UNIQUE NOT NULL
);

-- Create table for Locations
CREATE TABLE Location (
    id SERIAL PRIMARY KEY,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20)
);

-- Create table for Properties
CREATE TABLE Property (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    property_type_id INTEGER NOT NULL,
    location_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    price_per_night DECIMAL(10, 2) NOT NULL,
    max_guests INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id),
    FOREIGN KEY (property_type_id) REFERENCES PropertyType(id),
    FOREIGN KEY (location_id) REFERENCES Location(id)
);

-- Create table for Bookings
CREATE TABLE Booking (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    property_id INTEGER NOT NULL,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    guests INTEGER NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id),
    FOREIGN KEY (property_id) REFERENCES Property(id)
);

-- Create table for Payments
CREATE TABLE Payment (
    id SERIAL PRIMARY KEY,
    booking_id INTEGER NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES Booking(id)
);

-- Create indexes for performance
CREATE INDEX idx_user_email ON User(email);
CREATE INDEX idx_property_location ON Property(location_id);
CREATE INDEX idx_booking_dates ON Booking(check_in, check_out);


