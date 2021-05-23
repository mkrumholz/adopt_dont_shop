require 'rails_helper'

RSpec.describe 'new application view' do
  describe 'creation form' do
    # before :each do
    #   @shelter = Shelter.create!(name: 'All Star Pets', city: 'Walkerville', foster_program: true, rank: 4)
    #   @liz = @frizz.pets.create!(name: 'Liz Ard', breed: "Jackson's chameleon", age: 7, adoptable: true, shelter: @shelter)
    #   @cat = @frizz.pets.create!(name: 'Catward', breed: 'bengal', age: 4, adoptable: false, shelter: @shelter)
    # end

    it 'renders the create form' do
      visit '/applications/new'

      expect(page).to have_content 'New Application'
      expect(find('form')).to have_content 'Name'
      expect(find('form')).to have_content 'Street Address'
      expect(find('form')).to have_content 'City'
      expect(find('form')).to have_content 'State'
      expect(find('form')).to have_content 'Zip Code'
      expect(find('form')).to have_content 'Why would you make a good home for a new pet?'
    end
  end

  describe 'create action' do
    context 'given valid data' do
      it 'creates a new application' do
        visit '/applications/new'

        fill_in 'Name', with: 'Ms. Frizzle'
        fill_in 'Street Address', with: '1 Magic Schoolbus Rd'
        fill_in 'City', with: 'Walkerville'
        choose :state, option: 'MD'
        fill_in 'Zip Code', with: 01010
        fill_in 'Why would you make a good home for a new pet?', with: 'Because I am a boss.'
        click_button 'Save'

        # expect(current_path).to eq "/applications/#{\/d+\}"
        expect(page).to have_content 'Ms. Frizzle'
        expect(page).to have_content '1 Magic Schoolbus Rd, Walkerville, MD, 01010'
        expect(page).to have_content 'Because I am a boss.'
        expect(page).to have_content 'Application status: In Progress'
      end
    end

    context 'given invalid data' do
      it 're-renders the creation form' do
        visit '/applications/new'

        click_button 'Save'

        expect(page).to have_current_path '/applications/new'
        expect(page).to have_content("Error: Name can\'t be blank, Street address can\'t be blank, City can\'t be blank, State can\'t be blank, Zip code is not valid, Description can\'t be blank")
      end
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
# Then I am taken to the new application\'s show page
# And I see my Name, address information, and
# description of why I would make a good home
# And I see an indicator that this application is "In Progress"
