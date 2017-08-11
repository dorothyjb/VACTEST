class Bvadmin::RmsOrgInformation < Bvadmin::Record
  self.table_name = "BVADMIN.RMS_ORG_INFORMATION"

  belongs_to :rms_org_code

  def self.dropdown
    [ '' ] + where('name is not null').collect { |n| [ n[:name], n[:id] ] }
  end

  def total_fte
    Bvadmin::Employee.joins(:org_codes).where(<<-EOQ).sum(:fte).to_f
      rms_org_code.#{type_id} = #{self.id} and
      employee.employee_id = rms_org_code.employee_id
    EOQ
  end

  def total_vacant
    Bvadmin::RmsOrgCode.where("employee_id is null and #{type_id} = #{self.id}").count
  end

  def total_on_board
    0
  end

  def total_on_board_other
    0
  end

  def funded_positions
    Bvadmin::RmsOrgCode.where("rotation = 0 and #{type_id} = #{self.id}").count
  end

  def unfunded_positions
    Bvadmin::RmsOrgCode.where("rotation = 1 and #{type_id} = #{self.id}").count
  end

  def total_incoming
    0
  end

  def total_departing
    0
  end

private
  def type_id
    {
      'Bvadmin::RmsOrgOffice' => 'office_id',
      'Bvadmin::RmsOrgDivision' => 'division_id',
      'Bvadmin::RmsOrgBranch' => 'branch_id',
      'Bvadmin::RmsOrgUnit' => 'unit_id',
    }.fetch(self.class.to_s, 'id')
  end
end
