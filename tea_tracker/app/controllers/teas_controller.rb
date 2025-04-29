class TeasController < ApplicationController
    def show
        @tea = Tea.find(params[:id])

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
end
    
