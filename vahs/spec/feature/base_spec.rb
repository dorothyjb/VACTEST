require "rails_helper"

RSpec.feature "Home Page" do
  it "displays Index" do
    visit '/'
    p find("#content")
  end
end
