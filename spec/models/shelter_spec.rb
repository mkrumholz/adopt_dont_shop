require 'rails_helper'

RSpec.describe Shelter, type: :model do
  describe 'relationships' do
    it { should have_many(:pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:rank) }
    it { should validate_numericality_of(:rank) }
  end

  before(:each) do
    @app_1 = Application.create!(name: 'Newton', street_address: '1 New Rd', city: 'Newton', state: 'MA', zip_code: '11223', description: 'Unclear', status: :in_progress)
    @app_2 = Application.create!(name: 'Ms. Frizzle', street_address: '1 Magic Schoolbus Rd', city: 'Walkerville', state: 'MD', zip_code: '01010', description: 'Because I am a boss.', status: :pending)
    @app_3 = Application.create!(name: 'Doge Coin', street_address: '100 Dollar St.', city: 'Kabosu', state: 'AK', zip_code: '10000', description: 'To the moon!', status: :approved)

    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
    @pet_5 = @shelter_3.pets.create!(name: 'Doge', breed: 'Shiba-Inu', age: 7, adoptable: false)


    @app_2.pets << @pet_1
    @app_2.pets << @pet_3
    @app_3.pets << @pet_5
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Shelter.search("Fancy")).to eq([@shelter_3])
      end
    end

    describe '#order_by_recently_created' do
      it 'returns shelters with the most recently created first' do
        expect(Shelter.order_by_recently_created).to eq([@shelter_3, @shelter_2, @shelter_1])
      end
    end

    describe '#order_by_number_of_pets' do
      it 'orders the shelters by number of pets they have, descending' do
        expect(Shelter.order_by_number_of_pets).to eq([@shelter_1, @shelter_3, @shelter_2])
      end
    end

    describe '#by_name' do
      it 'orders the shelters in alphabetical order' do
        expect(Shelter.by_name).to eq([@shelter_1, @shelter_3, @shelter_2])
      end
    end

    describe '#reverse_by_name' do
      it 'orders the shelters in reverse alphabetical order' do
        expect(Shelter.reverse_by_name).to eq([@shelter_2, @shelter_3, @shelter_1])
      end
    end

    describe '#with_pending_applications' do
      it 'returns shelters with pending applications' do
        expect(Shelter.with_pending_applications).to include @shelter_1
        expect(Shelter.with_pending_applications).to include @shelter_3
        expect(Shelter.with_pending_applications).to_not include @shelter_2
      end
    end
  end

  describe 'instance methods' do
    describe '.adoptable_pets' do
      it 'only returns pets that are adoptable' do
        expect(@shelter_1.adoptable_pets).to eq([@pet_2, @pet_4])
      end
    end

    describe '.adoptable_pet_count' do
      it 'returns count of pets that are adoptable' do
        expect(@shelter_1.adoptable_pet_count).to eq 2
      end
    end

    describe '.avg_adoptable_pet_age' do
      it 'returns avg age of pets that are adoptable' do
        expect(@shelter_1.avg_adoptable_pet_age).to eq 4
      end
    end

    describe '.alphabetical_pets' do
      it 'returns pets associated with the given shelter in alphabetical name order' do
        expect(@shelter_1.alphabetical_pets).to eq([@pet_4, @pet_2])
      end
    end

    describe '.shelter_pets_filtered_by_age' do
      it 'filters the shelter pets based on given params' do
        expect(@shelter_1.shelter_pets_filtered_by_age(5)).to eq([@pet_4])
      end
    end

    describe '.pet_count' do
      it 'returns the number of pets at the given shelter' do
        expect(@shelter_1.pet_count).to eq(3)
      end
    end

    describe '.adopted_pet_count' do
      it 'returns the number of pets already adopted from the shelter' do
        expect(@shelter_3.adopted_pet_count).to eq 1
      end
    end
  end
end
