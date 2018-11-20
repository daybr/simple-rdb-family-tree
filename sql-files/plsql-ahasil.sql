/* 자신의 Mate_P PID 한 개 찾기 */
CREATE OR REPLACE FUNCTION GET_MATE_P_PID (
        TARGET_HID IN HUMAN.HID%TYPE
    )
    RETURN PARENTS.PID%TYPE
IS
    CURSOR cur IS SELECT P.PID
        FROM HUMAN H, PARENTS P
        WHERE H.HID = TARGET_HID AND (H.HID = P.FHID OR H.HID = P.MHID);
    mate_p_pid PARENTS.PID%TYPE;
BEGIN
    mate_p_pid := NULL;
    OPEN cur;
        FETCH cur INTO mate_p_pid;
    CLOSE cur;
    RETURN mate_p_pid;
END;
/

/* 친가 부계의 root가 속한 Mate_P PID 찾기 */
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
    root_mate_p_pid PARENTS.PID%TYPE;
    temp_fhid HUMAN.HID%TYPE;
    temp_mhid HUMAN.HID%TYPE;
BEGIN
    root_mate_p_pid := NULL;
    OPEN cur;
        /* ROOT ROW */
        FETCH cur INTO temp_level, temp_hid, root_mate_p_pid, temp_fhid, temp_mhid;
        IF NOT cur%NOTFOUND THEN
            /* UNDER-ROOT ROW: PID is MATE_P PID of ROOT! */
            FETCH cur INTO temp_level, temp_hid, root_mate_p_pid, temp_fhid, temp_mhid;
        ELSE
            /* Only one row exists */
            root_mate_p_pid := GET_MATE_P_PID(temp_hid);
        END IF;
    CLOSE cur;
    RETURN root_mate_p_pid;
END;
/

SELECT HID, NAME, SPEAR_LINE_ROOT_OF_FA(HID) AS ROOT_MATE_P_PID, GET_MATE_P_PID(HID)
    FROM HUMAN
    ORDER BY BIRTH;
