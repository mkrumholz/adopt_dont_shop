module Admin
  class SheltersController < ApplicationController
    def index
      @shelters = Shelter.all
      @reverse_shelters = @shelters.reverse_by_name
      @shelters_with_pending_apps = @shelters.with_pending_applications.by_name
    end

    def show
      @shelter = Shelter.find(params[:id])
      @shelter_name = Shelter.find_by_sql("select name from shelters where id = #{params[:id]}")
      @shelter_city = Shelter.find_by_sql("select city from shelters where id = #{params[:id]}")
    end
  end
end
