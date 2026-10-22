# Simplified Student Fee Management System — Automatic Pending Fees

A beginner-friendly Oracle SQL/PLSQL mini project. Oracle calculates pending fees automatically.

## Main idea
`pending_fees` is a **virtual generated column**:

```sql
pending_fees NUMBER(10,2)
  GENERATED ALWAYS AS (total_fees - paid_fees) VIRTUAL
```

You enter only `total_fees` and `paid_fees`. Oracle calculates `pending_fees` whenever you query the table. If `paid_fees` changes, the calculated pending amount changes automatically.

## Features
- Three tables: `STUDENTS`, `FEE_PAYMENTS`, `FEE_AUDIT`
- Automatic pending-fee calculation
- `CALCULATE_PENDING_FEES` function
- `ADD_STUDENT` and `RECORD_FEE_PAYMENT` procedures
- Explicit cursor report
- Audit trigger
- Basic exception handling

## Run order
Connect to Oracle SQL Developer. Open each script and press **F5 (Run Script)**:

1. `01_create_tables.sql`
2. `02_sample_data.sql`
3. `03_function.sql`
4. `04_procedures.sql`
5. `05_trigger.sql`
6. `06_reports_and_tests.sql`

Enable the DBMS Output panel for `DBMS_OUTPUT.PUT_LINE` messages.

## Test automatic calculation
After running the setup scripts, execute:

```sql
BEGIN
  RECORD_FEE_PAYMENT(101, 5000, 'UPI');
END;
/
```

Then query:

```sql
SELECT student_id, student_name, total_fees, paid_fees, pending_fees
FROM STUDENTS
WHERE student_id = 101;
```

For student 101, the starting values are total fees 85000, paid fees 50000, pending fees 35000. After a 5000 payment, paid fees become 55000 and pending fees become 30000.

You can also test directly:

```sql
UPDATE STUDENTS
SET paid_fees = 60000
WHERE student_id = 101;

SELECT total_fees, paid_fees, pending_fees
FROM STUDENTS
WHERE student_id = 101;

ROLLBACK;
```

The pending fee shown is calculated by Oracle; you never insert or update `pending_fees` directly.

## Important notes
- `01_create_tables.sql` drops and recreates the project's tables. It deletes existing data in those tables.
- The simple payment procedure uses `MAX(payment_id) + 1` to avoid introducing sequences into this beginner version. This is for a classroom mini project, not a production system.
- `FEE_AUDIT.audit_id` uses an identity column, supported by modern Oracle versions.
- The project is database-only and has no frontend.
