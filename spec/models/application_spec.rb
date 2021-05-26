require 'rails_helper'

RSpec.describe Application do
  describe 'validations' do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:street_address)}
    it {should validate_presence_of(:city)}
    it {should validate_presence_of(:state)}
    it {should validate_presence_of(:zip_code)}
    it {should allow_values('05408', '01010', '19493-8392').for(:zip_code)}
    it {should_not allow_values('14834084', '2384', 'agdke', '24821-33').for(:zip_code)}
    it {should validate_presence_of(:description)}
  end

  describe 'relationships' do
    it {should have_many(:pet_applications).dependent(:destroy)}
    it {should have_many(:pets).through(:pet_applications)}
  end

  describe 'instance methods' do
    before :each do
      @frizz = Application.create!(name: 'Ms. Frizzle', street_address: '1 Magic Schoolbus Rd', city: 'Walkerville', state: 'MD', zip_code: '01010', description: 'Because I am a boss.', status: :in_progress)
    end

    describe '#display_status' do
      it 'displays the status as a string' do
        expect(@frizz.display_status).to eq 'In Progress'
      end
    end

    describe '#display_address' do
      it 'displays the complete address as a string' do
        expect(@frizz.display_address).to eq '1 Magic Schoolbus Rd, Walkerville, MD, 01010'
      end
    end

    describe '#all_pets_approved?' do
      it 'returns true if all pet applications have been approved' do
        shelter = Shelter.create!(name: 'All Star Pets', city: 'Walkerville', foster_program: true, rank: 4)
        liz = @frizz.pets.create!(name: 'Liz Ard', breed: "Jackson's chameleon", age: 7, adoptable: true, shelter: shelter)
        cat = @frizz.pets.create!(name: 'Catward', breed: 'bengal', age: 4, adoptable: true, shelter: shelter)

        expect(@frizz.all_pets_approved?).to eq false

        PetApplication.locate(liz.id, @frizz.id).update_status(:approved)

        expect(@frizz.all_pets_approved?).to eq false

        PetApplication.locate(cat.id, @frizz.id).update_status(:approved)

        expect(@frizz.all_pets_approved?).to eq true
      end
    end
  end
end
