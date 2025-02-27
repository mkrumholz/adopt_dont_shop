require 'rails_helper'

RSpec.describe PetApplication do
  describe 'relationships' do
    it {should belong_to :application}
    it {should belong_to :pet}
  end

  before :each do
    @frizz = Application.create!(name: 'Ms. Frizzle', street_address: '1 Magic Schoolbus Rd', city: 'Walkerville', state: 'MD', zip_code: '01010', description: 'Because I am a boss.', status: :in_progress)
    @shelter = Shelter.create!(name: 'All Star Pets', city: 'Walkerville', foster_program: true, rank: 4)
    @liz = @frizz.pets.create!(name: 'Liz Ard', breed: "Jackson's chameleon", age: 7, adoptable: true, shelter: @shelter)
  end

  describe 'class methods' do
    describe '#all_approved?' do
      it 'returns true if all pet applications have approved status' do
        expect(PetApplication.all_approved?).to eq false

        PetApplication.last.update!(status: :approved)

        expect(PetApplication.all_approved?).to eq true
      end
    end

    describe '#any_rejected?' do
      it 'returns true if any pet app has been rejected' do
        expect(PetApplication.any_rejected?).to eq false

        PetApplication.last.update!(status: :rejected)

        expect(PetApplication.any_rejected?).to eq true
      end
    end

    describe '#locate' do
      it 'finds the pet application for a pet and application pair' do
        pet_application = PetApplication.last

        expect(PetApplication.locate(@liz.id, @frizz.id)).to eq pet_application
      end
    end
  end
end
