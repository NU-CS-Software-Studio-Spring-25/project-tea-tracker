class TeasController < ApplicationController
    before_action :require_login
    before_action :set_tea, only: [:show, :edit, :update, :destroy]
  
    def index
      redirect_to root_path
    end
  
    def show
        @tea = current_user.teas.find(params[:id])
      
        # Category comparison
        @this_category = current_user.teas.where(category: @tea.category)
        if @this_category.size > 1
          category_comparator = TeasHelper::RankComparator.new(@tea, @this_category)
          @category_rank_comparison = category_comparator.compare
        else
          @category_rank_comparison = "N/A – not enough teas in this category"
        end
      
        # Closest price comparison
        @closest_price_teas = current_user.teas
          .where.not(id: @tea.id)
          .order(Arel.sql("ABS(price - #{ActiveRecord::Base.connection.quote(@tea.price)})"))
          .limit(3)
      
        if @closest_price_teas.any?
          price_comparator = TeasHelper::RankComparator.new(@tea, @closest_price_teas)
          @price_rank_comparison = price_comparator.compare
        else
          @price_rank_comparison = "N/A – no other teas to compare price with"
        end
      
        # Closest rank comparison
        @closest_rank_teas = current_user.teas
          .where.not(id: @tea.id)
          .order(Arel.sql("ABS(rank - #{ActiveRecord::Base.connection.quote(@tea.rank)})"))
          .limit(3)
      
        if @closest_rank_teas.any?
          rank_comparator = TeasHelper::RankComparator.new(@tea, @closest_rank_teas, "price")
          @rank_price_comparison = rank_comparator.compare
        else
          @rank_price_comparison = "N/A – no other teas to compare rank with"
        end
      end
      
  
    def new
      @tea = Tea.new
    end
  
    def create
        @tea = current_user.teas.build(tea_params) # associate tea with current_user
      
        if @tea.save
          redirect_to root_path, notice: "Tea was successfully created." # go to home with flash
        else
          flash.now[:alert] = "There was an error creating the tea."
          render :new, status: :unprocessable_entity
        end
      end
  
    def edit
    end
  
    def update
      if @tea.update(tea_params)
        redirect_to tea_path(@tea), notice: "Tea updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @tea.destroy
      redirect_to teas_path, notice: "Tea was successfully deleted."
    end
  
    private
  
    def set_tea
      @tea = current_user.teas.find(params[:id])
    end
  
    def tea_params
      params.require(:tea).permit(:name, :rank, :price, :category, :vendor, :known_for, :ship_from, :popularity, :shopping_platform, :product_url)
    end
  
    def require_login
      redirect_to new_session_path unless current_user
    end
  end
  