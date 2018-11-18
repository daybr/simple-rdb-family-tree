/* 친가 부계의 root가 속한 mate PID 찾기 */
CREATE OR REPLACE FUNCTION SPEAR_LINE_ROOT_OF_FA (
        START_HID IN HUMAN.HID%TYPE
    )
    RETURN PARENTS.PID%TYPE
IS
    CURSOR cur IS SELECT LEVEL, H.HID AS HID, H.PID AS PID, P.FHID AS FHID, P.MHID AS MHID
        FROM HUMAN H LEFT OUTER JOIN PARENTS P ON (H.PID = P.PID)
        START WITH HID = START_HID
        CONNECT BY NOCYCLE PRIOR FHID = HID OR (FHID IS NULL AND PRIOR MHID = HID)
        ORDER BY LEVEL DESC;
    temp_level NUMBER;
    temp_hid HUMAN.HID%TYPE;
    root_pid PARENTS.PID%TYPE;
    temp_fhid HUMAN.HID%TYPE;
    temp_mhid HUMAN.HID%TYPE;
BEGIN
    root_pid := NULL;
    OPEN cur;
        FETCH cur INTO temp_level, temp_hid, root_pid, temp_fhid, temp_mhid;
        IF NOT cur%NOTFOUND THEN
            FETCH cur INTO temp_level, temp_hid, root_pid, temp_fhid, temp_mhid;
        END IF;
    CLOSE cur;
    RETURN root_pid;
END;
/

SELECT HID, SPEAR_LINE_ROOT_OF_FA(HID) AS ROOT_MATE_P_PID
    FROM HUMAN
    WHERE NAME = '여자';
