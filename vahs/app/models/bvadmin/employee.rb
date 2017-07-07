class Bvadmin::Employee < Bvadmin::Record
  self.table_name = "BVADMIN.EMPLOYEE"
  self.primary_key = :employee_id
  self.sequence_name = "BVADMIN.EMP_ID_SEQ"

  # validators
  validates :fname, presence: true
  validates :lname, presence: true
  validates_uniqueness_of :attorney_id, allow_nil: true, allow_blank: true

  # associations
  has_one :attorney
  has_many :attachments, class_name: Bvadmin::RmsAttachments
  has_many :org_codes, class_name: Bvadmin::RmsOrgCode

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

  # Uploads an attachment to associated with the Employee record.
  def save_attachment attachment
    return nil if attachment.nil?
    return nil unless attachment.is_a? Hash
    return nil unless attachment.has_key? :attachment
    return nil unless attachment.has_key? :attachment_type
    return nil unless attachment[:attachment].respond_to? :original_filename
    return nil unless attachment[:attachment].respond_to? :content_type
    return nil unless attachment[:attachment].respond_to? :read

    attach = Bvadmin::RmsAttachments.new(employee_id: self.employee_id,
                                         attachment_type: attachment[:attachment_type],
                                         filename: attachment[:attachment].original_filename,
                                         filetype: attachment[:attachment].content_type,
                                         filedata: attachment[:attachment].read,
                                         notes: attachment[:notes],
                                         date: Date.today)

    if attach.valid?
      attach.save
      return attach
    else
      append_errors 'Attachment', attach
      return nil
    end
  end

  def attorney
    super || Bvadmin::Attorney.new
  end

  def update_attorney! attributes
    return nil if attorney_id.blank?

    attributes.merge!(employee_id: employee_id, attorney_id: attorney_id)

    attorney = Bvadmin::Attorney.find_by(attorney_id: attorney_id) || Bvadmin::Attorney.create!(attributes)
    attorney.update_attributes! attributes

  rescue Exception => e
    append_errors 'attorney', attorney
    raise
  end

  def update_attorney attributes
    update_attorney! attributes rescue nil
  end

  # setter for primary org code
  def primary_org= new_org
    new_org = Bvadmin::RmsOrgCode.find(new_org.to_i) if new_org.to_i > 0
    new_org = Bvadmin::RmsOrgCode.find_by(code: new_org) if new_org.is_a? String

    if new_org.nil?
      return nil if primary_org.new_record?

      primary_org.update_attributes(employee_id: nil)
      return nil
    end

    unless new_org.is_a? Bvadmin::RmsOrgCode
      errors.add :primary_org, 'invalid data type'
      return nil
    end

    primary_org.update_attributes!(employee_id: nil) unless primary_org.new_record?
    new_org.update_attributes!(employee_id: self.employee_id)
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
    new_org = Bvadmin::RmsOrgCode.find(new_org.to_i) if new_org.to_i > 0
    new_org = Bvadmin::RmsOrgCode.find_by(code: new_org) if new_org.is_a? String

    if new_org.nil?
      return nil if rotation_org.new_record?

      rotation_org.update_attributes(employee_id: nil)
      return nil
    end

    unless new_org.is_a? Bvadmin::RmsOrgCode
      errors.add :rotation_org, 'invalid data type'
      return nil
    end

    return new_org if rotation_org.id == new_org.id

    rotation_org.update_attributes!(employee_id: nil) unless rotation_org.new_record?
    new_org.update_attributes!(employee_id: self.employee_id)
    new_org

  rescue Exception
    errors.add :rotation_org, 'could not update by given value'
    nil
  end

  # getting for rotation  org code
  def rotation_org
    org_codes.find_by(rotation: true) || Bvadmin::RmsOrgCode.new(employee_id: self.employee_id)
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

  private

  # Add errors from another model to this model.
  def append_errors name, model
    model.errors.each do |k, v|
      errors["#{name}.#{k}"] << v
    end
  end
end

