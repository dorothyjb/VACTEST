require "rails_helper"

RSpec.feature "Docket Page" do
  it "Has docket range" do
    visit "/docket"
    expect(find("#content")).to have_field('docdate')
  end

  it "Has Hearing Type" do
    visit "/docket"
    expect(find("#content")).to have_select('hType',
                                            :selected => '[Select Below]',
                                            :options => [ '[Select Below]',
                                                          'Central Office (CO)',
                                                          'Travel Board (TB)',
                                                          'Video Hearing (VH)'
                                                        ])
  end

  it "Displays an error if I fail to select a Hearing type" do
    visit "/docket"
    select "[Select Below]", from: 'hType'
    click_button "btnView"
    expect(find(".error")).to have_text("An error has occurred")
  end

  it "Displays Central office type when I select Central Office" do
    visit "/docket"
    select "Central Office (CO)", from: 'hType'
    click_button "btnView"
    expect(page.all(:xpath, ".//table/tbody/tr[1]/td[2]").first.text).to have_content("Central Office")
  end

  it "Displays Travel board type when I select Travel Board" do
    visit "/docket"
    select "Travel Board (TB)", from: 'hType'
    click_button "btnView"
    expect(page.all(:xpath, ".//table/tbody/tr[1]/td[2]").first.text).to have_content("Travel Board")
  end

  it "Displays Video type when I select Video Hearing" do
    visit "/docket"
    select "Video Hearing (VH)", from: 'hType'
    click_button "btnView"
    expect(page.all(:xpath, ".//table/tbody/tr[1]/td[2]").first.text).to have_content("Video")
  end
end
