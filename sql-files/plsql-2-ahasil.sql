CREATE GLOBAL TEMPORARY TABLE HUMAN_DIRECT_TEMP (
    LEV     INT NOT NULL,
    HID     RAW(16),
    PID     RAW(16),
    FHID    RAW(16),
    MHID    RAW(16)
) ON COMMIT DELETE ROWS;

CREATE GLOBAL TEMPORARY TABLE HUMAN_FAMILY_TREE (
    LEV         INT,
    CHON        INT,
    HID         RAW(16) NOT NULL,
    NAME        VARCHAR2(30) NOT NULL,
    SEX         CHAR,
    BIRTH       DATE,
    DEATH       DATE,
    PID         RAW(16),
    SIBORD      INT,
    MATE_P_PID  RAW(16),
    MATE_HID    RAW(16),
    MATE_NAME   VARCHAR2(30),
    MATE_SEX    CHAR,
    MATE_BIRTH  DATE,
    MATE_DEATH  DATE,
    MATE_PID    RAW(16)
) ON COMMIT DELETE ROWS;

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

CREATE OR REPLACE PROCEDURE DIRECT_SPEAR_LINE_OF_FA (
        START_HID       IN  HUMAN.HID%TYPE,
        ROOT_MATE_P_PID OUT PARENTS.PID%TYPE,
        LEV_OFFSET      IN  INT DEFAULT 0
    )
IS
    cur         SYS_REFCURSOR;
    temp_lev    INT;
    temp_hid    HUMAN.HID%TYPE;
    temp_pid    PARENTS.PID%TYPE;
    temp_fhid   HUMAN.HID%TYPE;
    temp_mhid   HUMAN.HID%TYPE;
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

CREATE OR REPLACE PROCEDURE DIRECT_SPEAR_LINE_OF_MA (
        START_HID       IN  HUMAN.HID%TYPE,
        ROOT_MATE_P_PID OUT PARENTS.PID%TYPE
    )
IS
    start_pid   PARENTS.PID%TYPE;
    start_fhid  HUMAN.HID%TYPE;
    start_mhid  HUMAN.HID%TYPE;
BEGIN
    SELECT H.PID, P.FHID, P.MHID INTO start_pid, start_fhid, start_mhid
        FROM HUMAN H LEFT OUTER JOIN PARENTS P ON H.PID = P.PID
        WHERE H.HID = START_HID;
    IF start_pid IS NULL THEN
        /* Starting PID is null */
        ROOT_MATE_P_PID := GET_MATE_P_PID(START_HID);
        DELETE FROM HUMAN_DIRECT_TEMP;
        INSERT INTO HUMAN_DIRECT_TEMP VALUES (1, START_HID, NULL, NULL, NULL);
        RETURN;
    END IF;
    IF start_mhid IS NOT NULL THEN
        /* Has a mother */
        DIRECT_SPEAR_LINE_OF_FA(start_mhid, ROOT_MATE_P_PID, 1);
        INSERT INTO HUMAN_DIRECT_TEMP VALUES (1, START_HID, NULL, NULL, NULL);
        RETURN;
    END IF;
    /* No mother or empty parents */
    ROOT_MATE_P_PID := start_pid;
    DELETE FROM HUMAN_DIRECT_TEMP;
    INSERT INTO HUMAN_DIRECT_TEMP VALUES (1, START_HID, NULL, NULL, NULL);
END;
/

CREATE OR REPLACE PROCEDURE MAKE_FAMILY_TREE (
        START_HID       IN  HUMAN.HID%TYPE,
        ROOT_MATE_P_PID OUT PARENTS.PID%TYPE,
        IS_FATHER_SIDE  IN  CHAR DEFAULT 'Y'
    )
IS
    cur         SYS_REFCURSOR;
    root_level  INT;
    root_pid    PARENTS.PID%TYPE;
