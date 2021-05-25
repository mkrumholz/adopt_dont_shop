require 'rails_helper'

RSpec.describe 'the application show page' do
  before :each do
    @frizz = Application.create!(name: 'Ms. Frizzle', street_address: '1 Magic Schoolbus Rd', city: 'Walkerville', state: 'MD', zip_code: '01010', description: 'Because I am a boss.', status: :in_progress)
    @shelter = Shelter.create!(name: 'All Star Pets', city: 'Walkerville', foster_program: true, rank: 4)
    @liz = @frizz.pets.create!(name: 'Liz Ard', breed: "Jackson's chameleon", age: 7, adoptable: true, shelter: @shelter)
    @cat = @frizz.pets.create!(name: 'Catward', breed: 'bengal', age: 4, adoptable: false, shelter: @shelter)
  end

  it 'shows the name of the applicant' do
    visit "/applications/#{@frizz.id}"

    expect(page).to have_content 'Ms. Frizzle'
  end

  it 'shows the full address of the applicant' do
    visit "/applications/#{@frizz.id}"

    expect(page).to have_content '1 Magic Schoolbus Rd, Walkerville, MD, 01010'
  end

  it 'shows the description given by applicant' do
    visit "/applications/#{@frizz.id}"

    expect(page).to have_content 'Because I am a boss.'
  end

  it 'shows the status of the application' do
    visit "/applications/#{@frizz.id}"

    expect(page).to have_content 'Application status: In Progress'
  end

  it 'shows all names of the pets this application is for' do
    visit "/applications/#{@frizz.id}"

    expect(page).to have_content 'Liz Ard'
    expect(page).to have_content 'Catward'
  end

  it 'shows each pet name as a link to their show page' do
    visit "/applications/#{@frizz.id}"

    click_link 'Liz Ard'

    expect(current_path).to eq "/pets/#{@liz.id}"
  end

  describe 'in-progress application' do
    it 'has a form to add a pet to the application' do
      new_pet = Pet.create!(name: 'Gus', breed: 'Black Lab', age: 4, adoptable: true, shelter: @shelter)

      visit "/applications/#{@frizz.id}"

      expect(page).to have_content 'Add a Pet to this Application'

      fill_in :search, with: 'Gus'
      click_on 'Search'

      expect(current_path).to eq "/applications/#{@frizz.id}"
      expect(page).to have_content 'Gus'
      expect(page).to have_content 'Breed: Black Lab'
      expect(page).to have_content 'Age: 4'
      expect(page).to have_content 'Shelter: All Star Pets'
    end

    it 'links to the show page for each pet' do
      new_pet_1 = Pet.create!(name: 'Gus', breed: 'Black Lab', age: 4, adoptable: true, shelter: @shelter)
      new_pet_2 = Pet.create!(name: 'Bambi', breed: 'Basic deer', age: 1, adoptable: true, shelter: @shelter)

      visit "/applications/#{@frizz.id}"

      fill_in :search, with: 'Gus'
      click_on 'Search'

      within "li#pet-#{new_pet_1.id}" do
        click_link 'More info'
      end

      expect(current_path).to eq "/pets/#{new_pet_1.id}"
    end

    it 'can add a pet to the application' do
      new_pet_1 = Pet.create!(name: 'Gus', breed: 'Black Lab', age: 4, adoptable: true, shelter: @shelter)
      new_pet_2 = Pet.create!(name: 'Bambi', breed: 'Basic deer', age: 1, adoptable: true, shelter: @shelter)

      visit "/applications/#{@frizz.id}"

      fill_in :search, with: 'Gus'
      click_on 'Search'

      within "li#pet-#{new_pet_1.id}" do
        click_button 'Adopt this pet'
      end

      expect(current_path).to eq "/applications/#{@frizz.id}"

      within "div#applied-for" do
        expect(page).to have_content 'Gus'
      end
    end
  end
end
