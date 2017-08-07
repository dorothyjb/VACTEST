class Bvadmin::EmployeeApplicant < Bvadmin::Record
  self.table_name = "BVADMIN.EMPLOYEE_APPLICANTS"
  self.primary_key = :applicant_id

  before_validation :sanitize_data
 
  validates :fname, presence: true
  validates :lname, presence: true
 
  has_many :applications, class_name: Bvadmin::EmployeeApplication, foreign_key: :applicant_id

  scope :fte_new_hires, -> (startdate,enddate) {
    joins(:applications).where("confirmed_eod >= ? and confirmed_eod <= ?", startdate, enddate).order('name ASC')
  }
  
  def sanitize_data
    self.fname = (self.fname || '').strip.upcase
    self.lname = (self.lname || '').strip.upcase
  end

  def save_application application
    return nil if application.nil? || application[:applicant_id].blank?
    if application[:status].blank? 
      application.update_attributes(status: 'Pipeline')
    end
    output = applications.build(office_id: application[:office_id],
                                division_id: application[:division_id],
                                branch_id: application[:branch_id],
                                unit_id: application[:unit_id],
                                org_code: application[:org_code])
    if output.valid?
      output.save
    else
      append_errors 'Application', output
    end
    output
  end

  def save_applications applications
    return [Bvadmin::EmployeeApplication.new] if applications.nil? || applications.empty?
    rst = []
    applications.each do |application|
      tmp = save_application(application)
      rst << tmp if tmp && !tmp.valid?
    end

    rst = [Bvadmin::EmployeeApplication.new] if rst.empty?
    rst  
  end

  def edit_applications applications
    byebug
    return if applications.nil? || applications.empty?

    applications.each do |application_id, application|
      app = Bvadmin::EmployeeApplication.find_by(application_id: application_id)
      if app.nil?
        errors.add "Application.#{application_id}", "Invalid ID"
      end
      app.update_attributes(office_id: application[:office_id],
                                division_id: application[:division_id],
                                branch_id: application[:branch_id],
                                unit_id: application[:unit_id],
                                org_code: application[:org_code])
      if app.valid?
        app.save
      else
        append_errors 'Application', app
      end
    end
  end

  def attachments
    [Bvadmin::RmsAttachment.new]
  end
end
