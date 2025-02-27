class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def self.by_name
    order(:name)
  end

  def self.reverse_by_name
    find_by_sql('select * from shelters order by lower(name) desc')
  end

  def self.with_pending_applications
    joins(pets: :applications).where({applications: {status: 'pending'}}).group(:id)
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def pending_pets
    pets.joins(:pet_applications, :applications)
        .where(pet_applications: {status: :pending})
        .where(applications: {status: :pending})
  end

  def adoptable_pet_count
    adoptable_pets.count
  end

  def adopted_pet_count
    pets.count_adopted
  end

  def avg_adoptable_pet_age
    pets.avg_adoptable_age
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end
end
