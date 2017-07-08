=begin
require 'rails_helper'

RSpec.describe Vacols::RegionalOffice, :type => :model do
  before(:all) do
    dates = [
              [ "1970-10-01", "2000-09-30" ],
              [ "2000-10-01", "2005-09-30" ],
              [ "2005-10-01", "2010-09-30" ],
              [ "2010-10-01", "2015-09-30" ],
              [ "2015-10-01", "2016-09-30" ],
              [ "2016-10-01", "2017-09-30" ],
              [ "3000-10-01", "3001-09-30" ],
            ]
    @ro = Vacols::RegionalOffice.new("RO01", dates)
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

  it "populates the fiscal_years array." do
    @ro.fiscal_years.should_not be_empty
  end

  it "defaults the percentage calculation of docdate_total to the value of docdate_total" do
    @ro.percentage.should == 100.0
  end

  it "calculates the percentage of docdate_total with a given total" do
    @ro.percentage(2.0).should == 50.0
  end

  it "displays the correct display" do
    @ro.fiscal_years[0][:display].should == "FY71-FY00"
    @ro.fiscal_years[1][:display].should == "FY01-FY05"
    @ro.fiscal_years[2][:display].should == "FY06-FY10"
    @ro.fiscal_years[3][:display].should == "FY11-FY15"
    @ro.fiscal_years[4][:display].should == "FY16"
    @ro.fiscal_years[5][:display].should == "FY17"
    @ro.fiscal_years[6][:display].should == "FY01"
  end

  it "populates the correct fiscal years" do
    Vacols::Brieff.central_office.each { |b| @ro.update_fiscal_year b }

    @ro.fiscal_years[0][:total].should > 0
    @ro.fiscal_years[1][:total].should > 0
    @ro.fiscal_years[2][:total].should > 0
    @ro.fiscal_years[3][:total].should > 0
    @ro.fiscal_years[4][:total].should > 0
    @ro.fiscal_years[5][:total].should > 0
    @ro.fiscal_years[6][:total].should == 0
  end
=end
