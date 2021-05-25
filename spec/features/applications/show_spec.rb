require 'rails_helper'

RSpec.describe 'the application show page' do
  before :each do
    @frizz = Application.create!(name: 'Ms. Frizzle', street_address: '1 Magic Schoolbus Rd', city: 'Walkerville', state: 'MD', zip_code: '01010', description: 'Because I am a boss.', status: :in_progress)
    @shelter = Shelter.create!(name: 'All Star Pets', city: 'Walkerville', foster_program: true, rank: 4)
    @liz = @frizz.pets.create!(name: 'Liz Ard', breed: "Jackson's chameleon", age: 7, adoptable: true, shelter: @shelter)
    @cat = @frizz.pets.create!(name: 'Catward', breed: 'bengal', age: 4, adoptable: false, shelter: @shelter)
  end

  describe 'application details' do
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
  end

  describe 'pets applied for' do
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

    it 'lets user know if application has no pets yet' do
      new_app = Application.create!(name: 'Newton', street_address: '1 New Rd', city: 'Newton', state: 'MA', zip_code: '11223', description: 'Unclear', status: :in_progress)

      visit "/applications/#{new_app.id}"

      within "div#applied-for" do
        expect(page).to have_content 'None yet! To submit your application, please add at least one pet.'
      end
    end
  end

  describe 'submitting the application' do
    it 'can submit the application' do
      visit "/applications/#{@frizz.id}"

      fill_in :description, with: 'Liz Ard is my soulmate.'
      click_on 'Submit application'

      expect(current_path).to eq "/applications/#{@frizz.id}"
      expect(page).to have_content 'Application status: Pending'
      expect(page).to_not have_content 'Add a Pet to this Application'
    end

    it 'does not allow submission if application has no pets' do
      new_app = Application.create!(name: 'Newton', street_address: '1 New Rd', city: 'Newton', state: 'MA', zip_code: '11223', description: 'Unclear', status: :in_progress)

      visit "/applications/#{new_app.id}"

      expect(page).to_not have_button 'Submit application'
    end
  end

  describe 'adding a pet' do
    before :each do
      @new_pet_1 = Pet.create!(name: 'Gus', breed: 'Black Lab', age: 4, adoptable: true, shelter: @shelter)
      @new_pet_2 = Pet.create!(name: 'Bambi', breed: 'Basic deer', age: 1, adoptable: true, shelter: @shelter)
    end

    it 'has a form to add a pet to the application' do
      visit "/applications/#{@frizz.id}"

      expect(page).to have_content 'Add a Pet to this Application'

      fill_in :search, with: 'gu'
      click_on 'Search'

      expect(current_path).to eq "/applications/#{@frizz.id}"
      expect(page).to have_content 'Gus'
      expect(page).to have_content 'Breed: Black Lab'
      expect(page).to have_content 'Age: 4'
      expect(page).to have_content 'Shelter: All Star Pets'
    end

    it 'links to the show page for each pet' do
      visit "/applications/#{@frizz.id}"

      fill_in :search, with: 'Gus'
      click_on 'Search'

      within "li#pet-#{@new_pet_1.id}" do
        click_link 'More info'
      end

      expect(current_path).to eq "/pets/#{@new_pet_1.id}"
    end

    it 'can add a pet to the application' do
      visit "/applications/#{@frizz.id}"

      fill_in :search, with: 'Gus'
      click_on 'Search'

      within "li#pet-#{@new_pet_1.id}" do
        click_button 'Adopt this pet'
      end

      expect(current_path).to eq "/applications/#{@frizz.id}"

      within "div#applied-for" do
        expect(page).to have_content 'Gus'
      end
    end

    it 'does not allow you to add a pet once application is submitted' do
      new_app = Application.create!(name: 'Newton', street_address: '1 New Rd', city: 'Newton', state: 'MA', zip_code: '11223', description: 'Unclear', status: :pending)

      visit "/applications/#{new_app.id}"

      expect(page).to_not have_content 'Add a Pet to this Application'
      expect(page).to_not have_button 'Search'
    end
  end
end
