class PetApplication < ApplicationRecord
  belongs_to :application
  belongs_to :pet

  def update_status(new_status)
    update!(status: new_status)
  end

  def self.locate(pet_id, application_id)
    where(pet_id: pet_id).where(application_id: application_id)[0]
  end
end
