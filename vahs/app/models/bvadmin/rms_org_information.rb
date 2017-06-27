class Bvadmin::RmsOrgInformation < Bvadmin::Record
  self.table_name = "BVADMIN.RMS_ORG_INFORMATION"

  belongs_to :rms_org_code

  def self.dropdown
    [ '' ] + where('name is not null').collect { |n| [ n[:name], n[:id] ] }
  end
end
