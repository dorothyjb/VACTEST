class Vacols::Lists < Vacols::Record
  self.table_name = "VACOLS.LISTS"

  scope :employee, -> { where("LSTKEY = 'EMPLOYEE'").order('LSTSTFID ASC') }
end
