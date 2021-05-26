# Approving a Pet for Adoption
#
# As a visitor
# When I visit an admin application show page ('/admin/applications/:id')
# For every pet that the application is for, I see a button to approve the application for that specific pet
# When I click that button
# Then I'm taken back to the admin application show page
# And next to the pet that I approved, I do not see a button to approve this pet
# And instead I see an indicator next to the pet that they have been approved

require 'rails_helper'

RSpec.describe 'admin applications show page' do
  before :each do
    @frizz = Application.create!(name: 'Ms. Frizzle', street_address: '1 Magic Schoolbus Rd', city: 'Walkerville', state: 'MD', zip_code: '01010', description: 'Because I am a boss.', status: :in_progress)
    @shelter = Shelter.create!(name: 'All Star Pets', city: 'Walkerville', foster_program: true, rank: 4)
    @liz = @frizz.pets.create!(name: 'Liz Ard', breed: "Jackson's chameleon", age: 7, adoptable: true, shelter: @shelter)
    @cat = @frizz.pets.create!(name: 'Catward', breed: 'bengal', age: 4, adoptable: false, shelter: @shelter)
  end

  it 'allows admin to approve any pet individually' do
    visit "/admin/applications/#{@frizz.id}"

    within "pet-#{@liz.id}" do
      click_on 'Approve'
    end

    expect(current_path).to eq "/admin/applications/#{@frizz.id}"
    within "pet-#{@liz.id}" do
      expect(page).to_not have_button 'Approve'
      expect(page).to_not have_button 'Reject'
      expect(page).to have_content 'Approved'
    end

    within "pet-#{@cat.id}" do
      expect(page).to have_button 'Approve'
      expect(page).to have_button 'Reject'
    end
  end

  it 'allows admin to approve any pet individually' do
    visit "/admin/applications/#{@frizz.id}"

    within "pet-#{@cat.id}" do
      click_on 'Reject'
    end

    expect(current_path).to eq "/admin/applications/#{@frizz.id}"
    within "pet-#{@cat.id}" do
      expect(page).to_not have_button 'Approve'
      expect(page).to_not have_button 'Reject'
      expect(page).to have_content 'Rejected'
    end

    within "pet-#{@liz.id}" do
      expect(page).to have_button 'Approve'
      expect(page).to have_button 'Reject'
    end
  end
end
