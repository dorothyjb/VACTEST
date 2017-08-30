class Rms::OrganizationController < Rms::ApplicationController
  def index
  end

  def dropdown
    @office = coerce_nil(params['office'])
    @division = coerce_nil(params['division'])
    @branch = coerce_nil(params['branch'])
    @unit = coerce_nil(params['unit'])
    @org_code = coerce_nil(params['org_code'])
    @selected = params['selected']

    ####
    # Logic to select office/division/branch/unit based on input.
    if @selected == 'primary_org'
      temp = Bvadmin::RmsOrgCode.find_by(id: @org_code)
      unless temp.nil?
        @office = temp.office_id
        @division = temp.division_id
        @branch = temp.branch_id
        @unit = temp.unit_id
      end
    elsif @selected == 'division'
      @office ||= Bvadmin::RmsOrgDivision.find_by(id: @division).try(:parent_id)
      @branch = nil
      @unit = nil
    elsif @selected == 'branch'
      @division ||= Bvadmin::RmsOrgBranch.find_by(id: @branch).try(:parent_id)
      @office ||= Bvadmin::RmsOrgDivision.find_by(id: @division).try(:parent_id)
      @unit = nil
    elsif @selected == 'unit'
      @branch ||= Bvadmin::RmsOrgUnit.find_by(id: @unit).try(:parent_id)
      @division ||= Bvadmin::RmsOrgBranch.find_by(id: @branch).try(:parent_id)
      @office ||= Bvadmin::RmsOrgDivision.find_by(id: @division).try(:parent_id)
    elsif @selected == 'office'
      @division = nil
      @branch = nil
      @unit = nil
    end

    ###
    # get record sets based on input (for populating dropdowns)
    @offices = Bvadmin::RmsOrgCode.offices
    @divisions = Bvadmin::RmsOrgDivision.where(parent_id: @office || @offices.ids)
    @branches = Bvadmin::RmsOrgBranch.where(parent_id: @division || @divisions.ids)
    @units = Bvadmin::RmsOrgUnit.where(parent_id: @branch || @branches.ids)

    ###
    # Additional logic (auto select if only one.)
    if @selected == 'office'
      @division = @divisions.first.id if @divisions.count == 1
      @branch = @branches.first.id if @branches.count == 1
      @unit = @units.first.id if @units.count == 1
    elsif @selected == 'division'
      @branch = @branches.first.id if @branches.count == 1
      @unit = @units.first.id if @units.count == 1
    elsif @selected == 'branch'
      @unit = @units.first.id if @units.count == 1
    end

    ###
    # Try to keep org code populated
    @org_codes = Bvadmin::RmsOrgCode.where(unit_id: @unit || 0)
    @org_codes = Bvadmin::RmsOrgCode.where(branch_id: @branch || 0) if @org_codes.empty?
    @org_codes = Bvadmin::RmsOrgCode.where(division_id: @division || 0) if @org_codes.empty?
    @org_codes = Bvadmin::RmsOrgCode.where(office_id: @office || 0) if @org_codes.empty?
    @org_codes = Bvadmin::RmsOrgCode.where('code is not null and rotation = ?', false) if @org_codes.empty?

    ###
    # Auto select org code if only one.
    @org_code = @org_codes.first.id if @org_codes.count == 1
  end

private
  # may not be necessary, but wanted to force blank strings to nil
  def coerce_nil s
    return nil if s.blank?
    s
  end
end
