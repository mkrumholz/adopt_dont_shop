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
    describe '#display_status' do
      it 'displays the status as a string' do
        @frizz = Application.create!(name: 'Ms. Frizzle', street_address: '1 Magic Schoolbus Rd', city: 'Walkerville', state: 'MD', zip_code: '01010', description: 'Because I am a boss.', status: :in_progress)

        expect(@frizz.display_status).to eq 'In Progress'
      end
    end

    describe '#display_address' do
      it 'displays the complete address as a string' do
        @frizz = Application.create!(name: 'Ms. Frizzle', street_address: '1 Magic Schoolbus Rd', city: 'Walkerville', state: 'MD', zip_code: '01010', description: 'Because I am a boss.', status: :in_progress)

        expect(@frizz.display_address).to eq '1 Magic Schoolbus Rd, Walkerville, MD, 01010'
      end
    end
  end
end
