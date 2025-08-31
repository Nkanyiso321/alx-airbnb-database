
-- Create User table
CREATE TABLE User (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Property table
CREATE TABLE Property (
    id SERIAL PRIMARY KEY,
    owner_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    location VARCHAR(255),
    price_per_night DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES User(id) ON DELETE CASCADE
);

-- Create Booking table
CREATE TABLE Booking (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    property_id INTEGER NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (property_id) REFERENCES Property(id) ON DELETE CASCADE
);

-- Create Payment table
CREATE TABLE Payment (
    id SERIAL PRIMARY KEY,
    booking_id INTEGER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50),
    status VARCHAR(50) DEFAULT 'completed',
    FOREIGN KEY (booking_id) REFERENCES Booking(id) ON DELETE CASCADE
);

-- Create indexes for performance optimization
CREATE INDEX idx_user_email ON User(email);
CREATE INDEX idx_property_location ON Property(location);
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);
CREATE INDEX idx_payment_status ON Payment(status);
