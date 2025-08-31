
-- Seed data for ALX Airbnb Database (PostgreSQL)
BEGIN;

-- Users
INSERT INTO users (email, password_hash, first_name, last_name, phone, role) VALUES
  ('host1@example.com', 'hashed_pw_1', 'Nomsa', 'Mthembu', '+27 82 000 0001', 'host'),
  ('host2@example.com', 'hashed_pw_2', 'Lebo', 'Mokoena', '+27 82 000 0002', 'host'),
  ('guest1@example.com', 'hashed_pw_3', 'Sipho', 'Dlamini', '+27 82 000 0003', 'guest'),
  ('guest2@example.com', 'hashed_pw_4', 'Thandi', 'Ndlovu', '+27 82 000 0004', 'guest'),
  ('admin@example.com',  'hashed_pw_5', 'Admin', 'User', '+27 82 000 0005', 'admin');

-- Addresses
INSERT INTO addresses (line1, line2, city, state, postal_code, country_code) VALUES
  ('12 Vilakazi St', NULL, 'Johannesburg', 'Gauteng', '1804', 'ZA'),
  ('101 Long St', NULL, 'Cape Town', 'Western Cape', '8000', 'ZA'),
  ('88 Florida Rd', NULL, 'Durban', 'KwaZulu-Natal', '4001', 'ZA');

-- Properties
INSERT INTO properties (host_id, title, description, type, room_count, bed_count, bath_count, max_guests, price_per_night, cleaning_fee, currency, address_id) VALUES
  (1, 'Soweto Heritage Home', 'Cozy home near Vilakazi Street, rich in culture.', 'house', 4, 3, 2, 6, 1200.00, 150.00, 'ZAR', 1),
  (2, 'City Bowl Apartment', 'Modern apartment with mountain views.', 'apartment', 2, 2, 1, 3, 1800.00, 200.00, 'ZAR', 2),
  (1, 'Durban Beach Room', 'Private room with sea breeze.', 'room', 1, 1, 1, 2, 800.00, 100.00, 'ZAR', 3);

-- Amenities
INSERT INTO amenities (name, category) VALUES
  ('Wi-Fi', 'Connectivity'),
  ('Air Conditioning', 'Climate'),
  ('Parking', 'Convenience'),
  ('Pool', 'Leisure'),
  ('Kitchen', 'Essentials'),
  ('Washer', 'Essentials')
ON CONFLICT DO NOTHING;

-- Property Amenities
INSERT INTO property_amenities (property_id, amenity_id) VALUES
  (1, 1), (1, 3), (1, 5),
  (2, 1), (2, 2), (2, 5), (2, 6),
  (3, 1), (3, 5);

-- Property Images
INSERT INTO property_images (property_id, url, is_cover, position) VALUES
  (1, 'https://example.com/img/soweto_cover.jpg', TRUE, 1),
  (1, 'https://example.com/img/soweto_lounge.jpg', FALSE, 2),
  (2, 'https://example.com/img/ct_cover.jpg', TRUE, 1),
  (3, 'https://example.com/img/durban_cover.jpg', TRUE, 1);

-- Bookings
-- Use relative dates for reproducibility: assume today at runtime, but here we pick concrete dates
INSERT INTO bookings (property_id, guest_id, check_in, check_out, guests_count, status, total_amount, currency) VALUES
  (1, 3, DATE '2025-09-10', DATE '2025-09-14', 2, 'confirmed', 1200.00*4 + 150.00, 'ZAR'),
  (2, 4, DATE '2025-10-01', DATE '2025-10-05', 2, 'pending',   1800.00*4 + 200.00, 'ZAR'),
  (3, 3, DATE '2025-08-20', DATE '2025-08-22', 1, 'completed',  800.00*2 + 100.00, 'ZAR');

-- Payments
INSERT INTO payments (booking_id, method, status, amount, currency, transaction_ref, paid_at) VALUES
  (1, 'card', 'completed',  4800.00 + 150.00, 'ZAR', 'TXN-20250901-ABC', '2025-09-01T10:00:00+02'),
  (3, 'card', 'completed',  1600.00 + 100.00, 'ZAR', 'TXN-20250815-XYZ', '2025-08-15T09:30:00+02');

-- Reviews (only for completed bookings by the author)
INSERT INTO reviews (booking_id, property_id, author_user_id, rating, comment) VALUES
  (3, 3, 3, 5, 'Amazing seaside stay, very clean and comfy!');

-- Favorites
INSERT INTO favorites (user_id, property_id) VALUES
  (3, 2), (4, 1);

COMMIT;
