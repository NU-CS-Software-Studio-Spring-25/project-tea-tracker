class HomeController < ApplicationController
  before_action :require_login

  def index
    if current_user
      @teas = current_user.teas
      render :dashboard
    else
      render :landing
    end
  end

  private

  def require_login
    unless current_user
      redirect_to new_session_path, alert: "You must log in first."
    end
  end
  
end
