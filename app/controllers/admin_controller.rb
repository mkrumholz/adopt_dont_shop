class AdminController < ApplicationController
  def index
    @shelters = Shelter.all
  end
end
