VARIABLE gradpa_pid NUMBER;

BEGIN
    INSERT INTO PARENTS VALUES (
        SYS_GUID(),
        NULL,
        NULL,
        NULL
    ) RETURNING PID INTO :grandpa_pid;
    /* �Ҿƹ��� �߰� */
    INSERT INTO HUMAN VALUES (SYS_GUID(), '�Ҿƹ���', 'M', '2016-10-15', NULL, :grandpa_pid, NULL);
    /* �����Ҿƹ��� �߰� */
    INSERT INTO HUMAN VALUES (SYS_GUID(), '�����Ҿƹ���', 'M', '2016-10-16', NULL, :grandpa_pid, NULL);
END;
/

/* �������ҸӴ� �߰� */
INSERT INTO HUMAN VALUES (SYS_GUID(), '�������ҸӴ�', 'M', '2015-11-15', NULL, NULL, NULL);

/* ���Ҿƹ��� �߰� */
INSERT INTO PARENTS VALUES (
    SYS_GUID(),
    NULL,
    (SELECT HID FROM HUMAN WHERE NAME = '�������ҸӴ�'),
    NULL
);
INSERT INTO HUMAN VALUES (SYS_GUID(), '���Ҿƹ���', 'M', '2016-11-15', NULL, (
    SELECT P.PID FROM PARENTS P, HUMAN MH WHERE P.MHID = MH.HID AND MH.NAME = '�������ҸӴ�'
), NULL);

/* �ƹ��� �߰� */
INSERT INTO PARENTS VALUES (
    SYS_GUID(),
    (SELECT HID FROM HUMAN WHERE NAME = '�Ҿƹ���'),
    NULL,
    NULL
);
INSERT INTO HUMAN VALUES (SYS_GUID(), '�ƹ���', 'M', '2017-10-15', NULL, (
    SELECT P.PID FROM PARENTS P, HUMAN FH WHERE P.FHID = FH.HID AND FH.NAME = '�Ҿƹ���'
), NULL);

/* ��Ӵ� �� ��ȥ �߰� */
INSERT INTO PARENTS VALUES (
    SYS_GUID(),
    (SELECT HID FROM HUMAN WHERE NAME = '���Ҿƹ���'),
    NULL,
    NULL
);
INSERT INTO HUMAN VALUES (SYS_GUID(), '��Ӵ�', 'F', '2017-10-15', NULL, (
    SELECT P.PID FROM PARENTS P, HUMAN FH WHERE P.FHID = FH.HID AND FH.NAME = '���Ҿƹ���'
), NULL);

/* ���� �ϳ� �߰� */
INSERT INTO PARENTS VALUES (
    SYS_GUID(),
    (SELECT HID FROM HUMAN WHERE NAME = '�ƹ���'),
    (SELECT HID FROM HUMAN WHERE NAME = '��Ӵ�'),
    NULL
);
INSERT INTO HUMAN VALUES (SYS_GUID(), '����', 'F', '2018-10-15', NULL, (
    SELECT P.PID FROM PARENTS P, HUMAN FH WHERE P.FHID = FH.HID AND FH.NAME = '�ƹ���'
), NULL);


/* SELECT statements */
SELECT * FROM HUMAN_WITH_PARENTS ORDER BY BIRTH;

SELECT * FROM PARENTS_WITH_NAMES;
