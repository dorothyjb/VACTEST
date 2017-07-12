require 'rails_helper'

RSpec.feature 'Employee Attachment(s)' do
  before(:all) do
    role = Bvadmin::RmsRole.find_by(name: 'employee')
    user = Bvadmin::RmsUser.find_by(email: 'test@localhost')
    user.update rms_roles: [ role ]
  end

  before(:each) do
    visit '/rms/employee/edit/1'
    click_link 'Employee Records'
  end

  after(:all) do
    user = Bvadmin::RmsUser.find_by(email: 'test@localhost')
    user.update rms_roles: []
  end

  let(:content) { find('#employee-records') }

  it 'should have the header "Employee Records"' do
    expect(content).to have_text 'Employee Records'
  end

  it 'should have a select for "Document Type"' do
    expect(content).to have_text 'Document Type'
    expect(content).to have_select :attachment_type
  end
end
