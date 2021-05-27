module Admin
  class SheltersController < ApplicationController
    def index
      @shelters = Shelter.all
      @reverse_shelters = @shelters.reverse_by_name
      @shelters_with_pending_apps = @shelters.with_pending_applications.by_name
    end

    def show
      @shelter = Shelter.find_by_sql("select id, name, city from shelters where id = #{params[:id]}").first
    end
  end
end
