class TeasController < ApplicationController
  include ActionView::Helpers::NumberHelper

  before_action :require_login
  before_action :set_tea, only: [:show, :edit, :update, :destroy]

  def index
    @teas = current_user.teas.includes(:entries)
    @entries = current_user.entries.index_by(&:tea_id)
    @tea_categories = @teas.pluck(:category).uniq
    
    
    # Apply filters
    if params[:category].present?
      @teas = @teas.where(category: params[:category])
    end
    
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @teas = @teas.where("name ILIKE ? OR vendor ILIKE ? OR ship_from ILIKE ?", 
                          search_term, search_term, search_term)
    end
    
    # Apply sorting
    case params[:sort]
    when "name_asc"
      @teas = @teas.order(name: :asc)
    when "rank_desc"
      @teas = @teas.joins(:entries).where(entries: { user_id: current_user.id }).order("entries.rank DESC")
    when "price_asc"
      @teas = @teas.order(price: :asc)
    when "price_desc"
      @teas = @teas.order(price: :desc)
    when "created_at_asc"
      @teas = @teas.order(created_at: :asc)
    else
      @teas = @teas.order(created_at: :desc) # Default sort
    end
    
    # Paginate results if Kaminari is available [installed it in gemfile so try bunbdle install if you see an error]
    if @teas.respond_to?(:page)
      @teas = @teas.page(params[:page]).per(12)
    end
  end

  def show
    # Calculate category average rank for comparison
    @category_avg_rank = Entry.joins(:tea)
                          .where(user: current_user)
                          .where(teas: { category: @tea.category })
                          .where.not(tea_id: @tea.id)
                          .average(:rank).to_f

    @entry = current_user.entries.find_by(tea: @tea)
    if @entry&.rank.present? && @category_avg_rank > 0
      if @entry.rank > @category_avg_rank
        @category_rank_comparison = "This tea's rank is higher than the average tea in its category (#{@category_avg_rank.round(1)})."
      else
        @category_rank_comparison = "This tea's rank is lower than the average tea in its category (#{@category_avg_rank.round(1)})."
      end
    end
    
    # Price comparison with similar ranked teas
    if @entry&.rank.present? && @tea.price.present?
      similar_entry_ids = Entry.where(user: current_user)
                             .where.not(tea_id: @tea.id)
                             .where.not(rank: nil)
                             .order(Arel.sql("ABS(rank - #{ActiveRecord::Base.connection.quote(@entry.rank)})"))
                             .limit(3)
                             .pluck(:tea_id)

      similar_teas = Tea.where(id: similar_entry_ids).where.not(price: nil)
      if similar_teas.any?
        avg_price = similar_teas.average(:price).to_f
        
        if @tea.price > avg_price
          @price_rank_comparison = "This tea's rank is higher than the average price of similar ranked teas (#{number_to_currency(avg_price)})."
        else
          @price_rank_comparison = "This tea's rank is lower than the average price of similar ranked teas (#{number_to_currency(avg_price)})."
        end
      end
    end
    
    # Rank comparison with similar priced teas
    if @tea.price.present? && @entry&.rank.present?
      similar_teas = current_user.teas.where.not(id: @tea.id)
                                    .where.not(price: nil)

      similar_tea_ids = similar_teas
                          .order(Arel.sql("ABS(price - #{ActiveRecord::Base.connection.quote(@tea.price)})"))
                          .limit(3)
                          .pluck(:id)

      similar_entries = Entry.where(user: current_user, tea_id: similar_tea_ids).where.not(rank: nil)

      if similar_entries.any?
        avg_rank = similar_entries.average(:rank).to_f

        if @entry.rank > avg_rank
          @rank_price_comparison = "higher than"
        else
          @rank_price_comparison = "lower than"
        end
      end
    end
  end

  def new
    @tea = current_user.teas.new
  end

  def create
    @tea = Tea.new(tea_params)
    
    ActiveRecord::Base.transaction do
      if @tea.save
        @entry = Entry.create!(tea: @tea, user: current_user, rank: params[:tea][:rank])
        redirect_to tea_path(@tea), notice: "Tea was successfully created."
      else
        flash.now[:alert] = "There was an error creating the tea."
        render :new, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = "There was an error creating the tea."
    render :new, status: :unprocessable_entity
  end

  def edit
    @entry = current_user.entries.find_by(tea: @tea)
      unless @entry
        redirect_to teas_path, alert: "You don't have access to this tea."
      end
  end

  def update
    @entry = current_user.entries.find_by(tea: @tea)
    unless @entry
      redirect_to teas_path, alert: "You don't have access to this tea."
      return
    end

    ActiveRecord::Base.transaction do
      if @tea.update(tea_params)
        @entry.update!(rank: params[:tea][:rank])
        redirect_to tea_path(@tea), notice: "Tea updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @entry = current_user.entries.find_by(tea: @tea)
    if @entry
      @entry.destroy
      if @tea.entries.empty?
        @tea.destroy
      end
      redirect_to teas_path, notice: "Tea was successfully removed from your collection."
    else
      redirect_to teas_path, alert: "You don't have access to this tea."
    end
  end
  
  def categories
    @categories = current_user.teas.pluck(:category).uniq
    @teas_by_category = {}
    @entries = current_user.entries.index_by(&:tea_id) # ✅ Add this line
  
    @categories.each do |category|
      @teas_by_category[category] = current_user.teas.where(category: category)
    end
  end
  
  def origins
    @origins = current_user.teas.pluck(:ship_from).uniq
    @teas_by_origin = {}
    @entries = current_user.entries.index_by(&:tea_id)  # ✅ Add this line
  
    @origins.each do |origin|
      @teas_by_origin[origin] = current_user.teas.where(ship_from: origin)
    end
  end
  
  def count
    @total_teas = current_user.teas.count
    @teas_by_category = current_user.teas.group(:category).count
    @teas_by_origin = current_user.teas.group(:ship_from).count
    
    render json: {
      total: @total_teas,
      by_category: @teas_by_category,
      by_origin: @teas_by_origin
    }
  end

  private
  
  def set_tea
    @tea = current_user.teas.find(params[:id])
  end
  
  def tea_params
    params.require(:tea).permit(:name, :price, :category, :vendor, :known_for, :ship_from, :popularity, :shopping_platform, :product_url)
  end
  
  def require_login
    unless current_user
      redirect_to new_session_path, alert: "You must log in first."
    end
  end
end