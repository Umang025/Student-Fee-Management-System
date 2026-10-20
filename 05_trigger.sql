-- Audit changes to paid_fees. pending_fees is calculated from total_fees - paid_fees.

CREATE OR REPLACE TRIGGER TRG_FEE_AUDIT
AFTER UPDATE OF paid_fees ON STUDENTS
FOR EACH ROW
WHEN (OLD.paid_fees <> NEW.paid_fees)
BEGIN
  INSERT INTO FEE_AUDIT
    (student_id, old_paid_fees, new_paid_fees, old_pending_fees, new_pending_fees)
  VALUES
    (:NEW.student_id, :OLD.paid_fees, :NEW.paid_fees,
     :OLD.total_fees - :OLD.paid_fees, :NEW.total_fees - :NEW.paid_fees);
END;
/

SHOW ERRORS TRIGGER TRG_FEE_AUDIT;
