=begin
require 'rails_helper'

RSpec.describe Vacols::Brieff, :type => :model do
  it "is valid" do
    expect(Vacols::Brieff.new).to be_valid
  end

  it "raises an exception when I pass an invalid hType to do_work" do
    expect { Vacols::Brieff.do_work("12", nil) }.to raise_exception(Exception)
  end
=end
