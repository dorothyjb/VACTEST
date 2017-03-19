require 'rails_helper'

RSpec.describe Vacols::RegionalOffice, :type => :model do
  before(:all) do
    @ro = Vacols::RegionalOffice.new("RO01")
    @ro.docdate_total = 100
  end

  it "populates the station id" do
    @ro.station_id.should_not be_empty
  end

  it "populates the regional office hash" do
    @ro.regional_office.should_not be_empty
  end

  it "populates the timezone value" do
    @ro.tz_value.should_not == 0
  end

  it "defaults the percentage calculation of docdate_total to the value of docdate_total" do
    @ro.percentage.should == 100.0
  end

  it "calculates the percentage of docdate_total with a given total" do
    @ro.percentage(2.0).should == 50.0
  end
end
