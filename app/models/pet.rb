class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  has_many :pet_applications, dependent: :destroy
  has_many :applications, through: :pet_applications

  def shelter_name
    shelter.name
  end

  def self.adoptable
    where(adoptable: true)
  end

  def self.avg_adoptable_age
    return 0 if adoptable == []
    where(adoptable: true).average(:age)
  end

  def self.count_adopted
    joins(:applications).where(applications: {status: :approved}).count
  end

  def pending_application_id
    applications.where(status: :pending).pluck(:id).first
  end

  def pet_application_status(app_id)
    PetApplication.locate(id, app_id).status
  end

  def approved?(app_id)
    pet_application_status(app_id) == 'approved'
  end

  def rejected?(app_id)
    pet_application_status(app_id) == 'rejected'
  end
end
