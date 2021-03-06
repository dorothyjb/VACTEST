CREATE TABLE "BVADMIN"."RMS_ATTACHMENTS" (
  "ID" NUMBER(38) NOT NULL PRIMARY KEY,
  "DATE" DATE NOT NULL,
  "FILENAME" VARCHAR2(100) NOT NULL,
  "FILETYPE" VARCHAR2(100) NOT NULL,
  "FILEDATA" BLOB NOT NULL,
  "ATTACHMENT_TYPE" VARCHAR2(100) NOT NULL,
  "EMPLOYEE_ID" NUMBER(38) NOT NULL,
  "NOTES" VARCHAR2(200)
);
CREATE SEQUENCE "BVADMIN"."RMS_ATTACHMENTS_seq" START WITH 1000;
