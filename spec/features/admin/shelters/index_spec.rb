# For this story, you should fully leverage ActiveRecord methods in your query.
#
# Shelters with Pending Applications
#
# As a visitor
# When I visit the admin shelter index ('/admin/shelters')
# Then I see a section for "Shelter's with Pending Applications"
# And in this section I see the name of every shelter that has a pending application

require 'rails_helper'

RSpec.describe 'admin shelter index' do
  before :each do
    @app_1 = Application.create!(name: 'Newton', street_address: '1 New Rd', city: 'Newton', state: 'MA', zip_code: '11223', description: 'Unclear', status: :in_progress)
    @app_2 = Application.create!(name: 'Ms. Frizzle', street_address: '1 Magic Schoolbus Rd', city: 'Walkerville', state: 'MD', zip_code: '01010', description: 'Because I am a boss.', status: :pending)

    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @liz = @app_2.pets.create!(name: 'Liz Ard', breed: "Jackson's chameleon", age: 7, adoptable: true, shelter: @shelter_1)
    @cat = @app_2.pets.create!(name: 'Catward', breed: 'bengal', age: 4, adoptable: false, shelter: @shelter_2)
  end

  it 'lists all shelters, ordered in reverse by name' do
    visit '/admin/shelters'

    within '#all-shelters' do
      expect(page).to have_content 'All Shelters'
      expect(@shelter_2.name).to appear_before(@shelter_3.name)
      expect(@shelter_3.name).to appear_before(@shelter_1.name)
    end
  end

  it 'lists shelters with pending applications in a separate section' do
    visit '/admin/shelters'

    within '#shelters-pending' do
      expect(page).to have_content 'Shelters with Pending Applications'
      expect(page).to have_content 'Aurora shelter'
      expect(page).to have_content 'RGV animal shelter'
      expect(page).to_not have_content 'Fancy pets of Colorado'
    end
  end
end
