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

    Bvadmin::Employee.find(1).attachments.delete_all
  end

  let(:content) { find('#employee-records') }
  let(:certificate) { Rails.root + 'spec/fixtures/files/certificate.png' }

  it 'should have the header "Employee Records"' do
    expect(content).to have_text 'Employee Records'
  end

  it 'should have a select for "Document Type"' do
    expect(content).to have_select 'attachment[][attachment_type]'
  end

  it 'should have a place to upload attachments' do
    expect(content).to have_field 'attachment[][attachment]'
  end

  it 'should have a place to add notes' do
    expect(content).to have_field 'attachment[][notes]'
  end

  it 'should let me attach a file' do
    # verify attachment isn't there.
    expect(content).to_not have_text 'Other'
    expect(content).to_not have_link 'certificate.png'
    expect(content).to_not have_text 'This is my certificate'

    # upload attachment
    select 'Other', from: 'attachment[][attachment_type]'
    attach_file 'attachment[][attachment]', certificate
    fill_in 'attachment[][notes]', with: 'This is my certificate'
    find('#save_employee').click

    # verify attachment was uploaded.
    expect(page).to have_text 'employee was saved'

    click_link 'Employee Records'

    # verify attachment is available
    expect(content).to have_text 'Other'
    expect(content).to have_link 'certificate.png'
    expect(content).to have_text 'This is my certificate'
  end
end
