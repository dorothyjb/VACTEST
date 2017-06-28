class Bvadmin::Employee < Bvadmin::Record
  self.table_name = "BVADMIN.EMPLOYEE"
  self.primary_key = :employee_id
  self.sequence_name = "BVADMIN.EMP_ID_SEQ"

  validates :fname, presence: true
  validates :lname, presence: true

  has_one :attorney

  #fte report
  scope :emp_fte_report, -> {where("fte > 0").order('name ASC')}
  scope :fte_losses, -> (startdate,startdate2){where("fte = 0 and status_change_date >= ? or status_change_date2 >= ?", startdate, startdate2).order('name ASC')}

  scope :paid_titles_list, -> { Bvadmin::Employee.select(:paid_title).distinct.order('PAID_TITLE ASC').
                                collect { |e| [ e.paid_title, e.paid_title ] unless e.paid_title.nil? }.
                                delete_if { |e| e.nil? } }

  scope :job_code_list, -> { Bvadmin::Employee.select(:job_code).distinct.order('JOB_CODE ASC').
                             collect { |e| [ e.job_code, e.job_code ] unless e.job_code.nil? }.
                             delete_if { |e| e.nil? } }

  scope :grades_list, -> { Bvadmin::Employee.select(:grade).distinct.order('GRADE ASC').
                           collect { |e| [ e.grade, e.grade ] unless e.grade.nil? }.
                           delete_if { |e| e.nil? } }

  scope :bva_titles_list, -> { Bvadmin::Employee.select(:bva_title).distinct.order('BVA_TITLE ASC').
                                collect { |e| [ e.bva_title, e.bva_title ] unless e.bva_title.nil? }.
                                delete_if { |e| e.nil? } }

  # XXX: Change this probably.
  scope :effectives_list, -> { Bvadmin::Employee.select(:assgnmt_date).distinct.order('ASSGNMT_DATE DESC').
                               collect { |e| [ e.assgnmt_date.strftime("%Y-%m-%d"), e.assgnmt_date.strftime("%Y-%m-%d") ] unless e.assgnmt_date.nil? }.
                               delete_if { |e| e.nil? or e.empty? } }
  
  # XXX/TODO: To be improved.
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

  def get_field_by_search_type srch_type
    # not DRY to avoid injection.
    rst = { "Employee ID" => :employee_id,
            "Attorney ID" => :attorney_id,
            "User ID" => :user_id,
            "Login ID" => :login_id,
            "Last Name" => :last_name_combined,
            "First Name" => :first_name_combined,
            "Grade" => :grade,
            "Work Group" => :work_group,
            "Assignment Date" => :assgnmt_date,
            "Service Completion Date" => :srvce_comp_date,
            "Years of Service" => :years_of_srvce,
            "BVA Title" => :bva_title,
            "Paid Title" => :paid_title,
            "Job Code" => :job_code,
            "Work Phone" => :work_phone,
            "Building Room" => :blding_room,
            "Position Number" => :position_num,
            "Employment Status" => :employment_status,
            "Bar Member" => :bar_member,
            "Generic" => :fte
          }
    return nil unless rst.has_key? srch_type

    rst = self.send(rst[srch_type])
    rst = rst.strftime("%Y-%m-%d") if rst.is_a? ActiveSupport::TimeWithZone

    rst
  end

  def last_name_combined
    rst = self.lname
    rst = "#{rst} (#{self.prev_lname})" unless self.prev_lname.nil? or self.prev_lname.empty?
    rst
  end

  def first_name_combined
    rst = self.fname
    rst = "#{rst} (#{self.fname2})" unless self.fname2.nil? or self.fname2.empty?
    rst
  end

  def save_picture pic
    return if pic.nil? or !(pic.respond_to?(:content_type) and pic.respond_to?(:read))

    self.picture_mime = pic.content_type
    self.picture_data = pic.read
    self.save!
  end 

  def has_picture?
    !(self.picture_mime.nil? && self.picture_data.nil?)
  end

  def on_rotation?
    Bvadmin::RmsOrgCode.where(employee_id: self.employee_id).count > 1
  end

  def update_org new_org_id, rotation = false
    org = Bvadmin::RmsOrgCode.find_by(employee_id: self.employee_id, rotation: rotation)

    if org
      return org if org.id == new_org_id

      org.employee_id = nil
      return nil unless org.save
    end

    org = Bvadmin::RmsOrgCode.find(new_org_id)
    org.employee_id = self.employee_id
    return org if org.save

    nil
  end

  def remove_org rotation=false
    org = Bvadmin::RmsOrgCode.find_by(employee_id: self.employee_id, rotation: rotation)
    if org
      org.employee_id = nil
      return org if org.save
    end

    nil
  end

  ## Ewwww.... There HAS to be a better way.
  def current_bva_duty_date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  def prior_bva_duty_date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  def date_of_grade= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  def promo_elig_date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  def wig_date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  def last_wig_date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  def rotation_start= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  def rotation_end= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end
end

