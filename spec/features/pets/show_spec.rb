require 'rails_helper'

RSpec.describe 'the pet show' do
  it "shows the pet and all it's attributes" do
    shelter = Shelter.create(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
    pet = Pet.create(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)

    visit "/pets/#{pet.id}"

    expect(page).to have_content(pet.name)
    expect(page).to have_content(pet.age)
    expect(page).to have_content(pet.adoptable)
    expect(page).to have_content(pet.breed)
    expect(page).to have_content(pet.shelter_name)
  end

  it "allows the user to delete a pet" do
    shelter = Shelter.create(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
    pet = Pet.create(name: 'Scrappy', age: 1, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)

    visit "/pets/#{pet.id}"

    click_on("Delete #{pet.name}")

    expect(page).to have_current_path('/pets')
    expect(page).to_not have_content(pet.name)
  end

  it 'shows that pet is no longer adoptable once its application is approved' do
    frizz = Application.create!(name: 'Ms. Frizzle', street_address: '1 Magic Schoolbus Rd', city: 'Walkerville', state: 'MD', zip_code: '01010', description: 'Because I am a boss.', status: :pending)
    shelter = Shelter.create!(name: 'All Star Pets', city: 'Walkerville', foster_program: true, rank: 4)
    liz = frizz.pets.create!(name: 'Liz Ard', breed: "Jackson's chameleon", age: 7, adoptable: true, shelter: shelter)
    cat = frizz.pets.create!(name: 'Catward', breed: 'bengal', age: 4, adoptable: true, shelter: shelter)

    PetApplication.locate(liz.id, frizz.id).update(status: :approved)
    PetApplication.locate(cat.id, frizz.id).update(status: :approved)
    frizz.update_status

    visit "/pets/#{liz.id}"

    expect(liz.adoptable).to eq false
    expect(page).to have_content 'false'

    visit "/pets/#{cat.id}"

    expect(cat.adoptable).to eq false
    expect(page).to have_content false
  end
end
