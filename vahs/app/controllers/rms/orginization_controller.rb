class Rms::OrginizationController < Rms::ApplicationController
  def index
  end

  def office
    @offices = Bvadmin::RmsOrgCode.offices
    @divisions = Bvadmin::RmsOrgCode.divisions_by_office(params['office'])
    @branches = Bvadmin::RmsOrgCode.branches_by_office(params['office'])
    @units = Bvadmin::RmsOrgCode.units_by_office(params['office'])
    @org_codes = Bvadmin::RmsOrgCode.by_office(params['office'])
  end

  def division
  end

  def branch
  end

  def unit
  end

  def org_code
  end
end
