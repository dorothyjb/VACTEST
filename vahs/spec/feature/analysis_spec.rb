require "rails_helper"

RSpec.feature "Analysis Page" do
  it "Has docket range" do
    visit "/analysis"
    expect(find("#content")).to have_field('docdate')
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
end
