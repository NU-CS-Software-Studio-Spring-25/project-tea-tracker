class EntriesController < ApplicationController
    before_action :require_login
    before_action :set_entry, only: [ :show, :edit, :update, :destroy ]

    def index
      @entries = current_user.entries.includes(:tea)
    end

    def show
      @tea = @entry.tea

      # Category comparison
      @this_category = current_user.entries.joins(:tea).where(teas: { category: @tea.category }).where.not(id: @entry.id)
      if @this_category.size > 0
        category_comparator = TeasHelper::RankComparator.new(@tea, @this_category.map(&:tea))
        @category_rank_comparison = category_comparator.compare
      else
        @category_rank_comparison = "N/A – not enough teas in this category"
      end

      # Closest price comparison
      @closest_price_entries = current_user.entries
        .joins(:tea)
        .where.not(id: @entry.id)
        .order(Arel.sql("ABS(teas.price - #{ActiveRecord::Base.connection.quote(@tea.price)})"))
        .limit(3)

      if @closest_price_entries.any?
        price_comparator = TeasHelper::RankComparator.new(@tea, @closest_price_entries.map(&:tea))
        @price_rank_comparison = price_comparator.compare
      else
        @price_rank_comparison = "N/A – no other teas to compare price with"
      end

      # Closest rank comparison
      @closest_rank_entries = current_user.entries
        .joins(:tea)
        .where.not(id: @entry.id)
        .order(Arel.sql("ABS(rank - #{ActiveRecord::Base.connection.quote(@entry.rank)})"))
        .limit(3)

      if @closest_rank_entries.any?
        rank_comparator = TeasHelper::RankComparator.new(@tea, @closest_rank_entries.map(&:tea), "price")
        @rank_price_comparison = rank_comparator.compare
      else
        @rank_price_comparison = "N/A – no other teas to compare rank with"
      end
    end

    def new
      @entry = Entry.new
    end

    def create
      @entry = current_user.entries.build(entry_params)

      if @entry.save
        redirect_to entries_path, notice: "Entry was successfully created."
      else
        flash.now[:alert] = "There was an error creating the entry."
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @entry.update(entry_params)
        redirect_to entry_path(@entry), notice: "Entry updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @entry.destroy
      redirect_to entries_path, notice: "Entry was successfully deleted."
    end

    private

    def set_entry
      @entry = current_user.entries.find(params[:id])
    end

    def entry_params
      params.require(:entry).permit(:rank, :tea_id)
    end

    def require_login
      redirect_to new_session_path unless current_user
    end
end
