class PetApplication < ApplicationRecord
  belongs_to :application
  belongs_to :pet

  def self.locate(pet_id, application_id)
    where(pet_id: pet_id, application_id: application_id)[0]
  end
end
