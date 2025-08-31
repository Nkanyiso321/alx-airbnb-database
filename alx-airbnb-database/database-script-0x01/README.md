
# Database Schema (DDL)

**DBMS:** PostgreSQL 14+

## How to Run
```bash
psql -v ON_ERROR_STOP=1 -f schema.sql
```

This creates all tables, constraints, enums, and indexes. It also adds an exclusion constraint that prevents overlapping **confirmed** bookings per property.
