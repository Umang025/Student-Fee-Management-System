-- Returns automatically calculated pending fees for a student.

CREATE OR REPLACE FUNCTION CALCULATE_PENDING_FEES (
  p_student_id IN NUMBER
) RETURN NUMBER
IS
  v_pending NUMBER(10,2);
BEGIN
  SELECT pending_fees
  INTO v_pending
  FROM STUDENTS
  WHERE student_id = p_student_id;

  RETURN v_pending;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001, 'Student ID not found.');
END;
/

SHOW ERRORS FUNCTION CALCULATE_PENDING_FEES;

SELECT student_id, student_name,
       CALCULATE_PENDING_FEES(student_id) AS pending_fees
FROM STUDENTS
ORDER BY student_id;
