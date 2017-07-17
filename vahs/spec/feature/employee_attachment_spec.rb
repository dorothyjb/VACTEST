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

  it 'should have an accordion for uploading attachments' do
    expect(content).to have_link 'Upload Attachment'
  end

  it 'should have an accordion for listing attachments' do
    expect(content).to have_link 'Employee Attachments'
  end

  it 'should have a select for "Document Type"' do
    click_link 'Upload Attachment'
    
    expect(content).to have_text 'Document Type'
    expect(content).to have_select :attachment_type
  end

  it 'should have a place to upload attachments' do
    click_link 'Upload Attachment'

    expect(content).to have_text 'Filename'
    expect(content).to have_field 'attachment[attachment]'
  end

  it 'should have a place to add notes' do
    click_link 'Upload Attachment'

    expect(content).to have_text 'Notes'
    expect(content).to have_field 'attachment[notes]'
  end

  scenario 'attach a file' do
    # verify attachment isn't there.
    click_link "Employee Attachments"

    expect(content).to_not have_text 'Other'
    expect(content).to_not have_link 'certificate.png'
    expect(content).to_not have_text 'This is my certificate'

    # upload attachment
    click_link 'Upload Attachment'
    select 'Other', from: 'attachment[attachment_type]'
    attach_file 'attachment[attachment]', certificate
    fill_in 'attachment[notes]', with: 'This is my certificate'
    find('#save_employee').click

    # verify attachment was uploaded.
    expect(page).to have_text 'employee was saved'

    # verify attachment is visible
    click_link 'Employee Records'
    click_link 'Employee Attachments'

    expect(content).to have_text 'Other'
    expect(content).to have_link 'certificate.png'
    expect(content).to have_text 'This is my certificate'
  end
end
