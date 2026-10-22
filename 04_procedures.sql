-- Add a student. pending_fees is calculated automatically.
CREATE OR REPLACE PROCEDURE ADD_STUDENT (
  p_student_id   IN NUMBER,
  p_student_name IN VARCHAR2,
  p_course_name  IN VARCHAR2,
  p_total_fees   IN NUMBER
)
IS
BEGIN
  IF p_total_fees <= 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'Total fees must be greater than zero.');
  END IF;

  INSERT INTO STUDENTS
    (student_id, student_name, course_name, total_fees, paid_fees)
  VALUES
    (p_student_id, p_student_name, p_course_name, p_total_fees, 0);

  DBMS_OUTPUT.PUT_LINE('Student added. Pending fees: ' || p_total_fees);
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    RAISE_APPLICATION_ERROR(-20003, 'This student ID already exists.');
END;
/

-- Record a payment. Oracle recalculates pending_fees automatically.
CREATE OR REPLACE PROCEDURE RECORD_FEE_PAYMENT (
  p_student_id     IN NUMBER,
  p_payment_amount IN NUMBER,
  p_payment_mode   IN VARCHAR2
)
IS
  v_pending    NUMBER(10,2);
  v_paid       NUMBER(10,2);
  v_payment_id NUMBER;
BEGIN
  IF p_payment_amount <= 0 THEN
    RAISE_APPLICATION_ERROR(-20004, 'Payment must be greater than zero.');
  END IF;

  SELECT paid_fees, pending_fees
  INTO v_paid, v_pending
  FROM STUDENTS
  WHERE student_id = p_student_id
  FOR UPDATE;

  IF p_payment_amount > v_pending THEN
    RAISE_APPLICATION_ERROR(-20005, 'Payment exceeds pending fees.');
  END IF;

  SELECT NVL(MAX(payment_id), 0) + 1
  INTO v_payment_id
  FROM FEE_PAYMENTS;

  INSERT INTO FEE_PAYMENTS
    (payment_id, student_id, payment_amount, payment_date, payment_mode)
  VALUES
    (v_payment_id, p_student_id, p_payment_amount, SYSDATE, p_payment_mode);

  UPDATE STUDENTS
  SET paid_fees = v_paid + p_payment_amount
  WHERE student_id = p_student_id;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Payment recorded successfully.');
  DBMS_OUTPUT.PUT_LINE('New paid fees: ' || (v_paid + p_payment_amount));
  DBMS_OUTPUT.PUT_LINE('New pending fees: ' || (v_pending - p_payment_amount));
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    ROLLBACK;
    RAISE_APPLICATION_ERROR(-20006, 'Student ID not found.');
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END;
/

SHOW ERRORS PROCEDURE ADD_STUDENT;
SHOW ERRORS PROCEDURE RECORD_FEE_PAYMENT;


-- Adding a student to test the procedures and trigger
EXEC ADD_STUDENT(107, 'Saurabh', 'MCA', 90000);

-- Adding a payment to test the trigger and procedures
EXEC RECORD_FEE_PAYMENT(107, 35000, 'UPI');