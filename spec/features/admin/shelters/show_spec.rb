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

  it 'has a list of pets with pending applications not yet marked as accepted/rejected' do
    shelter = Shelter.create!(name: 'All Star Pets', city: 'Walkerville', foster_program: true, rank: 4)

    liz = shelter.pets.create!(name: 'Liz Ard', breed: "Jackson's chameleon", age: 7, adoptable: true)
    cat = shelter.pets.create!(name: 'Catward', breed: 'bengal', age: 4, adoptable: true)
    doge = shelter.pets.create!(name: 'Doge', breed: 'Shiba-Inu', age: 7, adoptable: false)

    app_1 = Application.create!(name: 'Doge Coin', street_address: '100 Dollar St.', city: 'Kabosu', state: 'AK', zip_code: '10000', description: 'Because I am a boss.', status: :approved)
    app_1.pets << doge

    app_2 = Application.create!(name: 'Ms. Frizzle', street_address: '1 Magic Schoolbus Rd', city: 'Walkerville', state: 'MD', zip_code: '01010', description: 'Because I am a boss.', status: :pending)
    app_2.pets << liz
    app_2.pets << cat

    visit "/admin/shelters/#{shelter.id}"

    within "div#action-required" do
      expect(page).to have_content 'Action Required'
      expect(page).to have_content 'Liz Ard'
      expect(page).to have_content 'Catward'
      expect(page).to_not have_content 'Doge'
      click_on 'Liz Ard'
    end

    expect(current_path).to eq "/admin/applications/#{app_2.id}"
  end
end
