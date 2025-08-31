
# Normalization to 3NF

This document explains how the Airbnb-like schema was normalized from an initial conceptual model to **Third Normal Form (3NF)**.

## 0. Informal Functional Dependencies
- **USERS**: `email → (first_name, last_name, phone, role, password_hash)`; surrogate `id` is the PK.
- **PROPERTIES**: `id → (host_id, title, description, type, counts, pricing, currency, address_id)`; host is a user.
- **ADDRESSES**: `id → (line1, line2, city, state, postal_code, country_code)`.
- **AMENITIES**: `name → category`; surrogate `id` is the PK; `name` is unique.
- **PROPERTY_AMENITIES**: `(property_id, amenity_id) → ( )` (pure bridge table).
- **PROPERTY_IMAGES**: `id → (property_id, url, is_cover, position)`; `(property_id, position)` is also unique.
- **BOOKINGS**: `id → (property_id, guest_id, check_in, check_out, guests_count, status, total_amount, currency)`; `period` is a generated column.
- **PAYMENTS**: `id → (booking_id, method, status, amount, currency, transaction_ref, paid_at)`; `transaction_ref` is unique.
- **REVIEWS**: `id → (booking_id, property_id, author_user_id, rating, comment)`; `(booking_id, author_user_id)` unique.
- **FAVORITES**: `(user_id, property_id) → created_at`.

## 1. First Normal Form (1NF)
- All tables have atomic values (no repeating groups or arrays); for many-to-many (property amenities) we use a junction table.
- Images are one-per-row; amenities are one-per-row; phone numbers and emails are scalars.

## 2. Second Normal Form (2NF)
- Every non-key attribute depends on the **whole key**.
- Composite keys exist only in bridge tables (`PROPERTY_AMENITIES`, `FAVORITES`), where there are no additional non-key attributes besides `created_at` in `FAVORITES` (which depends on the full composite key).

## 3. Third Normal Form (3NF)
- Removed **transitive dependencies**:
  - Address attributes (`city`, `country_code`, etc.) are separated into **ADDRESSES**, referenced by **PROPERTIES**.
  - Amenity `category` depends on `amenity` not on `property`, so it stays in **AMENITIES**.
- No non-key attribute depends on another non-key attribute within a table.

## Additional Integrity & Performance Measures
- **Unique constraints** on natural keys: `users.email`, `amenities.name`, `(property_id, position)` on images.
- **Foreign key indexes** created to speed up joins and cascades.
- **Exclusion constraint** prevents overlapping confirmed bookings per property using `GiST` on a generated `daterange`.
- **ENUMs** constrain allowed values while being storage- and performance-friendly in PostgreSQL.

## Trade-offs Considered
- Storing `currency` as `CHAR(3)` (ISO 4217) in several tables avoids a separate lookup and eases reporting; a lookup can be added later.
- Reviews are tied to a booking and property for accountability (prevents reviews without stays).
- Messages/inbox are omitted to keep scope focused, but can be added without violating normalization.
