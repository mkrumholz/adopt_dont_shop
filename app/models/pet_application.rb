class PetApplication < ApplicationRecord
  belongs_to :application
  belongs_to :pet

  def update_status(new_status)
    self.status = new_status
  end
end
