class Bvadmin::Training < Bvadmin::Record
  self.table_name = "BVADMIN.TRAINING"

  belongs_to :employee 

  def class_date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end


end
