class Bvadmin::EmployeeApplicant < Bvadmin::Record
  self.table_name = "BVADMIN.EMPLOYEE_APPLICANTS"
  self.primary_key = :applicant_id

  before_validation :sanitize_data
 
  validates :fname, presence: true
  validates :lname, presence: true
 
  has_many :employee_applications, foreign_key: :applicant_id

  scope :fte_new_hires, -> (startdate,enddate) {
    joins(:employee_applications).where("confirmed_eod >= ? and confirmed_eod <= ?", startdate, enddate).order('name ASC')
  }
  
  def sanitize_data
    self.fname = (self.fname || '').strip.upcase
    self.lname = (self.lname || '').strip.upcase
  end
end
