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
end
