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
    @top_ranked_tea = @teas.order(rank: :desc).first
    @total_teas = @teas.count
    @most_expensive_tea = @teas.order(price: :desc).first
    @least_popular_tea = @teas.order(:popularity).first
  end

  def analytics
    @teas = current_user.teas
    @total_teas = @teas.count
    @tea_categories = @teas.pluck(:category).uniq
    @avg_rank = @teas.average(:rank).to_f
    @total_value = @teas.sum(:price)
    
    # Calculate average rank by category
    @category_avg_ranks = {}
    @tea_categories.each do |category|
      @category_avg_ranks[category] = @teas.where(category: category).average(:rank).to_f
    end
    
    # Get vendor statistics
    @vendors = @teas.pluck(:vendor).uniq
    @vendor_tea_counts = @teas.group(:vendor).count
    @vendor_avg_prices = {}
    @vendors.each do |vendor|
      @vendor_avg_prices[vendor] = @teas.where(vendor: vendor).average(:price).to_f
    end
    
    # Get origin statistics
    @origins = @teas.pluck(:ship_from).uniq
    @origin_tea_counts = @teas.group(:ship_from).count
    render 'analytics/index'
  end

  private

  def require_login
    unless current_user
      redirect_to new_session_path, alert: "You must log in first."
    end
  end
end
