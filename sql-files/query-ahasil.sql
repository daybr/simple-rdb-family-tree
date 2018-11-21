/* 자식 찾기 */
SELECT DISTINCT H.*
    FROM HUMAN H, PARENTS P
    WHERE H.PID = P.PID AND P.PID = (SELECT PID FROM HUMAN WHERE NAME = '아버지')
    ORDER BY H.BIRTH;

/* 배우자 찾기 */
SELECT H.*, MATE_P.PID AS MATE_P_PID, MATE_H.HID AS MATE_HID, MATE_H.NAME AS MATE_NAME, MATE_H.SEX AS MATE_SEX
    FROM HUMAN H
        LEFT OUTER JOIN PARENTS MATE_P ON (H.HID = MATE_P.FHID OR H.HID = MATE_P.MHID)
        LEFT OUTER JOIN HUMAN MATE_H ON (
            (H.HID <> MATE_P.FHID AND MATE_P.FHID = MATE_H.HID)
                OR (H.HID <> MATE_P.MHID AND MATE_P.MHID = MATE_H.HID)
        )
    ORDER BY H.BIRTH;

/* 친가 부계 찾기 1 */
SELECT 1 AS "LEVEL", HH1.HID AS HID, HH1.NAME AS NAME, HH1.PID AS PID, P1.FHID AS FHID, P1.MHID AS MHID
    FROM HUMAN HH1 LEFT OUTER JOIN PARENTS P1 ON (HH1.PID = P1.PID)
    WHERE HH1.NAME = '여자'
UNION
SELECT LEVEL, H.HID AS HID, H.NAME AS NAME, H.PID AS PID, P.FHID AS FHID, P.MHID AS MHID
    FROM HUMAN H LEFT OUTER JOIN PARENTS P ON (H.PID = P.PID)
    START WITH HID = (
        SELECT HH.HID
            FROM HUMAN HH LEFT OUTER JOIN PARENTS P2 ON (HH.PID = P2.PID)
            WHERE HH.NAME = '여자' AND (P2.FHID IS NOT NULL OR (P2.FHID IS NULL AND P2.MHID IS NULL))
    )
    CONNECT BY NOCYCLE PRIOR FHID = HID OR (FHID IS NULL AND PRIOR MHID = HID);

/* 친가 부계 찾기 2 */
SELECT 1 AS "LEVEL", HH1.HID AS HID, HH1.NAME AS NAME, HH1.PID AS PID, P1.FHID AS FHID, P1.MHID AS MHID
    FROM HUMAN HH1 LEFT OUTER JOIN PARENTS P1 ON (HH1.PID = P1.PID)
    WHERE HH1.NAME = '외할아버지'
UNION
SELECT LEVEL, H.HID AS HID, H.NAME AS NAME, H.PID AS PID, P.FHID AS FHID, P.MHID AS MHID
    FROM HUMAN H LEFT OUTER JOIN PARENTS P ON (H.PID = P.PID)
    START WITH HID = (
        SELECT HH.HID
            FROM HUMAN HH LEFT OUTER JOIN PARENTS P2 ON (HH.PID = P2.PID)
            WHERE HH.NAME = '외할아버지' AND (P2.FHID IS NOT NULL OR (P2.FHID IS NULL AND P2.MHID IS NULL))
    )
    CONNECT BY NOCYCLE PRIOR FHID = HID OR (FHID IS NULL AND PRIOR MHID = HID);

/* 외가 부계 찾기 */
SELECT 1 AS "LEVEL", HH1.HID AS HID, HH1.NAME AS NAME, HH1.PID AS PID, P1.FHID AS FHID, P1.MHID AS MHID
    FROM HUMAN HH1 LEFT OUTER JOIN PARENTS P1 ON (HH1.PID = P1.PID)
    WHERE HH1.NAME = '여자'
UNION
SELECT LEVEL+1 AS "LEVEL", H.HID AS HID, H.NAME AS NAME, H.PID AS PID, P.FHID AS FHID, P.MHID AS MHID
    FROM HUMAN H LEFT OUTER JOIN PARENTS P ON (H.PID = P.PID)
    START WITH HID = (
        SELECT P2.MHID
            FROM HUMAN HH2, PARENTS P2
            WHERE HH2.NAME = '여자' AND HH2.PID = P2.PID
    )
    CONNECT BY NOCYCLE PRIOR FHID = HID OR (FHID IS NULL AND PRIOR MHID = HID);
