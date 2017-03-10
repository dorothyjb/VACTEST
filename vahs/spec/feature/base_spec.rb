require "rails_helper"

RSpec.feature "Home Page" do
  it "displays Index" do
    visit "/"
    expect(find("#content")).to have_content("Index")
  end
end
