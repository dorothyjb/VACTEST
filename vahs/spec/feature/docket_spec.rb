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
end
