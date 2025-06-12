class HomeController < ApplicationController
  before_action :require_login, except: [ :index ]

  def index
    if current_user
      redirect_to action: :dashboard
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
    user_prices = @teas.map(&:price)
    all_prices = Tea.pluck(:price).compact.sort
    @user_avg = user_prices.sum.to_f / [ user_prices.size, 1 ].max
    @global_qtiles = all_prices.each_slice((all_prices.size / 4.0).ceil).map(&:last)
    @percentile = (all_prices.count { |p| p < @user_avg } * 100.0 / all_prices.size)

    # Collection statistics
    @tea_type_counts = @teas.group(:category).count
    @average_tea_cost = @teas.average(:price).to_f
    @popular_ship_from = @teas.group(:ship_from).count.sort_by { |_loc, c| -c }.first(5).to_h
    @total_teas = @teas.count

    # Highlight teas
    @top_entry = current_user.entries.order(rank: :desc).first
    @top_ranked_tea = @top_entry&.tea
    @most_expensive_tea = @teas.order(price: :desc).first

    # Vendor statistics
    @vendors = @teas.pluck(:vendor).uniq
    @vendor_tea_counts = @teas.group(:vendor).count.sort_by { |_vendor, count| -count }.first(5).to_h

    # Age statistics
    current_year = Date.today.year
    @tea_by_age = @teas.group(:year).count.transform_keys { |year| year.present? ? current_year - year.to_i : 'Unknown' }
    @tea_by_age = @tea_by_age.sort_by { |age, _| age == 'Unknown' ? 999 : age }.to_h

    # Price range statistics
    @price_ranges = {
      'Budget (< $0.10/g)' => @teas.where('price < 0.10').count,
      'Mid-range ($0.10-0.25/g)' => @teas.where('price >= 0.10 AND price <= 0.25').count,
      'Premium ($0.25-0.50/g)' => @teas.where('price > 0.25 AND price <= 0.50').count,
      'Luxury (> $0.50/g)' => @teas.where('price > 0.50').count
    }

    # Recent additions
    @recent_teas = @teas.order(created_at: :desc).limit(5)
  end

  def analytics
    @teas = Tea.joins(:entries).where(entries: { user_id: current_user.id })
    @total_teas = @teas.count
    @tea_categories = @teas.pluck(:category).uniq
    entries = Entry.where(user_id: current_user.id)
    ranks = entries.map(&:rank)
    @avg_rank = ranks.sum.to_f / ranks.size if ranks.any?
    @total_value = @teas.sum(:price)

    # Category statistics
    @tea_type_counts = @teas.group(:category).count

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
      selected = @teas.where(vendor: vendor).pluck(:id)
      entries = Entry.where(tea_id: selected)
      ranks = entries.map(&:rank)
      @vendor_avg_prices[vendor] = ranks.sum.to_f / ranks.size if ranks.any?
    end

    # Origin statistics
    @origins = @teas.pluck(:ship_from).uniq
    @origin_tea_counts = @teas.group(:ship_from).count
    @popular_ship_from = @teas.group(:ship_from).count

    # Pass the Ruby hash to the view
    @origin_coords = TEA_ORIGIN_COORDS
    # If you want to use the JSON file instead, uncomment below:
    # require 'json'
    # @origin_coords = JSON.parse(File.read(Rails.root.join('config', 'tea_origin_coords.json')))

    render 'analytics/index'
  end

  def price_statistics
    @selected_category = params[:category]
    @teas = if @selected_category.present?
              Tea.joins(:entries).where(entries: { user_id: current_user.id }).where(category: @selected_category)
    else
              Tea.joins(:entries).where(entries: { user_id: current_user.id })
    end

    @average_tea_cost = @teas.average(:price).to_f

    render partial: 'price_statistics'
  end

  private

  def require_login
    return if current_user

    redirect_to new_session_path, alert: 'You must log in first.'
  end
end
