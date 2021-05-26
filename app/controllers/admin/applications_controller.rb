module Admin
  class ApplicationsController < ApplicationController
    def show
      @application = Application.find(params[:id])
      if params[:status].present?
        # should refactor below line into PetApp model with `locate(id, id)`
        pet_application = PetApplication.where(pet_id: params[:pet_id]).where(application_id: @application.id)[0]
        pet_application.update_status(params[:status])
      end
    end
  end
end
