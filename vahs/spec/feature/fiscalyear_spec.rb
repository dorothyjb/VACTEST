require "rails_helper"

RSpec.feature "Fiscal Years" do
  it "displays each date entry" do
    visit "/fiscalyears"
    expect(page).to have_xpath('//tbody/tr', count: 6)
  end

  it "lets me remove a date entry" do
    checkbox_path = '//input[@name="fy[]" and @value="5"]'

    visit "/fiscalyears"
    expect(find(:xpath, checkbox_path)).to_not be_checked
    find(:xpath, checkbox_path).click

    click_button 'btnRemoveFY'
    page.should have_no_selector(:xpath, checkbox_path)
    click_button 'btnCloseFY'

    visit "/fiscalyears"
    expect(page).to have_xpath('//tbody/tr', count: 5)
  end

  it "lets me add a date entry" do
    visit "/fiscalyears"
    expect(page).to have_xpath('//tbody/tr', count: 6)

    click_button 'btnAddFY'
    expect(page).to have_xpath('//tbody/tr', count: 7)
    click_button 'btnCloseFY' # loads defaults

    visit "/fiscalyears"
    expect(page).to have_xpath('//tbody/tr', count: 7)
  end
end
