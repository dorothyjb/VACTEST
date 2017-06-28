class Bvadmin::EmployeeApplication < Bvadmin::Record
  self.table_name = "BVADMIN.EMPLOYEE_APPLICATIONS"
  self.primary_key = :application_id
  belongs_to :employee_applicants
end