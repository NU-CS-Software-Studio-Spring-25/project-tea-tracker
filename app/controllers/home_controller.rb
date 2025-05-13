class HomeController < ApplicationController
  before_action :require_login

  def index
    if current_user
      @teas = Tea.joins(:entries).where(entries: { user_id: current_user.id })
      @user_teas = @teas.pluck(:name, :price, :grams)

      # Gauge metrics (avg $ and percentile vs all teas)
      user_prices   = @teas.map(&:price)
      all_prices    = Tea.pluck(:price).compact.sort
      @user_avg     = user_prices.sum.to_f / [user_prices.size,1].max
      @global_qtiles = all_prices.each_slice((all_prices.size/4.0).ceil).map(&:last)
      @percentile   = (all_prices.count { |p| p < @user_avg } * 100.0 / all_prices.size)

      render :dashboard
    else
      render :landing
    end
  end

  def dashboard
    @selected_category = params[:category]
    @teas = if @selected_category.present?
      Tea.joins(:entries).where(entries: { user_id: current_user.id }).where(category: @selected_category)
    else
      Tea.joins(:entries).where(entries: { user_id: current_user.id })
    end

    @user_teas = @teas.pluck(:name, :price, :grams, :category)
    @tea_categories = @teas.pluck(:category).uniq
    
    # Gauge metrics (avg $ and percentile vs all teas)
    user_prices   = @teas.map(&:price)
    all_prices    = Tea.pluck(:price).compact.sort
    @user_avg     = user_prices.sum.to_f / [user_prices.size,1].max
    @global_qtiles = all_prices.each_slice((all_prices.size/4.0).ceil).map(&:last)
    @percentile   = (all_prices.count { |p| p < @user_avg } * 100.0 / all_prices.size)

    @tea_type_counts   = @teas.group(:category).count
    @average_tea_cost  = @teas.average(:price).to_f
    @popular_ship_from = @teas.group(:ship_from).count.sort_by { |_loc,c| -c }.first(5).to_h
    @top_entry         = current_user.entries.order(rank: :desc).first
    @top_ranked_tea    = @top_entry&.tea
    @total_teas        = @teas.count
    @most_expensive_tea= @teas.order(price: :desc).first
    @least_popular_tea = @teas.order(:popularity).first
  end

  def analytics
    @teas = Tea.joins(:entries).where(entries: { user_id: current_user.id })
    @total_teas = @teas.count
    @tea_categories = @teas.pluck(:category).uniq
    entries = Entry.where(user_id: current_user.id)
    ranks = entries.map(&:rank)
    @avg_rank = ranks.sum.to_f / ranks.size if ranks.any?
    @total_value = @teas.sum(:price)

    # Average rank by category
    @category_avg_ranks = {}
    @tea_categories.each do |category|
      selected = @teas.where(category: category).pluck(:id)
      entries = Entry.where(tea_id: selected)
      ranks = entries.map(&:rank)
      @category_avg_ranks[category] = ranks.sum.to_f / ranks.size if ranks.any?
    end

    # Vendor statistics
    @vendors = @teas.pluck(:vendor).uniq
    @vendor_tea_counts = @teas.group(:vendor).count
    @vendor_avg_prices = {}
    @vendors.each do |vendor|
      selected =@teas.where(vendor: vendor).pluck(:id)
      entries = Entry.where(tea_id: selected)
      ranks = entries.map(&:rank)
      @vendor_avg_prices[vendor] = ranks.sum.to_f / ranks.size if ranks.any?
    end

    # Origin statistics
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
