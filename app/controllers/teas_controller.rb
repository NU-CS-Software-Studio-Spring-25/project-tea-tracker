class TeasController < ApplicationController
    def show
        @tea = Tea.find(params[:id])
        
        # also loads in all of these comparisons, move out sometime
        @this_category = Tea.where(category: @tea.category)
        category_comparator = TeasHelper::RankComparator.new(@tea, @this_category)
        @category_rank_comparison = category_comparator.compare

        @closest_price_teas = Tea
            .where.not(id: @tea.id)
            .order(Arel.sql("ABS(price - #{ActiveRecord::Base.connection.quote(@tea.price)})"))
            .limit(3)

        price_comparator = TeasHelper::RankComparator.new(@tea, @closest_price_teas)
        @price_rank_comparison = price_comparator.compare

        @closest_rank_teas = Tea
            .where.not(id: @tea.id)
            .order(Arel.sql("ABS(rank - #{ActiveRecord::Base.connection.quote(@tea.rank)})"))
            .limit(3)
        rank_comparator = TeasHelper::RankComparator.new(@tea, @closest_rank_teas, "price")
        @rank_price_comparison = rank_comparator.compare
    end

    # home page thing ?
    def index
        @teas = Tea.all 
    end

    def new
        @tea = Tea.new
    end

    def create
        @tea = Tea.new(tea_params)
        if @tea.save
        redirect_to teas_path, notice: "Tea was successfully created."
        else
        render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
    end


    def destroy
        @tea.destroy
        redirect_to teas_path, notice: "Tea was successfully deleted."
    end

    private
    def set_tea
        @tea = Tea.find(params[:id])
    end
    
    def tea_params
        params.require(:tea).permit(:name, :rank, :price, :category)
    end

end
    
