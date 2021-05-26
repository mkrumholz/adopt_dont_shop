class ApplicationsController < ApplicationController
  def index
    @applications = Application.all
  end

  def show
    @application = Application.find(params[:id])
    if params[:search].present?
      @search_results = Pet.search(params[:search])
    elsif params[:pet_id].present?
      @application.pets << Pet.find(params[:pet_id])
    end
  end

  def new
  end

  def create
    application = Application.create(application_params)

    if application.save
      redirect_to "/applications/#{application.id}"
    else
      redirect_to new_application_path
      flash[:alert] = "Error: #{error_message(application.errors)}"
    end
  end

  def update
    application = Application.find(params[:id])
    if params[:commit] == "Submit application"
      application.update!(description: params[:description], status: :pending)
    end
    redirect_to "/applications/#{application.id}"
  end

  private
    def application_params
      params.permit(:name, :street_address, :city, :state, :zip_code, :description)
            .merge(status: :in_progress)
    end
end
