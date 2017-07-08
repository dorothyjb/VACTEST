require 'rails_helper'

RSpec.feature 'Home Page with employee role' do
  before(:all) do
    employee_role = Bvadmin::RmsRole.find_by(name: 'employee')
    user = Bvadmin::RmsUser.find_by(email: 'test@localhost')
    user.update rms_roles: [ employee_role ]
  end

  before(:each) do
    visit '/'
  end

  after(:all) do
    user = Bvadmin::RmsUser.find_by(email: 'test@localhost')
    user.update rms_roles: []
  end

  let(:content) { find('#content') }

  it 'should contain Data Entry & Maintenance' do
    expect(content).to have_content('Data Entry & Maintenance')
  end

  it 'should contain a link to create an employee record' do
    expect(content).to have_link 'Create Employee Record'
  end

  it 'should contain a link to modify an employee record' do
    expect(content).to have_link 'Modify Employee Record'
  end

  it 'should contain a link to the employee record search' do
    expect(content).to have_link 'Employee Record Search'
  end

  it 'should not contain Administrative Tools' do
    expect(content).to_not have_content('Administrative Tools')
  end
end
