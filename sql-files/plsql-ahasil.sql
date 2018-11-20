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
    temp_pid PARENTS.PID%TYPE;
    root_mate_p_pid PARENTS.PID%TYPE;
    temp_fhid HUMAN.HID%TYPE;
    temp_mhid HUMAN.HID%TYPE;
BEGIN
    root_mate_p_pid := NULL;
    SELECT H.PID, P.FHID, P.MHID INTO temp_pid, temp_fhid, temp_mhid
        FROM HUMAN H LEFT OUTER JOIN PARENTS P ON H.PID = P.PID
        WHERE H.HID = START_HID;
    IF temp_pid IS NULL THEN
        /* Starting PID is null */
        RETURN GET_MATE_P_PID(START_HID);
    END IF;
    IF temp_fhid IS NULL THEN
        IF temp_mhid IS NOT NULL THEN
            /* The person has a mother but no father */
            RETURN GET_MATE_P_PID(START_HID);
        END IF;
        /* Empty parents case */
        RETURN temp_pid;
    END IF;
    OPEN cur;
        /* ROOT ROW */
        FETCH cur INTO temp_level, temp_hid, temp_pid, temp_fhid, temp_mhid;
        IF NOT cur%NOTFOUND THEN
            IF temp_pid IS NOT NULL THEN
                /* Empty parents of (current) root */
                root_mate_p_pid := temp_pid;
            ELSE
                /* UNDER-ROOT ROW: PID is MATE_P PID of ROOT! */
                FETCH cur INTO temp_level, temp_hid, root_mate_p_pid, temp_fhid, temp_mhid;
            END IF;
        END IF;
    CLOSE cur;
    RETURN root_mate_p_pid;
END;
/

/* 외가 부계의 root가 속한 Mate_P PID 찾기 */
CREATE OR REPLACE FUNCTION SPEAR_LINE_ROOT_OF_MA (
        START_HID IN HUMAN.HID%TYPE
    )
    RETURN PARENTS.PID%TYPE
IS
    start_pid PARENTS.PID%TYPE;
    start_fhid HUMAN.HID%TYPE;
    start_mhid HUMAN.HID%TYPE;
BEGIN
    SELECT H.PID, P.FHID, P.MHID INTO start_pid, start_fhid, start_mhid
        FROM HUMAN H LEFT OUTER JOIN PARENTS P ON H.PID = P.PID
        WHERE H.HID = START_HID;
    IF start_pid IS NULL THEN
        /* Starting PID is null */
        RETURN GET_MATE_P_PID(START_HID);
    END IF;
    IF start_mhid IS NOT NULL THEN
        /* Has a mother */
        RETURN SPEAR_LINE_ROOT_OF_FA(start_mhid);
    END IF;
    IF start_fhid IS NOT NULL THEN
        /* Has a father but no mother */
        RETURN GET_MATE_P_PID(start_hid);
    END IF;
    /* Empty parents case */
    RETURN start_pid;
END;
/

SELECT H.HID, H.NAME, GET_MATE_P_PID(H.HID) AS MATE_P_PID, H.PID, PN.FHNAME,
        RF_PN.PID AS RF_MATE_P_PID, RF_PN.FHNAME AS RF_FA, RF_PN.MHNAME AS RF_MA,
        RM_PN.PID AS RM_MATE_P_PID, RM_PN.FHNAME AS RM_FA, RM_PN.MHNAME AS RM_MA
    FROM HUMAN H
        LEFT OUTER JOIN PARENTS_WITH_NAMES PN ON (H.PID = PN.PID)
        LEFT OUTER JOIN PARENTS_WITH_NAMES RF_PN ON (RF_PN.PID = SPEAR_LINE_ROOT_OF_FA(H.HID))
        LEFT OUTER JOIN PARENTS_WITH_NAMES RM_PN ON (RM_PN.PID = SPEAR_LINE_ROOT_OF_MA(H.HID))
    ORDER BY H.BIRTH;
