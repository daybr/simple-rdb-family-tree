CREATE GLOBAL TEMPORARY TABLE HUMAN_DIRECT_TEMP (
    LEV INT,
    HID RAW(16) NOT NULL,
    PID RAW(16),
    FHID RAW(16),
    MHID RAW(16)
) ON COMMIT DELETE ROWS;

CREATE OR REPLACE PROCEDURE DIRECT_SPEAR_LINE_OF_FA (
        START_HID IN HUMAN.HID%TYPE,
        ROOT_MATE_P_PID OUT PARENTS.PID%TYPE,
        DIRECT_LINE OUT SYS_REFCURSOR,
        LEV_OFFSET IN NUMBER DEFAULT 0
    )
IS
    cur SYS_REFCURSOR;
    temp_lev NUMBER;
    temp_hid HUMAN.HID%TYPE;
    temp_pid PARENTS.PID%TYPE;
    temp_fhid HUMAN.HID%TYPE;
    temp_mhid HUMAN.HID%TYPE;
BEGIN
    /* Clear HUMAN_DIRECT_TEMP */
    DELETE FROM HUMAN_DIRECT_TEMP;
    /* Examine the starting human */
    SELECT H.PID, P.FHID, P.MHID INTO temp_pid, temp_fhid, temp_mhid
        FROM HUMAN H LEFT OUTER JOIN PARENTS P ON H.PID = P.PID
        WHERE H.HID = START_HID;
    IF temp_pid IS NULL THEN
        /* Starting PID is null */
        ROOT_MATE_P_PID := GET_MATE_P_PID(START_HID);
        INSERT INTO HUMAN_DIRECT_TEMP VALUES (1, START_HID, NULL, NULL, NULL);
        RETURN;
    END IF;
    IF temp_fhid IS NULL THEN
        /* No father or empty parents */
        ROOT_MATE_P_PID := temp_pid;
        INSERT INTO HUMAN_DIRECT_TEMP VALUES (1, START_HID, temp_pid, NULL, temp_mhid);
        RETURN;
    END IF;
    /* Populate HUMAN_DIRECT_TEMP */
    INSERT INTO HUMAN_DIRECT_TEMP
        SELECT LEVEL + LEV_OFFSET AS LEV, H.HID AS HID, H.PID AS PID, P.FHID AS FHID, P.MHID AS MHID
            FROM HUMAN H LEFT OUTER JOIN PARENTS P ON (H.PID = P.PID)
            START WITH HID = START_HID
            CONNECT BY NOCYCLE PRIOR FHID = HID OR (FHID IS NULL AND PRIOR MHID = HID);
    OPEN cur FOR SELECT * FROM HUMAN_DIRECT_TEMP ORDER BY LEV DESC;
        /* ROOT ROW */
        FETCH cur INTO temp_lev, temp_hid, temp_pid, temp_fhid, temp_mhid;
        IF NOT cur%NOTFOUND THEN
            IF temp_pid IS NOT NULL THEN
                /* Empty parents of (current) root */
                ROOT_MATE_P_PID := temp_pid;
            ELSE
                /* UNDER-ROOT ROW: PID is MATE_P PID of ROOT! */
                FETCH cur INTO temp_lev, temp_hid, ROOT_MATE_P_PID, temp_fhid, temp_mhid;
            END IF;
        END IF;
    CLOSE cur;
END;
/


DECLARE
    WOMAN_HID RAW(16);
    ROOT_MATE_P_PID RAW(16);
    DIRECT_LINE_CUR SYS_REFCURSOR;
BEGIN
    SELECT HID INTO WOMAN_HID FROM HUMAN WHERE NAME = '��Ӵ�';
    DIRECT_SPEAR_LINE_OF_FA(WOMAN_HID, ROOT_MATE_P_PID, DIRECT_LINE_CUR, 1);
END;
/


SELECT DT.LEV, SUBSTR(DT.HID,1,4) AS HID, H.NAME, SUBSTR(DT.PID,1,4) AS PID,
        SUBSTR(DT.FHID,1,4) AS FHID, FH.NAME AS FHNAME,
        SUBSTR(DT.MHID,1,4) AS MHID, MH.NAME AS FMNAME
    FROM HUMAN_DIRECT_TEMP DT
        LEFT OUTER JOIN HUMAN H ON (DT.HID = H.HID)
        LEFT OUTER JOIN HUMAN FH ON (DT.FHID = FH.HID)
        LEFT OUTER JOIN HUMAN MH ON (DT.MHID = MH.HID);
        

COMMIT;
