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
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)
    @doge = @shelter_1.pets.create!(name: 'Doge', breed: 'Shiba-Inu', age: 7, adoptable: false)
    @app = Application.create!(name: 'Doge Coin', street_address: '100 Dollar St.', city: 'Kabosu', state: 'AK', zip_code: '10000', description: 'Because I am a boss.', status: :approved)
    @app.pets << @doge

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
  end
end
