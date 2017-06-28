class Bvadmin::EmployeeApplicant < Bvadmin::Record
  self.table_name = "BVADMIN.EMPLOYEE_APPLICANTS"
  self.primary_key = :applicant_id
  has_many :employee_applications, foreign_key: :applicant_id

 scope :fte_new_hires, -> (startdate,enddate) {joins(:employee_applications).where("confirmed_eod >= ? and confirmed_eod <= ?", startdate, enddate).order('name ASC') }

end