BEGIN
    DELETE FROM HUMAN_FAMILY_TREE;
    /* Populate temp table HUMAN_DIRECT_TEMP */
    IF IS_FATHER_SIDE = 'Y' OR IS_FATHER_SIDE = 'y' THEN
        DIRECT_SPEAR_LINE_OF_FA(START_HID, ROOT_MATE_P_PID);
    ELSE
        DIRECT_SPEAR_LINE_OF_MA(START_HID, ROOT_MATE_P_PID);
    END IF;
    IF ROOT_MATE_P_PID IS NULL THEN
        /* None or a single human case */
        INSERT INTO HUMAN_FAMILY_TREE(
                LEV, CHON, HID, NAME, SEX, BIRTH, DEATH, SIBORD)
            SELECT 1 AS LEV, 0 AS CHON,
                    HID, NAME, SEX, BIRTH, DEATH, SIBORD
                FROM HUMAN
                WHERE HID = START_HID;
        RETURN;
    END IF;
    /* Get root level */
    OPEN cur FOR SELECT LEV, PID
        FROM HUMAN_DIRECT_TEMP
        ORDER BY LEV DESC;
    FETCH cur INTO root_level, root_pid;
    IF cur%NOTFOUND THEN
        /* HUMAN_DIRECT_TEMP is empty */
        CLOSE cur;
        RETURN;
    END IF;
    CLOSE cur;
    IF root_pid IS NOT NULL THEN
        /* Empty parents case */
        INSERT INTO HUMAN_DIRECT_TEMP(LEV) VALUES (root_level + 1);
    END IF;
    /* Find all children (except root) */
    INSERT INTO HUMAN_FAMILY_TREE
        SELECT (root_level - LEVEL + 1) AS LEV,
                (2 * DIR_H.LEV + LEVEL - root_level - 2) AS CHON,
                H.HID, H.NAME, H.SEX, H.BIRTH, H.DEATH, H.PID, H.SIBORD,
                MATE_P.PID, MATE_H.HID, MATE_H.NAME, MATE_H.SEX,
                MATE_H.BIRTH, MATE_H.DEATH, MATE_H.PID
            FROM HUMAN_DIRECT_TEMP DIR_H, HUMAN H
                LEFT OUTER JOIN PARENTS MATE_P ON (MATE_P.PID = GET_MATE_P_PID(H.HID))
                LEFT OUTER JOIN HUMAN MATE_H ON (
                    (H.HID <> MATE_P.FHID AND MATE_P.FHID = MATE_H.HID)
                        OR (H.HID <> MATE_P.MHID AND MATE_P.MHID = MATE_H.HID))
            START WITH (DIR_H.LEV = root_level AND H.HID = DIR_H.HID)
                OR (root_pid IS NOT NULL AND DIR_H.LEV = root_level + 1 AND H.PID = root_pid
                    AND H.HID NOT IN (SELECT HID FROM HUMAN_DIRECT_TEMP WHERE HID IS NOT NULL))
            CONNECT BY NOCYCLE PRIOR GET_MATE_P_PID(H.HID) = H.PID
                AND ((PRIOR DIR_H.LEV = DIR_H.LEV AND H.HID
                        NOT IN (SELECT HID FROM HUMAN_DIRECT_TEMP WHERE HID IS NOT NULL))
                    OR H.HID = DIR_H.HID);
    /* DELETE FROM HUMAN_DIRECT_TEMP WHERE LEV = root_level + 1; */
END;
/

/* Test MAKE_FAMILY_TREE */
DECLARE
    WOMAN_HID RAW(16);
    ROOT_MATE_P_PID RAW(16);
BEGIN
    SELECT HID INTO WOMAN_HID FROM HUMAN WHERE NAME = '여자';
    /* DIRECT_SPEAR_LINE_OF_FA(WOMAN_HID, ROOT_MATE_P_PID); */
    /* DIRECT_SPEAR_LINE_OF_MA(WOMAN_HID, ROOT_MATE_P_PID); */
    MAKE_FAMILY_TREE(WOMAN_HID, ROOT_MATE_P_PID, 'Y');
END;
/

/* Print result tree */
SELECT LEV, CHON, SUBSTR(HID,1,4) AS HID, NAME, SEX,
        BIRTH, DEATH, SUBSTR(PID,1,4) AS PID, SIBORD,
        SUBSTR(MATE_HID,1,4) AS MATE_HID, MATE_NAME, MATE_SEX,
        MATE_BIRTH, MATE_DEATH, SUBSTR(MATE_PID,1,4) AS MATE_PID
    FROM HUMAN_FAMILY_TREE
    ORDER BY LEV DESC, PID, BIRTH;

/* Print direct line */
SELECT DT.LEV, SUBSTR(DT.HID,1,4) AS HID, H.NAME, SUBSTR(DT.PID,1,4) AS PID,
        SUBSTR(DT.FHID,1,4) AS FHID, FH.NAME AS FHNAME,
        SUBSTR(DT.MHID,1,4) AS MHID, MH.NAME AS FMNAME
    FROM HUMAN_DIRECT_TEMP DT
        LEFT OUTER JOIN HUMAN H ON (DT.HID = H.HID)
        LEFT OUTER JOIN HUMAN FH ON (DT.FHID = FH.HID)
        LEFT OUTER JOIN HUMAN MH ON (DT.MHID = MH.HID)
    ORDER BY DT.LEV DESC;

/* Clean temp table */
COMMIT;
