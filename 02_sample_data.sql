-- Sample data. pending_fees is intentionally omitted; Oracle calculates it.

INSERT INTO STUDENTS (student_id, student_name, course_name, total_fees, paid_fees)
VALUES (101, 'Umang Kumar Singh', 'MCA', 85000, 50000);
INSERT INTO STUDENTS (student_id, student_name, course_name, total_fees, paid_fees)
VALUES (102, 'Priya Patel', 'MCA', 85000, 85000);
INSERT INTO STUDENTS (student_id, student_name, course_name, total_fees, paid_fees)
VALUES (103, 'Amit Verma', 'BCA', 60000, 0);
INSERT INTO STUDENTS (student_id, student_name, course_name, total_fees, paid_fees)
VALUES (104, 'Sneha Kumar', 'MBA', 95000, 40000);
INSERT INTO STUDENTS (student_id, student_name, course_name, total_fees, paid_fees)
VALUES (105, 'Rohan Gupta', 'B.Tech CSE', 120000, 60000);

INSERT INTO FEE_PAYMENTS (payment_id, student_id, payment_amount, payment_date, payment_mode)
VALUES (1, 101, 50000, DATE '2026-08-01', 'UPI');
INSERT INTO FEE_PAYMENTS (payment_id, student_id, payment_amount, payment_date, payment_mode)
VALUES (2, 102, 85000, DATE '2026-08-02', 'Bank Transfer');
INSERT INTO FEE_PAYMENTS (payment_id, student_id, payment_amount, payment_date, payment_mode)
VALUES (3, 104, 40000, DATE '2026-08-03', 'Cash');
INSERT INTO FEE_PAYMENTS (payment_id, student_id, payment_amount, payment_date, payment_mode)
VALUES (4, 105, 60000, DATE '2026-08-04', 'UPI');

COMMIT;

SELECT student_id, student_name, total_fees, paid_fees, pending_fees
FROM STUDENTS
ORDER BY student_id;
