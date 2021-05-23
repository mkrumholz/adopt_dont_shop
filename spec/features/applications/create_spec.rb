require 'rails_helper'

RSpec.describe 'new application view' do
  describe 'creation form' do
    it 'renders the create form' do
      visit '/applications/new'

      expect(page).to have_content 'New Application'
      expect(find('form')).to have_content 'Name'
      expect(find('form')).to have_content 'Street address'
      expect(find('form')).to have_content 'City'
      expect(find('form')).to have_content 'State'
      expect(find('form')).to have_content 'Zip code'
      expect(find('form')).to have_content 'Why would you make a good home for a new pet?'
    end
  end

  describe 'create action' do
    context 'given valid data' do
      it 'creates a new application' do
        visit '/applications/new'

        fill_in 'Name', with: 'Ms. Frizzle'
        fill_in 'Street address', with: '1 Magic Schoolbus Rd'
        fill_in 'City', with: 'Walkerville'
        select 'Maryland', from: :state
        fill_in 'Zip code', with: '01010'
        fill_in :description, with: 'Because I am a boss.'
        click_button 'Save'

        expect(current_path).to eq "/applications/#{Application.last.id}"
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
        expect(page).to have_content("Error: Name can\'t be blank, Street address can\'t be blank, City can\'t be blank, Zip code can\'t be blank, Zip code does not have a valid format, Description can\'t be blank")
      end
    end
  end
end
