require 'rails_helper'

RSpec.describe Bvadmin::Training, :type => :model do
  it "is not valid without without any attributes set" do
    expect(Bvadmin::Training.new).to_not be_valid
  end

  it "is not valid without a user_id" do
    expect(Bvadmin::Training.new(class_date: Date.today,
                                 class_name: "foo")).to_not be_valid
  end

  it "is not valid without a class_name" do
    expect(Bvadmin::Training.new(user_id: "1234",
                                 class_date: Date.today)).to_not be_valid
  end

  it "is not valid without a class_date" do
    expect(Bvadmin::Training.new(user_id: "1234",
                                 class_name: "foo")).to_not be_valid
  end

  it "lets me assign a string in the format of YYYY-MM-DD to a date" do
    train = Bvadmin::Training.new(class_date: '2012-12-12')
    expect(train.class_date.strftime('%Y-%m-%d')).to eq '2012-12-12'
  end

  it "lets me assign a string in the format of MM/DD/YYYY to a date" do
    train = Bvadmin::Training.new(class_date: '12/12/2012')
    expect(train.class_date.strftime('%Y-%m-%d')).to eq '2012-12-12'
  end

  it "lets me assign a string in the format of MMDDYYYY to a date" do
    train = Bvadmin::Training.new(class_date: '12122012')
    expect(train.class_date.strftime('%Y-%m-%d')).to eq '2012-12-12'
  end
end
