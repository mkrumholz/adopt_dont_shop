require 'rails_helper'

RSpec.describe 'the application index page' do
  before :each do
    @frizz = Application.create!(name: 'Ms. Frizzle', address: '1 Magic Schoolbus Rd, Walkerville, MD, 01010', description: 'Because I am a boss.', status: :in_progress)
    @shelter = Shelter.create!(name: 'All Star Pets', city: 'Walkerville', foster_program: true, rank: 4)
    @liz = @frizz.pets.create!(name: 'Liz Ard', breed: "Jackson's chameleon", age: 7, adoptable: true, shelter: @shelter)
    @cat = @frizz.pets.create!(name: 'Catward', breed: 'bengal', age: 4, adoptable: false, shelter: @shelter)
  end

  it 'shows all the names of the pets' do
    visit '/applications'

    expect(page).to have_content 'Ms. Frizzle'
  end

  it 'contains a link to each pet show page' do
    visit '/applications'

    click_on 'Ms. Frizzle'

    expect(current_path).to eq "/applications/#{@frizz.id}"
  end
end
