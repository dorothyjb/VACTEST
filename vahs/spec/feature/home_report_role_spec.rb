require 'rails_helper'

RSpec.feature 'Home Page with report role' do
  before(:all) do
    role = Bvadmin::RmsRole.find_by(name: 'report')
    user = Bvadmin::RmsUser.find_by(email: 'test@localhost')
    user.update rms_roles: [ role ]
  end

  before(:each) do
    visit '/'
  end

  after(:all) do
    user = Bvadmin::RmsUser.find_by(email: 'test@localhost')
    user.update rms_roles: []
  end

  let(:content) { find('#content') }

  it 'should contain Research & Analysis' do
    expect(content).to have_content('Research & Analysis')
  end

  it 'should not contain Data Entry & Maintenance' do
    expect(content).to_not have_content('Data Entry & Maintenance')
  end

  it 'should contain a link to the Employee Locator' do
    expect(content).to have_link 'Employee Locator'
  end

  it 'should not contain a link to the Employee record search' do
    expect(content).to_not have_link 'Employee Record Search'
  end

  it 'should contain a link to the Reports page' do
    expect(content).to have_link 'Reports'
  end

  it 'should contain a link to the PAID file update report' do
    expect(content).to have_link 'PAID File Update Report'
  end

  it 'should not contain Administrative Tools' do
    expect(content).to_not have_content('Administrative Tools')
  end
end
