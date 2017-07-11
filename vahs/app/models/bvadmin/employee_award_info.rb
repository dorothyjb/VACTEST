class Bvadmin::EmployeeAwardInfo < Bvadmin::Record
  self.table_name = "BVADMIN.EMPLOYEE_AWARD_INFO"
  self.primary_key = :id
  
  belongs_to :employee
end
