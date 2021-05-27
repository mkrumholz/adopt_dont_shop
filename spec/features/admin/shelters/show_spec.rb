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
    shelter.pets.create!(name: 'Catward', breed: 'bengal', age: 4, adoptable: true)
    doge = shelter.pets.create!(name: 'Doge', breed: 'Shiba-Inu', age: 7, adoptable: false)
    app = Application.create!(name: 'Doge Coin', street_address: '100 Dollar St.', city: 'Kabosu', state: 'AK', zip_code: '10000', description: 'Because I am a boss.', status: :approved)
    app.pets << doge

    visit "/admin/shelters/#{shelter.id}"

    expect(page).to have_content 'Pets available: 2'
    expect(page).to have_content 'Average age of available pets: 5.5'
    expect(page).to have_content 'Total pets adopted to date: 1'
  end
end
