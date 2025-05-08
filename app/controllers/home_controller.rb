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

  def dashboard
    @teas = current_user.teas
    @tea_type_counts = @teas.group(:category).count
    @average_tea_cost = @teas.average(:price).to_f
    @popular_ship_from = @teas.group(:ship_from).count.sort_by { |_location, count| -count }.first(5).to_h
    @top_entry = current_user.entries.order(rank: :desc).first
    @top_ranked_tea = @top_entry&.tea
    @total_teas = @teas.count
    @most_expensive_tea = @teas.order(price: :desc).first
    @least_popular_tea = @teas.order(:popularity).first
  end

  private

  def require_login
    unless current_user
      redirect_to new_session_path, alert: "You must log in first."
    end
  end
end
