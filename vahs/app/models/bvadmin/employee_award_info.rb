class Bvadmin::EmployeeAwardInfo < Bvadmin::Record
  self.table_name = "BVADMIN.EMPLOYEE_AWARD_INFO"
  self.primary_key = :id
  
  belongs_to :employee


  def special_award_date= date
      return super(date) unless date.is_a? String

      date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
      date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
      date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

      super date
  end


  def within_grade_date= date
      return super(date) unless date.is_a? String

      date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
      date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
      date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

      super date
  end

  def award_date= date
      return super(date) unless date.is_a? String

      date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
      date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
      date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

      super date
  end
  def quality_step_date= date
      return super(date) unless date.is_a? String

      date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
      date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
      date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

      super date
  end
end
