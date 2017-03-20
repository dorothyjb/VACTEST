require 'rails_helper'

RSpec.describe Vacols::Brieff, :type => :model do
  it "is valid" do
    expect(Vacols::Brieff.new).to be_valid
  end

  it "returns array index 0 for fiscal year less than or equal to 2000" do
    v = Vacols::Brieff.new
    v[:BFD19] = Date.new(1999, 9, 30)
    v.fiscal_year.should == 0
    v[:BFD19] = Date.new(2017, 3, 14)
    v.fiscal_year.should_not == 0
  end

  it "returns array index 1 for fiscal year less than or equal to 2005" do
    v = Vacols::Brieff.new
    v[:BFD19] = Date.new(2003, 9, 30)
    v.fiscal_year.should == 1
    v[:BFD19] = Date.new(2017, 3, 14)
    v.fiscal_year.should_not == 1
  end

  it "returns array index 2 for fiscal year less than or equal to 2010" do
    v = Vacols::Brieff.new
    v[:BFD19] = Date.new(2007, 9, 30)
    v.fiscal_year.should == 2
    v[:BFD19] = Date.new(2017, 3, 14)
    v.fiscal_year.should_not == 2
  end

  it "returns array index 3 for fiscal year less than or equal to 2015" do
    v = Vacols::Brieff.new
    v[:BFD19] = Date.new(2012, 9, 30)
    v.fiscal_year.should == 3
    v[:BFD19] = Date.new(2017, 3, 14)
    v.fiscal_year.should_not == 3
  end

  it "returns array index 4 for fiscal year less than or equal to 2016" do
    v = Vacols::Brieff.new
    v[:BFD19] = Date.new(2016, 1, 30)
    v.fiscal_year.should == 4
    v[:BFD19] = Date.new(2017, 3, 14)
    v.fiscal_year.should_not == 4
  end

  it "returns array index 5 for fiscal year less than or equal to 2017" do
    v = Vacols::Brieff.new
    v[:BFD19] = Date.new(2017, 1, 30)
    v.fiscal_year.should == 5
    v[:BFD19] = Date.new(2000, 3, 14)
    v.fiscal_year.should_not == 5
  end

  it "raises an exception if I enter a year later than 2017" do
    v = Vacols::Brieff.new
    v[:BFD19] = Date.new(2020, 1, 30)
    expect { v.fiscal_year }.to raise_exception(Exception)
  end

  it "raises an exception when I pass an invalid hType to do_work" do
    expect { Vacols::Brieff.do_work("12", nil) }.to raise_exception(Exception)
  end
end
