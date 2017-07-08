class Bvadmin::RmsAttachment < Bvadmin::Record
  self.table_name = "BVADMIN.RMS_ATTACHMENTS"

  belongs_to :employee
end
