require 'rails_helper'

RSpec.describe 'the application show page' do
  before :each do
    @app_1 = Application.create!(name: 'Ms. Frizzle', address: '1 Magic Schoolbus Rd, Walkerville, MD, 01010', description: 'Because I am a boss.', status: :in_progress)
  end

  it 'shows the name of the applicant' do
    visit "/applications/#{@app_1.id}"

    expect(page).to have_content 'Ms. Frizzle'
  end

  it 'shows the full address of the applicant' do
    visit "/applications/#{@app_1.id}"

    expect(page).to have_content '1 Magic Schoolbus Rd, Walkerville, MD, 01010'
  end

  it 'shows the description given by applicant' do
    visit "/applications/#{@app_1.id}"

    expect(page).to have_content 'Because I am a boss.'
  end

  it 'shows the status of the application' do
    visit "/applications/#{@app_1.id}"

    expect(page).to have_content 'Application status: In Progress'
  end
end
#
# As a visitor
# When I visit an applications show page
# Then I can see the following:
#
# Name of the Applicant
# Full Address of the Applicant including:
# street address, city, state, and zip code
# Description of why the applicant says they'd be
# a good home for this pet(s)
# names of all pets that this application is for
# (all names of pets should be links to their show page)
# The Application's status, either:
# "In Progress", "Pending", "Accepted", or "Rejected"
