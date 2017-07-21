require 'rails_helper'

RSpec.feature 'Knowledge Management' do
  before(:all) do
    role = Bvadmin::RmsRole.find_by(name: 'employee')
    user = Bvadmin::RmsUser.find_by(email: 'test@localhost')
    user.update rms_roles: [ role ]
  end

  before(:each) do
    visit '/rms/employee/edit/1'
    click_link 'Knowledge Management'
  end

  after(:all) do
    user = Bvadmin::RmsUser.find_by(email: 'test@localhost')
    user.update rms_roles: []

    employee = Bvadmin::Employee.find(1)
    employee.trainings.destroy_all
    employee.update(user_id: nil)
  end

  let(:content) { find('#knowledge-management') }
  let(:training_actions) { find('#knowledge-management .entries .actions') }
  let(:training_courses) { find('#knowledge-management .entries') }
  
  it 'should have a place for me to enter a class name' do
    click_link 'Add Class'

    expect(content).to have_text('Class Name')
    expect(content).to have_field('training[class_name]')
  end

  it 'should have a place for me to enter a class date' do
    click_link 'Add Class'

    expect(content).to have_text('Class Date')
    expect(content).to have_field('training[class_date]')
  end

  it 'should not let me add a class if the User ID is blank' do
    click_link 'Add Class'

    fill_in 'training[class_name]', with: 'RSpec Training'
    fill_in 'training[class_date]', with: '07/20/2017'

    click_button 'Save'

    expect(page).to have_text "user_id: can't be blank"
  end

  it 'should let me add a class if the User ID is not blank' do
    click_link 'Personal Information 1'

    fill_in 'employee[user_id]', with: '1234'

    click_link 'Knowledge Management'
    click_link 'Add Class'

    fill_in 'training[class_name]', with: 'RSpec Training'
    fill_in 'training[class_date]', with: '07/20/2017'

    click_button 'Save'

    expect(page).to have_text 'employee was saved'
  end

  it 'should not let me add a class without a date' do
    click_link 'Add Class'

    fill_in 'training[class_name]', with: 'RSpec Training 2.0'
    fill_in 'training[class_date]', with: ''

    click_button 'Save'

    expect(page).to have_text "date: can't be blank"
  end

  it 'should not let me add a class without a name' do
    click_link 'Add Class'

    fill_in 'training[class_name]', with: ''
    fill_in 'training[class_date]', with: '07/20/2017'

    click_button 'Save'

    expect(page).to have_text "name: can't be blank"
  end

  it 'should display the list of classes I have added' do
    click_link 'Class Details'

    expect(training_courses).to have_text 'RSpec Training'
    expect(training_courses).to have_text '07/20/2017'
  end

  it 'should have a link for editing the training entry' do
    click_link 'Class Details'

    expect(training_actions).to have_link 'Edit'
  end

  it 'should let me edit the class name of the class' do
    click_link 'Class Details'

    course = nil
    Bvadmin::Record.transaction do
      course = Bvadmin::Training.find_by(class_name: 'RSpec Training',
                                         class_date: Date.parse('2017-07-20'))
    end
    course_obj = "etraining[#{course.id}]"

    within(training_actions) do
      click_link 'Edit'
    end

    expect(training_courses).to have_field "#{course_obj}[class_name]"
    expect(training_courses).to have_field "#{course_obj}[class_date]"

    fill_in "#{course_obj}[class_name]", with: 'Rails Training'
    click_button 'Save'

    expect(page).to have_text 'employee was saved'

    click_link 'Knowledge Management'
    click_link 'Class Details'

    expect(training_courses).to have_text 'Rails Training'
    expect(training_courses).to have_text '07/20/2017'
    expect(training_courses).to_not have_text 'RSpec Training'
  end

  it 'should let me edit the class date of the class' do
    click_link 'Class Details'

    course = nil
    Bvadmin::Record.transaction do
      course = Bvadmin::Training.find_by(class_name: 'RSpec Training',
                                         class_date: Date.parse('2017-07-20'))
    end
    course_obj = "etraining[#{course.id}]"

    fill_in "#{course_obj}[class_date]", with: '12/12/2012'
    click_button 'Save'

    click_link 'Knowledge Management'
    click_link 'Class Details'

    expect(training_courses).to have_text 'Rails Training'
    expect(training_courses).to have_text '12/12/2012'

    expect(training_courses).to_not have_text '07/20/2017'
  end

  it 'should have a link for deleting the training entry' do
    click_link 'Class Details'

    expect(training_actions).to have_link 'Delete'
  end

  it 'should let me delete a class' do
    click_link 'Class Details'

    within(training_actions) do
      click_link 'Delete'
    end

    expect(page).to have_text 'was successfully removed'

    click_link 'Knowledge Management'
    click_link 'Class Details'

    expect(training_courses).to_not have_text 'RSpec Training'
    expect(training_courses).to_not have_text '07/20/2017'
  end
end
