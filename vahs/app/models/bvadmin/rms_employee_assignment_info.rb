class Bvadmin::RmsEmployeeAssignmentInfo < Bvadmin::Record
  self.table_name = "BVADMIN.RMS_EMPLOYEE_ASSIGNMENT_INFO"
  self.sequence_name = "BVADMIN.RMS_EMP_ASSIGNMENT_INFO_seq"
  self.primary_key = :id
  
  belongs_to :employee

  def effective_date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  def expected_return_date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

end
