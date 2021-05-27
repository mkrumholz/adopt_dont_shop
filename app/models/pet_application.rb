class PetApplication < ApplicationRecord
  belongs_to :application
  belongs_to :pet

  def self.locate(pet_id, application_id)
    where(pet_id: pet_id, application_id: application_id)[0]
  end

  def self.all_approved?
    all.all? { |pet_app| pet_app.status == 'approved' }
  end

  def self.any_rejected?
    all.any? { |application| application.status == 'rejected' }
  end
end
