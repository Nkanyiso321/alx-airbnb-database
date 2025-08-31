
# alx-airbnb-database

Deliverables for **DataScape: Mastering Database Design** (ALX Airbnb Database Module).

## Structure
```
ERD/
  requirements.md
normalization.md

database-script-0x01/
  README.md
  schema.sql

database-script-0x02/
  README.md
  seed.sql
```

## Quickstart (PostgreSQL)
```bash
psql -v ON_ERROR_STOP=1 -f database-script-0x01/schema.sql
psql -v ON_ERROR_STOP=1 -f database-script-0x02/seed.sql
```

> If you need MySQL instead, open an issue or request a MySQL-compatible DDL; changes mainly include enums, generated columns, and the exclusion constraint.
