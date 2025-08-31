
# ERD Requirements — ALX Airbnb Database

This ERD models an Airbnb-like system. It covers users (hosts/guests), properties, amenities, bookings, payments, reviews, images, and favorites.

> **Assumption**: PostgreSQL 14+ is used. One user can be both a host and a guest.

## Mermaid ER Diagram
```mermaid
erDiagram
    USERS ||--o{ PROPERTIES : "hosts"
    USERS ||--o{ BOOKINGS : "makes"
    USERS ||--o{ REVIEWS : "writes"
    USERS ||--o{ FAVORITES : "saves"

    PROPERTIES ||--|| ADDRESSES : "located at"
    PROPERTIES ||--o{ PROPERTY_IMAGES : "has"
    PROPERTIES ||--o{ BOOKINGS : "booked in"
    PROPERTIES ||--o{ REVIEWS : "gets"
    PROPERTIES ||--o{ PROPERTY_AMENITIES : "offers"

    AMENITIES ||--o{ PROPERTY_AMENITIES : "tagged by"

    BOOKINGS ||--o{ PAYMENTS : "paid via"
    BOOKINGS ||--o| REVIEWS : "one per booking by author"

    USERS {
      bigint id PK
      text email UNIQUE
      text password_hash
      text first_name
      text last_name
      text phone
      user_role role
      timestamptz created_at
    }

    PROPERTIES {
      bigint id PK
      bigint host_id FK -> USERS.id
      text title
      text description
      property_type type
      int room_count
      int bed_count
      int bath_count
      int max_guests
      numeric price_per_night
      numeric cleaning_fee
      char(3) currency
      bigint address_id FK -> ADDRESSES.id
      timestamptz created_at
    }

    ADDRESSES {
      bigint id PK
      text line1
      text line2
      text city
      text state
      text postal_code
      char(2) country_code
    }

    PROPERTY_IMAGES {
      bigint id PK
      bigint property_id FK -> PROPERTIES.id
      text url
      bool is_cover
      int position
      timestamptz created_at
    }

    AMENITIES {
      int id PK
      text name UNIQUE
      text category
    }

    PROPERTY_AMENITIES {
      bigint property_id FK -> PROPERTIES.id
      int amenity_id FK -> AMENITIES.id
      PK (property_id, amenity_id)
    }

    BOOKINGS {
      bigint id PK
      bigint property_id FK -> PROPERTIES.id
      bigint guest_id FK -> USERS.id
      date check_in
      date check_out
      int guests_count
      booking_status status
      numeric total_amount
      char(3) currency
      daterange period GENERATED
      timestamptz created_at
    }

    PAYMENTS {
      bigint id PK
      bigint booking_id FK -> BOOKINGS.id
      payment_method method
      payment_status status
      numeric amount
      char(3) currency
      text transaction_ref UNIQUE
      timestamptz paid_at
      timestamptz created_at
    }

    REVIEWS {
      bigint id PK
      bigint booking_id FK -> BOOKINGS.id
      bigint property_id FK -> PROPERTIES.id
      bigint author_user_id FK -> USERS.id
      int rating
      text comment
      timestamptz created_at
    }

    FAVORITES {
      bigint user_id FK -> USERS.id
      bigint property_id FK -> PROPERTIES.id
      timestamptz created_at
      PK (user_id, property_id)
    }
```

## Notes
- A property has exactly one address (1–1). If you prefer, you can inline address fields into `properties`, but this breaks 3NF when reusing addresses.
- We prevent overlapping **confirmed** bookings for the same property using a PostgreSQL exclusion constraint.
- `role`, `booking_status`, `payment_status`, `payment_method`, and `property_type` are implemented as PostgreSQL `ENUM`s in `schema.sql`.

