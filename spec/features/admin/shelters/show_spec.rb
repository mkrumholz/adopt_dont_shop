require 'rails_helper'

RSpec.describe 'admin shelters show page' do
  it 'displays the shelter name and address' do
    shelter = Shelter.create!(name: 'All Star Pets', city: 'Walkerville', foster_program: true, rank: 4)

    visit "/admin/shelters/#{shelter.id}"

    expect(page).to have_content 'All Star Pets'
    expect(page).to have_content 'Walkerville'
  end

  it 'displays statistics for the shelter' do
    shelter = Shelter.create!(name: 'All Star Pets', city: 'Walkerville', foster_program: true, rank: 4)
    shelter.pets.create!(name: 'Liz Ard', breed: "Jackson's chameleon", age: 7, adoptable: true)
    shelter.pets.create!(name: 'Catward', breed: 'bengal', age: 4, adoptable: false)

    visit "/admin/shelters/#{shelter.id}"

    expect(page).to have_content 'Average pet age: 5.5'
  end
end
