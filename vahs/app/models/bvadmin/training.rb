class Bvadmin::Training < Bvadmin::Record
  self.table_name = "BVADMIN.TRAINING"

  belongs_to :employee 

end
