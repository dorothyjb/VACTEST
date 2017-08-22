class Bvadmin::EmployeeApplicant < Bvadmin::Record
  self.table_name = "BVADMIN.EMPLOYEE_APPLICANTS"
  self.primary_key = :applicant_id

  before_validation :sanitize_data
 
  validates :fname, presence: true
  validates :lname, presence: true
 
  has_many :attachments, class_name: Bvadmin::RmsAttachment
  has_many :applications, foreign_key: :applicant_id, class_name: Bvadmin::EmployeeApplication
  has_many :org_codes, class_name: Bvadmin::RmsOrgCode

>>>>>>> master
  scope :fte_new_hires, -> (startdate,enddate) {
    joins(:applications).where("confirmed_eod >= ? and confirmed_eod <= ?", startdate, enddate).order('name ASC')
  }
  
  def sanitize_data
    self.fname = (self.fname || '').strip.upcase
    self.lname = (self.lname || '').strip.upcase
  end

  def save_application application
    return nil if application.nil? || application[:grade].blank? || application[:series].blank? || application[:title].blank? || application[:vacancy_number].blank? ||  application[:status].blank?
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
     if application.nil? || application[:grade].blank? || application[:series].blank? || application[:title].blank? || application[:vacancy_number].blank? ||  application[:status].blank?
      errors.add "Application.#{application_id}", "Not all required fields entered"
      return
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

  def save_attachment attachment
    return nil if attachment.blank? || !attachment.is_a?(Hash)
    return nil if attachment[:attachment].blank? && attachment[:date].blank? && attachment[:notes].blank?

    attachment[:attachment] ||= FakeAttachment.new
    attachment[:date] = Date.today.strftime("%Y-%m-%d") if attachment[:date].blank?

    attach = Bvadmin::RmsAttachment.new(employee_applicant_id: self.applicant_id,
                                        attachment_type: attachment[:attachment_type],
                                        filename: attachment[:attachment].original_filename,
                                        filetype: attachment[:attachment].content_type,
                                        filedata: attachment[:attachment].read,
                                        notes: attachment[:notes],
                                        str_date: attachment[:date])

    if attach.valid?
      attach.save
    else
      append_errors 'Attachment', attach
    end

    attach
  end


  def save_attachments attachments
    return [Bvadmin::RmsAttachment.new] if attachments.nil? || attachments.empty?

    rst = []
    attachments.each do |attachment|
      tmp = save_attachment(attachment)
      rst << tmp if tmp && !tmp.valid?
    end

    rst = [Bvadmin::RmsAttachment.new] if rst.empty?
    rst
  end

  def edit_attachments attachments
    return if attachments.nil? || attachments.empty?

    attachments.each do |id, attachment|
      attach = Bvadmin::RmsAttachment.find_by(id: id)
      if attach.nil?
        errors.add "Attachment.#{id}", "Invalid ID"
        next
      end

      attach.update_attributes(attachment_type: attachment[:attachment_type],
                               filename: attachment[:filename],
                               notes: attachment[:notes],
                               str_date: attachment[:date])

      if attach.valid?
        attach.save
      else
        append_errors 'Attachment', attach
      end
    end
  end

  def append_errors name, model
    model.errors.each do |k,v|
      self.errors.add "#{name}.#{k}", v
    end
  end

end
