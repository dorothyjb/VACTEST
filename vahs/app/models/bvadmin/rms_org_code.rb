class Bvadmin::RmsOrgCode < Bvadmin::Record
  self.table_name = "BVADMIN.RMS_ORG_CODE"

  has_one :employee

  scope :offices, -> { Bvadmin::RmsOrgOffice.where('name is not null') }
  scope :divisions_by_office, -> (office_id) {
    Bvadmin::RmsOrgDivision.where('id in (?)',
                                  Bvadmin::RmsOrgCode.
                                  select(:division_id).uniq.
                                  where('office_id = :office_id and division_id is not null', office_id: office_id).collect { |x| x.division_id })
  }

  scope :branches_by_office, -> (office_id) {
    Bvadmin::RmsOrgBranch.where('id in (?)',
                                Bvadmin::RmsOrgCode.
                                select(:branch_id).uniq.
                                where('office_id = :office_id and branch_id is not null', office_id: office_id).collect { |x| x.branch_id })
  }

  scope :units_by_office, -> (office_id) {
    Bvadmin::RmsOrgUnit.where('id in (?)',
                              Bvadmin::RmsOrgCode.
                              select(:unit_id).uniq.
                              where('office_id = :office_id and unit_id is not null', office_id: office_id).collect { |x| x.unit_id })
  }

  scope :by_office, -> (office_id) { where(office_id: office_id) }
  scope :by_division, -> (division_id) { where(division_id: division_id) }
  scope :by_branch, -> (branch_id) { where(branch_id: branch_id) }
  scope :by_unit, -> (unit_id) { where(unit_id: unit_id) }

  def division
    Bvadmin::RmsOrgInformation.where(id: division_id).first
  end

  def office
    Bvadmin::RmsOrgInformation.where(id: office_id).first
  end

  def branche
    Bvadmin::RmsOrgInformation.where(id: branch_id).first
  end

  def unit
    Bvadmin::RmsOrgInformation.where(id: unit_id).first
  end

  def self.dropdown rotation=false
    [ '' ] + where('code is not null and rotation = ?', rotation).collect { |o| [ o[:code], o[:id] ] }
  end
end
