class HomeController < ApplicationController
  def index
    @teas = Tea.all
  end
end
