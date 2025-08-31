
-- Schema for ALX Airbnb Database (PostgreSQL 14+)
-- Run with: psql -v ON_ERROR_STOP=1 -f schema.sql

BEGIN;

-- Extensions for advanced constraints and UUIDs (optional)
CREATE EXTENSION IF NOT EXISTS btree_gist; -- for exclusion constraint with equality

-- =========================
-- ENUM types
-- =========================
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_role') THEN
    CREATE TYPE user_role AS ENUM ('guest','host','admin');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'property_type') THEN
    CREATE TYPE property_type AS ENUM ('apartment','house','room','villa','other');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'booking_status') THEN
    CREATE TYPE booking_status AS ENUM ('pending','confirmed','cancelled','completed');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'payment_status') THEN
    CREATE TYPE payment_status AS ENUM ('pending','completed','failed','refunded');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'payment_method') THEN
    CREATE TYPE payment_method AS ENUM ('card','paypal','bank_transfer');
  END IF;
END $$;

-- =========================
-- Tables
-- =========================
CREATE TABLE IF NOT EXISTS users (
  id               BIGSERIAL PRIMARY KEY,
  email            TEXT NOT NULL UNIQUE,
  password_hash    TEXT NOT NULL,
  first_name       TEXT NOT NULL,
  last_name        TEXT NOT NULL,
  phone            TEXT,
  role             user_role NOT NULL DEFAULT 'guest',
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS addresses (
  id             BIGSERIAL PRIMARY KEY,
  line1          TEXT NOT NULL,
  line2          TEXT,
  city           TEXT NOT NULL,
  state          TEXT,
  postal_code    TEXT,
  country_code   CHAR(2) NOT NULL
);

CREATE TABLE IF NOT EXISTS properties (
  id               BIGSERIAL PRIMARY KEY,
  host_id          BIGINT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  title            TEXT NOT NULL,
  description      TEXT,
  type             property_type NOT NULL,
  room_count       INT NOT NULL DEFAULT 1 CHECK (room_count >= 0),
  bed_count        INT NOT NULL DEFAULT 1 CHECK (bed_count >= 0),
  bath_count       INT NOT NULL DEFAULT 1 CHECK (bath_count >= 0),
  max_guests       INT NOT NULL CHECK (max_guests > 0),
  price_per_night  NUMERIC(10,2) NOT NULL CHECK (price_per_night >= 0),
  cleaning_fee     NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (cleaning_fee >= 0),
  currency         CHAR(3) NOT NULL,
  address_id       BIGINT UNIQUE REFERENCES addresses(id) ON DELETE SET NULL,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS amenities (
  id         SERIAL PRIMARY KEY,
  name       TEXT NOT NULL UNIQUE,
  category   TEXT
);

CREATE TABLE IF NOT EXISTS property_amenities (
  property_id   BIGINT NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  amenity_id    INT NOT NULL REFERENCES amenities(id) ON DELETE CASCADE,
  PRIMARY KEY (property_id, amenity_id)
);

CREATE TABLE IF NOT EXISTS property_images (
  id            BIGSERIAL PRIMARY KEY,
  property_id   BIGINT NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  url           TEXT NOT NULL,
  is_cover      BOOLEAN NOT NULL DEFAULT FALSE,
  position      INT NOT NULL DEFAULT 1 CHECK (position > 0),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (property_id, position)
);

CREATE TABLE IF NOT EXISTS bookings (
  id            BIGSERIAL PRIMARY KEY,
  property_id   BIGINT NOT NULL REFERENCES properties(id) ON DELETE RESTRICT,
  guest_id      BIGINT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  check_in      DATE NOT NULL,
  check_out     DATE NOT NULL,
  guests_count  INT NOT NULL CHECK (guests_count > 0),
  status        booking_status NOT NULL DEFAULT 'pending',
  total_amount  NUMERIC(10,2) NOT NULL CHECK (total_amount >= 0),
  currency      CHAR(3) NOT NULL,
  period        DATERANGE GENERATED ALWAYS AS (daterange(check_in, check_out, '[]')) STORED,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CHECK (check_in < check_out)
);

-- Prevent overlapping confirmed bookings for the same property
CREATE INDEX IF NOT EXISTS idx_bookings_property_id ON bookings(property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_guest_id ON bookings(guest_id);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'no_overlap_confirmed_bookings'
  ) THEN
    ALTER TABLE bookings
    ADD CONSTRAINT no_overlap_confirmed_bookings
    EXCLUDE USING gist (
      property_id WITH =,
      period WITH &&
    ) WHERE (status = 'confirmed');
  END IF;
END $$;

CREATE TABLE IF NOT EXISTS payments (
  id               BIGSERIAL PRIMARY KEY,
  booking_id       BIGINT NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
  method           payment_method NOT NULL,
  status           payment_status NOT NULL DEFAULT 'pending',
  amount           NUMERIC(10,2) NOT NULL CHECK (amount >= 0),
  currency         CHAR(3) NOT NULL,
  transaction_ref  TEXT UNIQUE,
  paid_at          TIMESTAMPTZ,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_payments_booking_id ON payments(booking_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(status);

CREATE TABLE IF NOT EXISTS reviews (
  id               BIGSERIAL PRIMARY KEY,
  booking_id       BIGINT NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
  property_id      BIGINT NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  author_user_id   BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  rating           INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment          TEXT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (booking_id, author_user_id)
);

CREATE INDEX IF NOT EXISTS idx_reviews_property_id ON reviews(property_id);
CREATE INDEX IF NOT EXISTS idx_reviews_author_user_id ON reviews(author_user_id);

CREATE TABLE IF NOT EXISTS favorites (
  user_id        BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  property_id    BIGINT NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (user_id, property_id)
);

-- Helpful indexes for common lookups
CREATE INDEX IF NOT EXISTS idx_properties_host_id ON properties(host_id);
CREATE INDEX IF NOT EXISTS idx_properties_type ON properties(type);
CREATE INDEX IF NOT EXISTS idx_property_images_property_id ON property_images(property_id);
CREATE INDEX IF NOT EXISTS idx_property_amenities_amenity_id ON property_amenities(amenity_id);

COMMIT;
