SET SERVEROUTPUT ON;

-- 1. Student fee status: pending_fees is calculated automatically.
SELECT student_id, student_name, course_name, total_fees, paid_fees, pending_fees
FROM STUDENTS
ORDER BY student_id;

-- 2. Explicit cursor: list students with pending fees.
DECLARE
  CURSOR c_pending IS
    SELECT student_id, student_name, pending_fees
    FROM STUDENTS
    WHERE pending_fees > 0
    ORDER BY pending_fees DESC;
BEGIN
  DBMS_OUTPUT.PUT_LINE('STUDENTS WITH PENDING FEES');
  FOR r IN c_pending LOOP
    DBMS_OUTPUT.PUT_LINE(r.student_id || ' - ' || r.student_name ||
                         ' - Pending: Rs. ' || r.pending_fees);
  END LOOP;
END;
/

-- 3. Try a payment in a separate worksheet:
-- BEGIN
--   RECORD_FEE_PAYMENT(101, 5000, 'UPI');
-- END;
-- /
-- Then run the student SELECT above again.

-- 4. Payment history
SELECT * FROM FEE_PAYMENTS ORDER BY payment_date, payment_id;

-- 5. Audit log
SELECT * FROM FEE_AUDIT ORDER BY audit_id;

-- 6. Fee summary
SELECT SUM(total_fees) AS total_fees,
       SUM(paid_fees) AS collected_fees,
       SUM(pending_fees) AS pending_fees
FROM STUDENTS;
