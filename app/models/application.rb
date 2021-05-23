class Application < ApplicationRecord
  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true
  validates_format_of :zip_code, :with => /\A[0-9]{5}(?:-[0-9]{4})?\z/, :message => 'does not have a valid format'
  validates :description, presence: true
  has_many :pet_applications, dependent: :destroy
  has_many :pets, through: :pet_applications

  def display_status
    status.split('_').map {|w| w.capitalize}.join(' ')
  end

  def display_address
    "#{street_address}, #{city}, #{state}, #{zip_code}"
  end
end
