class Bvadmin::RmsAttachments < Bvadmin::Record
  self.table_name = "BVADMIN.RMS_ATTACHMENTS"

  belongs_to :employee
end
