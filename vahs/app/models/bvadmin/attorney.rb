class Bvadmin::Attorney < Bvadmin::Record
  self.table_name = "BVADMIN.ATTORNEY"
  self.primary_key = :attorney_id

  belongs_to :employee

  def board_appt_date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  def board_reappt_date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  def board_exp_date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end
end
