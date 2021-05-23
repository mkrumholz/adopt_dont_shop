require 'rails_helper'

RSpec.describe 'new application view' do
  describe 'creation form' do
    it 'renders the create form'
  end

  describe 'create action' do
    context 'given valid data' do
      it 'creates a new application'
    end

    context 'given invalid data' do
      it 're-renders the creation form'
    end
  end
end

#
# As a visitor
# When I visit the pet index page
# Then I see a link to "Start an Application"
# When I click this link
# Then I am taken to the new application page where I see a form
# When I fill in this form with my:
#
# Name
# Street Address
# City
# State
# Zip Code
# And I click submit
# Then I am taken to the new application's show page
# And I see my Name, address information, and
# description of why I would make a good home
# And I see an indicator that this application is "In Progress"
