CREATE VIEW "BVADMIN"."WORKFORCE_ROSTER" AS
SELECT
    to_char(org.code) AS "ORG_CODE",
    
    case
      when ai.assignment_type = 'Satellite Station' then to_char(ai.satellite_room)
      when ai.assignment_type = 'Primary Station' then to_char(ai.room_number)
      when ai.assignment_type = 'Telework' then to_char('REMOTE')
      else to_char(null)
    end AS "LOCATION",
    
    (SELECT "NAME" FROM "BVADMIN"."RMS_ORG_INFORMATION" WHERE ID = org.office_id) AS "OFFICE",
    (SELECT "NAME" FROM "BVADMIN"."RMS_ORG_INFORMATION" WHERE ID = org.division_id) AS "DIVISION",
    (SELECT "NAME" FROM "BVADMIN"."RMS_ORG_INFORMATION" WHERE ID = org.branch_id) AS "BRANCH",
    (SELECT "NAME" FROM "BVADMIN"."RMS_ORG_INFORMATION" WHERE ID = org.unit_id) AS "UNIT",
    
    case
      when org.employee_id is null then to_char('VACANT')
      when emp.on_union = 1 then to_char('UNION')
      when ai.other_assignment = 'Detail To' then to_char('DETAIL')
      when ai.other_assignment = 'Extended Leave' then to_char('MILITARY')
      when org.rotation = 0 and
           (SELECT COUNT(*)
               FROM "BVADMIN"."RMS_ORG_CODE"
               WHERE "BVADMIN"."RMS_ORG_CODE"."EMPLOYEE_ID" = org.employee_id) > 1 then to_char('ROTATION')
      else to_char('ON BOARD')
    end AS "STATUS",
    
    to_char(emp.lname || ', ' || emp.fname) AS "POSITION_OCCUPANT",
    to_char(emp.paid_title) AS "OFFICIAL_TITLE",
    to_char(emp.bva_title)  AS "UNOFFICIAL_TITLE",
    
    to_char(null) AS "PD_NUMBER",
    
    to_char(emp.job_code) AS "SERIES",
    to_char(emp.grade) AS "GRADE",
    
    to_char(null) AS "SPECIAL_STATUS",
    
    to_date(emp.current_bva_duty_date) AS "EOD",
    to_date(emp.srvce_comp_date) AS "SVC_COMP",
    
    case
      when emp.vet_status = 'V' then to_char('Y')
      else to_char('N')
    end AS "VETERAN",
    
    to_char(emp.time_leave_unit) AS "T_AND_L",
    
    to_char(emp.name) AS "PAID_NAME",
    to_number(emp.fte) AS "FTEE",
    
    case
      when org.employee_id is null then to_number('0')
      when org.rotation = 0 and
           (SELECT COUNT(*) 
               FROM "BVADMIN"."RMS_ORG_CODE"
               WHERE "BVADMIN"."RMS_ORG_CODE"."EMPLOYEE_ID" = org.employee_id) > 1 then to_number('0')
      else to_number('1')
    end AS "NUMBER_OF_PERSONNEL",
    
    case
      when org.employee_id is null then to_number('1')
      else to_number('0')
    end AS "VACANT",
    
    case
      when emp.on_union = 1 then to_number('1')
      when ai.other_assignment is not null and
           ai.other_assignment in ('Detail To', 'Extended Leave') then to_number('1')
      else to_number('0')
    end AS "OTHER",
    
    case
      when org.rotation = 0 and
           (SELECT COUNT(*) 
               FROM "BVADMIN"."RMS_ORG_CODE"
               WHERE "BVADMIN"."RMS_ORG_CODE"."EMPLOYEE_ID" = org.employee_id) > 1 then to_number('1')
      else to_number('0')
    end AS "ROTATION",
    
    case
      when org.rotation = 1 then to_number('0')
      else to_number('1')
    end AS "FUNDED_POSITION",
    
    case
      when org.rotation = 1 then to_number('1')
      else to_number('0')
    end AS "UNFUNDED_POSITION",
    
    to_number(null) AS "INCOMING",
    
    case
      when si.status_type = 'Separation' and SYSDATE < si.separation_effective_date then to_number('1')
      else to_number(null)
    end AS "DEPARTING"
    
  FROM
    "BVADMIN"."RMS_ORG_CODE" org
  LEFT JOIN
    "BVADMIN"."EMPLOYEE" emp ON emp.employee_id = org.employee_id
  LEFT JOIN
    "BVADMIN"."RMS_EMPLOYEE_ASSIGNMENT_INFO" ai ON ai.employee_id = org.employee_id
  LEFT JOIN
    "BVADMIN"."RMS_STATUS_INFO" si ON si.employee_id = org.employee_id
UNION
SELECT
    to_char(null) AS "ORG_CODE",
    to_char(null) AS "LOCATION",
    (SELECT "NAME" FROM "BVADMIN"."RMS_ORG_INFORMATION" WHERE ID = app.office_id) AS "OFFICE",
    (SELECT "NAME" FROM "BVADMIN"."RMS_ORG_INFORMATION" WHERE ID = app.division_id) AS "DIVISION",
    (SELECT "NAME" FROM "BVADMIN"."RMS_ORG_INFORMATION" WHERE ID = app.branch_id) AS "BRANCH",
    (SELECT "NAME" FROM "BVADMIN"."RMS_ORG_INFORMATION" WHERE ID = app.unit_id) AS "UNIT",
    case
      when app.status = 'Incoming' then to_char('VACANT-ARRIVING')
      else to_char('VACANT-PIPELINE')
    end AS "STATUS",
    to_char(apl.lname || ', ' || apl.fname) AS "POSITION_OCCUPANT",
    to_char(app.title) AS "OFFICIAL_TITLE",
    to_char(null) AS "UNOFFICIAL_TITLE",
    to_char(null) AS "PD_NUMBER",
    to_char(app.series) AS "SERIES",
    to_char(app.grade) AS "GRADE",
    to_char(null) AS "SPECIAL_STATUS",
    to_date(app.confirmed_eod) AS "EOD",
    to_date(null) AS "SVC_COMP",
    to_char(null) AS "VETERAN",
    to_char(null) AS "T_AND_L",
    to_char('VACANT') AS "PAID_NAME",
    to_number('0') AS "FTEE",
    to_number('0') AS "NUMBER_OF_PERSONNEL",
    to_number('1') AS "VACANT",
    to_number('0') AS "OTHER",
    to_number('0') AS "ROTATION",
    to_number('1') AS "FUNDED_POSITION",
    to_number('0') AS "UNFUNDED_POSITION",
    to_number('1') AS "INCOMING",
    to_number('0') AS "DEPARTING"
  FROM
    "BVADMIN"."EMPLOYEE_APPLICATIONS" app
  JOIN
    "BVADMIN"."EMPLOYEE_APPLICANTS" apl ON apl.applicant_id = app.applicant_id
  WHERE
    app.status != 'Denied';
