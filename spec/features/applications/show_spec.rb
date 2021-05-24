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
    end
  end
#
#   As a visitor
# When I visit an application's show page
# And that application has not been submitted,
# Then I see a section on the page to "Add a Pet to this Application"
# In that section I see an input where I can search for Pets by name
# When I fill in this field with a Pet's name
# And I click submit,
# Then I am taken back to the application show page
# And under the search bar I see any Pet whose name matches my search
end
