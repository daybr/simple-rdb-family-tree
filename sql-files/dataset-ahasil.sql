/*** 연도
 * 친가 증조: 2001
 * 외가 증조: 2011
 * 형제: 2016
 * 자식: 2017~
 *** 달
 * 직계: 6월
 * 같은 항렬: +-1개월
 *** 일
 * 남자: 홀수 (기본 15)
 * 여자: 짝수 (기본 16)
 * 형제: +-2일
*/

DECLARE
    grandfa_pid RAW(16);
BEGIN
    INSERT INTO PARENTS VALUES (
        SYS_GUID(),
        NULL,
        NULL,
        NULL
    ) RETURNING PID INTO grandfa_pid;
    /* 할아버지 추가 */
    INSERT INTO HUMAN VALUES (SYS_GUID(), '할아버지', 'M', '2002-06-15', NULL, grandfa_pid, NULL);
    /* 작은할아버지 추가 */
    INSERT INTO HUMAN VALUES (SYS_GUID(), '작은할아버지', 'M', '2002-06-17', NULL, grandfa_pid, NULL);
END;
/

INSERT INTO PARENTS VALUES (
    SYS_GUID(),
    (SELECT HID FROM HUMAN WHERE NAME = '할아버지'),
    NULL,
    NULL
);

/* 외증조할머니 추가 */
INSERT INTO HUMAN VALUES (SYS_GUID(), '외증조할머니', 'M', '2011-06-16', NULL, NULL, NULL);

INSERT INTO PARENTS VALUES (
    SYS_GUID(),
    NULL,
    (SELECT HID FROM HUMAN WHERE NAME = '외증조할머니'),
    NULL
);

/* 외할아버지 추가 */
INSERT INTO HUMAN VALUES (SYS_GUID(), '외할아버지', 'M', '2012-06-15', NULL, (
    SELECT P.PID FROM PARENTS P, HUMAN MH WHERE P.MHID = MH.HID AND MH.NAME = '외증조할머니'
), NULL);

INSERT INTO PARENTS VALUES (
    SYS_GUID(),
    (SELECT HID FROM HUMAN WHERE NAME = '외할아버지'),
    NULL,
    NULL
);

/* 큰고모 추가 */
INSERT INTO HUMAN VALUES (SYS_GUID(), '큰고모', 'F', '2003-06-14', NULL, (
    SELECT P.PID FROM PARENTS P, HUMAN FH WHERE P.FHID = FH.HID AND FH.NAME = '할아버지'
), NULL);

/* 아버지 추가 */
INSERT INTO HUMAN VALUES (SYS_GUID(), '아버지', 'M', '2003-06-15', NULL, (
    SELECT P.PID FROM PARENTS P, HUMAN FH WHERE P.FHID = FH.HID AND FH.NAME = '할아버지'
), NULL);

/* 어머니 추가 */
INSERT INTO HUMAN VALUES (SYS_GUID(), '어머니', 'F', '2013-06-16', NULL, (
    SELECT P.PID FROM PARENTS P, HUMAN FH WHERE P.FHID = FH.HID AND FH.NAME = '외할아버지'
), NULL);

INSERT INTO PARENTS VALUES (
    SYS_GUID(),
    (SELECT HID FROM HUMAN WHERE NAME = '아버지'),
    (SELECT HID FROM HUMAN WHERE NAME = '어머니'),
    NULL
);

/* 작은외삼촌 추가 */
INSERT INTO HUMAN VALUES (SYS_GUID(), '작은외삼촌', 'M', '2013-06-17', NULL, (
    SELECT P.PID FROM PARENTS P, HUMAN FH WHERE P.FHID = FH.HID AND FH.NAME = '외할아버지'
), NULL);

/* 작은이모 추가 */
INSERT INTO HUMAN VALUES (SYS_GUID(), '작은이모', 'F', '2013-06-18', NULL, (
    SELECT P.PID FROM PARENTS P, HUMAN FH WHERE P.FHID = FH.HID AND FH.NAME = '외할아버지'
), NULL);

/* 작은이모부 추가 */
INSERT INTO HUMAN VALUES (SYS_GUID(), '작은이모부', 'M', '2013-07-17', NULL, NULL, NULL);

INSERT INTO PARENTS VALUES (
    SYS_GUID(),
    (SELECT HID FROM HUMAN WHERE NAME = '작은이모부'),
    (SELECT HID FROM HUMAN WHERE NAME = '작은이모'),
    NULL
);

/* 남자 하나 추가 */
INSERT INTO HUMAN VALUES (SYS_GUID(), '남자', 'F', '2016-06-15', NULL, (
    SELECT P.PID FROM PARENTS P, HUMAN FH WHERE P.FHID = FH.HID AND FH.NAME = '아버지'
), NULL);

INSERT INTO PARENTS VALUES (
    SYS_GUID(),
    (SELECT HID FROM HUMAN WHERE NAME = '남자'),
    NULL,
    NULL
);

/* 여자 하나 추가 */
INSERT INTO HUMAN VALUES (SYS_GUID(), '여자', 'F', '2016-06-16', NULL, (
    SELECT P.PID FROM PARENTS P, HUMAN FH WHERE P.FHID = FH.HID AND FH.NAME = '아버지'
), NULL);

/* 남자 자식 추가 */
INSERT INTO HUMAN VALUES (SYS_GUID(), '남자아들', 'M', '2017-05-15', NULL, (
    SELECT P.PID FROM PARENTS P, HUMAN FH WHERE P.FHID = FH.HID AND FH.NAME = '남자'
), NULL);

/* SELECT HUMAN with PARENTS */
SELECT SUBSTR(HID,1,4) AS HID, NAME, SEX, BIRTH, DEATH, SUBSTR(PID,1,4) AS PID,
        SUBSTR(FHID,1,4) AS FHID, FHNAME, SUBSTR(MHID,1,4) AS MHID, MHNAME, SIBORD, CHILDCOUNT
    FROM HUMAN_WITH_PARENTS ORDER BY BIRTH;

/* SELECT PARENTS with names */
SELECT SUBSTR(PN.PID,1,4) AS PID, SUBSTR(PN.FHID,1,4) AS FHID, PN.FHNAME,
        SUBSTR(PN.MHID,1,4) AS MHID, PN.MHNAME, PN.CHILDCOUNT, COUNT(CH.HID)
    FROM PARENTS_WITH_NAMES PN LEFT OUTER JOIN HUMAN CH ON (PN.PID = CH.PID)
    GROUP BY SUBSTR(PN.PID,1,4), SUBSTR(PN.FHID,1,4), PN.FHNAME,
        SUBSTR(PN.MHID,1,4), PN.MHNAME, PN.CHILDCOUNT;
