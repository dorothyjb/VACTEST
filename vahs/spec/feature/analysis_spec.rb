=begin
require "rails_helper"

RSpec.feature "Analysis Page" do
  it "Has docket range" do
    visit "/analysis"
    expect(page).to have_field('docdate')
  end

  it "Has Hearing Type" do
    visit "/analysis"
    expect(find("#content")).to have_select('hType',
                                            :selected => '[Select Below]',
                                            :options => [ '[Select Below]',
                                                          'Central Office (CO)',
                                                          'Travel Board (TB)',
                                                          'Video Hearing (VH)'
                                                        ])
  end

  it "Has number of judges" do
    visit "/analysis"
    expect(find("#content")).to have_field('numJudge')
  end

  it "Has hearing days/month" do
    visit "/analysis"
    expect(find("#content")).to have_field('judgeMult')
  end

  it "Has central office days" do
    visit "/analysis"
    expect(find("#content")).to have_field('coDays')
  end

  it "Displays an error if I don't select a Hearing type" do
    visit "/analysis"
    select "[Select Below]", from: 'hType'
    click_button "btnView"
    expect(find(".error")).to have_text("An error has occurred")
  end

  it "Displays Central Office Analysis" do
    visit "/analysis"
    select "Central Office (CO)", from: 'hType'
    click_button "btnView"
    expect(find(".rptResultsHeader")).to have_content("Central Office Allocation Analysis")
  end

  it "Displays Travel Board Analysis" do
    visit "/analysis"
    select "Travel Board (TB)", from: 'hType'
    click_button "btnView"
    expect(find(".rptResultsHeader")).to have_content("Travel Board Allocation Analysis")
  end

  it "Displays Video Hearing Analysis" do
    visit "/analysis"
    select "Video Hearing (VH)", from: 'hType'
    click_button "btnView"
    expect(find(".rptResultsHeader")).to have_content("Video Hearing Allocation Analysis")
  end

  it "Exports an XLS file for Video Hearing" do
    visit "/analysis"
    select "Video Hearing (VH)", from: 'hType'
    click_button 'btnExport'
    expect(page.response_headers['Content-Type']).to have_content('application/vnd.ms-excel')
  end

  it "Exports an XLS file for Travel Board" do
    visit "/analysis"
    select "Travel Board (TB)", from: 'hType'
    click_button "btnExport"
    expect(page.response_headers['Content-Type']).to have_content('application/vnd.ms-excel')
  end

  it "Exports an XLS file for Central Office" do
    visit "/analysis"
    select "Central Office (CO)", from: 'hType'
    click_button "btnExport"
    expect(page.response_headers['Content-Type']).to have_content('application/vnd.ms-excel')
  end

  it "Displays an error if I attempt to export no Hearing type" do
    visit "/analysis"
    select "[Select Below]", from: 'hType'
    click_button "btnExport"
    expect(find(".error")).to have_text("An error has occurred")
  end
=end
