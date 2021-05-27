class PetApplicationsController < ApplicationController
  def update
    application = Application.find(params[:id])
    pet_application = PetApplication.locate(params[:pet_id], application.id)
    pet_application.update(status: params[:status])
    application.update_status
    redirect_to admin_application_path
  end
end
