
# Seed Data (DML)

Populate the database with realistic sample data for development/testing.

## How to Run
1. Ensure the schema exists:
   ```bash
   psql -v ON_ERROR_STOP=1 -f ../database-script-0x01/schema.sql
   ```
2. Load seeds:
   ```bash
   psql -v ON_ERROR_STOP=1 -f seed.sql
   ```
