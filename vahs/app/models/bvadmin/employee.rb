class Bvadmin::Employee < Bvadmin::Record
  self.table_name = "BVADMIN.EMPLOYEE"
  self.primary_key = :employee_id
  self.sequence_name = "BVADMIN.EMP_ID_SEQ"

  # validators
  validates :fname, presence: true
  validates :lname, presence: true
  validates_uniqueness_of :attorney_id, allow_nil: true, allow_blank: true
  validates :union_timespent, length: { maximum: 12 }
  validates :union_timespent, presence: true, if: :on_union?
  validates :union_start, presence: true, if: :on_union?
  validates :union_end, presence: true, if: :on_union?

  # associations
  has_one :attorney, foreign_key: :attorney_id, primary_key: :attorney_id
  has_one :assignment, class_name: Bvadmin::RmsEmployeeAssignmentInfo
  has_many :attachments, class_name: Bvadmin::RmsAttachment
  has_many :org_codes, class_name: Bvadmin::RmsOrgCode
  has_many :trainings, class_name: Bvadmin::Training, foreign_key: :user_id, primary_key: :user_id
  has_many :awards, class_name: Bvadmin::EmployeeAwardInfo
  has_many :statuses, class_name: Bvadmin::RmsStatusInfo
  
  #has_one :primary_position, -> { where(rotation: 0) }, class_name: Bvadmin::RmsOrgCode
  #has_one :rotation_position, -> { where(rotation: 1) }, class_name: Bvadmin::RmsOrgCode

  # FTE report
  scope :emp_fte_report, -> { where("fte > 0").order('name ASC') }

  # FTE report
  scope :fte_losses, -> (startdate,startdate2){where("fte = 0 and status_change_date >= ? or status_change_date2 >= ?", startdate, startdate2).order('name ASC')}
  
  # This is not a proper scope; should switch to Bvadmin::RmsDropDownConfig
  scope :paid_titles_list, -> { Bvadmin::Employee.select(:paid_title).distinct.order('PAID_TITLE ASC').
                                collect { |e| [ e.paid_title, e.paid_title ] unless e.paid_title.nil? }.
                                delete_if { |e| e.nil? } }

  # This is not a proper scope; should switch to Bvadmin::RmsDropDownConfig
  scope :job_code_list, -> { Bvadmin::Employee.select(:job_code).distinct.order('JOB_CODE ASC').
                             collect { |e| [ e.job_code, e.job_code ] unless e.job_code.nil? }.
                             delete_if { |e| e.nil? } }

  # This is not a proper scope; should switch to Bvadmin::RmsDropDownConfig
  scope :grades_list, -> { Bvadmin::Employee.select(:grade).distinct.order('GRADE ASC').
                           collect { |e| [ e.grade, e.grade ] unless e.grade.nil? }.
                           delete_if { |e| e.nil? } }

  # This is not a proper scope; should switch to Bvadmin::RmsDropDownConfig
  scope :bva_titles_list, -> { Bvadmin::Employee.select(:bva_title).distinct.order('BVA_TITLE ASC').
                                collect { |e| [ e.bva_title, e.bva_title ] unless e.bva_title.nil? }.
                                delete_if { |e| e.nil? } }

  # This is not a proper scope; should switch to Bvadmin::RmsDropDownConfig
  scope :effectives_list, -> { Bvadmin::Employee.select(:assgnmt_date).distinct.order('ASSGNMT_DATE DESC').
                               collect { |e| [ e.assgnmt_date.strftime("%Y-%m-%d"), e.assgnmt_date.strftime("%Y-%m-%d") ] unless e.assgnmt_date.nil? }.
                               delete_if { |e| e.nil? or e.empty? } }
  
  # Searches the employee table.
  # Returns an ActiveRecord_Relation of the search criteria.
  #
  # The +type+ argument is the <tt>type</tt> of search to be done.
  # The +str+ argument is the text to be used as the search criteria.
  def self.search type, str
    str.downcase!

    srchmap = {
               "Employee ID" => [ "EMPLOYEE_ID LIKE ?", "%#{str}%" ],
               "Attorney ID" => [ "ATTORNEY_ID LIKE ?", "%#{str}%" ],
               "User ID" => [ "USER_ID LIKE ?", "%#{str}%" ],
               "Login ID" => [ "LOWER(LOGIN_ID) LIKE ?", "%#{str}%" ],
               "Last Name" => [ "LOWER(LNAME) LIKE ? OR LOWER(PREV_LNAME) LIKE ? OR "\
                                "SOUNDEX(?) IN (SOUNDEX(LNAME), SOUNDEX(PREV_LNAME))", "%#{str}%", "%#{str}%", str ],
               "First Name" => [ "LOWER(FNAME) LIKE ? OR LOWER(FNAME2) LIKE ? OR "\
                                 "SOUNDEX(?) IN (SOUNDEX(FNAME), SOUNDEX(FNAME2))", "%#{str}%", "%#{str}%", str ],
               "Grade" => [ "GRADE LIKE ? ", "%#{str}%" ],
               "Work Group" => [ "LOWER(WORK_GROUP) LIKE ?", "%#{str}%" ],
               "Assignment Date" => [ "ASSGNMT_DATE = to_date(?, 'yyyy-mm-dd')", (Date.parse(str) rescue Date.today).strftime("%Y-%m-%d") ],
               "Service Completion Date" => [ "SRVCE_COMP_DATE = to_date(?, 'yyyy-mm-dd')", (Date.parse(str) rescue Date.today).strftime("%Y-%m-%d") ],
               "Years of Service" => [ "YEARS_OF_SRVCE = ?", str ],
               "BVA Title" => [ "LOWER(BVA_TITLE) LIKE ?", "%#{str}%" ],
               "Paid Title" => [ "LOWER(PAID_TITLE) LIKE ?", "%#{str}%" ],
               "Job Code" => [ "JOB_CODE LIKE ?", "%#{str}%" ],
               "Work Phone" => [ "WORK_PHONE LIKE ?", "%#{str}%" ],
               "Building Room" => [ "LOWER(BLDING_ROOM) LIKE ?", "%#{str}%" ],
               "Position Number" => [ "POSITION_NUM LIKE ?", "%#{str}%" ],
               "Employment Status" => [ "LOWER(EMPLOYMENT_STATUS) LIKE ?", "%#{str}%" ],
               "Bar Member" => [ "LOWER(BAR_MEMBER) LIKE ? OR LOWER(BAR_MEMBER) LIKE ?",  ],
               "Generic" => [ "LOWER(LNAME) LIKE ? OR LOWER(FNAME) LIKE ? OR "\
                              "LOWER(BVA_TITLE) LIKE ? OR LOWER(PAID_TITLE) LIKE ? OR "\
                              "SOUNDEX(?) IN (SOUNDEX(LNAME), SOUNDEX(FNAME), SOUNDEX(FNAME2), SOUNDEX(PREV_LNAME)) OR "\
                              "EMPLOYEE_ID LIKE ? OR ATTORNEY_ID LIKE ?", "%#{str}%", "%#{str}%",
                              "%#{str}%", "%#{str}%", str, "%#{str}%", "%#{str}%" ]
              }

    return Bvadmin::Employee.none if srchmap[type].nil?

    query = srchmap[type].shift
    Bvadmin::Employee.where(query, *srchmap[type])
  end

  # Saves a picture to the Employee record.
  # Returns +nil+ if pic is nil, or pic fails to respond to the necessary methods.
  # Returns +self+ if the picture was updated successfully.
  # 
  # <tt>pic</tt> is expected to have <tt>content_type</tt> and <tt>read</tt> methods.
  # <tt>content_type</tt> should return the content type of the image data
  # <tt>read</tt> should return the bytes that make up the image.
  def save_picture pic
    save if update_picture(pic)
  end

  def update_picture pic
    return nil if pic.nil? or !(pic.respond_to?(:content_type) and pic.respond_to?(:read))

    self.picture_mime = pic.content_type
    self.picture_data = pic.read

    self
  end 

  # Check if an Employee record has a picture
  # Returns +false+ if the Employee does not have a picture in their record
  # Returns +true+ if the Employee does have a picture in their record
  def has_picture?
    !(self.picture_mime.nil? && self.picture_data.nil?)
  end

  # Check to see if the employee is on rotation
  # Returns +true+ if the employee is on rotation
  # Return +false+ if the employee is not on rotation
  def on_rotation?
    org_codes.find_by(rotation: true)
  end

  # Adds training class to employee's training record
  def save_training training
    return Bvadmin::Training.new if training.nil?
    return Bvadmin::Training.new unless training.is_a? Hash
    return Bvadmin::Training.new if training[:class_name].blank? && training[:class_date].blank?

    train = self.trainings.build(class_name: training[:class_name], class_date: training[:class_date])
    if train.valid?
      train.save
    else
      append_errors 'training', train
    end

    train
  end

  # updates training classes
  def update_training training
    return nil if training.nil? || !training.is_a?(Hash)

    training.each do |k, v|
      begin
        course = Bvadmin::Training.find(k)
        course.update_attributes(class_name: v[:class_name],
                                 class_date: v[:class_date])

        if course.valid?
          course.save
        else
          append_errors 'Training', course
        end

      rescue ActiveRecord::RecordNotFound
        errors.add 'Training.ID', 'Invalid record'
        next
      end
    end
  end

  # Uploads an attachment to associated with the Employee record.
  def save_attachment attachment
    return nil if attachment.blank? || !attachment.is_a?(Hash)
    return nil if attachment[:attachment].blank? && attachment[:date].blank? && attachment[:notes].blank?

    attachment[:attachment] ||= FakeAttachment.new
    attachment[:date] = Date.today.strftime("%Y-%m-%d") if attachment[:date].blank?

    attach = Bvadmin::RmsAttachment.new(employee_id: self.employee_id,
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

  def save_award award
    return nil if award.nil? || award[:award_date].blank? || award[:special_award_date].blank?

    output = awards.build(special_award_amount: award[:special_award_amount],
                          special_award_date: award[:special_award_date],
                          within_grade_date: award[:within_grade_date],
                          award_date: award[:award_date],
                          award_amount: award[:award_amount],
                          quality_step_date: award[:quality_step_date])

    if output.valid?
      output.save
    else
      append_errors 'Award', output
    end

    output
  end

  def save_awards awards
    return [Bvadmin::EmployeeAwardInfo.new] if awards.nil? || awards.empty?

    rst = []
    awards.each do |award|
      tmp = save_award(award)
      rst << tmp if tmp && !tmp.valid?
    end

    rst = [Bvadmin::EmployeeAwardInfo.new] if rst.empty?
    rst
  end
  
  
  def edit_awards awards
    return if awards.nil? || awards.empty?
    awards.each do |id, award|
      temp = Bvadmin::EmployeeAwardInfo.find_by(id: id)
      if temp.nil?
        errors.add "Award.#{id}", "Invalid ID"
        next
      end
      temp.update_attributes(special_award_amount: award[:special_award_amount],
                             special_award_date: award[:special_award_date],
                             within_grade_date: award[:within_grade_date],
                             award_date: award[:award_date],
                             award_amount: award[:award_amount],
                             quality_step_date: award[:quality_step_date])

      if temp.valid?
        temp.save
      else
        append_errors 'Award', temp
      end
    end
  end
  
  def save_status status
    return Bvadmin::RmsStatusInfo.new if status.nil? || status.blank? || status[:status_type].blank?

    output = Bvadmin::RmsStatusInfo.new(employee_id: self.employee_id,
                                        status_type: status[:status_type],
                                        rolls_date: status[:rolls_date],
                                        str_appointment_onboard_date: status[:appointment_onboard_date],
                                        appointment_notes: status[:appointment_notes],
                                        separation_status: status[:separation_status],
                                        separation_reason: status[:separation_reason],
                                        str_separation_effective_date: status[:separation_effective_date],
                                        termination_notes: status[:termination_notes],
                                        str_promotion_date: status[:promotion_date],
                                        promotion_notes: status[:promotion_notes])
    if output.valid?
      output.save
    else
      append_errors 'Status', output
    end

    output
  end

  def update_assignment attributes
    return Bvadmin::RmsEmployeeAssignmentInfo.new if attributes[:assignment_type].blank?

    build_assignment if assignment.nil?
    assignment.update_attributes attributes
    
    if assignment.valid?
      assignment.save
    else
      append_errors 'assignment', assignment
    end

    assignment
  end

  def update_attorney attributes
    return Bvadmin::Attorney.new if attorney_id.blank?

    build_attorney if attorney.nil?
    attorney.update_attributes attributes

    if attorney.valid?
      attorney.save
    else
      append_errors 'attorney', attorney
    end

    attorney
  end

  # setter for primary org code
  def primary_org= new_org
    if new_org.blank?
      return nil if primary_org.new_record?
      primary_org.update_attributes(employee_id: nil)
      return new_org
    end

    if new_org.is_a?(Fixnum) || new_org.is_a?(String)
      new_org = Bvadmin::RmsOrgCode.find(new_org.to_i) if new_org.to_i > 0
      new_org ||= Bvadmin::RmsOrgCode.find_by(code: new_org)
    end

    unless new_org.is_a? Bvadmin::RmsOrgCode
      errors.add :primary_org, 'invalid data type'
      return nil
    end

    return new_org if primary_org.code == new_org.code

    unless primary_org.new_record?
      primary_org.update_attributes!(employee_id: nil)
      primary_org.save
    end

    new_org.update_attributes!(employee_id: self.employee_id)
    new_org.save
    new_org

  rescue Exception
    errors.add :primary_org, 'could not update by given value'
    nil
  end

  # getter for primary org code
  def primary_org
    org_codes.find_by(rotation: false) || Bvadmin::RmsOrgCode.new(employee_id: self.employee_id)
  end

  # setter for rotation org code
  def rotation_org= new_org
    if new_org.blank?
      return nil if rotation_org.new_record?
      rotation_org.update_attributes(employee_id: nil)
      return new_org
    end

    if new_org.is_a?(Fixnum) || new_org.is_a?(String)
      new_org = Bvadmin::RmsOrgCode.find(new_org.to_i) if new_org.to_i > 0
      new_org ||= Bvadmin::RmsOrgCode.find_by(code: new_org)
    end

    unless new_org.is_a? Bvadmin::RmsOrgCode
      errors.add :rotation_org, 'invalid data type'
      return nil
    end

    return new_org if rotation_org.id == new_org.id

    unless rotation_org.new_record?
      rotation_org.update_attributes!(employee_id: nil)
      rotation_org.save
    end

    new_org.update_attributes!(employee_id: self.employee_id)
    new_org.save
    new_org

  rescue Exception
    errors.add :rotation_org, 'could not update by given value'
    nil
  end

  # getting for rotation  org code
  def rotation_org
    org_codes.find_by(rotation: true) || Bvadmin::RmsOrgCode.new(employee_id: self.employee_id)
  end

  def on_union?
    !!self.on_union
  end

  def is_attorney?
    %w{0905}.include? self.job_code # series
  end

  def is_board_member?
    is_attorney? && self.pay_sched =~ /^(al|sl|es)/i
  end

  def is_assigned?
    is_attorney? && self.pay_sched =~ /^al/i
  end

  ## Ewwww.... There HAS to be a better way.
  # :nodoc:
  def current_bva_duty_date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  # :nodoc:
  def prior_bva_duty_date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  # :nodoc:
  def date_of_grade= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  # :nodoc:
  def promo_elig_date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  # :nodoc:
  def wig_date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  # :nodoc:
  def last_wig_date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  # :nodoc:
  def rotation_start= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  # :nodoc:
  def rotation_end= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  # :nodoc:
  def union_start= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  def union_end= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  private

  # Add errors from another model to this model.
  def append_errors name, model
    model.errors.each do |k, v|
      self.errors.add "#{name}.#{k}", v
    end
  end

  class FakeAttachment
    attr_reader :original_filename, :content_type, :read

    def initialize
      @original_filename = ""
      @content_type = ""
      @read = ""
    end
  end
end
