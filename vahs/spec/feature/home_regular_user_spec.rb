require 'rails_helper'

RSpec.feature 'Home Page as regular user' do
  before(:each) do
    visit '/'
  end

  it 'should contain Research & Analysis' do
    expect(find('#content')).to have_content('Research & Analysis')
  end

  it 'should contain a link to the Employee Locator' do
    expect(find('#content')).to have_link 'Employee Locator'
  end

  it 'should not contain Data Entry & Maintenance' do
    expect(find('#content')).to_not have_content('Data Entry & Maintenance')
  end

  it 'should not contain Administrative Tools' do
    expect(find('#content')).to_not have_content('Administrative Tools')
  end
end
