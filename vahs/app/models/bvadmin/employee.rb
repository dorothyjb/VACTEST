class Bvadmin::Employee < Bvadmin::Record
  self.table_name = "BVADMIN.EMPLOYEE"
  self.primary_key = :employee_id
  self.sequence_name = "BVADMIN.EMP_ID_SEQ"

  # validators
  validates :fname, presence: true
  validates :lname, presence: true

  # associations
  has_one :attorney
  has_many :trainings, class_name: Bvadmin::Training

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
    return nil if pic.nil? or !(pic.respond_to?(:content_type) and pic.respond_to?(:read))

    self.picture_mime = pic.content_type
    self.picture_data = pic.read

    rst = nil
    rst = self if self.save

    rst
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
    Bvadmin::RmsOrgCode.where(employee_id: self.employee_id).count > 1
  end

  # Update the orginization code associated with this Employee Record
  # Returns an RmsOrgCode object if the org code could be associated.
  # Returns +nil+ if the given org code could not be associated.
  #
  # <tt>new_org_id</tt> The +ID+ of the org code to associate
  # <tt>rotation</tt> Is this a rotation entry?
  def update_org new_org_id, rotation = false
    org = Bvadmin::RmsOrgCode.find_by(employee_id: self.employee_id, rotation: rotation)

    if org
      return org if org.id == new_org_id

      org.employee_id = nil
      return nil unless org.save
    end

    org = Bvadmin::RmsOrgCode.find(new_org_id)
    if org
      org.employee_id = self.employee_id
      return org if org.save
    end

    nil
  end

  # define training
  def training
     super || Bvadmin::Training.new 
  end

  # Removes an associated org code with the Employee record
  # Returns the org code object that was associated with this employee if the association could be removed
  # Returns +nil+ if the org code could not be removed
  #
  # If <tt>rotation</tt> is +false+, Remove the primary org code associated with this employee
  # If <tt>rotation</tt> is +true+, Remove the rotation org code associated with this employee
  def remove_org rotation=false
    org = Bvadmin::RmsOrgCode.find_by(employee_id: self.employee_id, rotation: rotation)
    if org
      org.employee_id = nil
      return org if org.save
    end

    nil
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
end

