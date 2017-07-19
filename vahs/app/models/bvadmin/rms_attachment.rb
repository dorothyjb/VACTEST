class Bvadmin::RmsAttachment < Bvadmin::Record
  self.table_name = "BVADMIN.RMS_ATTACHMENTS"

  attr_writer :str_date

  belongs_to :employee

  validate :str_date_is_valid

  validates :employee_id, presence: true
  validates :date, presence: true
  validates :filename, presence: true
  validates :filetype, presence: true
  validates :attachment_type, presence: true
  validates :filedata, presence: true


  def date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  def str_date
    @str_date || self.date.to_s
  end

  def str_date_is_valid
    return if @str_date.blank?

    unless @str_date =~ /^(\d{8}|\d{1,2}\/\d{1,2}\/\d{4}|\d{4}-\d{1,2}-\d{1,2})$/
      errors.add :date, 'invalid date format supplied, accepted forms are: YYYY-MM-DD, MMDDYYYY, and MM/DD/YYYY'
      return
    end

    if @str_date =~ /^\d{8}$/
      tmp = Date.strptime(@str_date, "%m%d%Y")
    elsif @str_date =~ /^\d{1,2}\/\d{1,2}\/\d{4}$/
      tmp = Date.strptime(@str_date, "%m/%d/%Y") 
    else
      tmp = Date.strptime(@str_date, "%Y-%m-%d") 
    end

    self.date = tmp
  end
end
