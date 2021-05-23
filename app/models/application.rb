class Application < ApplicationRecord
  has_many :pet_applications, dependent: :destroy
  has_many :pets, through: :pet_applications

  def display_status
    status.split('_').map {|w| w.capitalize}.join(' ')
  end
end
