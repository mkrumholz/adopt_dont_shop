require 'rails_helper'

RSpec.describe 'the application index page' do
  before :each do
    @frizz = Application.create!(name: 'Ms. Frizzle', street_address: '1 Magic Schoolbus Rd', city: 'Walkerville', state: 'MD', zip_code: '01010', description: 'Because I am a boss.', status: :in_progress)
    @shelter = Shelter.create!(name: 'All Star Pets', city: 'Walkerville', foster_program: true, rank: 4)
    @liz = @frizz.pets.create!(name: 'Liz Ard', breed: "Jackson's chameleon", age: 7, adoptable: true, shelter: @shelter)
    @cat = @frizz.pets.create!(name: 'Catward', breed: 'bengal', age: 4, adoptable: false, shelter: @shelter)
  end

  it 'shows all the names of the pets' do
    visit '/admin/applications'

    expect(page).to have_content 'Ms. Frizzle'
  end

  it 'contains a link to each application admin show page' do
    visit '/admin/applications'

    click_on 'Ms. Frizzle'

    expect(current_path).to eq "/admin/applications/#{@frizz.id}"
  end
end
