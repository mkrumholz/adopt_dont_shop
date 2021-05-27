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
      @shelter = Shelter.create!(name: 'All Star Pets', city: 'Walkerville', foster_program: true, rank: 4)
      @liz = @frizz.pets.create!(name: 'Liz Ard', breed: "Jackson's chameleon", age: 7, adoptable: true, shelter: @shelter)
      @cat = @frizz.pets.create!(name: 'Catward', breed: 'bengal', age: 4, adoptable: true, shelter: @shelter)

      @new_app = Application.create!(name: 'New App', street_address: '123 Abc St.', city: 'New St.', state: 'MD', zip_code: '01010', description: 'Just because.', status: :in_progress)
      @dog = @new_app.pets.create!(name: 'Doggus', breed: 'Lab', age: 6, adoptable: true, shelter: @shelter)
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
        expect(@frizz.all_pets_approved?).to eq false

        PetApplication.locate(@liz.id, @frizz.id).update!(status: :approved)

        expect(@frizz.all_pets_approved?).to eq false

        PetApplication.locate(@cat.id, @frizz.id).update!(status: :approved)

        expect(@frizz.all_pets_approved?).to eq true
      end
    end

    describe '#any_pet_rejected?' do
      it 'returns true if any pet app has been rejected' do
        expect(@frizz.any_pet_rejected?).to eq false

        PetApplication.locate(@cat.id, @frizz.id).update!(status: :rejected)

        expect(@frizz.any_pet_rejected?).to eq true
      end
    end

    describe '#update_status' do
      it 'updates the applications status to approved if all pet_apps are approved' do
        PetApplication.locate(@liz.id, @frizz.id).update(status: :approved)
        PetApplication.locate(@cat.id, @frizz.id).update(status: :approved)

        @frizz.update_status

        expect(@frizz.status).to eq 'approved'
      end

      it 'updates the applications status to rejected if any pet_apps was rejected' do
        PetApplication.locate(@liz.id, @frizz.id).update!(status: :pending)
        PetApplication.locate(@cat.id, @frizz.id).update!(status: :rejected)

        @frizz.update_status

        expect(@frizz.status).to eq 'rejected'
      end

      it 'does nothing if some pet_apps are approved and some are still pending' do
        PetApplication.locate(@liz.id, @frizz.id).update!(status: :approved)
        PetApplication.locate(@cat.id, @frizz.id).update!(status: :pending)

        @frizz.update_status

        expect(@frizz.status).to eq 'in_progress'
      end
    end
  end
end
