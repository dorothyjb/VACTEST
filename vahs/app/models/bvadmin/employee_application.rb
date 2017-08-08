class Bvadmin::EmployeeApplication < Bvadmin::Record
  self.table_name = "BVADMIN.EMPLOYEE_APPLICATIONS"
  self.primary_key = :application_id
  belongs_to :employee_applicants

scope :active_applications, -> (applicant_id, active_status){where("applicant_id = ? and status in (?)", applicant_id, active_status).order('vacancy_number ASC')}


end
