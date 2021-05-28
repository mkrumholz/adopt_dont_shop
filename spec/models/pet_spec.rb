require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to(:shelter) }
    it {should have_many(:pet_applications).dependent(:destroy)}
    it { should have_many(:applications).through(:pet_applications)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'New Shelter', city: 'Boulder, CO', foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)
    @doge = @shelter_1.pets.create!(name: 'Doge', breed: 'Shiba-Inu', age: 7, adoptable: false)

    @app_1 = Application.create!(name: 'Doge Coin', street_address: '100 Dollar St.', city: 'Kabosu', state: 'AK', zip_code: '10000', description: 'Because I am a boss.', status: :approved)
    @app_1.pets << @doge

    @app_2 = Application.create!(name: 'Ms. Frizzle', street_address: '1 Magic Schoolbus Rd', city: 'Walkerville', state: 'MD', zip_code: '01010', description: 'Because I am a boss.', status: :pending)
    @app_2.pets << @pet_1

    @app_3 = Application.create!(name: 'New App', street_address: '1 NewApp Rd', city: 'Newton', state: 'MA', zip_code: '01010', description: 'Just cause.', status: :rejected)
    @app_3.pets << @pet_2
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Pet.search("Claw")).to eq([@pet_2])
      end
    end

    describe '#adoptable' do
      it 'returns adoptable pets' do
        expect(Pet.adoptable).to eq([@pet_1, @pet_2])
      end
    end

    describe '#avg_adoptable_age' do
      it 'returns the average age of the pets' do
        expect(Pet.avg_adoptable_age). to eq 4
      end

      it 'returns 0 if no pets are adoptable' do
        expect(@shelter_2.pets.avg_adoptable_age). to eq 0
      end
    end

    describe '#count_adopted' do
      it 'returns a count of pets already adopted' do
        expect(Pet.count_adopted).to eq 1
      end
    end
  end

  describe 'instance methods' do
    describe '.shelter_name' do
      it 'returns the shelter name for the given pet' do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
      end
    end

    describe '.pending_application_id' do
      it 'returns the id of the first pending application for the pet' do
        expect(@pet_1.pending_application_id).to eq @app_2.id
      end
    end

    describe '.pet_application_status' do
      it 'returns the status of the pet application for the pet and given app' do
        expect(@pet_1.pet_application_status(@app_2.id)).to eq 'pending'
      end
    end

    describe '.approved?' do
      it 'returns true if the application has been approved' do
        PetApplication.locate(@doge.id, @app_1.id).update(status: :approved)
        expect(@doge.approved?(@app_1)).to eq true
      end
    end

    describe '.rejected?' do
      it 'returns true if the application has been rejected' do
        PetApplication.locate(@pet_2.id, @app_3.id).update(status: :rejected)
        expect(@pet_2.rejected?(@app_3)).to eq true
      end
    end

  end
end
