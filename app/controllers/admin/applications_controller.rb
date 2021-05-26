module Admin
  class ApplicationsController < ApplicationController
    def show
      @application = Application.find(params[:id])
      if params[:status].present?
        pet_application = PetApplication.locate(params[:pet_id], @application.id)
        pet_application.update_status(params[:status])
      end
      if @application.pet_applications.all? { |application| application.status == 'approved' }
        @application.update!(status: :approved)
      elsif @application.pet_applications.any? { |application| application.status == 'rejected' }      
        @application.update!(status: :rejected)
      end
    end
  end
end
