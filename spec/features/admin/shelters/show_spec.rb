require 'rails_helper'

RSpec.describe 'admin shelters show page' do
  it 'displays the shelter name and address' do
    shelter = Shelter.create!(name: 'All Star Pets', city: 'Walkerville', foster_program: true, rank: 4)

    visit "/admin/shelters/#{shelter.id}"

    expect(page).to have_content 'All Star Pets'
    expect(page).to have_content 'Walkerville'
  end
end
