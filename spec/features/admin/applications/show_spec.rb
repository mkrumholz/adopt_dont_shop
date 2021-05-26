require 'rails_helper'

RSpec.describe 'admin applications show page' do
  before :each do
    @frizz = Application.create!(name: 'Ms. Frizzle', street_address: '1 Magic Schoolbus Rd', city: 'Walkerville', state: 'MD', zip_code: '01010', description: 'Because I am a boss.', status: :pending)
    @shelter = Shelter.create!(name: 'All Star Pets', city: 'Walkerville', foster_program: true, rank: 4)
    @liz = @frizz.pets.create!(name: 'Liz Ard', breed: "Jackson's chameleon", age: 7, adoptable: true, shelter: @shelter)
    @cat = @frizz.pets.create!(name: 'Catward', breed: 'bengal', age: 4, adoptable: false, shelter: @shelter)
  end

  it 'allows admin to approve any pet individually' do
    visit "/admin/applications/#{@frizz.id}"

    within "div#pet-#{@liz.id}" do
      click_on 'Approve'
    end

    expect(current_path).to eq "/admin/applications/#{@frizz.id}"

    within "div#pet-#{@liz.id}" do
      expect(page).to_not have_button 'Approve'
      expect(page).to_not have_button 'Reject'
      expect(page).to have_content 'Approved'
    end

    within "div#pet-#{@cat.id}" do
      expect(page).to have_button 'Approve'
      expect(page).to have_button 'Reject'
    end
  end

  it 'allows admin to approve any pet individually' do
    visit "/admin/applications/#{@frizz.id}"

    within "div#pet-#{@cat.id}" do
      click_on 'Reject'
    end

    expect(current_path).to eq "/admin/applications/#{@frizz.id}"
    within "div#pet-#{@cat.id}" do
      expect(page).to_not have_button 'Approve'
      expect(page).to_not have_button 'Reject'
      expect(page).to have_content 'Rejected'
    end

    within "div#pet-#{@liz.id}" do
      expect(page).to have_button 'Approve'
      expect(page).to have_button 'Reject'
    end
  end

  it 'does not impact other applications for that pet' do
    new_app = Application.create!(name: 'Newton', street_address: '1 New Rd', city: 'Newton', state: 'MA', zip_code: '11223', description: 'Unclear', status: :pending)
    new_app.pets << @liz

    visit "/admin/applications/#{new_app.id}"

    within "div#pet-#{@liz.id}" do
      expect(page).to have_button 'Approve'
      expect(page).to have_button 'Reject'
    end

    visit "/admin/applications/#{@frizz.id}"

    within "div#pet-#{@liz.id}" do
      click_on 'Approve'
    end

    visit "/admin/applications/#{new_app.id}"

    within "div#pet-#{@liz.id}" do
      expect(page).to have_button 'Approve'
      expect(page).to have_button 'Reject'
    end
  end
end
