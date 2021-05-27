module Admin
  class SheltersController < ApplicationController
    def index
      @shelters = Shelter.all
    end

    def show
      @shelter_name = Shelter.find_by_sql("select name from shelters where id = #{params[:id]}")
      @shelter_city = Shelter.find_by_sql("select city from shelters where id = #{params[:id]}")
    end
  end
end
