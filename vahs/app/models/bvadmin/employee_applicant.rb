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
    return nil if application.nil? || application[:grade].blank? || application[:series].blank?
    output = applications.build(applicant_id: self.applicant_id,
                                office_id: application[:office_id],
                                division_id: application[:division_id],
                                branch_id: application[:branch_id],
                                unit_id: application[:unit_id],
                                org_code: application[:org_code],
                                status: application[:status],
                                title: application[:title],
                                process_start_date: application[:process_start_date],
                                vacancy_number: application[:vacancy_number], 
                                grade: application[:grade],
                                series: application[:series],
                                pay_schedule: application[:pay_schedule],
                                arpa: application[:arpa],
                                selected_date: application[:selected_date],
                                str_tentative_offer_date: application[:tentative_offer_date],
                                str_sent_to_security_date: application[:sent_to_security_date],
                                str_final_offer_date: application[:final_offer_date],
                                str_requested_eod: application[:requested_eod],
                                str_confirmed_eod: application[:confirmed_eod],
                                denied_reason: application[:denied_reason],
                                str_denied_action_date: application[:denied_action_date],
                                denied_comments: application[:denied_comments],
                                str_incoming_action_date: application[:incoming_action_date],
                                incoming_comments: application[:incoming_comments],
                                str_pipeline_action_date: application[:pipeline_action_date],
                                str_selection_date: application[:selection_date],
                                pipeline_comments: application[:pipeline_comments],
                                str_sent_start_date: application[:sent_start_date]
                         )
    output.update_attributes(status: "Pipeline")
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
                                org_code: application[:org_code],
                                status: application[:status],
                                title: application[:title],
                                process_start_date: application[:process_start_date],
                                vacancy_number: application[:vacancy_number], 
                                grade: application[:grade],
                                series: application[:series],
                                pay_schedule: application[:pay_schedule],
                                arpa: application[:arpa],
                                selected_date: application[:selected_date],
                                str_sent_to_security_date: application[:sent_to_security_date],
                                str_tentative_offer_date: application[:tentative_offer_date],
                                str_final_offer_date: application[:final_offer_date],
                                str_requested_eod: application[:requested_eod],
                                str_confirmed_eod: application[:confirmed_eod],
                                denied_reason: application[:denied_reason],
                                str_denied_action_date: application[:denied_action_date],
                                denied_comments: application[:denied_comments],
                                str_incoming_action_date: application[:incoming_action_date],
                                incoming_comments: application[:incoming_comments],
                                str_pipeline_action_date: application[:pipeline_action_date],
                                str_selection_date: application[:selection_date],
                                pipeline_comments: application[:pipeline_comments],
                                str_sent_start_date: application[:sent_start_date]
                         )
      if app.valid?
        app.save
      else
        append_errors 'Application', app
      end
    end
  end

  def append_errors name, model
    model.errors.each do |k,v|
      self.errors.add "#{name}.#{k}", v
    end
  end

  def attachments
    [Bvadmin::RmsAttachment.new]
  end
end
