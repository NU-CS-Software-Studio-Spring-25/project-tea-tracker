class TeasController < ApplicationController
  include ActionView::Helpers::NumberHelper

  before_action :require_login
  before_action :set_tea, only: %i[show edit update destroy]

  def index
    @teas = current_user.teas.includes(:entries)
    @entries = current_user.entries.index_by(&:tea_id)
    @tea_categories = @teas.pluck(:category).uniq

    # Apply filters
    @teas = @teas.where(category: params[:category]) if params[:category].present?

    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @teas = @teas.where('name ILIKE ? OR vendor ILIKE ? OR ship_from ILIKE ?',
                          search_term, search_term, search_term)
    end

    # Apply sorting
    @teas = case params[:sort]
            when 'name_asc'
              @teas.order(name: :asc)
            when 'rank_desc'
              @teas.joins(:entries).where(entries: { user_id: current_user.id }).order('entries.rank DESC')
            when 'price_asc'
              @teas.order(price: :asc)
            when 'price_desc'
              @teas.order(price: :desc)
            when 'created_at_asc'
              @teas.order(created_at: :asc)
            else
              @teas.order(created_at: :desc) # Default sort
            end

    # Paginate results if Kaminari is available [installed it in gemfile so try bunbdle install if you see an error]
    return unless @teas.respond_to?(:page)

    @teas = @teas.page(params[:page]).per(12)
  end

  def show
    # Calculate category average rank for comparison
    category_entries = Entry.joins(:tea)
                            .where(user: current_user)
                            .where(teas: { category: @tea.category })
                            .where.not(tea_id: @tea.id)
    ranks = category_entries.map(&:rank)
    @category_avg_rank = ranks.sum.to_f / ranks.size if ranks.any?
    @closest_index = current_user.teas.count / 10.round(0)

    @entry = current_user.entries.find_by(tea: @tea)
    if @entry&.position.present? && @category_avg_rank && @category_avg_rank > 0
      if @entry.rank < @category_avg_rank
        @category_rank_comparison = "This tea's rank is #{@category_avg_rank.round(0) - @entry.rank} places higher than the average #{@tea.category} tea."
      else
        @category_rank_comparison = "This tea's rank is #{@entry.rank - @category_avg_rank.round(0)} places lower than the average #{@tea.category} tea."
      end
    end

    # Price comparison with similar ranked teas
    if @entry&.rank.present? && @tea.price.present?
      similar_entry_ids = Entry.where(user: current_user)
                               .where.not(tea_id: @tea.id)
                               .where.not(position: nil)
                               .order(Arel.sql("ABS(rank - #{ActiveRecord::Base.connection.quote(@entry.rank)})"))
                               .limit(@closest_index)
                               .pluck(:tea_id)

      similar_teas = Tea.where(id: similar_entry_ids).where.not(price: nil)
      if similar_teas.any?
        avg_price = similar_teas.average(:price).to_f

        if @tea.price > avg_price
          @price_rank_comparison = "This tea's price is higher than the average price of similar ranked teas (#{number_to_currency(avg_price)})."
        else
          @price_rank_comparison = "This tea's price is lower than the average price of similar ranked teas (#{number_to_currency(avg_price)})."
        end
      end
    end

    # Rank comparison with similar priced teas
    return unless @tea.price.present? && @entry&.rank.present?

    similar_tea_ids = current_user.teas.where.not(id: @tea.id)
                                  .where.not(price: nil)
                                  .order(Arel.sql("ABS(price - #{ActiveRecord::Base.connection.quote(@tea.price)})"))
                                  .limit(@closest_index)
                                  .pluck(:id)

    similar_teas = Entry.where(tea_id: similar_tea_ids)
    ranks = similar_teas.map(&:rank)
    avg_rank = ranks.sum.to_f / ranks.size if ranks.any?

    return unless similar_teas.any?

    @rank_price_comparison = if @entry.rank > avg_rank
                               "#{(@entry.rank - avg_rank).round(0)} places lower on average than"
                             else
                               "#{(avg_rank - @entry.rank).round(0)} places higher on average than"
                             end
  end

  def new
    @tea = current_user.teas.new
  end

  def create
    @tea = Tea.new(tea_params)
    normalize_category_param

    # Check for potential misspelling
    check_for_category_misspelling(@tea)

    ActiveRecord::Base.transaction do
      if @tea.save
        @entry = Entry.create!(tea: @tea, user: current_user, rank: params[:tea][:rank])
        redirect_to tea_path(@tea), notice: 'Tea was successfully created.'
      else
        flash.now[:alert] = 'There was an error creating the tea.'
        render :new, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = 'There was an error creating the tea.'
    render :new, status: :unprocessable_entity
  end

  def edit
    @entry = current_user.entries.find_by(tea: @tea)
    return if @entry

    redirect_to teas_path, alert: "You don't have access to this tea."
  end

  def update
    @entry = current_user.entries.find_by(tea: @tea)
    unless @entry
      redirect_to teas_path, alert: "You don't have access to this tea."
      return
    end

    normalize_category_param

    # Check for potential misspelling
    check_for_category_misspelling(@tea)

    ActiveRecord::Base.transaction do
      if @tea.update(tea_params)
        @entry.update!(rank: params[:tea][:rank])
        redirect_to tea_path(@tea), notice: 'Tea updated successfully.'
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
      @tea.destroy if @tea.entries.empty?
      redirect_to teas_path, notice: 'Tea was successfully removed from your collection.'
    else
      redirect_to teas_path, alert: "You don't have access to this tea."
    end
  end

  def categories
    @categories = current_user.teas.pluck(:category).uniq
    @teas_by_category = {}
    @entries = current_user.entries.index_by(&:tea_id)

    @categories.each do |category|
      @teas_by_category[category] =
        current_user.teas.where(category: category).page(params["page_#{category}".to_sym]).per(8)
    end
  end

  def origins
    @origins = current_user.teas.pluck(:ship_from).uniq
    @teas_by_origin = {}
    @entries = current_user.entries.index_by(&:tea_id)

    @origins.each do |origin|
      @teas_by_origin[origin] = current_user.teas.where(ship_from: origin).page(params["page_#{origin}".to_sym]).per(8)
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

  # update the ranks
  def update_ranks
    params[:tea_ranks].each do |tea_id, rank|
      entry = current_user.entries.find_by(tea_id: tea_id)
      entry.update(rank: rank) if entry
    end
    
    head :ok
  end

  private

  def set_tea
    @tea = current_user.teas.find(params[:id])
  end

  def tea_params
    params.require(:tea).permit(:name, :price, :category, :vendor, :known_for, :ship_from, :popularity,
                                :shopping_platform, :product_url)
  end

  def require_login
    return if current_user

    redirect_to new_session_path, alert: 'You must log in first.'
  end

  def normalize_category_param
    return unless params[:tea] && params[:tea][:category]

    params[:tea][:category] = params[:tea][:category].downcase.strip
  end

  def check_for_category_misspelling(tea)
    return if tea.category.blank? || tea.canonical_category?

    return unless suggestion = tea.category_suggestion
    # Only suggest if the edit distance is small (likely a typo)
    return unless tea.send(:levenshtein_distance, tea.category, suggestion) <= 2

    flash.now[:warning] =
      "Did you mean '#{suggestion}' instead of '#{tea.category}'? We've kept your entry, but it might be a typo."
  end
end
