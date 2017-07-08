require 'rails_helper'

RSpec.feature 'Employee Attachment(s)' do
  before(:all) do
    role = Bvadmin::RmsRole.find_by(name: 'employee')
    user = Bvadmin::RmsUser.find_by(email: 'test@localhost')
    user.update rms_roles: [ role ]
  end

  before(:each) do
    visit '/rms/employee/edit/1'
  end

  after(:all) do
    user = Bvadmin::RmsUser.find_by(email: 'test@localhost')
    user.update rms_roles: []
  end

  let(:content) { find('#content') }

  it 'should contain a field to upload attachments' do
    expect(content).to have_field('attachment[attachment]')
  end
end
