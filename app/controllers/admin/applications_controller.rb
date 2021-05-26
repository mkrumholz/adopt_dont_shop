module Admin
  class ApplicationsController < ApplicationController
    def show
      @application = Application.find(params[:id])
      if params[:status].present?
        pet_application = PetApplication.locate(params[:pet_id], @application.id)
        pet_application.update_status(params[:status])
        render :show
      end
    end
  end
end
