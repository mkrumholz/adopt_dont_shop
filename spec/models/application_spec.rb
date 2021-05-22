require 'rails_helper'

RSpec.describe Application do
  describe 'relationships' do
    it {should have_many :pet_applications}
    it {should have_many(:pets).through(:pet_applications)}
  end

  describe 'instance methods' do
    describe '#display_status' do
      it 'displays the status as a string' do
        @frizz = Application.create!(name: 'Ms. Frizzle', address: '1 Magic Schoolbus Rd, Walkerville, MD, 01010', description: 'Because I am a boss.', status: :in_progress)

        expect(@frizz.display_status).to eq 'In Progress'
      end
    end
  end
end
